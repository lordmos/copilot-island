//
//  SessionPhase.swift
//  CopilotIsland
//
//  State machine for a Copilot CLI session lifecycle.
//

import Foundation

enum SessionPhase: Equatable, Sendable {
    case idle
    case processing        // AI is thinking / responding
    case runningTool(name: String, args: String)   // Tool executing (includes sub-agents)
    case waitingForInput   // Completed a turn, waiting for next user message
    case taskComplete      // session.task_complete fired — full task is done
    case compacting        // Context compaction in progress
    case interrupted       // User aborted
    case error(String)     // Session error
    case ended             // Session shut down

    var needsAttention: Bool {
        switch self {
        case .processing, .runningTool: return true
        default: return false
        }
    }

    var displayLabel: String {
        switch self {
        case .idle: return "Idle"
        case .processing: return "Thinking…"
        case .runningTool(let name, _): return "Running \(name)"
        case .waitingForInput: return "Waiting for input"
        case .taskComplete: return "完成"
        case .compacting: return "Compacting…"
        case .interrupted: return "Interrupted"
        case .error(let msg): return "Error: \(msg)"
        case .ended: return "Ended"
        }
    }

    /// A session is "active" while it still has ongoing or recently completed work.
    /// taskComplete is NOT active — the task is done, session is idle until next user message.
    var isActive: Bool {
        switch self {
        case .processing, .runningTool, .waitingForInput, .compacting: return true
        default: return false
        }
    }
}

// MARK: - Session Events (State Machine Input)

enum SessionEvent: Sendable {
    case sessionDiscovered(sessionId: String, cwd: String, workspace: CopilotWorkspace?)
    case sessionContextUpdated(sessionId: String, cwd: String, gitRoot: String?, branch: String?)
    case userMessageSent(sessionId: String, content: String)
    case assistantTurnStarted(sessionId: String)
    case assistantMessageReceived(sessionId: String, content: String, messageId: String)
    case toolStarted(sessionId: String, toolCallId: String, toolName: String, arguments: String)
    case toolCompleted(sessionId: String, toolCallId: String, success: Bool, result: String)
    case subagentStarted(sessionId: String, agentId: String, agentDisplayName: String)
    case subagentCompleted(sessionId: String, agentId: String)
    case assistantTurnEnded(sessionId: String)
    case taskCompleted(sessionId: String, summary: String?)   // session.task_complete
    case compactionStarted(sessionId: String)
    case compactionCompleted(sessionId: String)
    case sessionAborted(sessionId: String)
    case sessionError(sessionId: String, reason: String)
    case sessionShutdown(sessionId: String)
    case sessionSummaryUpdated(sessionId: String, summary: String)
    case sessionRemoved(sessionId: String)
}
