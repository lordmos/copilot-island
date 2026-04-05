//
//  MenuView.swift
//  CopilotIsland
//
//  Settings / menu panel shown from the notch.
//

import SwiftUI

struct MenuView: View {
    let onClose: () -> Void
    @ObservedObject private var settings = Settings.shared
    @StateObject private var client = GitHubModelsClient.shared
    @State private var tokenInput = ""
    @State private var showTokenField = false

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // GitHub Token
                menuSection("GitHub Models API") {
                    if client.isConfigured {
                        HStack {
                            Image(systemName: "checkmark.shield.fill")
                                .foregroundColor(CopilotTheme.successGreen)
                            Text("Token configured")
                                .font(.system(size: 12))
                                .foregroundColor(CopilotTheme.textSecondary)
                            Spacer()
                            Button("Remove") { client.token = nil }
                                .buttonStyle(.plain)
                                .font(.system(size: 11))
                                .foregroundColor(CopilotTheme.warningRed)
                        }
                    } else if showTokenField {
                        HStack(spacing: 8) {
                            SecureField("ghp_…", text: $tokenInput)
                                .textFieldStyle(.plain)
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(CopilotTheme.textPrimary)
                            Button("Save") {
                                client.token = tokenInput.trimmingCharacters(in: .whitespaces)
                                tokenInput = ""
                                showTokenField = false
                            }
                            .buttonStyle(.plain)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(CopilotTheme.copilotPurple)
                        }
                    } else {
                        Button(action: { showTokenField = true }) {
                            HStack {
                                Image(systemName: "plus.circle")
                                    .foregroundStyle(CopilotTheme.copilotGradient)
                                Text("Add GitHub Token")
                                    .font(.system(size: 12))
                                    .foregroundColor(CopilotTheme.textPrimary)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }

                // Model Selection
                menuSection("AI Model") {
                    Picker("", selection: $settings.selectedModel) {
                        ForEach(settings.availableModels, id: \.self) { model in
                            Text(model).tag(model)
                        }
                    }
                    .pickerStyle(.menu)
                    .font(.system(size: 12))
                    .tint(CopilotTheme.textPrimary)
                }

                // Session monitoring info
                menuSection("Session Monitoring") {
                    HStack {
                        Image(systemName: "folder.badge.gearshape")
                            .foregroundColor(CopilotTheme.textTertiary)
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
                menuSection("About") {
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
                    .foregroundColor(CopilotTheme.githubBlue)
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
            Text(title.uppercased())
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
