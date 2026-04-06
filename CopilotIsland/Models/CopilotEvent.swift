//
//  CopilotEvent.swift
//  CopilotIsland
//
//  Event types parsed from ~/.copilot/session-state/{id}/events.jsonl
//

import Foundation

// MARK: - Raw JSONL Event

struct CopilotRawEvent: Codable, Sendable {
    let type: String
    let data: CopilotEventData?

    enum CodingKeys: String, CodingKey {
        case type, data
    }
}

struct CopilotEventData: Codable, Sendable {
    // session.start
    let sessionId: String?
    let copilotVersion: String?
    let startTime: String?
    let context: SessionStartContext?   // cwd, branch, gitRoot

    // user.message
    let content: String?
    let interactionId: String?

    // assistant.turn_start / turn_end
    let turnId: String?

    // assistant.message
    let messageId: String?
    let toolRequests: [CopilotToolRequest]?
    let reasoningText: String?

    // tool.execution_start / complete
    let toolCallId: String?
    let toolName: String?
    let arguments: AnyCodable?
    let success: Bool?
    let result: AnyCodable?

    // session.shutdown / error
    let reason: String?
    let errorMessage: String?  // "message" field in session.error events

    // session.task_complete
    let summary: String?

    // subagent.started / completed
    let agentName: String?
    let agentDisplayName: String?

    enum CodingKeys: String, CodingKey {
        case sessionId, copilotVersion, startTime, context
        case content, interactionId
        case turnId
        case messageId, toolRequests, reasoningText
        case toolCallId, toolName, arguments
        case success, result
        case reason
        case errorMessage = "message"
        case summary
        case agentName, agentDisplayName
    }
}

/// Nested context block inside session.start events.
struct SessionStartContext: Codable, Sendable {
    let cwd: String?
    let gitRoot: String?
    let branch: String?
    let headCommit: String?
}

struct CopilotToolRequest: Codable, Sendable {
    let id: String?
    let name: String?
    let arguments: AnyCodable?
}

// Helper to decode arbitrary JSON values
struct AnyCodable: Codable, Sendable {
    let value: Any

    init(_ value: Any) { self.value = value }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let v = try? container.decode(String.self) { value = v }
        else if let v = try? container.decode(Int.self) { value = v }
        else if let v = try? container.decode(Double.self) { value = v }
        else if let v = try? container.decode(Bool.self) { value = v }
        else if let v = try? container.decode([String: AnyCodable].self) {
            value = v.mapValues { $0.value }
        } else if let v = try? container.decode([AnyCodable].self) {
            value = v.map { $0.value }
        } else { value = NSNull() }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case let v as String: try container.encode(v)
        case let v as Int: try container.encode(v)
        case let v as Double: try container.encode(v)
        case let v as Bool: try container.encode(v)
        default: try container.encodeNil()
        }
    }

    var stringValue: String {
        if let v = value as? String { return v }
        if let v = value as? [String: Any] {
            return (try? String(data: JSONSerialization.data(withJSONObject: v, options: .prettyPrinted), encoding: .utf8)) ?? "{}"
        }
        return String(describing: value)
    }
}

// MARK: - Session Workspace Metadata

struct CopilotWorkspace: Codable, Sendable {
    let id: String
    let cwd: String?
    let gitRoot: String?
    let branch: String?
    let summary: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, cwd
        case gitRoot = "git_root"
        case branch, summary
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
