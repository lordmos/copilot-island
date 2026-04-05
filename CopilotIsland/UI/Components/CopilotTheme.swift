//
//  CopilotTheme.swift
//  CopilotIsland
//
//  Copilot Island design system — colors, typography, spacing.
//

import SwiftUI

enum CopilotTheme {
    // MARK: - Colors

    /// GitHub Copilot Purple
    static let copilotPurple = Color(red: 0.43, green: 0.25, blue: 0.79)
    /// GitHub Blue
    static let githubBlue = Color(red: 0.12, green: 0.44, blue: 0.92)
    /// Neon Cyan — active/processing state
    static let neonCyan = Color(red: 0.0, green: 0.83, blue: 1.0)
    /// Success green (GitHub)
    static let successGreen = Color(red: 0.18, green: 0.64, blue: 0.31)
    /// Warning/deny amber-red
    static let warningRed = Color(red: 0.97, green: 0.51, blue: 0.40)
    /// Deep Space background
    static let background = Color(red: 0.05, green: 0.07, blue: 0.09)
    /// Card background (GitHub dark card)
    static let cardBackground = Color(red: 0.086, green: 0.106, blue: 0.133)
    /// Primary text
    static let textPrimary = Color.white.opacity(0.92)
    /// Secondary text
    static let textSecondary = Color.white.opacity(0.55)
    /// Tertiary text
    static let textTertiary = Color.white.opacity(0.28)
    /// Border/divider
    static let border = Color.white.opacity(0.08)

    // MARK: - Status Colors

    static func statusColor(for phase: SessionPhase) -> Color {
        switch phase {
        case .processing: return neonCyan
        case .runningTool: return copilotPurple
        case .waitingForInput: return githubBlue
        case .ended: return textTertiary
        case .error: return warningRed
        case .interrupted: return warningRed
        default: return textTertiary
        }
    }

    // MARK: - Gradients

    static let copilotGradient = LinearGradient(
        colors: [copilotPurple, githubBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - View Modifiers

struct CopilotCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(CopilotTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(CopilotTheme.border, lineWidth: 0.5)
            )
    }
}

extension View {
    func copilotCard() -> some View {
        modifier(CopilotCardStyle())
    }
}
