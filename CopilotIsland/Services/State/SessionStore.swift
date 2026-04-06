//
//  SessionStore.swift
//  CopilotIsland
//
//  Actor-based central state manager. All state mutations go through here.
//

import Foundation
import Combine

actor SessionStore {
    static let shared = SessionStore()

    private var sessions: [String: SessionState] = [:]
    private let subject = PassthroughSubject<[SessionState], Never>()

    nonisolated var sessionsPublisher: AnyPublisher<[SessionState], Never> {
        subject.eraseToAnyPublisher()
    }

    private init() {}

    // MARK: - Process Events

    func process(_ event: SessionEvent) {
        switch event {
        case .sessionDiscovered(let sessionId, let cwd, let workspace):
            if sessions[sessionId] == nil {
                let state = SessionState(
                    sessionId: sessionId,
                    cwd: cwd,
                    projectName: workspace?.cwd.map { URL(fileURLWithPath: $0).lastPathComponent },
                    gitBranch: workspace?.branch,
                    phase: .idle,
                    summary: workspace?.summary
                )
                sessions[sessionId] = state
                publish()
            }

        case .sessionContextUpdated(let sessionId, let cwd, _, let branch):
            // session.start event provides accurate cwd/branch (overrides workspace.yaml)
            update(sessionId) {
                $0 = SessionState(
                    sessionId: $0.sessionId,
                    cwd: cwd,
                    projectName: URL(fileURLWithPath: cwd).lastPathComponent,
                    gitBranch: branch,
                    phase: $0.phase,
                    messages: $0.messages,
                    currentTool: $0.currentTool,
                    summary: $0.summary,
                    lastUserMessage: $0.lastUserMessage,
                    lastActivity: $0.lastActivity,
                    createdAt: $0.createdAt
                )
            }

        case .userMessageSent(let sessionId, let content):
            update(sessionId) {
                $0.phase = .processing
                $0.lastUserMessage = content
                $0.lastActivity = Date()
                $0.messages.append(CopilotMessage(
                    id: UUID().uuidString,
                    role: .user,
                    content: content,
                    toolName: nil,
                    toolArguments: nil,
                    toolSuccess: nil,
                    timestamp: Date()
                ))
            }

        case .assistantTurnStarted(let sessionId):
            update(sessionId) {
                $0.phase = .processing
                $0.lastActivity = Date()
            }

        case .assistantMessageReceived(let sessionId, let content, let messageId):
            update(sessionId) {
                $0.phase = .processing
                $0.lastActivity = Date()
                if !content.isEmpty {
                    $0.messages.append(CopilotMessage(
                        id: messageId,
                        role: .assistant,
                        content: content,
                        toolName: nil,
                        toolArguments: nil,
                        toolSuccess: nil,
                        timestamp: Date()
                    ))
                }
            }

        case .toolStarted(let sessionId, let toolCallId, let toolName, let arguments):
            update(sessionId) {
                $0.phase = .runningTool(name: toolName, args: arguments)
                $0.currentTool = ActiveTool(
                    toolCallId: toolCallId,
                    toolName: toolName,
                    arguments: arguments,
                    startTime: Date()
                )
                $0.lastActivity = Date()
            }

        case .toolCompleted(let sessionId, let toolCallId, let success, let result):
            update(sessionId) { state in
                let toolName = state.currentTool?.toolName
                let toolArgs = state.currentTool?.arguments
                state.currentTool = nil
                state.phase = .processing
                state.lastActivity = Date()
                state.messages.append(CopilotMessage(
                    id: toolCallId,
                    role: .tool,
                    content: result,
                    toolName: toolName,
                    toolArguments: toolArgs,
                    toolSuccess: success,
                    timestamp: Date()
                ))
            }

        case .subagentStarted(let sessionId, let agentId, let displayName):
            update(sessionId) {
                $0.phase = .runningTool(name: displayName, args: agentId)
                $0.lastActivity = Date()
            }

        case .subagentCompleted(let sessionId, _):
            update(sessionId) {
                $0.phase = .processing
                $0.lastActivity = Date()
            }

        case .assistantTurnEnded(let sessionId):
            update(sessionId) {
                $0.phase = .waitingForInput
                $0.currentTool = nil
                $0.lastActivity = Date()
            }

        case .taskCompleted(let sessionId, let summary):
            update(sessionId) {
                $0.phase = .taskComplete
                $0.currentTool = nil
                $0.lastActivity = Date()
                if let s = summary, !s.isEmpty { $0.summary = s }
            }

        case .compactionStarted(let sessionId):
            update(sessionId) {
                $0.phase = .compacting
                $0.lastActivity = Date()
            }

        case .compactionCompleted(let sessionId):
            update(sessionId) {
                $0.phase = .processing
                $0.lastActivity = Date()
            }

        case .sessionAborted(let sessionId):
            update(sessionId) {
                $0.phase = .interrupted
                $0.currentTool = nil
                $0.lastActivity = Date()
            }

        case .sessionError(let sessionId, let reason):
            update(sessionId) {
                $0.phase = .error(reason)
                $0.lastActivity = Date()
            }

        case .sessionShutdown(let sessionId):
            update(sessionId) {
                $0.phase = .ended
                $0.currentTool = nil
                $0.lastActivity = Date()
            }

        case .sessionSummaryUpdated(let sessionId, let summary):
            update(sessionId) {
                $0.summary = summary
            }

        case .sessionRemoved(let sessionId):
            sessions.removeValue(forKey: sessionId)
            publish()
        }
    }

    func session(for sessionId: String) -> SessionState? {
        sessions[sessionId]
    }

    func allSessions() -> [SessionState] {
        Array(sessions.values).sorted { $0.lastActivity > $1.lastActivity }
    }

    // MARK: - Private

    private func update(_ sessionId: String, _ mutation: (inout SessionState) -> Void) {
        guard var state = sessions[sessionId] else { return }
        mutation(&state)
        sessions[sessionId] = state
        publish()
    }

    private func publish() {
        let sorted = Array(sessions.values)
            .filter { $0.phase != .ended }
            .sorted { $0.lastActivity > $1.lastActivity }
        subject.send(sorted)
    }
}
