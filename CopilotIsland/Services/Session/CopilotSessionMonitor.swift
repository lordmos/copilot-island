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

    /// Fires once each time any session transitions to `.waitingForInput`.
    /// WindowManager subscribes to trigger the notch pop animation.
    let sessionCompleted = PassthroughSubject<Void, Never>()

    private var cancellables = Set<AnyCancellable>()

    init() {
        SessionStore.shared.sessionsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sessions in
                self?.sessions = sessions
                self?.activeSessions = sessions.filter { $0.phase.isActive }
                self?.triggerSoundIfNeeded(sessions)
            }
            .store(in: &cancellables)
    }

    // Plays the 8-bit chime and fires sessionCompleted only after FULL work is done.
    // "Full work" = the agent was actively processing or running tools before completing.
    // Idle/compacting → waitingForInput does NOT trigger (not a meaningful work completion).
    private var previousPhases: [String: SessionPhase] = [:]
    private func triggerSoundIfNeeded(_ sessions: [SessionState]) {
        for session in sessions {
            let prev = previousPhases[session.sessionId]
            if case .waitingForInput = session.phase {
                let wasWorking: Bool
                switch prev {
                case .processing, .runningTool: wasWorking = true
                default: wasWorking = false
                }
                if wasWorking {
                    SoundManager.shared.playAgentDone()
                    sessionCompleted.send()
                }
            }
            previousPhases[session.sessionId] = session.phase
        }
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
