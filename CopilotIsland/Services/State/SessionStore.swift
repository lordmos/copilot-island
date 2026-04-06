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
    private nonisolated(unsafe) let subject = PassthroughSubject<[SessionState], Never>()

    // Effect publishers — only fire for non-historical events (< 5s old at processing time).
    // CopilotSessionMonitor subscribes to trigger sound + peek flash animations.
    private nonisolated(unsafe) let taskCompleteSubject = PassthroughSubject<String, Never>()
    private nonisolated(unsafe) let sessionFailedSubject = PassthroughSubject<String, Never>()

    nonisolated var taskCompletePublisher: AnyPublisher<String, Never> {
        taskCompleteSubject.eraseToAnyPublisher()
    }
    nonisolated var sessionFailedPublisher: AnyPublisher<String, Never> {
        sessionFailedSubject.eraseToAnyPublisher()
    }

    // Pending task completions: set by session.task_complete,
    // consumed by the next assistant.turn_end (which is the actual last output).
    // Also carries isHistorical so the effect fires only for live events.
    private var pendingTaskCompletions: [String: (summary: String?, isHistorical: Bool)] = [:]

    // Tracks sessions where assistant.turn_start has fired but no message yet — forces new message block.
    private var sessionNewTurn: Set<String> = []

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
            sessionNewTurn.insert(sessionId)   // next message starts a new block
            update(sessionId) {
                $0.phase = .processing
                $0.lastActivity = Date()
            }

        case .assistantMessageReceived(let sessionId, let content, let messageId):
            guard !content.isEmpty else { break }
            let isFirst = sessionNewTurn.remove(sessionId) != nil
            update(sessionId) {
                $0.phase = .processing
                $0.lastActivity = Date()
                // Concat consecutive assistant chunks within the same turn into one message.
                if !isFirst,
                   let lastIdx = $0.messages.indices.last,
                   $0.messages[lastIdx].role == .assistant {
                    let old = $0.messages[lastIdx]
                    $0.messages[lastIdx] = CopilotMessage(
                        id: old.id, role: .assistant,
                        content: old.content + content,
                        toolName: nil, toolArguments: nil, toolSuccess: nil,
                        timestamp: old.timestamp
                    )
                } else {
                    $0.messages.append(CopilotMessage(
                        id: messageId, role: .assistant,
                        content: content,
                        toolName: nil, toolArguments: nil, toolSuccess: nil,
                        timestamp: Date()
                    ))
                }
            }

        case .toolStarted(let sessionId, let toolCallId, let toolName, let arguments):
            // After a tool starts, next assistant message should open a new block.
            sessionNewTurn.insert(sessionId)
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
            sessionNewTurn.remove(sessionId)
            // If session.task_complete arrived before this turn_end,
            // NOW is the right moment to finalize: assistant has written its last output.
            if let pending = pendingTaskCompletions.removeValue(forKey: sessionId) {
                update(sessionId) {
                    $0.phase = .taskComplete
                    $0.currentTool = nil
                    $0.lastActivity = Date()
                    if let s = pending.summary, !s.isEmpty { $0.summary = s }
                }
                if !pending.isHistorical {
                    taskCompleteSubject.send(sessionId)
                }
            } else {
                update(sessionId) {
                    $0.phase = .waitingForInput
                    $0.currentTool = nil
                    $0.lastActivity = Date()
                }
            }

        case .taskCompleted(let sessionId, let summary, let isHistorical):
            // Don't flip phase yet — assistant.turn_end fires right after this event.
            // Store pending; assistantTurnEnded will finalize phase and fire effects.
            pendingTaskCompletions[sessionId] = (summary: summary, isHistorical: isHistorical)

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

        case .sessionAborted(let sessionId, let isHistorical):
            pendingTaskCompletions.removeValue(forKey: sessionId)
            update(sessionId) {
                $0.phase = .interrupted
                $0.currentTool = nil
                $0.lastActivity = Date()
            }
            if !isHistorical { sessionFailedSubject.send(sessionId) }

        case .sessionError(let sessionId, let reason, let isHistorical):
            pendingTaskCompletions.removeValue(forKey: sessionId)
            update(sessionId) {
                $0.phase = .error(reason)
                $0.lastActivity = Date()
            }
            if !isHistorical { sessionFailedSubject.send(sessionId) }

        case .sessionShutdown(let sessionId, let isHistorical):
            pendingTaskCompletions.removeValue(forKey: sessionId)
            let wasActive = sessions[sessionId]?.phase.isActive ?? false
            update(sessionId) {
                $0.phase = .ended
                $0.currentTool = nil
                $0.lastActivity = Date()
            }
            // Only fire failure for unexpected shutdowns (was still active)
            if !isHistorical && wasActive { sessionFailedSubject.send(sessionId) }

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
