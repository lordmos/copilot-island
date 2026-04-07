---
layout: doc
---

# 設定

Copilot Island 所需設定極少，開箱即用。

## 設定面板

點擊展開瀏海面板中的 **⋯ 選單圖示**，然後選擇**設定**即可進入設定頁面。

### 音效

開關完成提示音和失敗音效：

- **完成音效** — 當代理程式完成任務時播放（`session.task_complete` → `assistant.turn_end`）
- **失敗音效** — 在 `abort`、`session.error` 或意外的 `session.shutdown` 時播放

### 關於與更新

設定中的**關於**標籤頁顯示目前應用程式版本，並支援**檢查更新**（由 Sparkle 提供支援）。當 GitHub 上有新版本發布時，Copilot Island 將通知您。

## 工作階段監控

Copilot Island 會自動監控 `~/.copilot/session-state/` 中的變更。  
無需任何設定 — 開箱即用。

啟動時，僅載入**目前任務**（從最後一條 `user.message` 開始的事件），以保持介面回應速度。歷史記錄不會被重新播放。

## macOS 權限

首次啟動時，請在提示時授予以下權限：

- **檔案與資料夾** → 允許讀取主目錄中 Copilot CLI 工作階段檔案的存取權限
