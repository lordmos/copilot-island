//
//  WindowManager.swift
//  CopilotIsland
//
//  Creates the notch overlay window and manages its lifecycle.
//  Architecture mirrors ClaudeIsland:
//  - Small window (750pt) anchored to top of screen
//  - NSPanel with ignoresMouseEvents toggled by notch status
//  - PassThroughHostingView for selective hit-testing
//

import AppKit
import SwiftUI
import Combine

// MARK: - PassThroughHostingView

/// Custom NSHostingView that only accepts mouse events within the active panel bounds.
/// Clicks outside pass through to windows (e.g. menu bar) behind.
class PassThroughHostingView<Content: View>: NSHostingView<Content> {
    var hitTestRect: () -> CGRect = { .zero }

    override func hitTest(_ point: NSPoint) -> NSView? {
        guard hitTestRect().contains(point) else { return nil }
        return super.hitTest(point)
    }
}

// MARK: - WindowManager

@MainActor
class WindowManager {
    private var notchWindow: NotchWindow?
    private var viewModel: NotchViewModel?
    private let sessionMonitor: CopilotSessionMonitor
    private var cancellables = Set<AnyCancellable>()

    init(sessionMonitor: CopilotSessionMonitor) {
        self.sessionMonitor = sessionMonitor
    }

    func createNotchWindow() {
        guard let screen = NSScreen.main else { return }
        let screenFrame = screen.frame

        // Always create a window — fall back to simulated notch on non-notch Macs.
        let notchWidth: CGFloat = screenFrame.width > 2000 ? 196 : 126
        let notchHeight: CGFloat = 37
        let deviceNotchRect = CGRect(
            x: (screenFrame.width - notchWidth) / 2,
            y: 0,
            width: notchWidth,
            height: notchHeight
        )

        // Window covers the top 750pt of the screen — enough for the largest content view.
        let windowHeight: CGFloat = 750
        let windowFrame = NSRect(
            x: screenFrame.origin.x,
            y: screenFrame.maxY - windowHeight,
            width: screenFrame.width,
            height: windowHeight
        )

        let vm = NotchViewModel(
            deviceNotchRect: deviceNotchRect,
            screenRect: screenFrame,
            windowHeight: windowHeight,
            hasPhysicalNotch: screen.hasNotch
        )
        viewModel = vm

        // Build SwiftUI view inside a hit-test–aware hosting view.
        let rootView = NotchView(viewModel: vm, sessionMonitor: sessionMonitor)
        let hostingView = PassThroughHostingView(rootView: rootView)
        hostingView.hitTestRect = { [weak vm] in
            guard let vm else { return .zero }
            // View coords: origin at bottom-left, y increases upward.
            switch vm.status {
            case .opened:
                let panelSize = vm.openedSize
                let panelWidth = panelSize.width + 52  // padding for corner radius
                return CGRect(
                    x: (screenFrame.width - panelWidth) / 2,
                    y: windowHeight - panelSize.height,
                    width: panelWidth,
                    height: panelSize.height
                )
            case .closed, .popping:
                return CGRect(
                    x: (screenFrame.width - notchWidth) / 2 - 10,
                    y: windowHeight - notchHeight - 5,
                    width: notchWidth + 20,
                    height: notchHeight + 10
                )
            }
        }

        let window = NotchWindow(contentRect: windowFrame)
        window.contentView = hostingView
        // Re-apply frame after level is set to ensure window sits at exact screen top.
        // Without this, the system may constrain position before .mainMenu+3 level takes effect.
        window.setFrame(windowFrame, display: false)
        window.makeKeyAndOrderFront(nil)
        notchWindow = window

        // Toggle mouse event pass-through based on notch open/close state.
        vm.$status
            .receive(on: DispatchQueue.main)
            .sink { [weak window, weak vm] status in
                switch status {
                case .opened:
                    window?.ignoresMouseEvents = false
                    if vm?.openReason != .notification {
                        NSApp.activate(ignoringOtherApps: false)
                        window?.makeKey()
                    }
                case .closed, .popping:
                    window?.ignoresMouseEvents = true
                }
            }
            .store(in: &cancellables)

        // Brief delay before boot animation so window is fully on screen.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak vm] in
            vm?.performBootAnimation()
        }
    }
}

