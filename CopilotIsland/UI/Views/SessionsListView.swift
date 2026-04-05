//
//  SessionsListView.swift
//  CopilotIsland
//
//  Shows all active Copilot CLI sessions, sorted by activity.
//

import SwiftUI

struct SessionsListView: View {
    let sessions: [SessionState]
    let onSelectSession: (SessionState) -> Void
    let onAPIChat: () -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                if sessions.isEmpty {
                    emptyState
                } else {
                    ForEach(sessions) { session in
                        SessionCard(session: session)
                            .onTapGesture { onSelectSession(session) }
                    }
                }

                Divider().background(CopilotTheme.border).padding(.horizontal, 8)

                // Direct AI Chat button
                Button(action: onAPIChat) {
                    HStack(spacing: 8) {
                        Image(systemName: "bubble.left.and.bubble.right")
                            .font(.system(size: 13))
                            .foregroundStyle(CopilotTheme.copilotGradient)

                        Text("Chat with GitHub Models AI")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(CopilotTheme.textPrimary)

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.system(size: 10))
                            .foregroundColor(CopilotTheme.textTertiary)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .copilotCard()
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 8)
            }
            .padding(12)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "terminal")
                .font(.system(size: 32))
                .foregroundStyle(CopilotTheme.copilotGradient)

            Text("No active Copilot sessions")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(CopilotTheme.textSecondary)

            Text("Run the Copilot CLI to get started")
                .font(.system(size: 11))
                .foregroundColor(CopilotTheme.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}

// MARK: - Session Card

struct SessionCard: View {
    let session: SessionState

    var body: some View {
        HStack(spacing: 12) {
            // Status bar
            RoundedRectangle(cornerRadius: 2)
                .fill(CopilotTheme.statusColor(for: session.phase))
                .frame(width: 3, height: 36)

            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(session.projectName)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(CopilotTheme.textPrimary)
                        .lineLimit(1)

                    if let branch = session.gitBranch {
                        Text(branch)
                            .font(.system(size: 10))
                            .foregroundColor(CopilotTheme.textTertiary)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 1)
                            .background(CopilotTheme.border)
                            .clipShape(Capsule())
                    }

                    Spacer()

                    // Phase indicator
                    phaseIndicator
                }

                Text(statusText)
                    .font(.system(size: 11))
                    .foregroundColor(CopilotTheme.textSecondary)
                    .lineLimit(1)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .copilotCard()
    }

    private var statusText: String {
        switch session.phase {
        case .runningTool(let name, _):
            return "⚡ \(name)"
        case .processing:
            return session.lastUserMessage.map { "Thinking: \($0)" } ?? "Processing…"
        case .waitingForInput:
            return session.lastUserMessage ?? "Waiting for input"
        case .ended:
            return "Session ended"
        case .error(let msg):
            return "Error: \(msg)"
        default:
            return session.phase.displayLabel
        }
    }

    @ViewBuilder
    private var phaseIndicator: some View {
        switch session.phase {
        case .processing:
            ProgressView()
                .scaleEffect(0.5)
                .frame(width: 14, height: 14)
        case .runningTool:
            Image(systemName: "bolt.fill")
                .font(.system(size: 10))
                .foregroundColor(CopilotTheme.copilotPurple)
        case .waitingForInput:
            Image(systemName: "pause.circle")
                .font(.system(size: 12))
                .foregroundColor(CopilotTheme.githubBlue)
        default:
            EmptyView()
        }
    }
}
