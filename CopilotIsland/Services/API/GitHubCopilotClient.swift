//
//  GitHubCopilotClient.swift
//  CopilotIsland
//
//  Streams responses from the GitHub Copilot Chat API.
//  Endpoint: https://api.githubcopilot.com/chat/completions (SSE streaming)
//  Auth: Personal Access Token with `copilot_chat:read` scope or fine-grained token.
//

import Foundation

struct ChatMessage: Codable, Equatable, Identifiable {
    let id: String
    let role: ChatRole
    var content: String
    let timestamp: Date

    enum ChatRole: String, Codable {
        case user, assistant, system
    }
}

@MainActor
final class GitHubCopilotClient: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var isStreaming = false
    @Published var errorMessage: String?

    private var streamTask: Task<Void, Never>?
    private let endpoint = URL(string: "https://api.githubcopilot.com/chat/completions")!

    var token: String {
        get { KeychainHelper.shared.loadToken() ?? "" }
        set { KeychainHelper.shared.saveToken(newValue) }
    }

    var hasToken: Bool { !token.isEmpty }

    func sendMessage(_ text: String) {
        let userMsg = ChatMessage(
            id: UUID().uuidString,
            role: .user,
            content: text,
            timestamp: Date()
        )
        messages.append(userMsg)
        errorMessage = nil
        streamAssistantReply()
    }

    func clearConversation() {
        streamTask?.cancel()
        messages.removeAll()
        isStreaming = false
        errorMessage = nil
    }

    // MARK: - Streaming

    private func streamAssistantReply() {
        guard hasToken else {
            errorMessage = "GitHub token not set. Add it in Settings (⋯ menu)."
            return
        }

        isStreaming = true
        let historyForAPI = buildAPIMessages()
        let currentToken = token

        let placeholderId = UUID().uuidString
        let placeholder = ChatMessage(
            id: placeholderId,
            role: .assistant,
            content: "",
            timestamp: Date()
        )
        messages.append(placeholder)

        streamTask = Task {
            do {
                var request = URLRequest(url: endpoint)
                request.httpMethod = "POST"
                request.setValue("Bearer \(currentToken)", forHTTPHeaderField: "Authorization")
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("CopilotIsland/1.0", forHTTPHeaderField: "User-Agent")
                request.setValue("text/event-stream", forHTTPHeaderField: "Accept")

                let body: [String: Any] = [
                    "model": "gpt-4o",
                    "stream": true,
                    "messages": historyForAPI
                ]
                request.httpBody = try JSONSerialization.data(withJSONObject: body)

                let (stream, response) = try await URLSession.shared.bytes(for: request)

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    let statusError = "API error \(httpResponse.statusCode). Check your token."
                    await MainActor.run {
                        self.errorMessage = statusError
                        self.removeMessage(id: placeholderId)
                        self.isStreaming = false
                    }
                    return
                }

                var accumulated = ""
                for try await line in stream.lines {
                    if Task.isCancelled { break }
                    guard line.hasPrefix("data: ") else { continue }
                    let data = String(line.dropFirst(6))
                    guard data != "[DONE]" else { break }

                    if let chunk = parseSSEChunk(data) {
                        accumulated += chunk
                        let snapshot = accumulated
                        await MainActor.run {
                            self.updateMessage(id: placeholderId, content: snapshot)
                        }
                    }
                }

                await MainActor.run {
                    self.isStreaming = false
                    SoundManager.shared.playAgentDone()
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.removeMessage(id: placeholderId)
                    self.isStreaming = false
                }
            }
        }
    }

    // MARK: - Helpers

    private func buildAPIMessages() -> [[String: String]] {
        var result: [[String: String]] = [
            ["role": "system", "content": "You are GitHub Copilot, an AI assistant. Be helpful, concise, and accurate."]
        ]
        for msg in messages where msg.role != .system {
            result.append(["role": msg.role.rawValue, "content": msg.content])
        }
        return result
    }

    private func parseSSEChunk(_ json: String) -> String? {
        guard let data = json.data(using: .utf8),
              let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let choices = obj["choices"] as? [[String: Any]],
              let delta = choices.first?["delta"] as? [String: Any],
              let content = delta["content"] as? String else { return nil }
        return content
    }

    private func updateMessage(id: String, content: String) {
        if let idx = messages.firstIndex(where: { $0.id == id }) {
            messages[idx] = ChatMessage(
                id: id, role: .assistant, content: content, timestamp: messages[idx].timestamp
            )
        }
    }

    private func removeMessage(id: String) {
        messages.removeAll { $0.id == id }
    }
}
