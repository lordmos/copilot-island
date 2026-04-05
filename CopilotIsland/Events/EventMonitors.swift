//
//  EventMonitors.swift
//  CopilotIsland
//

import AppKit
import Combine

class EventMonitors {
    static let shared = EventMonitors()

    let mouseLocation = PassthroughSubject<CGPoint, Never>()
    let mouseDown = PassthroughSubject<Void, Never>()

    private var globalMonitor: Any?
    private var localMonitor: Any?

    private init() { startMonitoring() }

    private func startMonitoring() {
        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved, .leftMouseDown]) { [weak self] event in
            switch event.type {
            case .mouseMoved:
                self?.mouseLocation.send(NSEvent.mouseLocation)
            case .leftMouseDown:
                self?.mouseDown.send(())
            default: break
            }
        }

        localMonitor = NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved, .leftMouseDown]) { [weak self] event in
            switch event.type {
            case .mouseMoved:
                self?.mouseLocation.send(NSEvent.mouseLocation)
            case .leftMouseDown:
                self?.mouseDown.send(())
            default: break
            }
            return event
        }
    }

    deinit {
        if let m = globalMonitor { NSEvent.removeMonitor(m) }
        if let m = localMonitor { NSEvent.removeMonitor(m) }
    }
}
