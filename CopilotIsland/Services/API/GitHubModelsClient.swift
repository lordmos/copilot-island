//
//  GitHubModelsClient.swift
//  CopilotIsland
//
//  Direct GitHub Models API client (OpenAI-compatible).
//  Provides standalone AI chat without requiring Copilot CLI to be running.
//

import Foundation

struct ChatMessage: Codable, Sendable {
    let role: String
    let content: String
}

struct ChatRequest: Codable {
    let model: String
    let messages: [ChatMessage]
    let stream: Bool
    let temperature: Double?

    init(model: String = "gpt-4o", messages: [ChatMessage], stream: Bool = true, temperature: Double? = nil) {
        self.model = model
        self.messages = messages
        self.stream = stream
        self.temperature = temperature
    }
}

struct ChatChunk: Codable {
    let choices: [Choice]

    struct Choice: Codable {
        let delta: Delta
        struct Delta: Codable {
            let content: String?
        }
    }
}

enum GitHubModelsError: Error, LocalizedError {
    case noToken
    case httpError(Int)
    case decodingError

    var errorDescription: String? {
        switch self {
        case .noToken: return "No GitHub token configured. Add a token in Settings."
        case .httpError(let code): return "HTTP error \(code)"
        case .decodingError: return "Failed to decode response"
        }
    }
}

class GitHubModelsClient: ObservableObject {
    static let shared = GitHubModelsClient()

    private let endpoint = URL(string: "https://models.inference.ai.azure.com/chat/completions")!
    private let keychainKey = "CopilotIsland.GitHubToken"

    @Published var isConfigured: Bool = false

    private init() {
        isConfigured = token != nil
    }

    // MARK: - Token Management (Keychain)

    var token: String? {
        get {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: keychainKey,
                kSecReturnData as String: true
            ]
            var result: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &result)
            guard status == errSecSuccess,
                  let data = result as? Data,
                  let token = String(data: data, encoding: .utf8)
            else { return nil }
            return token
        }
        set {
            if let newValue {
                let data = newValue.data(using: .utf8)!
                let query: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword,
                    kSecAttrAccount as String: keychainKey,
                    kSecValueData as String: data
                ]
                SecItemDelete(query as CFDictionary)
                SecItemAdd(query as CFDictionary, nil)
                isConfigured = true
            } else {
                let query: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword,
                    kSecAttrAccount as String: keychainKey
                ]
                SecItemDelete(query as CFDictionary)
                isConfigured = false
            }
        }
    }

    // MARK: - Streaming Chat

    func streamChat(
        messages: [ChatMessage],
        model: String = "gpt-4o",
        onChunk: @escaping (String) -> Void,
        onComplete: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    ) async {
        guard let token else { onError(GitHubModelsError.noToken); return }

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ChatRequest(model: model, messages: messages, stream: true)
        guard let data = try? JSONEncoder().encode(body) else { return }
        request.httpBody = data

        do {
            let (bytes, response) = try await URLSession.shared.bytes(for: request)
            guard let httpResponse = response as? HTTPURLResponse else { return }
            guard httpResponse.statusCode == 200 else {
                onError(GitHubModelsError.httpError(httpResponse.statusCode))
                return
            }

            for try await line in bytes.lines {
                guard line.hasPrefix("data: "),
                      !line.contains("[DONE]")
                else { continue }

                let jsonStr = String(line.dropFirst(6))
                guard let jsonData = jsonStr.data(using: .utf8),
                      let chunk = try? JSONDecoder().decode(ChatChunk.self, from: jsonData),
                      let content = chunk.choices.first?.delta.content
                else { continue }

                await MainActor.run { onChunk(content) }
            }

            await MainActor.run { onComplete() }
        } catch {
            onError(error)
        }
    }
}
