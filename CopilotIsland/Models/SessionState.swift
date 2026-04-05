//
//  SessionState.swift
//  CopilotIsland
//
//  Unified state model for a Copilot CLI session.
//

import Foundation

struct SessionState: Equatable, Identifiable, Sendable {
    // MARK: - Identity
    let sessionId: String
    let cwd: String
    let projectName: String
    let gitBranch: String?

    // MARK: - Process Info
    var pid: Int?

    // MARK: - State
    var phase: SessionPhase

    // MARK: - Chat History
    var messages: [CopilotMessage]

    // MARK: - Tool Tracking
    var currentTool: ActiveTool?

    // MARK: - Summary
    var summary: String?
    var lastUserMessage: String?

    // MARK: - Timestamps
    var lastActivity: Date
    var createdAt: Date

    var id: String { sessionId }

    init(
        sessionId: String,
        cwd: String,
        projectName: String? = nil,
        gitBranch: String? = nil,
        pid: Int? = nil,
        phase: SessionPhase = .idle,
        messages: [CopilotMessage] = [],
        currentTool: ActiveTool? = nil,
        summary: String? = nil,
        lastUserMessage: String? = nil,
        lastActivity: Date = Date(),
        createdAt: Date = Date()
    ) {
        self.sessionId = sessionId
        self.cwd = cwd
        self.projectName = projectName ?? URL(fileURLWithPath: cwd).lastPathComponent
        self.gitBranch = gitBranch
        self.pid = pid
        self.phase = phase
        self.messages = messages
        self.currentTool = currentTool
        self.summary = summary
        self.lastUserMessage = lastUserMessage
        self.lastActivity = lastActivity
        self.createdAt = createdAt
    }

    // MARK: - Derived Properties

    var needsAttention: Bool { phase.needsAttention }

    var displayTitle: String {
        summary ?? lastUserMessage ?? projectName
    }

    var stableId: String {
        if let pid { return "\(pid)-\(sessionId)" }
        return sessionId
    }
}

// MARK: - Supporting Types

struct ActiveTool: Equatable, Sendable {
    let toolCallId: String
    let toolName: String
    let arguments: String
    let startTime: Date
}

struct CopilotMessage: Equatable, Identifiable, Sendable {
    let id: String
    let role: MessageRole
    let content: String
    let toolName: String?
    let toolSuccess: Bool?
    let timestamp: Date

    enum MessageRole: String, Sendable {
        case user, assistant, tool
    }
}
