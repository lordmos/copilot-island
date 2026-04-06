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

    // 3-second flash states for the left peek icon.
    // taskComplete → trophy icon; failure → X icon. Both auto-clear.
    @Published var completionFlashActive: Bool = false
    @Published var failureFlashActive: Bool = false

    /// Fires once each time a task completes — WindowManager subscribes to trigger notch pop.
    let sessionCompleted = PassthroughSubject<Void, Never>()

    private var cancellables = Set<AnyCancellable>()

    init() {
        SessionStore.shared.sessionsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sessions in
                self?.sessions = sessions
                self?.activeSessions = sessions.filter { $0.phase.isActive }
            }
            .store(in: &cancellables)

        SessionStore.shared.taskCompletePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                SoundManager.shared.playAgentDone()
                self?.sessionCompleted.send()
                self?.triggerCompletionFlash()
            }
            .store(in: &cancellables)

        SessionStore.shared.sessionFailedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                SoundManager.shared.playAgentFailed()
                self?.triggerFailureFlash()
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

    // MARK: - Flash helpers

    private var completionFlashTask: DispatchWorkItem?
    private var failureFlashTask: DispatchWorkItem?

    private func triggerCompletionFlash() {
        completionFlashTask?.cancel()
        completionFlashActive = true
        let work = DispatchWorkItem { [weak self] in self?.completionFlashActive = false }
        completionFlashTask = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: work)
    }

    private func triggerFailureFlash() {
        failureFlashTask?.cancel()
        failureFlashActive = true
        let work = DispatchWorkItem { [weak self] in self?.failureFlashActive = false }
        failureFlashTask = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: work)
    }
}
