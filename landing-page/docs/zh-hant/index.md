---
layout: home

hero:
  name: "Copilot Island"
  text: "您的 MacBook 瀏海螢幕，由 GitHub Copilot 驅動"
  tagline: 在瀏海螢幕中即時監控 Copilot CLI 工作階段，瀏覽 AI 對話歷程。
  image:
    src: /hero.svg
    alt: Copilot Island
  actions:
    - theme: brand
      text: 下載 Mac 版
      link: https://github.com/lordmos/copilot-island/releases/latest
    - theme: alt
      text: 在 GitHub 查看
      link: https://github.com/lordmos/copilot-island
    - theme: alt
      text: 快速開始 →
      link: /guide/quick-start

features:
  - icon: 🔔
    title: 即時工作階段監控
    details: 直接從 MacBook 瀏海螢幕即時監控每個 Copilot CLI 工作階段，隨時掌握 AI 的工作狀態。

  - icon: ⚡
    title: 工具呼叫動態
    details: 即時查看 Copilot 正在執行的每個工具——檔案寫入、終端機命令、網路搜尋——所有參數一覽無遺。

  - icon: 💬
    title: 完整對話歷程
    details: 瀏覽完整的對話記錄，支援精美的 Markdown 渲染，程式碼區塊和工具結果清晰展示。

  - icon: 🎨
    title: Copilot 風格設計
    details: 以 GitHub 設計語言精心打造。低飽和草綠色調、深色主題，流暢動畫完美融入 macOS。

  - icon: 🔓
    title: 完全開源
    details: Apache 2.0 授權。查看原始碼、貢獻功能、回報問題。由社群用 ❤️ 共同建構。
---

## 運作原理

```bash
# 1. 安裝 Copilot Island（從 Releases 下載）
# 2. 正常執行 Copilot CLI 工作階段
copilot "為驗證模組新增單元測試"

# 3. Copilot Island 自動偵測工作階段
#    並在 MacBook 瀏海螢幕中顯示——無需任何設定！
```

> Copilot Island 監控 `~/.copilot/session-state/` 目錄，即時讀取 Copilot CLI 原生的 JSONL 事件日誌，零設定即可運行。

## 系統需求

- macOS 14.0+（Sonoma 或更高版本）
- 搭載瀏海螢幕的 MacBook Pro 或 MacBook Air（2021 年或更新款）
- 已安裝並登入 GitHub Copilot CLI
