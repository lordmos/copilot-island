//
//  NotchViewModel.swift
//  CopilotIsland
//

import AppKit
import Combine
import SwiftUI

enum NotchStatus: Equatable { case closed, opened, popping }
enum NotchOpenReason { case click, hover, notification, boot, unknown }

enum NotchContentType: Equatable {
    case sessions
    case menu
    case chat(SessionState)
    case agentChat

    var id: String {
        switch self {
        case .sessions: return "sessions"
        case .menu: return "menu"
        case .chat(let s): return "chat-\(s.sessionId)"
        case .agentChat: return "agentChat"
        }
    }
}

@MainActor
class NotchViewModel: ObservableObject {
    @Published var status: NotchStatus = .closed
    @Published var openReason: NotchOpenReason = .unknown
    @Published var contentType: NotchContentType = .sessions
    @Published var isHovering: Bool = false

    let geometry: NotchGeometry
    let spacing: CGFloat = 12
    let hasPhysicalNotch: Bool

    var deviceNotchRect: CGRect { geometry.deviceNotchRect }
    var screenRect: CGRect { geometry.screenRect }
    var windowHeight: CGFloat { geometry.windowHeight }

    var openedSize: CGSize {
        switch contentType {
        case .chat, .agentChat:
            return CGSize(width: min(screenRect.width * 0.5, 620), height: 580)
        case .menu:
            return CGSize(width: min(screenRect.width * 0.4, 480), height: 320)
        case .sessions:
            return CGSize(width: min(screenRect.width * 0.4, 480), height: 320)
        }
    }

    var animation: Animation { .easeOut(duration: 0.25) }

    private var cancellables = Set<AnyCancellable>()
    private let events = EventMonitors.shared
    private var hoverTimer: DispatchWorkItem?
    private var savedChatSession: SessionState?

    init(deviceNotchRect: CGRect, screenRect: CGRect, windowHeight: CGFloat, hasPhysicalNotch: Bool) {
        self.geometry = NotchGeometry(
            deviceNotchRect: deviceNotchRect,
            screenRect: screenRect,
            windowHeight: windowHeight
        )
        self.hasPhysicalNotch = hasPhysicalNotch
        setupEventHandlers()
    }

    private func setupEventHandlers() {
        events.mouseLocation
            .throttle(for: .milliseconds(50), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] loc in self?.handleMouseMove(loc) }
            .store(in: &cancellables)

        events.mouseDown
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.handleMouseDown() }
            .store(in: &cancellables)
    }

    private func handleMouseMove(_ location: CGPoint) {
        let inNotch = geometry.isPointInNotch(location)
        let inOpened = status == .opened && geometry.isPointInOpenedPanel(location, size: openedSize)
        let newHovering = inNotch || inOpened
        guard newHovering != isHovering else { return }
        isHovering = newHovering
        hoverTimer?.cancel()
        hoverTimer = nil
        if isHovering && (status == .closed || status == .popping) {
            let workItem = DispatchWorkItem { [weak self] in
                guard let self, self.isHovering else { return }
                self.notchOpen(reason: .hover)
            }
            hoverTimer = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: workItem)
        }
    }

    private func handleMouseDown() {
        let location = NSEvent.mouseLocation
        switch status {
        case .opened:
            if geometry.isPointOutsidePanel(location, size: openedSize) {
                notchClose()
                repostClick(at: location)
            } else if geometry.notchScreenRect.contains(location) {
                if case .sessions = contentType { notchClose() }
            }
        case .closed, .popping:
            if geometry.isPointInNotch(location) { notchOpen(reason: .click) }
        }
    }

    private func repostClick(at location: CGPoint) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            guard let screen = NSScreen.main else { return }
            let cgPoint = CGPoint(x: location.x, y: screen.frame.height - location.y)
            CGEvent(mouseEventSource: nil, mouseType: .leftMouseDown, mouseCursorPosition: cgPoint, mouseButton: .left)?.post(tap: .cghidEventTap)
            CGEvent(mouseEventSource: nil, mouseType: .leftMouseUp, mouseCursorPosition: cgPoint, mouseButton: .left)?.post(tap: .cghidEventTap)
        }
    }

    func notchOpen(reason: NotchOpenReason = .unknown) {
        openReason = reason
        status = .opened
        if reason == .notification { savedChatSession = nil; return }
        if let saved = savedChatSession {
            if case .chat(let c) = contentType, c.sessionId == saved.sessionId { return }
            contentType = .chat(saved)
        }
    }

    func notchClose() {
        if case .chat(let s) = contentType { savedChatSession = s }
        status = .closed
        contentType = .sessions
    }

    func showAgentChat() {
        contentType = .agentChat
    }

    func notchPop() {
        guard status == .closed else { return }
        status = .popping
    }

    func notchUnpop() {
        guard status == .popping else { return }
        status = .closed
    }

    func toggleMenu() {
        contentType = contentType == .menu ? .sessions : .menu
    }

    func showChat(for session: SessionState) {
        if case .chat(let c) = contentType, c.sessionId == session.sessionId { return }
        contentType = .chat(session)
    }

    func showAPIChat() {
        // Feature removed — no-op
    }

    func exitChat() {
        savedChatSession = nil
        contentType = .sessions
    }

    func performBootAnimation() {
        notchOpen(reason: .boot)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
            guard let self, self.openReason == .boot else { return }
            self.notchClose()
        }
    }
}
