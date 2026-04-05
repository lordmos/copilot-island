//
//  NotchWindow.swift
//  CopilotIsland
//
//  Transparent NSPanel overlay above the menu bar.
//  - ignoresMouseEvents = true by default (pass-through)
//  - Toggled to false when panel is opened so buttons work
//  - sendEvent override forwards clicks outside panel to windows behind
//

import AppKit

class NotchWindow: NSPanel {
    init(contentRect: CGRect) {
        super.init(
            contentRect: contentRect,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        isFloatingPanel = true
        becomesKeyOnlyIfNeeded = true
        isOpaque = false
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
        backgroundColor = .clear
        hasShadow = false
        isMovable = false
        collectionBehavior = [.fullScreenAuxiliary, .stationary, .canJoinAllSpaces, .ignoresCycle]
        level = .mainMenu + 3
        allowsToolTipsWhenApplicationIsInactive = true
        ignoresMouseEvents = true  // pass-through by default; toggled when opened
        isReleasedWhenClosed = false
        acceptsMouseMovedEvents = false
    }

    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }

    // Forward clicks that land outside the panel content to windows behind.
    override func sendEvent(_ event: NSEvent) {
        if event.type == .leftMouseDown || event.type == .leftMouseUp ||
           event.type == .rightMouseDown || event.type == .rightMouseUp {
            let loc = event.locationInWindow
            if contentView?.hitTest(loc) == nil {
                let screenLoc = convertPoint(toScreen: loc)
                ignoresMouseEvents = true
                DispatchQueue.main.async { [weak self] in self?.repost(event, at: screenLoc) }
                return
            }
        }
        super.sendEvent(event)
    }

    private func repost(_ event: NSEvent, at screenLoc: NSPoint) {
        guard let screen = NSScreen.main else { return }
        let cgPt = CGPoint(x: screenLoc.x, y: screen.frame.height - screenLoc.y)
        let type: CGEventType
        switch event.type {
        case .leftMouseDown:  type = .leftMouseDown
        case .leftMouseUp:    type = .leftMouseUp
        case .rightMouseDown: type = .rightMouseDown
        case .rightMouseUp:   type = .rightMouseUp
        default: return
        }
        let btn: CGMouseButton = (event.type == .rightMouseDown || event.type == .rightMouseUp) ? .right : .left
        CGEvent(mouseEventSource: nil, mouseType: type, mouseCursorPosition: cgPt, mouseButton: btn)?.post(tap: .cghidEventTap)
    }
}

