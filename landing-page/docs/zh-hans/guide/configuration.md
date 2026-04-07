---
layout: doc
---

# 配置

Copilot Island 所需配置极少，开箱即用。

## 设置面板

点击展开刘海面板中的 **⋯ 菜单图标**，然后选择**设置**即可进入设置页面。

### 音效

开关完成提示音和失败音效：

- **完成音效** — 当代理完成任务时播放（`session.task_complete` → `assistant.turn_end`）
- **失败音效** — 在 `abort`、`session.error` 或意外的 `session.shutdown` 时播放

### 关于与更新

设置中的**关于**标签页显示当前应用版本，并支持**检查更新**（由 Sparkle 提供支持）。当 GitHub 上有新版本发布时，Copilot Island 将通知您。

## 会话监控

Copilot Island 会自动监控 `~/.copilot/session-state/` 中的变更。  
无需任何配置 — 开箱即用。

启动时，仅加载**当前任务**（从最后一条 `user.message` 开始的事件），以保持界面响应速度。历史记录不会被重新播放。

## macOS 权限

首次启动时，请在提示时授予以下权限：

- **文件与文件夹** → 允许读取主目录中 Copilot CLI 会话文件的访问权限
