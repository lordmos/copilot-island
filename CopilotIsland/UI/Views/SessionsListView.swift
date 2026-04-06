//
//  SessionsListView.swift
//  CopilotIsland
//
//  Sessions grouped by project.
//  Each project card has a header row + one session row per active session.
//

import SwiftUI

struct SessionsListView: View {
    let sessions: [SessionState]
    let onSelectSession: (SessionState) -> Void

    // Group by projectName, sorted by most-recent activity within each group
    private var grouped: [(project: String, sessions: [SessionState])] {
        let dict = Dictionary(grouping: sessions) { $0.projectName }
        return dict
            .sorted { a, b in
                let aLatest = a.value.map(\.lastActivity).max() ?? .distantPast
                let bLatest = b.value.map(\.lastActivity).max() ?? .distantPast
                return aLatest > bLatest
            }
            .map { (
                project: $0.key,
                sessions: $0.value.sorted { $0.lastActivity > $1.lastActivity }
            )}
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                if sessions.isEmpty {
                    emptyState
                } else {
                    ForEach(grouped, id: \.project) { group in
                        ProjectGroupCard(
                            projectName: group.project,
                            sessions: group.sessions,
                            onSelect: onSelectSession
                        )
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
            Text(NSLocalizedString("No active Copilot sessions", comment: ""))
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(CopilotTheme.textSecondary)
            Text(NSLocalizedString("Run the Copilot CLI to get started", comment: ""))
                .font(.system(size: 11))
                .foregroundColor(CopilotTheme.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}

// MARK: - Project Group Card

private struct ProjectGroupCard: View {
    let projectName: String
    let sessions: [SessionState]
    let onSelect: (SessionState) -> Void

    // Most urgent phase among all sessions in this group
    private var groupPhase: SessionPhase {
        if sessions.contains(where: { if case .processing = $0.phase { return true }; return false }) { return .processing }
        if sessions.contains(where: { if case .runningTool = $0.phase { return true }; return false }) { return sessions.first(where: { if case .runningTool = $0.phase { return true }; return false })!.phase }
        return sessions.first?.phase ?? .idle
    }

    var body: some View {
        VStack(spacing: 0) {
            // ── Project Header ──────────────────────────────────────
            HStack(spacing: 8) {
                // Colored project accent dot
                Circle()
                    .fill(CopilotTheme.statusColor(for: groupPhase))
                    .frame(width: 7, height: 7)

                Image(systemName: "folder.fill")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(CopilotTheme.sagePrimary.opacity(0.7))

                Text(projectName)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(CopilotTheme.textSecondary)
                    .lineLimit(1)

                Spacer()

                // Session count badge (only when > 1)
                if sessions.count > 1 {
                    Text("\(sessions.count)")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(CopilotTheme.sagePrimary)
                        .frame(minWidth: 16)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(CopilotTheme.sagePrimary.opacity(0.15))
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(CopilotTheme.sagePrimary.opacity(0.05))
            // Bottom separator between header and session rows
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(CopilotTheme.border)
                    .frame(height: 0.5)
            }

            // ── Session Rows ────────────────────────────────────────
            ForEach(Array(sessions.enumerated()), id: \.element.id) { idx, session in
                if idx > 0 {
                    Rectangle()
                        .fill(CopilotTheme.border.opacity(0.5))
                        .frame(height: 0.5)
                        .padding(.leading, 20)
                }
                SessionRow(session: session)
                    .contentShape(Rectangle())
                    .onTapGesture { onSelect(session) }
            }
        }
        .background(CopilotTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(CopilotTheme.border, lineWidth: 0.5)
        )
    }
}

// MARK: - Session Row

private struct SessionRow: View {
    let session: SessionState

    var body: some View {
        HStack(spacing: 0) {
            // Left status bar (phase color accent)
            RoundedRectangle(cornerRadius: 1.5)
                .fill(CopilotTheme.statusColor(for: session.phase))
                .frame(width: 3)
                .padding(.vertical, 10)
                .padding(.leading, 10)
                .padding(.trailing, 10)

            // Phase indicator (fixed-width column)
            phaseIndicator
                .frame(width: 18, alignment: .center)

            // Main content
            VStack(alignment: .leading, spacing: 3) {
                Text(statusText)
                    .font(.system(size: 12))
                    .foregroundColor(CopilotTheme.textPrimary)
                    .lineLimit(1)

                if let branch = session.gitBranch {
                    HStack(spacing: 3) {
                        Image(systemName: "arrow.triangle.branch")
                            .font(.system(size: 8))
                            .foregroundColor(CopilotTheme.sagePrimary.opacity(0.6))
                        Text(branch)
                            .font(.system(size: 10))
                            .foregroundColor(CopilotTheme.sagePrimary.opacity(0.75))
                            .lineLimit(1)
                    }
                }
            }
            .padding(.leading, 8)

            Spacer(minLength: 8)

            // Relative time
            Text(relativeTime)
                .font(.system(size: 10))
                .foregroundColor(CopilotTheme.textTertiary)
                .monospacedDigit()
                .padding(.trailing, 12)
        }
        .frame(minHeight: 46)
    }

    // MARK: Status text

    private var statusText: String {
        switch session.phase {
        case .runningTool(let name, _):
            return "⚡ \(name)"
        case .processing:
            return session.lastUserMessage
                .map { NSLocalizedString("Thinking: ", comment: "") + $0 }
                ?? NSLocalizedString("Processing…", comment: "")
        case .waitingForInput:
            return session.lastUserMessage
                ?? NSLocalizedString("Waiting for input", comment: "")
        case .taskComplete:
            return session.summary
                ?? session.lastUserMessage
                ?? NSLocalizedString("Task complete", comment: "")
        case .compacting:
            return NSLocalizedString("Compacting context…", comment: "")
        case .ended:
            return NSLocalizedString("Session ended", comment: "")
        case .error(let msg):
            return String(format: NSLocalizedString("Error: %@", comment: ""), msg)
        default:
            return session.phase.displayLabel
        }
    }

    // MARK: Phase indicator

    @ViewBuilder
    private var phaseIndicator: some View {
        switch session.phase {
        case .processing, .compacting:
            SageSpinner(size: 12)
                .frame(width: 14, height: 14)
        case .runningTool:
            Image(systemName: "bolt.fill")
                .font(.system(size: 10))
                .foregroundColor(CopilotTheme.sagePrimary)
        case .taskComplete:
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 12))
                .foregroundColor(CopilotTheme.successGreen)
        case .waitingForInput:
            Image(systemName: "pause.circle")
                .font(.system(size: 12))
                .foregroundColor(CopilotTheme.textTertiary)
        case .error:
            Image(systemName: "exclamationmark.circle.fill")
                .font(.system(size: 12))
                .foregroundColor(CopilotTheme.warningRed)
        default:
            EmptyView()
        }
    }

    // MARK: Relative time

    private var relativeTime: String {
        let s = Date().timeIntervalSince(session.lastActivity)
        if s < 60 { return NSLocalizedString("now", comment: "") }
        if s < 3600 { return "\(Int(s / 60))m" }
        if s < 86400 { return "\(Int(s / 3600))h" }
        return "\(Int(s / 86400))d"
    }
}

