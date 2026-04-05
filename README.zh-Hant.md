# Copilot Island 🏝️

<p align="center">
  <img src="landing-page/docs/public/hero.svg" width="128" height="128" alt="Copilot Island Logo"/>
</p>

<p align="center">
  <strong>將 GitHub Copilot CLI 帶到您的 MacBook 瀏海螢幕</strong><br/>
  在瀏海螢幕中即時監控工作階段，瀏覽 AI 對話歷程。
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
  <a href="README.zh-Hans.md">简体中文</a> ·
  <strong>繁體中文</strong> ·
  <a href="README.ja.md">日本語</a> ·
  <a href="README.ko.md">한국어</a> ·
  <a href="README.fr.md">Français</a> ·
  <a href="README.de.md">Deutsch</a> ·
  <a href="README.pt.md">Português</a> ·
  <a href="README.es.md">Español</a>
</p>

---

## 什麼是 Copilot Island？

Copilot Island 是一款**免費開源的 macOS 瀏海螢幕應用程式**，駐留在 MacBook 的瀏海螢幕中，即時顯示 GitHub Copilot CLI 的所有操作。

靈感來自 [ClaudeIsland](https://github.com/celestialglobe/claude-island)，Copilot Island 將同樣優雅的瀏海螢幕 UI 帶給 GitHub Copilot CLI 使用者。

### 功能特色

| 功能 | 描述 |
|------|------|
| 🔔 **即時工作階段** | 自動偵測所有活躍的 Copilot CLI 工作階段 |
| ⚡ **工具動態** | 即時查看每個工具呼叫（read_file、run_command 等） |
| 💬 **對話歷程** | 瀏覽完整對話，支援 Markdown 渲染 |
| 🎨 **草綠色設計** | 低飽和草綠色調、深色主題、流暢動畫 |
| 🔒 **私密安全** | 無資料收集、無遙測，完全本地執行 |

## 系統需求

- **macOS 14.0+**（Sonoma 或更高版本）
- 搭載瀏海螢幕的 MacBook Pro 或 MacBook Air（2021 年或更新款）
- 已安裝 [GitHub Copilot CLI](https://docs.github.com/en/copilot/github-copilot-in-the-cli)

## 安裝

### 下載

前往 [Releases](https://github.com/lordmos/copilot-island/releases/latest) 下載最新的 `CopilotIsland.dmg`。

### 從原始碼建置

```bash
git clone https://github.com/lordmos/copilot-island.git
cd copilot-island/copilot-island-project
chmod +x scripts/setup.sh && ./scripts/setup.sh
open CopilotIsland.xcodeproj
```

建置需求：Xcode 15+、macOS 14+、Homebrew（用於 XcodeGen）。

## 運作原理

Copilot Island 使用 macOS `FSEvents` 監控 `~/.copilot/session-state/`——Copilot CLI 的原生工作階段目錄。每個事件（工作階段開始、使用者訊息、工具呼叫、工具結果）都從 `events.jsonl` 檔案中零延遲地串流傳輸。

```
~/.copilot/
├── session-state/
│   └── {UUID}/
│       ├── workspace.yaml    ← 工作階段元資料（工作目錄、分支等）
│       └── events.jsonl      ← 附加寫入的事件串流 ← 由 Copilot Island 監控
```

無需 Python 鉤子，無需修改 CLI，無需任何設定。

## ⭐ Star 歷史

[![Star History Chart](https://api.star-history.com/svg?repos=lordmos/copilot-island&type=Date)](https://star-history.com/#lordmos/copilot-island&Date)

## 貢獻

歡迎貢獻！請查看 [CONTRIBUTING.md](CONTRIBUTING.md) 了解指南。

## 授權條款

Apache License 2.0——詳見 [LICENSE](LICENSE)。

---

<p align="center">
  由 <a href="https://github.com/lordmos">lordmos</a> 和 AI 隊友用 ❤️ 打造
</p>
