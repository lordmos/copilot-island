//
//  NotchView.swift
//  CopilotIsland
//
//  Root view for the notch overlay. Handles expand/collapse animation
//  and routes to the correct content view.
//

import SwiftUI

struct NotchView: View {
    @ObservedObject var viewModel: NotchViewModel
    @ObservedObject var sessionMonitor: CopilotSessionMonitor

    var body: some View {
        ZStack(alignment: .top) {
            Color.clear

            if viewModel.status == .opened {
                expandedContent
                    .transition(.opacity.combined(with: .scale(scale: 0.97, anchor: .top)))
            } else {
                closedPill
                    .transition(.opacity)
            }
        }
        .animation(viewModel.animation, value: viewModel.status)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea()
    }

    // MARK: - Closed State (with peek)

    private var closedPill: some View {
        let notchW = viewModel.deviceNotchRect.width
        let notchH = viewModel.deviceNotchRect.height   // exact notch height, no padding
        let peekW: CGFloat = 50   // peek width on each side
        let isPopping = viewModel.status == .popping

        return HStack(spacing: 0) {
            // Left peek — status icon (transparent, no interaction)
            HStack {
                Spacer()
                LeftPeekView(sessions: sessionMonitor.activeSessions)
                    .frame(width: 24, height: notchH)
                    .scaleEffect(isPopping ? 1.15 : 1.0)
                    .animation(viewModel.animation, value: isPopping)
            }
            .frame(width: peekW, height: notchH)

            // Center notch pill — flush with screen top, rounded only at bottom
            HStack(spacing: 6) {
                Circle()
                    .fill(CopilotTheme.copilotGradient)
                    .frame(width: 7, height: 7)
                    .shadow(color: CopilotTheme.sagePrimary.opacity(0.8), radius: 4)

                if sessionMonitor.activeSessions.isEmpty {
                    Circle()
                        .fill(CopilotTheme.textTertiary)
                        .frame(width: 4, height: 4)
                } else {
                    PulsingDot()
                }
            }
            .frame(width: notchW, height: notchH)
            .background(
                // topRadius=0: flat top edge flush with screen; only bottom is rounded
                NotchShape(
                    topRadius: 0,
                    bottomRadius: isPopping ? 18 : 14
                )
                .fill(Color.black)
                .animation(viewModel.animation, value: isPopping)
            )

            // Right peek — session count (transparent, no interaction)
            HStack {
                RightPeekView(count: sessionMonitor.sessions.count)
                    .frame(height: notchH)
                Spacer()
            }
            .frame(width: peekW, height: notchH)
        }
        .frame(width: notchW + peekW * 2, height: notchH, alignment: .top)
    }

    // MARK: - Expanded State

    private var expandedContent: some View {
        VStack(spacing: 0) {
            // 4pt gap so the card visually drops from the notch
            Spacer().frame(height: 4)

            VStack(spacing: 0) {
                header

                Divider()
                    .background(CopilotTheme.border)

                contentArea
            }
            .background(CopilotTheme.background)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(CopilotTheme.border, lineWidth: 0.5)
            )
            .shadow(color: .black.opacity(0.55), radius: 18, y: 6)
            .frame(width: viewModel.openedSize.width, height: viewModel.openedSize.height)
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }

    private var header: some View {
        HStack {
            // Logo + Title
            HStack(spacing: 6) {
                Image(nsImage: NSApp.applicationIconImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))

                Text("Copilot Island")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(CopilotTheme.textPrimary)
            }

            Spacer()

            // Session count badge
            if !sessionMonitor.sessions.isEmpty {
                Text("\(sessionMonitor.sessions.count)")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(CopilotTheme.sagePrimary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(CopilotTheme.sagePrimary.opacity(0.12))
                    .clipShape(Capsule())
            }

            // Menu toggle
            Button(action: { viewModel.toggleMenu() }) {
                Image(systemName: viewModel.contentType == .menu ? "xmark" : "ellipsis")
                    .font(.system(size: 12))
                    .foregroundColor(CopilotTheme.textSecondary)
                    .frame(width: 24, height: 24)
                    .background(CopilotTheme.cardBackground)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    @ViewBuilder
    private var contentArea: some View {
        switch viewModel.contentType {
        case .sessions:
            SessionsListView(
                sessions: sessionMonitor.sessions,
                onSelectSession: { viewModel.showChat(for: $0) }
            )
        case .chat(let sessionId):
            // Look up the LIVE session by ID so ChatHistoryView always has fresh data
            if let liveSession = sessionMonitor.sessions.first(where: { $0.sessionId == sessionId }) {
                ChatHistoryView(
                    session: liveSession,
                    onBack: { viewModel.exitChat() }
                )
            } else {
                // Session was removed — fall back to list
                SessionsListView(
                    sessions: sessionMonitor.sessions,
                    onSelectSession: { viewModel.showChat(for: $0) }
                )
            }
        case .agentChat:
            SessionsListView(
                sessions: sessionMonitor.sessions,
                onSelectSession: { viewModel.showChat(for: $0) }
            )
        case .menu:
            MenuView(onClose: { viewModel.toggleMenu() })
        }
    }
}

// MARK: - Pulsing Dot

struct PulsingDot: View {
    @State private var pulsing = false

    var body: some View {
        ZStack {
            Circle()
                .fill(CopilotTheme.sageGlow.opacity(0.3))
                .frame(width: 10, height: 10)
                .scaleEffect(pulsing ? 1.6 : 1.0)
                .opacity(pulsing ? 0 : 0.8)

            Circle()
                .fill(CopilotTheme.sageGlow)
                .frame(width: 6, height: 6)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: false)) {
                pulsing = true
            }
        }
    }
}

