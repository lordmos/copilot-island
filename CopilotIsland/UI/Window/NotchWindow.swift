//
//  NotchWindow.swift
//  CopilotIsland
//

import AppKit

class NotchWindow: NSWindow {
    init(contentRect: CGRect, screen: NSScreen) {
        super.init(
            contentRect: contentRect,
            styleMask: [.borderless, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        level = .screenSaver
        backgroundColor = .clear
        isOpaque = false
        hasShadow = false
        ignoresMouseEvents = false
        collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle, .fullScreenDisallowsTiling]
        isMovable = false
        isReleasedWhenClosed = false
    }
}
