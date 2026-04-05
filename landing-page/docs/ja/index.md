---
layout: home

hero:
  name: "Copilot Island"
  text: "MacBook ノッチを GitHub Copilot で活用しよう"
  tagline: Copilot CLI のセッションをリアルタイムで監視し、AI との会話をノッチから閲覧できます。
  image:
    src: /hero.svg
    alt: Copilot Island
  actions:
    - theme: brand
      text: Mac 版をダウンロード
      link: https://github.com/lordmos/copilot-island/releases/latest
    - theme: alt
      text: GitHub で見る
      link: https://github.com/lordmos/copilot-island
    - theme: alt
      text: クイックスタート →
      link: /guide/quick-start

features:
  - icon: 🔔
    title: ライブセッション監視
    details: MacBook のノッチから Copilot CLI セッションをリアルタイムで監視。AI の動作を常に把握できます。

  - icon: ⚡
    title: ツールアクティビティフィード
    details: Copilot が実行しているツール（ファイル書き込み、シェルコマンド、Web 検索）を引数付きでノッチに表示します。

  - icon: 💬
    title: 完全な会話履歴
    details: Markdown レンダリング対応で、AI との会話全体をスクロールして閲覧できます。コードブロックやツール結果も美しく表示。

  - icon: 🎨
    title: Copilot インスパイアデザイン
    details: GitHub のデザイン言語で設計。セージグリーンのパレット、ダークテーマ、macOS にネイティブな滑らかなアニメーション。

  - icon: 🔓
    title: 完全オープンソース
    details: Apache 2.0 ライセンス。コードの検査、機能の貢献、バグの報告が可能。コミュニティが ❤️ を込めて開発しています。
---

## 仕組み

```bash
# 1. Copilot Island をインストール（Releases からダウンロード）
# 2. 通常どおり Copilot CLI セッションを開始
copilot "認証モジュールのユニットテストを追加して"

# 3. Copilot Island が自動でセッションを検出し、
#    MacBook のノッチに表示します — 設定不要！
```

> Copilot Island は `~/.copilot/session-state/` を監視し、Copilot CLI ネイティブの JSONL イベントログからリアルタイムにストリーミングします。設定ゼロで動作します。

## 動作環境

- macOS 14.0 以降（Sonoma またはそれ以降）
- ノッチ搭載の MacBook Pro または MacBook Air（2021 年以降）
- GitHub Copilot CLI がインストール・認証済みであること
