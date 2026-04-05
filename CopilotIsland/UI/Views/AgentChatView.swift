//
//  AgentChatView.swift
//  CopilotIsland
//
//  In-app chat view powered by the GitHub Copilot API.
//  Supports streaming responses and full Markdown rendering.
//

import SwiftUI

struct AgentChatView: View {
    @ObservedObject var client: GitHubCopilotClient
    let onBack: () -> Void

    @State private var inputText = ""
    @FocusState private var inputFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider().background(CopilotTheme.border)
            if !client.hasToken {
                noTokenPlaceholder
            } else {
                messageArea
                Divider().background(CopilotTheme.border)
                inputBar
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 8) {
            Button(action: onBack) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 11, weight: .semibold))
                    Text("Back")
                        .font(.system(size: 12, weight: .medium))
                }
                .foregroundColor(CopilotTheme.sagePrimary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(CopilotTheme.sagePrimary.opacity(0.1))
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)

            Spacer()

            HStack(spacing: 6) {
                Image(nsImage: NSApp.applicationIconImage)
                    .resizable().scaledToFit()
                    .frame(width: 18, height: 18)
                    .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                Text("Copilot Chat")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(CopilotTheme.textPrimary)
            }

            if client.isStreaming {
                ProgressView().scaleEffect(0.6).tint(CopilotTheme.sagePrimary)
            }

            if !client.messages.isEmpty {
                Button(action: { client.clearConversation() }) {
                    Image(systemName: "trash")
                        .font(.system(size: 11))
                        .foregroundColor(CopilotTheme.textTertiary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }

    // MARK: - No Token

    private var noTokenPlaceholder: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "key.horizontal")
                .font(.system(size: 28))
                .foregroundStyle(CopilotTheme.copilotGradient)
            Text("GitHub Token Required")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(CopilotTheme.textPrimary)
            Text("Add your GitHub Personal Access Token\nin Settings (⋯) to start chatting.")
                .font(.system(size: 12))
                .foregroundColor(CopilotTheme.textSecondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
    }

    // MARK: - Message Area

    private var messageArea: some View {
        Group {
            if client.messages.isEmpty {
                VStack(spacing: 10) {
                    Spacer()
                    Image(systemName: "bubble.left.and.bubble.right")
                        .font(.system(size: 28))
                        .foregroundStyle(CopilotTheme.copilotGradient)
                    Text("Ask Copilot anything")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(CopilotTheme.textSecondary)
                    if let err = client.errorMessage {
                        Text(err)
                            .font(.system(size: 11))
                            .foregroundColor(CopilotTheme.warningRed)
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                }
                .padding(.horizontal)
            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(client.messages) { message in
                                AgentMessageRow(message: message)
                                    .id(message.id)
                            }
                            if let err = client.errorMessage {
                                Text(err)
                                    .font(.system(size: 11))
                                    .foregroundColor(CopilotTheme.warningRed)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 4)
                            }
                        }
                        .padding(12)
                    }
                    .onAppear {
                        if let last = client.messages.last {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                    .onChange(of: client.messages.count) { _, _ in
                        if let last = client.messages.last {
                            withAnimation(.easeOut(duration: 0.15)) {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                    .onChange(of: client.messages.last?.content) { _, _ in
                        if let last = client.messages.last {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Input Bar

    private var inputBar: some View {
        HStack(spacing: 8) {
            TextField("Message Copilot…", text: $inputText, axis: .vertical)
                .textFieldStyle(.plain)
                .font(.system(size: 13))
                .foregroundColor(CopilotTheme.textPrimary)
                .lineLimit(1...4)
                .focused($inputFocused)
                .onSubmit {
                    if !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        && !client.isStreaming {
                        sendMessage()
                    }
                }
                .onAppear { inputFocused = true }

            Button(action: sendMessage) {
                Image(systemName: client.isStreaming ? "stop.circle.fill" : "arrow.up.circle.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(
                        (inputText.isEmpty && !client.isStreaming)
                            ? AnyShapeStyle(CopilotTheme.textTertiary)
                            : AnyShapeStyle(CopilotTheme.copilotGradient)
                    )
            }
            .buttonStyle(.plain)
            .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !client.isStreaming)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(CopilotTheme.cardBackground)
    }

    private func sendMessage() {
        if client.isStreaming {
            // Stop is handled via task cancellation inside client
            return
        }
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        inputText = ""
        client.sendMessage(text)
    }
}

// MARK: - Message Row

private struct AgentMessageRow: View {
    let message: ChatMessage

    var body: some View {
        switch message.role {
        case .user:
            HStack(alignment: .top, spacing: 8) {
                Spacer(minLength: 40)
                Text(message.content.isEmpty ? "(empty)" : message.content)
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                    .textSelection(.enabled)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 11)
                    .padding(.vertical, 8)
                    .background(CopilotTheme.githubBlue.opacity(0.75))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(CopilotTheme.githubBlue)
            }
        case .assistant, .system:
            HStack(alignment: .top, spacing: 8) {
                Image(nsImage: NSApp.applicationIconImage)
                    .resizable().scaledToFit()
                    .frame(width: 22, height: 22)
                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    .padding(.top, 1)
                VStack(alignment: .leading, spacing: 0) {
                    if message.content.isEmpty {
                        TypingIndicator()
                    } else {
                        MarkdownMessageView(text: message.content)
                    }
                }
                .padding(.horizontal, 11)
                .padding(.vertical, 8)
                .background(CopilotTheme.sagePrimary.opacity(0.07))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer(minLength: 16)
            }
        }
    }
}

// MARK: - Typing Indicator

private struct TypingIndicator: View {
    @State private var dotIndex = 0
    private let timer = Timer.publish(every: 0.4, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { i in
                Circle()
                    .fill(CopilotTheme.sagePrimary.opacity(dotIndex == i ? 0.9 : 0.3))
                    .frame(width: 6, height: 6)
                    .animation(.easeInOut(duration: 0.2), value: dotIndex)
            }
        }
        .onReceive(timer) { _ in
            dotIndex = (dotIndex + 1) % 3
        }
    }
}
