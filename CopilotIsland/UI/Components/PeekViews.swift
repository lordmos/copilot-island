//
//  PeekViews.swift
//  CopilotIsland
//
//  Animated status icons that peek out from the left/right of the notch
//  when the panel is closed. They rest on the menu bar.
//

import SwiftUI

// MARK: - Status category (derived from all active sessions)

enum NotchPeekStatus {
    case none          // no sessions
    case processing    // AI thinking / responding
    case runningTool   // tool executing (e.g. bash, read_file)
    case waitingInput  // turn ended, waiting for user
    case error         // any session in error/interrupted state
}

extension Array where Element == SessionState {
    var peekStatus: NotchPeekStatus {
        if isEmpty { return .none }
        if contains(where: { if case .error = $0.phase { return true }; return $0.phase == .interrupted }) { return .error }
        if contains(where: { if case .runningTool = $0.phase { return true }; return false }) { return .runningTool }
        if contains(where: { $0.phase == .processing }) { return .processing }
        if contains(where: { $0.phase == .waitingForInput }) { return .waitingInput }
        return .none
    }
}

// MARK: - Left peek: animated Copilot status icon

struct LeftPeekView: View {
    let sessions: [SessionState]

    var body: some View {
        let status = sessions.peekStatus
        Group {
            switch status {
            case .none:
                EmptyView()
            case .processing:
                SpinnerIcon()
            case .runningTool:
                ToolIcon()
            case .waitingInput:
                DoneIcon()
            case .error:
                ErrorIcon()
            }
        }
        .shadow(color: Color.black.opacity(0.45), radius: 3, y: 1)
    }
}

// MARK: - Right peek: session count

struct RightPeekView: View {
    let count: Int

    var body: some View {
        if count > 0 {
            Text("\(count)")
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundColor(CopilotTheme.sagePrimary)
                .padding(.horizontal, 5)
                .padding(.vertical, 2)
                .background(CopilotTheme.sagePrimary.opacity(0.18))
                .clipShape(Capsule())
                .shadow(color: Color.black.opacity(0.4), radius: 2, y: 1)
        }
    }
}

// MARK: - Individual icon views

/// Spinning arc — AI is processing
private struct SpinnerIcon: View {
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.72)
                .stroke(
                    AngularGradient(
                        colors: [CopilotTheme.sagePrimary, CopilotTheme.sagePrimary.opacity(0.05)],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 2, lineCap: .round)
                )
                .rotationEffect(.degrees(rotation))
                .onAppear {
                    withAnimation(.linear(duration: 1.1).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }
                }
            Circle()
                .fill(CopilotTheme.sagePrimary)
                .frame(width: 4, height: 4)
        }
        .frame(width: 15, height: 15)
    }
}

/// Bouncing wrench — tool is running
private struct ToolIcon: View {
    @State private var bouncing = false

    var body: some View {
        Image(systemName: "wrench.and.screwdriver.fill")
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(Color(red: 1.0, green: 0.72, blue: 0.25))
            .offset(y: bouncing ? -2 : 1)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.55).repeatForever()) {
                    bouncing = true
                }
            }
    }
}

/// Gentle pulse — waiting for user input
private struct DoneIcon: View {
    @State private var glowing = false

    var body: some View {
        Image(systemName: "checkmark.circle.fill")
            .font(.system(size: 14))
            .foregroundStyle(CopilotTheme.copilotGradient)
            .opacity(glowing ? 1.0 : 0.55)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.4).repeatForever()) {
                    glowing = true
                }
            }
    }
}

/// Pulsing red exclamation — error or interrupted
private struct ErrorIcon: View {
    @State private var pulsing = false

    var body: some View {
        Image(systemName: "exclamationmark.circle.fill")
            .font(.system(size: 14))
            .foregroundColor(CopilotTheme.warningRed)
            .scaleEffect(pulsing ? 1.18 : 1.0)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.75).repeatForever()) {
                    pulsing = true
                }
            }
    }
}
