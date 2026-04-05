# Copilot Island 🏝️

<p align="center">
  <img src="landing-page/docs/public/hero.svg" width="128" height="128" alt="Copilot Island Logo"/>
</p>

<p align="center">
  <strong>GitHub Copilot CLI を MacBook のノッチに</strong><br/>
  ノッチからセッションをリアルタイム監視し、AI との会話を閲覧。
</p>

<p align="center">
  <a href="https://github.com/lordmos/copilot-island/releases/latest">
    <img src="https://img.shields.io/github/v/release/lordmos/copilot-island?style=flat-square&color=6CBB98" alt="最新リリース"/>
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
  <a href="README.zh-Hant.md">繁體中文</a> ·
  <strong>日本語</strong> ·
  <a href="README.ko.md">한국어</a> ·
  <a href="README.fr.md">Français</a> ·
  <a href="README.de.md">Deutsch</a> ·
  <a href="README.pt.md">Português</a> ·
  <a href="README.es.md">Español</a>
</p>

---

## Copilot Island とは？

Copilot Island は **無料のオープンソース macOS ノッチアプリ** で、MacBook のノッチに常駐し、GitHub Copilot CLI がリアルタイムで行っているすべてのことを表示します。

[ClaudeIsland](https://github.com/celestialglobe/claude-island) にインスパイアされ、同じエレガントなノッチベース UI を GitHub Copilot CLI ユーザーに提供します。

### 機能

| 機能 | 説明 |
|------|------|
| 🔔 **ライブセッション** | すべてのアクティブな Copilot CLI セッションを自動検出 |
| ⚡ **ツールフィード** | ツール呼び出し（read_file、run_command 等）をリアルタイム表示 |
| 💬 **会話履歴** | Markdown レンダリングで完全な会話を閲覧 |
| 🎨 **セージグリーンデザイン** | 落ち着いたセージグリーン、ダークテーマ、滑らかなアニメーション |
| 🔒 **プライバシー重視** | 分析なし、テレメトリなし、100% デバイス上で動作 |

## 動作環境

- **macOS 14.0+**（Sonoma 以降）
- ノッチ搭載の MacBook Pro または MacBook Air（2021 年以降）
- [GitHub Copilot CLI](https://docs.github.com/en/copilot/github-copilot-in-the-cli) がインストール済み

## インストール

### ダウンロード

[Releases](https://github.com/lordmos/copilot-island/releases/latest) から最新の `CopilotIsland.dmg` をダウンロードしてください。

### ソースからビルド

```bash
git clone https://github.com/lordmos/copilot-island.git
cd copilot-island/copilot-island-project
chmod +x scripts/setup.sh && ./scripts/setup.sh
open CopilotIsland.xcodeproj
```

ビルド要件：Xcode 15+、macOS 14+、Homebrew（XcodeGen 用）。

## 仕組み

Copilot Island は macOS `FSEvents` を使用して `~/.copilot/session-state/`（Copilot CLI のネイティブセッションディレクトリ）を監視します。すべてのイベント（セッション開始、ユーザーメッセージ、ツール呼び出し、ツール結果）は `events.jsonl` ファイルからゼロレイテンシでストリーミングされます。

```
~/.copilot/
├── session-state/
│   └── {UUID}/
│       ├── workspace.yaml    ← セッションメタデータ（cwd、ブランチ等）
│       └── events.jsonl      ← 追記型イベントストリーム ← Copilot Island が監視
```

Python フックなし。CLI の変更なし。設定不要。

## ⭐ Star 履歴

[![Star History Chart](https://api.star-history.com/svg?repos=lordmos/copilot-island&type=Date)](https://star-history.com/#lordmos/copilot-island&Date)

## コントリビューション

コントリビューションを歓迎します！ガイドラインは [CONTRIBUTING.md](CONTRIBUTING.md) をご覧ください。

## ライセンス

Apache License 2.0 — 詳細は [LICENSE](LICENSE) を参照してください。

---

<p align="center">
  <a href="https://github.com/lordmos">lordmos</a> と AI チームメイトが ❤️ を込めて制作
</p>
