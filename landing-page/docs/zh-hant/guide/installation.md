---
layout: doc
---

# 安裝

## 系統需求

- **macOS 14.0+**（Sonoma 或更新版本）
- 配備**瀏海**的 MacBook Pro 或 MacBook Air（2021 年或更新款）
- 已安裝並完成身分驗證的 [GitHub Copilot CLI](https://docs.github.com/en/copilot/github-copilot-in-the-cli)

## 方式一：下載發布版本（建議）

1. 前往 [發布頁面](https://github.com/lordmos/copilot-island/releases/latest)
2. 下載 `CopilotIsland.dmg`
3. 開啟 DMG 檔案，將 Copilot Island 拖入「應用程式」資料夾
4. 從「應用程式」（或 Spotlight）啟動 Copilot Island
5. 應用程式將顯示在 MacBook 瀏海中

## 方式二：從原始碼建置

```bash
# 複製儲存庫
git clone https://github.com/lordmos/copilot-island.git
cd copilot-island

# 執行設定腳本（安裝 XcodeGen 並產生 Xcode 專案）
chmod +x scripts/setup.sh && ./scripts/setup.sh

# 在 Xcode 中開啟
open CopilotIsland.xcodeproj
```

然後按 **⌘R** 進行建置並執行。

## 首次啟動

首次啟動時，Copilot Island 將：
1. 請求存取您主目錄中檔案的權限
2. 自動開始監控 `~/.copilot/session-state/`
3. 在 MacBook 瀏海中顯示一個折疊的膠囊圖示

無需額外設定 — 只需在終端機中開始使用 `copilot` 即可！
