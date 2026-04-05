//
//  CopilotTheme.swift
//  CopilotIsland
//
//  Copilot Island design system — muted sage green palette.
//

import SwiftUI

enum CopilotTheme {
    // MARK: - Primary Brand Colors (Muted Sage Green)

    /// Sage green — primary brand accent
    static let sagePrimary = Color(red: 0.42, green: 0.73, blue: 0.58)
    /// Deep teal-green — secondary accent / gradient end
    static let sageDeep = Color(red: 0.22, green: 0.52, blue: 0.41)
    /// Sage glow — used for pulsing/active states
    static let sageGlow = Color(red: 0.55, green: 0.85, blue: 0.69)

    // MARK: - Supporting Colors

    /// GitHub Blue — kept for user actions / links
    static let githubBlue = Color(red: 0.12, green: 0.44, blue: 0.92)
    /// Success green (affirm / done)
    static let successGreen = Color(red: 0.35, green: 0.75, blue: 0.52)
    /// Warning / error red
    static let warningRed = Color(red: 0.97, green: 0.51, blue: 0.40)

    // MARK: - Backgrounds (Green-tinted dark)

    /// App background — deep green-black
    static let background = Color(red: 0.05, green: 0.08, blue: 0.07)
    /// Card surface — slightly elevated
    static let cardBackground = Color(red: 0.09, green: 0.13, blue: 0.11)

    // MARK: - Text

    static let textPrimary = Color.white.opacity(0.92)
    static let textSecondary = Color.white.opacity(0.55)
    static let textTertiary = Color.white.opacity(0.28)

    // MARK: - Border / Divider

    static let border = Color(red: 0.35, green: 0.55, blue: 0.45).opacity(0.18)

    // MARK: - Status Colors

    static func statusColor(for phase: SessionPhase) -> Color {
        switch phase {
        case .processing: return sageGlow
        case .runningTool: return sagePrimary
        case .waitingForInput: return githubBlue
        case .ended: return textTertiary
        case .error: return warningRed
        case .interrupted: return warningRed
        default: return textTertiary
        }
    }

    // MARK: - Gradients

    /// Primary brand gradient: sage → teal
    static let copilotGradient = LinearGradient(
        colors: [sagePrimary, sageDeep],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Subtle glow gradient for highlights
    static let glowGradient = LinearGradient(
        colors: [sageGlow.opacity(0.8), sagePrimary.opacity(0.6)],
        startPoint: .top,
        endPoint: .bottom
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
