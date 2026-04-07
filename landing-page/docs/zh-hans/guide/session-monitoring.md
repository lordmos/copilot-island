---
layout: doc
---

# 会话监控

Copilot Island 的核心功能是对您的 GitHub Copilot CLI 会话进行实时监控。

## 会话检测原理

Copilot Island 使用 macOS **FSEvents** 监控 `~/.copilot/session-state/` — 这是 Xcode 和 Spotlight 同样使用的低延迟文件系统通知 API。当 Copilot CLI 创建新的会话目录时，Copilot Island 会在毫秒内检测到。

```
~/.copilot/session-state/
└── {UUID}/                    ← 新目录触发检测
    ├── workspace.yaml         ← 会话元数据
    └── events.jsonl           ← 事件流（实时追加）
```

无需任何钩子、插件或 CLI 修改。

## 会话卡片

每个会话在刘海面板中以卡片形式显示，包含：

| 字段 | 描述 |
|------|------|
| 🟢 状态点 | 绿色 = 活动中，灰色 = 已结束 |
| 项目路径 | `workspace.yaml` 中的 `cwd` |
| Git 分支 | 当前分支（如果在 git 仓库中） |
| 会话摘要 | Copilot CLI 自动生成的摘要 |
| 已用时间 | 会话开始后经过的时间 |

## 事件流

在每个会话中，Copilot Island 持续读取 `events.jsonl` 并处理以下事件类型：

| 事件类型 | 含义 |
|---------|------|
| `session.start` | 新的 Copilot CLI 会话已开始 |
| `user.message` | 您向 Copilot 发送了消息 |
| `assistant.turn_start` | Copilot 开始思考/响应 |
| `assistant.message` | Copilot 生成了响应 |
| `tool.execution_start` | Copilot 即将运行工具 |
| `tool.execution_complete` | 工具已完成（成功或失败） |
| `assistant.turn_end` | Copilot 完成了本次响应 |
| `abort` | 会话被用户中止 |
| `session.shutdown` | Copilot CLI 进程已退出 |

## 多会话支持

Copilot Island 可追踪**所有并发会话**。如果您有多个终端窗口运行 `copilot`，每个会话将作为独立卡片显示。会话按最近活动时间排序。

## 会话保留

已结束的会话在当前应用启动期间仍保持可见。会话不会在应用重启后持久化（以保持应用轻量并保护您的隐私）。

## 隐私

Copilot Island **在本地**从您的 Mac 读取会话数据，不会上传或分享任何内容。GitHub Models API 聊天功能是唯一的网络功能，且完全为选择性启用。
