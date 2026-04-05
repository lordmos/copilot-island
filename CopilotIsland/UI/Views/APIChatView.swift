//
//  APIChatView.swift
//  CopilotIsland
//
//  Standalone GitHub Models API chat — no CLI required.
//

import SwiftUI

struct APIChatView: View {
    let onBack: () -> Void

    @StateObject private var client = GitHubModelsClient.shared
    @ObservedObject private var settings = Settings.shared
    @State private var messages: [ChatMessage] = []
    @State private var inputText = ""
    @State private var isLoading = false
    @State private var streamingContent = ""
    @State private var errorMessage: String?
    @FocusState private var inputFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 8) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(CopilotTheme.textSecondary)
                }
                .buttonStyle(.plain)

                Image(systemName: "bubble.left.and.bubble.right")
                    .font(.system(size: 12))
                    .foregroundStyle(CopilotTheme.copilotGradient)

                Text("GitHub Models Chat")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(CopilotTheme.textPrimary)

                Spacer()

                if !client.isConfigured {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 12))
                        .foregroundColor(CopilotTheme.warningRed)
                }

                Text(settings.selectedModel)
                    .font(.system(size: 10))
                    .foregroundColor(CopilotTheme.textTertiary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(CopilotTheme.cardBackground)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)

            Divider().background(CopilotTheme.border)

            if !client.isConfigured {
                tokenSetupView
            } else {
                chatBody
            }
        }
    }

    // MARK: - Token Setup

    private var tokenSetupView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "key.fill")
                .font(.system(size: 28))
                .foregroundStyle(CopilotTheme.copilotGradient)

            Text("Add GitHub Token")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(CopilotTheme.textPrimary)

            Text("A GitHub token with\n`models:read` permission is required.")
                .font(.system(size: 11))
                .foregroundColor(CopilotTheme.textSecondary)
                .multilineTextAlignment(.center)

            Button("Open Settings") { NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil) }
                .buttonStyle(.plain)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(CopilotTheme.copilotPurple)
            Spacer()
        }
        .padding()
    }

    // MARK: - Chat

    private var chatBody: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(Array(messages.enumerated()), id: \.offset) { _, msg in
                            APIChatBubble(role: msg.role, content: msg.content)
                                .id("\(messages.count)-\(msg.role)-\(msg.content.prefix(10))")
                        }
                        if isLoading && !streamingContent.isEmpty {
                            APIChatBubble(role: "assistant", content: streamingContent + "▌")
                                .id("streaming")
                        }
                    }
                    .padding(12)
                }
                .onChange(of: messages.count) { _ in
                    withAnimation { proxy.scrollTo("streaming", anchor: .bottom) }
                }
                .onChange(of: streamingContent) { _ in
                    proxy.scrollTo("streaming", anchor: .bottom)
                }
            }

            if let err = errorMessage {
                Text(err)
                    .font(.system(size: 11))
                    .foregroundColor(CopilotTheme.warningRed)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
            }

            // Input bar
            HStack(spacing: 8) {
                TextField("Ask GitHub Models AI…", text: $inputText)
                    .textFieldStyle(.plain)
                    .font(.system(size: 12))
                    .foregroundColor(CopilotTheme.textPrimary)
                    .focused($inputFocused)
                    .onSubmit { sendMessage() }
                    .disabled(isLoading)

                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(
                            inputText.isEmpty || isLoading
                            ? AnyShapeStyle(CopilotTheme.textTertiary)
                            : AnyShapeStyle(CopilotTheme.copilotGradient)
                        )
                }
                .buttonStyle(.plain)
                .disabled(inputText.isEmpty || isLoading)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(CopilotTheme.cardBackground)
        }
    }

    private func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty, !isLoading else { return }

        inputText = ""
        errorMessage = nil
        messages.append(ChatMessage(role: "user", content: text))
        isLoading = true
        streamingContent = ""

        Task {
            await client.streamChat(
                messages: messages,
                model: settings.selectedModel,
                onChunk: { chunk in streamingContent += chunk },
                onComplete: {
                    messages.append(ChatMessage(role: "assistant", content: streamingContent))
                    streamingContent = ""
                    isLoading = false
                },
                onError: { err in
                    errorMessage = err.localizedDescription
                    isLoading = false
                    streamingContent = ""
                }
            )
        }
    }
}

struct APIChatBubble: View {
    let role: String
    let content: String

    var isUser: Bool { role == "user" }

    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            if !isUser {
                Image(systemName: "sparkle")
                    .font(.system(size: 14))
                    .foregroundStyle(CopilotTheme.copilotGradient)
            }
            Text(content)
                .font(.system(size: 12))
                .foregroundColor(CopilotTheme.textPrimary)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: isUser ? .trailing : .leading)
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(isUser ? CopilotTheme.githubBlue.opacity(0.2) : CopilotTheme.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            if isUser {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(CopilotTheme.githubBlue)
            }
        }
    }
}
