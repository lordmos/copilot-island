//
//  ChatHistoryView.swift
//  CopilotIsland
//
//  Displays the full conversation history for a Copilot session.
//  - User messages: clean right-aligned bubble
//  - Assistant messages: full Markdown rendering with code blocks
//  - Tool messages: compact result card showing tool name + output
//

import SwiftUI

struct ChatHistoryView: View {
    let session: SessionState
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider().background(CopilotTheme.border)
            messageArea
            activeToolBar
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

            VStack(alignment: .trailing, spacing: 1) {
                Text(session.projectName)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(CopilotTheme.textPrimary)
                if let branch = session.gitBranch {
                    Text("on \(branch)")
                        .font(.system(size: 10))
                        .foregroundColor(CopilotTheme.sagePrimary.opacity(0.7))
                }
            }

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
    }

    // MARK: - Message Area

    @ViewBuilder
    private var messageArea: some View {
        if session.messages.isEmpty {
            Spacer()
            VStack(spacing: 8) {
                Image(systemName: "bubble.left")
                    .font(.system(size: 24))
                    .foregroundStyle(CopilotTheme.copilotGradient)
                Text("No messages yet")
                    .font(.system(size: 12))
                    .foregroundColor(CopilotTheme.textTertiary)
            }
            Spacer()
        } else {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(session.messages) { message in
                            MessageRow(message: message)
                                .id(message.id)
                        }
                    }
                    .padding(12)
                }
                .onAppear {
                    if let last = session.messages.last {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
                .onChange(of: session.messages.count) { _ in
                    if let last = session.messages.last {
                        withAnimation(.easeOut(duration: 0.2)) {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Active Tool Indicator

    @ViewBuilder
    private var activeToolBar: some View {
        if case .runningTool(let name, let args) = session.phase {
            HStack(spacing: 8) {
                ProgressView().scaleEffect(0.6).tint(CopilotTheme.sagePrimary)
                VStack(alignment: .leading, spacing: 1) {
                    Text(NSLocalizedString("Running: %@", comment: "").replacingOccurrences(of: "%@", with: name))
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(CopilotTheme.sagePrimary)
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
            .background(CopilotTheme.sagePrimary.opacity(0.06))
        }
    }
}

// MARK: - Message Row (dispatches to per-role views)

private struct MessageRow: View {
    let message: CopilotMessage

    var body: some View {
        switch message.role {
        case .user:
            UserMessageBubble(message: message)
        case .assistant:
            AssistantMessageBubble(message: message)
        case .tool:
            ToolResultCard(message: message)
        }
    }
}

// MARK: - User Message Bubble

private struct UserMessageBubble: View {
    let message: CopilotMessage

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Spacer(minLength: 40)
            Text(message.content.isEmpty ? NSLocalizedString("(empty)", comment: "") : message.content)
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
    }
}

// MARK: - Assistant Message Bubble

private struct AssistantMessageBubble: View {
    let message: CopilotMessage

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "leaf.fill")
                .font(.system(size: 15))
                .foregroundStyle(CopilotTheme.copilotGradient)
                .frame(width: 18)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 0) {
                if message.content.isEmpty {
                    Text(NSLocalizedString("(empty)", comment: ""))
                        .font(.system(size: 12))
                        .foregroundColor(CopilotTheme.textTertiary)
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

// MARK: - Tool Result Card

private struct ToolResultCard: View {
    let message: CopilotMessage
    @State private var expanded = false

    private var toolLabel: String { message.toolName ?? "tool" }
    private var success: Bool { message.toolSuccess ?? true }
    private var trimmedContent: String { message.content.trimmingCharacters(in: .whitespacesAndNewlines) }
    private var isLong: Bool { trimmedContent.count > 300 }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header row
            Button(action: { withAnimation(.easeInOut(duration: 0.2)) { expanded.toggle() } }) {
                HStack(spacing: 6) {
                    Image(systemName: success ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(success ? CopilotTheme.successGreen : CopilotTheme.warningRed)

                    Text(toolLabel)
                        .font(.system(size: 11, weight: .semibold, design: .monospaced))
                        .foregroundColor(CopilotTheme.textSecondary)

                    Spacer()

                    if !trimmedContent.isEmpty {
                        Image(systemName: expanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 9))
                            .foregroundColor(CopilotTheme.textTertiary)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
            }
            .buttonStyle(.plain)

            // Expandable result
            if expanded && !trimmedContent.isEmpty {
                Divider().background(CopilotTheme.border.opacity(0.5))
                ScrollView {
                    Text(isLong && !expanded ? String(trimmedContent.prefix(300)) + "…" : trimmedContent)
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(CopilotTheme.textSecondary)
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                }
                .frame(maxHeight: 140)
            }
        }
        .background(Color.black.opacity(0.25))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(
                    success ? CopilotTheme.border : CopilotTheme.warningRed.opacity(0.3),
                    lineWidth: 0.5
                )
        )
        .padding(.leading, 26)
    }
}

