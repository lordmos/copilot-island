# SuperSpec 看板设计规范

> **归属**: `super-spec/docs/kanban-design.md`  
> **上级文档**: [`../PRD.md`](../PRD.md)

---

## 设计原则

看板不是 UI，是**约定好的文件夹**。规则：

1. **用户只写 `kanban/user/`**，不修改 `kanban/agent/`
2. **Agent 只写 `kanban/agent/`**，不修改 `kanban/user/`（只读用户文件）
3. 所有文件都是 Markdown，可直接在编辑器里打开
4. Agent 通过检测文件 git diff 识别新增条目，不重复处理历史

---

## 用户端文件

### `kanban/user/requirements.md`

新功能需求和需求变更。

```markdown
---
version: 1
---

## 待处理

- id: req-001
  title: "支持深色模式"
  priority: high
  detail: |
    系统偏好设置切换时自动跟随。
    当前亮色背景在 OLED 屏刺眼。

- id: req-002
  title: "导出 PDF 报告"
  priority: low
  detail: "每周自动生成进度报告 PDF，发送到邮箱。"

## 已确认（agent 可执行）

- id: req-001
  confirmed_at: 2024-01-15
```

### `kanban/user/bugs.md`

Bug 提报。

```markdown
---
version: 1
---

## 待处理

- id: bug-001
  title: "点击设置按钮崩溃"
  severity: critical
  steps: |
    1. 打开应用
    2. 点击右上角齿轮图标
    3. 立即崩溃，无错误提示
  environment: "macOS 14.2, M1"

## 已归档
```

### `kanban/user/confirmations.md`

回答 agent 的阻塞问题。

```markdown
---
version: 1
---

## 待回答

## 已回答

- question_id: q-003
  question: "数据库是用 SQLite 还是 PostgreSQL？"
  answered_at: 2024-01-15
  answer: "SQLite，这是个桌面应用不需要服务器"
```

---

## Agent 端文件

### `kanban/agent/tasks.md`

当前任务执行状态。Agent 写入，用户只读。

```markdown
---
updated_at: 2024-01-15T10:30:00Z
active_change: "dark-mode-support"
---

## 执行中

- id: task-001
  ref: req-001
  agent: implementer
  status: in_progress
  started_at: 2024-01-15T09:00:00Z
  summary: "正在修改 ThemeManager.swift，添加 NSAppearance 监听"

## 已完成

- id: task-001
  completed_at: 2024-01-15T10:25:00Z
  output_ref: "changes/dark-mode-support/outputs.md"
```

### `kanban/agent/blockers.md`

需要用户回答才能继续的问题。

```markdown
---
updated_at: 2024-01-15T10:00:00Z
---

## 待回答 ⚠️

- id: q-001
  asked_at: 2024-01-15T09:45:00Z
  agent: architect
  context: "正在设计深色模式存储方案"
  question: |
    用户的主题偏好应该：
    A) 始终跟随系统  
    B) 可独立设置，系统切换时询问  
    请在 kanban/user/confirmations.md 中回答。

## 已解决
```

### `kanban/agent/outputs.md`

已完成工作的摘要和产出链接。

```markdown
---
updated_at: 2024-01-15T11:00:00Z
---

## 最新产出

- id: out-001
  ref: req-001
  completed_at: 2024-01-15T10:25:00Z
  summary: "深色模式支持已完成"
  files_changed:
    - CopilotIsland/Core/ThemeManager.swift
    - CopilotIsland/UI/Views/SettingsView.swift
  test_status: passed
  pr: "#42"
```

---

## Agent 读取规则

```yaml
# 在 agents.yaml 中声明读写权限
kanban:
  read:
    - kanban/user/requirements.md
    - kanban/user/bugs.md
    - kanban/user/confirmations.md
  write:
    - kanban/agent/tasks.md
    - kanban/agent/blockers.md
    - kanban/agent/outputs.md
```

**增量识别**：Agent 通过 `git diff HEAD` 检测 `kanban/user/` 下的新增行。只处理本次 diff 中新增的条目（`- id:` 开头的新行），避免重复执行历史任务。

---

## 交互流程示意

```
用户写 requirements.md         Agent 读取，执行任务
──────────────────────         ──────────────────────────────
加一条 req-002          →      检测到新条目 req-002
                               写 tasks.md: status=in_progress
                               遇到问题 →
                         ←     写 blockers.md: q-001 (需回答)
用户在 confirmations.md  →    检测到 q-001 已回答
回答 q-001                     继续执行
                         ←     写 outputs.md: out-001 完成
                               写 tasks.md: status=done
```
