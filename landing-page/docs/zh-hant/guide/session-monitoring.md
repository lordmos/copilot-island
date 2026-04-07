---
layout: doc
---

# 工作階段監控

Copilot Island 的核心功能是對您的 GitHub Copilot CLI 工作階段進行即時監控。

## 工作階段偵測原理

Copilot Island 使用 macOS **FSEvents** 監控 `~/.copilot/session-state/` — 這是 Xcode 和 Spotlight 同樣使用的低延遲檔案系統通知 API。當 Copilot CLI 建立新的工作階段目錄時，Copilot Island 會在毫秒內偵測到。

```
~/.copilot/session-state/
└── {UUID}/                    ← 新目錄觸發偵測
    ├── workspace.yaml         ← 工作階段中繼資料
    └── events.jsonl           ← 事件串流（即時附加）
```

無需任何掛鉤、外掛程式或 CLI 修改。

## 工作階段卡片

每個工作階段在瀏海面板中以卡片形式顯示，包含：

| 欄位 | 描述 |
|------|------|
| 🟢 狀態點 | 綠色 = 活動中，灰色 = 已結束 |
| 專案路徑 | `workspace.yaml` 中的 `cwd` |
| Git 分支 | 目前分支（如果在 git 儲存庫中） |
| 工作階段摘要 | Copilot CLI 自動產生的摘要 |
| 已用時間 | 工作階段開始後經過的時間 |

## 事件串流

在每個工作階段中，Copilot Island 持續讀取 `events.jsonl` 並處理以下事件類型：

| 事件類型 | 意義 |
|---------|------|
| `session.start` | 新的 Copilot CLI 工作階段已開始 |
| `user.message` | 您向 Copilot 傳送了訊息 |
| `assistant.turn_start` | Copilot 開始思考/回應 |
| `assistant.message` | Copilot 產生了回應 |
| `tool.execution_start` | Copilot 即將執行工具 |
| `tool.execution_complete` | 工具已完成（成功或失敗） |
| `assistant.turn_end` | Copilot 完成了本次回應 |
| `abort` | 工作階段被使用者中止 |
| `session.shutdown` | Copilot CLI 程序已結束 |

## 多工作階段支援

Copilot Island 可追蹤**所有並行工作階段**。如果您有多個終端機視窗執行 `copilot`，每個工作階段將作為獨立卡片顯示。工作階段按最近活動時間排序。

## 工作階段保留

已結束的工作階段在目前應用程式啟動期間仍保持可見。工作階段不會在應用程式重新啟動後持續保存（以保持應用程式輕量並保護您的隱私）。

## 隱私

Copilot Island **在本機**從您的 Mac 讀取工作階段資料，不會上傳或分享任何內容。GitHub Models API 聊天功能是唯一的網路功能，且完全為選擇性啟用。
