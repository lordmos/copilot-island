//
//  MenuView.swift
//  CopilotIsland
//
//  Settings / menu panel shown from the notch.
//

import SwiftUI

struct MenuView: View {
    let onClose: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Session monitoring info
                menuSection("SESSION MONITORING") {
                    HStack {
                        Image(systemName: "folder.badge.gearshape")
                            .foregroundStyle(CopilotTheme.copilotGradient)
                            .font(.system(size: 11))
                        Text("~/.copilot/session-state/")
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundColor(CopilotTheme.textTertiary)
                    }
                    Text("Watching for Copilot CLI sessions automatically")
                        .font(.system(size: 11))
                        .foregroundColor(CopilotTheme.textSecondary)
                }

                // About
                menuSection("ABOUT") {
                    HStack {
                        Text("Copilot Island")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(CopilotTheme.textPrimary)
                        Spacer()
                        Text("v1.0.0")
                            .font(.system(size: 11))
                            .foregroundColor(CopilotTheme.textTertiary)
                    }
                    Button("View on GitHub →") {
                        NSWorkspace.shared.open(URL(string: "https://github.com/lordmos/copilot-island")!)
                    }
                    .buttonStyle(.plain)
                    .font(.system(size: 11))
                    .foregroundColor(CopilotTheme.sagePrimary)
                }

                Divider().background(CopilotTheme.border).padding(.horizontal, 8)

                Button(action: { NSApplication.shared.terminate(nil) }) {
                    HStack {
                        Image(systemName: "power")
                        Text("Quit Copilot Island")
                    }
                    .font(.system(size: 12))
                    .foregroundColor(CopilotTheme.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
                .buttonStyle(.plain)
            }
            .padding(8)
        }
    }

    @ViewBuilder
    func menuSection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(CopilotTheme.textTertiary)
                .padding(.horizontal, 4)

            VStack(alignment: .leading, spacing: 6) {
                content()
            }
            .padding(10)
            .copilotCard()
        }
        .padding(.bottom, 8)
    }
}
