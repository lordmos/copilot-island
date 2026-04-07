---
layout: doc
---

# インストール

## 動作環境

- **macOS 14.0 以降**（Sonoma またはそれ以降）
- ノッチ搭載の MacBook Pro または MacBook Air（**2021 年以降**）
- [GitHub Copilot CLI](https://docs.github.com/en/copilot/github-copilot-in-the-cli) がインストール・認証済みであること

## オプション 1: リリースをダウンロード（推奨）

1. [Releases ページ](https://github.com/lordmos/copilot-island/releases/latest)を開く
2. `CopilotIsland.dmg` をダウンロード
3. DMG を開き、Copilot Island をアプリケーションフォルダにドラッグ
4. アプリケーション（または Spotlight）から Copilot Island を起動
5. アプリが MacBook のノッチに表示されます

## オプション 2: ソースからビルド

```bash
# リポジトリをクローン
git clone https://github.com/lordmos/copilot-island.git
cd copilot-island

# セットアップを実行（XcodeGen をインストールし、Xcode プロジェクトを生成）
chmod +x scripts/setup.sh && ./scripts/setup.sh

# Xcode で開く
open CopilotIsland.xcodeproj
```

**⌘R** を押してビルドして実行します。

## 初回起動

初回起動時、Copilot Island は以下を行います：
1. ホームディレクトリ内のファイルへのアクセス許可を求める
2. `~/.copilot/session-state/` の自動監視を開始する
3. MacBook のノッチに折りたたまれたピルを表示する

追加の設定は不要です — ターミナルで `copilot` を使い始めるだけです！
