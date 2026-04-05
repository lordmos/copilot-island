# Copilot Island 🏝️

<p align="center">
  <img src="landing-page/docs/public/hero.svg" width="128" height="128" alt="Copilot Island Logo"/>
</p>

<p align="center">
  <strong>Bring GitHub Copilot CLI to your MacBook Notch</strong><br/>
  Monitor sessions and browse chat history — all from the notch.
</p>

<p align="center">
  <a href="https://github.com/lordmos/copilot-island/releases/latest">
    <img src="https://img.shields.io/github/v/release/lordmos/copilot-island?style=flat-square&color=6CBB98" alt="Latest Release"/>
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/license-Apache%202.0-blue?style=flat-square" alt="Apache 2.0"/>
  </a>
  <img src="https://img.shields.io/badge/macOS-14%2B-brightgreen?style=flat-square" alt="macOS 14+"/>
  <img src="https://img.shields.io/badge/Swift-5.9-orange?style=flat-square&logo=swift" alt="Swift 5.9"/>
  <a href="https://lordmos.github.io/copilot-island">
    <img src="https://img.shields.io/badge/docs-website-brightgreen?style=flat-square" alt="Documentation"/>
  </a>
</p>

<p align="center">
  <a href="README.zh-Hans.md">简体中文</a> ·
  <a href="README.zh-Hant.md">繁體中文</a> ·
  <a href="README.ja.md">日本語</a> ·
  <a href="README.ko.md">한국어</a> ·
  <a href="README.fr.md">Français</a> ·
  <a href="README.de.md">Deutsch</a> ·
  <a href="README.pt.md">Português</a> ·
  <a href="README.es.md">Español</a>
</p>

---

## What is Copilot Island?

Copilot Island is a **free, open-source macOS notch app** that lives in your MacBook's notch and shows you everything GitHub Copilot CLI is doing — in real time.

Inspired by [ClaudeIsland](https://github.com/celestialglobe/claude-island), Copilot Island brings the same elegant notch-based UI to GitHub Copilot CLI users.

### Features

| Feature | Description |
|---------|-------------|
| 🔔 **Live Sessions** | Auto-detects all active Copilot CLI sessions |
| ⚡ **Tool Feed** | See every tool call (read_file, run_command, etc.) as it happens |
| 💬 **Chat History** | Browse full conversation with Markdown rendering |
| 🎨 **Sage Green Design** | Muted sage-green palette, dark theme, fluid animations |
| 🔒 **Private & Secure** | No analytics, no telemetry, runs 100% on-device |

## Requirements

- **macOS 14.0+** (Sonoma or later)
- MacBook Pro or MacBook Air **with notch** (2021 or later)
- [GitHub Copilot CLI](https://docs.github.com/en/copilot/github-copilot-in-the-cli) installed

## Installation

### Download

Go to [Releases](https://github.com/lordmos/copilot-island/releases/latest) and download the latest `CopilotIsland.dmg`.

### Build from Source

```bash
git clone https://github.com/lordmos/copilot-island.git
cd copilot-island/copilot-island-project
chmod +x scripts/setup.sh && ./scripts/setup.sh
open CopilotIsland.xcodeproj
```

Requirements for building: Xcode 15+, macOS 14+, Homebrew (for XcodeGen).

## How It Works

Copilot Island watches `~/.copilot/session-state/` — Copilot CLI's native session directory — using macOS `FSEvents`. Every event (session start, user message, tool call, tool result) is streamed from `events.jsonl` files with zero latency.

```
~/.copilot/
├── session-state/
│   └── {UUID}/
│       ├── workspace.yaml    ← session metadata (cwd, branch, etc.)
│       └── events.jsonl      ← append-only event stream ← watched by Copilot Island
```

No Python hooks. No CLI modification. No configuration.

## Architecture

```
CopilotIsland/
├── App/                    # SwiftUI App entry point + AppDelegate
├── Models/                 # CopilotEvent, SessionState, SessionPhase
├── Services/
│   ├── Session/            # CopilotSessionWatcher (FSEvents) + Monitor
│   ├── State/              # SessionStore (Swift Actor)
│   └── Update/             # SparkleUpdater
├── Core/                   # NotchViewModel + NotchGeometry + Settings
├── Events/                 # Mouse event monitors
└── UI/
    ├── Window/             # NotchWindow (NSPanel)
    ├── Components/         # NotchShape + CopilotTheme (sage green)
    └── Views/              # NotchView, SessionsListView, ChatHistoryView,
                            #   MenuView
```

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

- 🐛 [Report bugs](https://github.com/lordmos/copilot-island/issues/new?template=bug_report.md)
- 💡 [Request features](https://github.com/lordmos/copilot-island/issues/new?template=feature_request.md)
- 📖 [Improve docs](https://lordmos.github.io/copilot-island)

## License

Apache License 2.0 — see [LICENSE](LICENSE) for details.

---

<p align="center">
  Made with ❤️ by <a href="https://github.com/lordmos">lordmos</a> and AI teammates
</p>
