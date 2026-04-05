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
                            .foregroundColor(CopilotTheme.sagePrimary.opacity(0.8))
                            .padding(.horizontal, 5)
                            .padding(.vertical, 1)
                            .background(CopilotTheme.sagePrimary.opacity(0.1))
                            .clipShape(Capsule())
                    }

                    Spacer()

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
            return session.lastUserMessage.map { String(format: NSLocalizedString("Thinking: %@", comment: ""), $0) } ?? NSLocalizedString("Processing…", comment: "")
        case .waitingForInput:
            return session.lastUserMessage ?? NSLocalizedString("Waiting for input", comment: "")
        case .ended:
            return NSLocalizedString("Session ended", comment: "")
        case .error(let msg):
            return String(format: NSLocalizedString("Error: %@", comment: ""), msg)
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
                .tint(CopilotTheme.sagePrimary)
        case .runningTool:
            Image(systemName: "bolt.fill")
                .font(.system(size: 10))
                .foregroundColor(CopilotTheme.sagePrimary)
        case .waitingForInput:
            Image(systemName: "pause.circle")
                .font(.system(size: 12))
                .foregroundColor(CopilotTheme.githubBlue)
        default:
            EmptyView()
        }
    }
}
