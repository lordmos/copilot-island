---
layout: doc
---

# セッション監視

Copilot Island のコア機能は、GitHub Copilot CLI セッションのリアルタイム監視です。

## セッションの検出方法

Copilot Island は macOS の **FSEvents** を使用して `~/.copilot/session-state/` を監視します。これは Xcode や Spotlight が使用しているのと同じ低遅延ファイルシステム通知 API です。Copilot CLI が新しいセッションディレクトリを作成すると、Copilot Island はミリ秒以内にそれを検出します。

```
~/.copilot/session-state/
└── {UUID}/                    ← 新しいディレクトリが検出をトリガー
    ├── workspace.yaml         ← セッションメタデータ
    └── events.jsonl           ← イベントストリーム（リアルタイムで追記）
```

フック、プラグイン、CLI の変更は一切不要です。

## セッションカード

各セッションはノッチパネルにカードとして表示され、以下の情報が確認できます：

| フィールド | 説明 |
|-----------|------|
| 🟢 ステータスドット | 緑 = アクティブ、グレー = 終了 |
| プロジェクトパス | `workspace.yaml` の `cwd` |
| Git ブランチ | 現在のブランチ（Git リポジトリ内の場合） |
| セッション概要 | Copilot CLI が自動生成した概要 |
| 経過時間 | セッション開始からの経過時間 |

## イベントストリーム

各セッション内で、Copilot Island は `events.jsonl` をテールし、以下のイベントタイプを処理します：

| イベントタイプ | 意味 |
|--------------|------|
| `session.start` | 新しい Copilot CLI セッションが開始された |
| `user.message` | Copilot にメッセージを送信した |
| `assistant.turn_start` | Copilot が考え/応答を開始した |
| `assistant.message` | Copilot が応答を生成した |
| `tool.execution_start` | Copilot がツールを実行しようとしている |
| `tool.execution_complete` | ツールが完了した（成功またはエラー） |
| `assistant.turn_end` | Copilot が応答ターンを完了した |
| `abort` | ユーザーによってセッションが中断された |
| `session.shutdown` | Copilot CLI プロセスが終了した |

## 複数セッション

Copilot Island は**すべての同時セッション**を追跡します。複数のターミナルウィンドウで `copilot` を実行している場合、各セッションは別々のカードとして表示されます。セッションは最近アクティブになった順に並べられます。

## セッションの保持

終了したセッションは現在のアプリ起動中は表示され続けます。アプリを軽量に保ちプライバシーを尊重するため、セッションはアプリ再起動後も保持されません。

## プライバシー

Copilot Island はセッションデータを Mac から**ローカルで**読み取ります。アップロードや共有は一切行いません。GitHub Models API チャット機能のみがネットワーク機能であり、完全にオプトインです。
