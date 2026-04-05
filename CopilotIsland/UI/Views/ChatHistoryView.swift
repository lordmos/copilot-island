//
//  ChatHistoryView.swift
//  CopilotIsland
//
//  Displays the full conversation history for a Copilot session.
//

import SwiftUI

struct ChatHistoryView: View {
    let session: SessionState
    let onBack: () -> Void

    @State private var autoScroll = true

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

                VStack(alignment: .leading, spacing: 1) {
                    Text(session.projectName)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(CopilotTheme.textPrimary)

                    if let branch = session.gitBranch {
                        Text("on \(branch)")
                            .font(.system(size: 10))
                            .foregroundColor(CopilotTheme.textTertiary)
                    }
                }

                Spacer()

                // Status
                HStack(spacing: 4) {
                    Circle()
                        .fill(CopilotTheme.statusColor(for: session.phase))
                        .frame(width: 6, height: 6)
                    Text(session.phase.displayLabel)
                        .font(.system(size: 10))
                        .foregroundColor(CopilotTheme.textSecondary)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)

            Divider().background(CopilotTheme.border)

            if session.messages.isEmpty {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "message")
                        .font(.system(size: 24))
                        .foregroundColor(CopilotTheme.textTertiary)
                    Text("No messages yet")
                        .font(.system(size: 12))
                        .foregroundColor(CopilotTheme.textTertiary)
                }
                Spacer()
            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(session.messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding(12)
                    }
                    .onChange(of: session.messages.count) { _ in
                        if autoScroll, let last = session.messages.last {
                            withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                        }
                    }
                }
            }

            // Active tool indicator
            if case .runningTool(let name, let args) = session.phase {
                HStack(spacing: 8) {
                    ProgressView().scaleEffect(0.6)
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Running: \(name)")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(CopilotTheme.copilotPurple)
                        if !args.isEmpty && args != "{}" {
                            Text(args.prefix(60))
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(CopilotTheme.textTertiary)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(CopilotTheme.cardBackground)
            }
        }
    }
}

// MARK: - Message Bubble

struct MessageBubble: View {
    let message: CopilotMessage

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if message.role != .user { roleIcon }

            VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 2) {
                Text(message.content.isEmpty ? "(empty)" : message.content)
                    .font(.system(size: 12))
                    .foregroundColor(CopilotTheme.textPrimary)
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: message.role == .user ? .trailing : .leading)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(bubbleColor)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }

            if message.role == .user { roleIcon }
        }
        .frame(maxWidth: .infinity)
    }

    private var roleIcon: some View {
        Group {
            switch message.role {
            case .user:
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(CopilotTheme.githubBlue)
            case .assistant:
                Image(systemName: "sparkle")
                    .font(.system(size: 16))
                    .foregroundStyle(CopilotTheme.copilotGradient)
            case .tool:
                Image(systemName: message.toolSuccess == false ? "xmark.circle" : "checkmark.circle")
                    .font(.system(size: 16))
                    .foregroundColor(message.toolSuccess == false ? CopilotTheme.warningRed : CopilotTheme.successGreen)
            }
        }
    }

    private var bubbleColor: Color {
        switch message.role {
        case .user: return CopilotTheme.githubBlue.opacity(0.2)
        case .assistant: return CopilotTheme.cardBackground
        case .tool: return Color.black.opacity(0.3)
        }
    }
}
