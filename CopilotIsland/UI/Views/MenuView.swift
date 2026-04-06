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

    private var appVersion: String {
        let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
        return "v\(v)"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // MARK: Preferences
                menuSection("偏好设置") {
                    Toggle(isOn: $soundEnabled) {
                        HStack(spacing: 8) {
                            Image(systemName: soundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(CopilotTheme.copilotGradient)
                                .frame(width: 16)
                            VStack(alignment: .leading, spacing: 1) {
                                Text("Agent 完成提示音")
                                    .font(.system(size: 12))
                                    .foregroundColor(CopilotTheme.textPrimary)
                                Text("Agent 回复完毕时播放 8-bit 提示")
                                    .font(.system(size: 10))
                                    .foregroundColor(CopilotTheme.textTertiary)
                            }
                        }
                    }
                    .toggleStyle(.switch)
                    .tint(CopilotTheme.sagePrimary)
                }

                // MARK: Monitoring
                menuSection("监听路径") {
                    HStack(spacing: 8) {
                        Image(systemName: "antenna.radiowaves.left.and.right")
                            .font(.system(size: 13))
                            .foregroundStyle(CopilotTheme.copilotGradient)
                            .frame(width: 16)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("~/.copilot/session-state/")
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(CopilotTheme.textSecondary)
                            Text("自动监听 Copilot CLI 会话，无需配置")
                                .font(.system(size: 10))
                                .foregroundColor(CopilotTheme.textTertiary)
                        }
                    }
                }

                // MARK: About
                menuSection("关于") {
                    HStack {
                        HStack(spacing: 8) {
                            Image(nsImage: NSApp.applicationIconImage)
                                .resizable().scaledToFit()
                                .frame(width: 28, height: 28)
                                .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                            VStack(alignment: .leading, spacing: 1) {
                                Text("Copilot Island")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(CopilotTheme.textPrimary)
                                Text(appVersion)
                                    .font(.system(size: 10))
                                    .foregroundColor(CopilotTheme.textTertiary)
                            }
                        }
                        Spacer()
                    }

                    Divider().background(CopilotTheme.border)

                    HStack(spacing: 0) {
                        Button(action: {
                            NSWorkspace.shared.open(URL(string: "https://github.com/lordmos/copilot-island")!)
                        }) {
                            Label("GitHub", systemImage: "link")
                                .font(.system(size: 11))
                                .foregroundColor(CopilotTheme.sagePrimary)
                        }
                        .buttonStyle(.plain)

                        Spacer()

                        Button(action: { sparkleUpdater.checkForUpdates() }) {
                            Label("检查更新", systemImage: "arrow.down.circle")
                                .font(.system(size: 11))
                                .foregroundColor(sparkleUpdater.canCheckForUpdates
                                    ? CopilotTheme.sagePrimary : CopilotTheme.textTertiary)
                        }
                        .buttonStyle(.plain)
                        .disabled(!sparkleUpdater.canCheckForUpdates)
                    }
                }

                // MARK: Quit
                Button(action: { NSApplication.shared.terminate(nil) }) {
                    HStack(spacing: 6) {
                        Image(systemName: "power")
                            .font(.system(size: 11))
                        Text("退出 Copilot Island")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(CopilotTheme.textTertiary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
                .buttonStyle(.plain)
                .padding(.top, 4)
            }
            .padding(10)
        }
    }

    @ViewBuilder
    func menuSection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(CopilotTheme.textTertiary)
                .tracking(0.5)
                .padding(.horizontal, 2)

            VStack(alignment: .leading, spacing: 8) {
                content()
            }
            .padding(12)
            .copilotCard()
        }
        .padding(.bottom, 10)
    }
}

