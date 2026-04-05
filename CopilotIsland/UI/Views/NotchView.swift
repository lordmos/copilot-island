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

    // MARK: - Closed State

    private var closedPill: some View {
        HStack(spacing: 6) {
            // Copilot dot
            Circle()
                .fill(CopilotTheme.copilotGradient)
                .frame(width: 8, height: 8)
                .shadow(color: CopilotTheme.copilotPurple.opacity(0.8), radius: 4)

            if sessionMonitor.activeSessions.isEmpty {
                // Idle — subtle pulse
                Circle()
                    .fill(CopilotTheme.textTertiary)
                    .frame(width: 5, height: 5)
            } else {
                // Active — cyan pulse
                PulsingDot()
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            NotchShape(
                topRadius: viewModel.status == .popping ? 9 : 6,
                bottomRadius: viewModel.status == .popping ? 18 : 14
            )
            .fill(Color.black)
        )
        .frame(
            width: viewModel.deviceNotchRect.width + 20,
            height: viewModel.deviceNotchRect.height + 8
        )
        .position(
            x: viewModel.screenRect.midX,
            y: viewModel.windowHeight - viewModel.deviceNotchRect.height / 2 - 4
        )
    }

    // MARK: - Expanded State

    private var expandedContent: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 4)

            VStack(spacing: 0) {
                header

                Divider()
                    .background(CopilotTheme.border)
                    .padding(.horizontal, 1)

                contentArea
            }
            .background(CopilotTheme.background)
            .clipShape(NotchShape(topRadius: 19, bottomRadius: 24))
            .overlay(
                NotchShape(topRadius: 19, bottomRadius: 24)
                    .strokeBorder(CopilotTheme.border, lineWidth: 0.5)
            )
            .shadow(color: .black.opacity(0.6), radius: 20, y: 8)
            .frame(width: viewModel.openedSize.width, height: viewModel.openedSize.height)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .position(
            x: viewModel.screenRect.midX,
            y: viewModel.windowHeight - viewModel.openedSize.height / 2 - 4
        )
    }

    private var header: some View {
        HStack {
            // Logo + Title
            HStack(spacing: 6) {
                Image(systemName: "sparkle")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(CopilotTheme.copilotGradient)

                Text("Copilot Island")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(CopilotTheme.textPrimary)
            }

            Spacer()

            // Session count badge
            if !sessionMonitor.sessions.isEmpty {
                Text("\(sessionMonitor.sessions.count)")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(CopilotTheme.textSecondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(CopilotTheme.cardBackground)
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
                onSelectSession: { viewModel.showChat(for: $0) },
                onAPIChat: { viewModel.showAPIChat() }
            )
        case .chat(let session):
            ChatHistoryView(
                session: session,
                onBack: { viewModel.exitChat() }
            )
        case .apiChat:
            APIChatView(onBack: { viewModel.exitChat() })
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
                .fill(CopilotTheme.neonCyan.opacity(0.3))
                .frame(width: 10, height: 10)
                .scaleEffect(pulsing ? 1.6 : 1.0)
                .opacity(pulsing ? 0 : 0.8)

            Circle()
                .fill(CopilotTheme.neonCyan)
                .frame(width: 6, height: 6)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: false)) {
                pulsing = true
            }
        }
    }
}
