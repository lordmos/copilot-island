# Copilot Island 🏝️

<p align="center">
  <img src="landing-page/docs/public/hero.svg" width="128" height="128" alt="Copilot Island Logo"/>
</p>

<p align="center">
  <strong>将 GitHub Copilot CLI 带到您的 MacBook 刘海屏</strong><br/>
  在刘海屏中实时监控会话，浏览 AI 对话历史。
</p>

<p align="center">
  <a href="https://github.com/lordmos/copilot-island/releases/latest">
    <img src="https://img.shields.io/github/v/release/lordmos/copilot-island?style=flat-square&color=6CBB98" alt="最新版本"/>
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/license-Apache%202.0-blue?style=flat-square" alt="Apache 2.0"/>
  </a>
  <img src="https://img.shields.io/badge/macOS-14%2B-brightgreen?style=flat-square" alt="macOS 14+"/>
  <img src="https://img.shields.io/badge/Swift-5.9-orange?style=flat-square&logo=swift" alt="Swift 5.9"/>
</p>

<p align="center">
  <a href="README.md">English</a> ·
  <strong>简体中文</strong> ·
  <a href="README.zh-Hant.md">繁體中文</a> ·
  <a href="README.ja.md">日本語</a> ·
  <a href="README.ko.md">한국어</a> ·
  <a href="README.fr.md">Français</a> ·
  <a href="README.de.md">Deutsch</a> ·
  <a href="README.pt.md">Português</a> ·
  <a href="README.es.md">Español</a>
</p>

---

## 什么是 Copilot Island？

Copilot Island 是一款**免费开源的 macOS 刘海屏应用**，驻留在 MacBook 的刘海屏中，实时显示 GitHub Copilot CLI 的所有操作。

灵感来自 [ClaudeIsland](https://github.com/celestialglobe/claude-island)，Copilot Island 将同样优雅的刘海屏 UI 带给 GitHub Copilot CLI 用户。

### 功能特性

| 功能 | 描述 |
|------|------|
| 🔔 **实时会话** | 自动检测所有活跃的 Copilot CLI 会话 |
| ⚡ **工具动态** | 实时查看每个工具调用（read_file、run_command 等） |
| 💬 **对话历史** | 浏览完整对话，支持 Markdown 渲染 |
| 🎨 **草绿色设计** | 低饱和草绿色调、深色主题、流畅动画 |
| 🔒 **私密安全** | 无数据收集、无遥测，完全本地运行 |

## 系统要求

- **macOS 14.0+**（Sonoma 或更高版本）
- 带刘海屏的 MacBook Pro 或 MacBook Air（2021 年或更新款）
- 已安装 [GitHub Copilot CLI](https://docs.github.com/en/copilot/github-copilot-in-the-cli)

## 安装

### 下载

前往 [Releases](https://github.com/lordmos/copilot-island/releases/latest) 下载最新的 `CopilotIsland.dmg`。

### 从源码构建

```bash
git clone https://github.com/lordmos/copilot-island.git
cd copilot-island/copilot-island-project
chmod +x scripts/setup.sh && ./scripts/setup.sh
open CopilotIsland.xcodeproj
```

构建要求：Xcode 15+、macOS 14+、Homebrew（用于 XcodeGen）。

## 工作原理

Copilot Island 使用 macOS `FSEvents` 监控 `~/.copilot/session-state/`——Copilot CLI 的原生会话目录。每个事件（会话开始、用户消息、工具调用、工具结果）都从 `events.jsonl` 文件中零延迟地流式传输。

```
~/.copilot/
├── session-state/
│   └── {UUID}/
│       ├── workspace.yaml    ← 会话元数据（工作目录、分支等）
│       └── events.jsonl      ← 追加写入的事件流 ← 由 Copilot Island 监控
```

无需 Python 钩子，无需修改 CLI，无需任何配置。

## 架构

```
CopilotIsland/
├── App/                    # SwiftUI App 入口 + AppDelegate
├── Models/                 # CopilotEvent、SessionState、SessionPhase
├── Services/
│   ├── Session/            # CopilotSessionWatcher (FSEvents) + Monitor
│   ├── State/              # SessionStore (Swift Actor)
│   └── Update/             # SparkleUpdater
├── Core/                   # NotchViewModel + NotchGeometry + Settings
├── Events/                 # 鼠标事件监听器
└── UI/
    ├── Window/             # NotchWindow (NSPanel)
    ├── Components/         # NotchShape + CopilotTheme（草绿色）
    └── Views/              # NotchView、SessionsListView、ChatHistoryView、MenuView
```

## ⭐ Star 历史

[![Star History Chart](https://api.star-history.com/svg?repos=lordmos/copilot-island&type=Date)](https://star-history.com/#lordmos/copilot-island&Date)

## 贡献

欢迎贡献！请查看 [CONTRIBUTING.md](CONTRIBUTING.md) 了解指南。

- 🐛 [报告 Bug](https://github.com/lordmos/copilot-island/issues/new?template=bug_report.md)
- 💡 [功能请求](https://github.com/lordmos/copilot-island/issues/new?template=feature_request.md)
- 📖 [改进文档](https://lordmos.github.io/copilot-island)

## 许可证

Apache License 2.0——详见 [LICENSE](LICENSE)。

---

<p align="center">
  由 <a href="https://github.com/lordmos">lordmos</a> 和 AI 队友用 ❤️ 打造
</p>
