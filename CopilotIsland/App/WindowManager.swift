//
//  WindowManager.swift
//  CopilotIsland
//

import AppKit
import SwiftUI

class WindowManager {
    private var notchWindow: NotchWindow?
    private let sessionMonitor: CopilotSessionMonitor

    init(sessionMonitor: CopilotSessionMonitor) {
        self.sessionMonitor = sessionMonitor
    }

    @MainActor func createNotchWindow() {
        guard let screen = NSScreen.main else { return }
        guard let notchRect = screen.notchRect else { return }

        let windowHeight = screen.frame.height
        let frame = CGRect(
            x: screen.frame.minX,
            y: screen.frame.minY,
            width: screen.frame.width,
            height: windowHeight
        )

        let viewModel = NotchViewModel(
            deviceNotchRect: notchRect,
            screenRect: screen.frame,
            windowHeight: windowHeight,
            hasPhysicalNotch: screen.hasNotch
        )

        let rootView = NotchView(viewModel: viewModel, sessionMonitor: sessionMonitor)
        let hostingController = NSHostingController(rootView: rootView)

        notchWindow = NotchWindow(contentRect: frame, screen: screen)
        notchWindow?.contentViewController = hostingController
        notchWindow?.makeKeyAndOrderFront(nil)

        viewModel.performBootAnimation()
    }
}
