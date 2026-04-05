//
//  CopilotSessionMonitor.swift
//  CopilotIsland
//
//  MainActor wrapper around SessionStore for SwiftUI observation.
//

import AppKit
import Combine
import Foundation

@MainActor
class CopilotSessionMonitor: ObservableObject {
    @Published var sessions: [SessionState] = []
    @Published var activeSessions: [SessionState] = []

    private var cancellables = Set<AnyCancellable>()

    init() {
        SessionStore.shared.sessionsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sessions in
                self?.sessions = sessions
                self?.activeSessions = sessions.filter { $0.phase.isActive }
            }
            .store(in: &cancellables)
    }

    func startMonitoring() {
        Task { await CopilotSessionWatcher.shared.start() }
    }

    func stopMonitoring() {
        Task { await CopilotSessionWatcher.shared.stop() }
    }

    func archiveSession(sessionId: String) {
        Task { await SessionStore.shared.process(.sessionRemoved(sessionId: sessionId)) }
    }
}
