//
//  MenuView.swift
//  CopilotIsland
//
//  Settings / menu panel shown from the notch.
//

import SwiftUI

struct MenuView: View {
    let onClose: () -> Void
    @EnvironmentObject private var sparkleUpdater: SparkleUpdater
    @AppStorage("soundEnabled") private var soundEnabled: Bool = true
    @State private var tokenInput: String = ""
    @State private var tokenSaved: Bool = false

    private var appVersion: String {
        let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
        let b = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "?"
        return "v\(v) (\(b))"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Preferences
                menuSection("PREFERENCES") {
                    Toggle(isOn: $soundEnabled) {
                        HStack(spacing: 6) {
                            Image(systemName: "speaker.wave.2")
                                .font(.system(size: 11))
                                .foregroundStyle(CopilotTheme.copilotGradient)
                            Text("Sound when agent finishes")
                                .font(.system(size: 11))
                                .foregroundColor(CopilotTheme.textSecondary)
                        }
                    }
                    .toggleStyle(.switch)
                    .scaleEffect(0.8, anchor: .leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                // GitHub Token
                menuSection("GITHUB TOKEN") {
                    Text("Required for Copilot Chat. Create a PAT with `copilot_chat:read` scope or enable Copilot access.")
                        .font(.system(size: 10))
                        .foregroundColor(CopilotTheme.textTertiary)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack(spacing: 6) {
                        SecureField("ghp_…", text: $tokenInput)
                            .textFieldStyle(.plain)
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundColor(CopilotTheme.textPrimary)
                            .onAppear {
                                tokenInput = KeychainHelper.shared.loadToken() ?? ""
                            }

                        Button(tokenSaved ? "Saved ✓" : "Save") {
                            KeychainHelper.shared.saveToken(tokenInput)
                            tokenSaved = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { tokenSaved = false }
                        }
                        .buttonStyle(.plain)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(tokenSaved ? CopilotTheme.successGreen : CopilotTheme.sagePrimary)
                    }
                    .padding(6)
                    .background(Color.black.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                }

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
                        Text(appVersion)
                            .font(.system(size: 11))
                            .foregroundColor(CopilotTheme.textTertiary)
                    }
                    Button("View on GitHub →") {
                        NSWorkspace.shared.open(URL(string: "https://github.com/lordmos/copilot-island")!)
                    }
                    .buttonStyle(.plain)
                    .font(.system(size: 11))
                    .foregroundColor(CopilotTheme.sagePrimary)

                    Button(action: { sparkleUpdater.checkForUpdates() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.down.circle")
                                .font(.system(size: 11))
                            Text("Check for Updates")
                                .font(.system(size: 11))
                        }
                        .foregroundColor(sparkleUpdater.canCheckForUpdates
                            ? CopilotTheme.sagePrimary
                            : CopilotTheme.textTertiary)
                    }
                    .buttonStyle(.plain)
                    .disabled(!sparkleUpdater.canCheckForUpdates)
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
