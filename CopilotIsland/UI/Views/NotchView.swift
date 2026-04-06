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
        let peekW  = viewModel.peekWidth                // peek width on each side (50pt)
        let isPopping = viewModel.status == .popping
        let totalW = notchW + peekW * 2

        return HStack(spacing: 0) {
            // Left peek — status icon inside unified black bar
            HStack(spacing: 0) {
                Spacer()
                LeftPeekView(sessions: sessionMonitor.activeSessions)
                    .frame(width: 24, height: notchH)
                    .scaleEffect(isPopping ? 1.15 : 1.0)
                    .animation(viewModel.animation, value: isPopping)
                Spacer().frame(width: 6)
            }
            .frame(width: peekW, height: notchH)

            // Center indicator dots
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

            // Right peek — session count inside unified black bar
            HStack(spacing: 0) {
                Spacer().frame(width: 6)
                RightPeekView(count: sessionMonitor.sessions.count)
                    .frame(height: notchH)
                Spacer()
            }
            .frame(width: peekW, height: notchH)
        }
        // Single unified black background for the entire notch bar (left icon + center + right count).
        // topRadius=0: flat top flush with the screen edge; only bottom corners are rounded.
        .background(
            NotchShape(topRadius: 0, bottomRadius: isPopping ? 18 : 14)
                .fill(Color.black)
                .animation(viewModel.animation, value: isPopping)
        )
        .frame(width: totalW, height: notchH, alignment: .top)
    }

    // MARK: - Expanded State

    private var expandedContent: some View {
        VStack(spacing: 0) {
            // Spacer so card starts BELOW the physical notch, not overlapping it
            Spacer().frame(height: viewModel.deviceNotchRect.height + 4)

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

