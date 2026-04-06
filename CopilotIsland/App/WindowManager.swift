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
    private let sparkleUpdater: SparkleUpdater
    private var cancellables = Set<AnyCancellable>()

    init(sessionMonitor: CopilotSessionMonitor, sparkleUpdater: SparkleUpdater) {
        self.sessionMonitor = sessionMonitor
        self.sparkleUpdater = sparkleUpdater
    }

    func createNotchWindow() {
        guard let screen = NSScreen.main else { return }
        let screenFrame = screen.frame

        // Use dynamic notch dimensions from screen APIs (macOS 12+).
        // Falls back to simulated notch rect on non-notch Macs.
        let deviceNotchRect: CGRect
        if let nr = screen.notchRect {
            deviceNotchRect = nr
        } else {
            deviceNotchRect = CGRect(x: 0, y: 0, width: 174, height: 37)
        }
        let notchWidth  = deviceNotchRect.width
        let notchHeight = deviceNotchRect.height

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
            .environmentObject(sparkleUpdater)
        let hostingView = PassThroughHostingView(rootView: rootView)
        hostingView.hitTestRect = { [weak vm] in
            guard let vm else { return .zero }
            let peekW = vm.peekWidth
            // View coords: origin at bottom-left, y increases upward.
            switch vm.status {
            case .opened:
                let panelSize = vm.openedSize
                let panelWidth = panelSize.width + 52  // padding for corner radius
                return CGRect(
                    x: (screenFrame.width - panelWidth) / 2,
                    y: windowHeight - panelSize.height,  // panel top = window top = screen top
                    width: panelWidth,
                    height: panelSize.height
                )
            case .closed, .popping:
                // Include peek areas (left + right 50pt) so hover/click there works too.
                let totalW = notchWidth + peekW * 2
                return CGRect(
                    x: (screenFrame.width - notchWidth) / 2 - peekW,
                    y: windowHeight - notchHeight,
                    width: totalW,
                    height: notchHeight + 10
                )
            }
        }

        let window = NotchWindow(contentRect: windowFrame)
        window.contentView = hostingView
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

        // Trigger notch pop + sound already handled; pop animation on session complete.
        sessionMonitor.sessionCompleted
            .receive(on: DispatchQueue.main)
            .sink { [weak vm] in vm?.triggerCompletionPop() }
            .store(in: &cancellables)

        // Brief delay before boot animation so window is fully on screen.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak vm] in
            vm?.performBootAnimation()
        }
    }
}

