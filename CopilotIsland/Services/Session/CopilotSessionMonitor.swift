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
    // Uses a 3-second debounce: if the agent immediately continues (e.g. multi-step confirmation),
    // the timer is cancelled and no sound plays. Sound only fires if agent stays idle ≥ 3 seconds.
    private var previousPhases: [String: SessionPhase] = [:]
    private var soundTimers: [String: DispatchWorkItem] = [:]

    private func triggerSoundIfNeeded(_ sessions: [SessionState]) {
        for session in sessions {
            let prev = previousPhases[session.sessionId]
            let id   = session.sessionId

            switch session.phase {
            case .waitingForInput:
                let wasWorking: Bool
                switch prev {
                case .processing, .runningTool: wasWorking = true
                default: wasWorking = false
                }
                if wasWorking {
                    // Agent finished a work turn — wait 3s to confirm it's truly done
                    // (not just a mid-task confirmation prompt)
                    soundTimers[id]?.cancel()
                    let item = DispatchWorkItem { [weak self] in
                        guard let self else { return }
                        guard let current = self.sessions.first(where: { $0.sessionId == id }),
                              case .waitingForInput = current.phase else { return }
                        SoundManager.shared.playAgentDone()
                        self.sessionCompleted.send()
                    }
                    soundTimers[id] = item
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: item)
                }

            case .processing, .runningTool:
                // Agent resumed work — cancel any pending sound timer
                soundTimers[id]?.cancel()
                soundTimers[id] = nil

            default:
                break
            }
            previousPhases[id] = session.phase
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
