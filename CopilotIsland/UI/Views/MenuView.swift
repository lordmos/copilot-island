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
                    // What is it
                    HStack(alignment: .top, spacing: 6) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 11))
                            .foregroundColor(CopilotTheme.githubBlue.opacity(0.7))
                            .padding(.top, 1)
                        Text("Token 是 GitHub 颁发给你的访问凭证，让 Copilot Island 代表你向 Copilot 发送对话请求。它只存在你本机的 Keychain 里，不会上传。")
                            .font(.system(size: 10))
                            .foregroundColor(CopilotTheme.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    // Steps
                    VStack(alignment: .leading, spacing: 5) {
                        tokenStep(num: "1", text: "打开 GitHub → Settings → Developer settings")
                        tokenStep(num: "2", text: "选 Personal access tokens → Tokens (classic)")
                        tokenStep(num: "3", text: "点 Generate new token，勾选 copilot 权限")
                        tokenStep(num: "4", text: "复制生成的 ghp_… 粘贴到下方输入框")
                    }
                    .padding(8)
                    .background(CopilotTheme.githubBlue.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 6))

                    // Quick open button
                    Button(action: {
                        NSWorkspace.shared.open(URL(string: "https://github.com/settings/tokens/new?description=CopilotIsland&scopes=copilot")!)
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "safari")
                                .font(.system(size: 10))
                            Text("在 GitHub 上创建 Token →")
                                .font(.system(size: 11))
                        }
                        .foregroundColor(CopilotTheme.githubBlue)
                    }
                    .buttonStyle(.plain)

                    // Input + Save
                    HStack(spacing: 6) {
                        SecureField("粘贴 ghp_… token", text: $tokenInput)
                            .textFieldStyle(.plain)
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundColor(CopilotTheme.textPrimary)
                            .onAppear {
                                tokenInput = KeychainHelper.shared.loadToken() ?? ""
                            }

                        Button(tokenSaved ? "已保存 ✓" : "保存") {
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

    @ViewBuilder
    private func tokenStep(num: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 6) {
            Text(num)
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .foregroundColor(CopilotTheme.githubBlue)
                .frame(width: 14, height: 14)
                .background(CopilotTheme.githubBlue.opacity(0.15))
                .clipShape(Circle())
            Text(text)
                .font(.system(size: 10))
                .foregroundColor(CopilotTheme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
