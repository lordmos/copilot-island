# SuperSpec 用户手册

> **版本**: 0.2.0  
> 本手册说明你作为用户的完整操作流程。Agent 做什么、怎么做，参见 [`docs/agent-roster.md`](docs/agent-roster.md)。

---

## 快速开始

SuperSpec 支持三种启动方式，取决于你的项目现状。

### 情况 A：我有一个新 idea（从零开始）

```bash
/sps:init
```

初始化后，告诉 PM agent 你的想法：

```bash
/sps:propose my-awesome-app
```

PM 会引导你头脑风暴，产出：
- `proposal.md` — 需求整理
- `phases.md` — 阶段工作计划
- `agents.yaml` — 根据项目类型自动选择的 agent 角色 + 工作目录

### 情况 B：我有需求文档

```bash
/sps:init
```

把你的需求文档（PRD、设计稿等）放到项目里，然后：

```bash
/sps:propose feature-name
```

PM 会阅读你的文档，结构化整理，发现缺失的信息会在 `kanban/agent/blockers.md` 向你提问。

### 情况 C：项目已经在做了（中途接入）

```bash
/sps:init
/sps:propose current-sprint
```

PM 会扫描现有代码、依赖、git 历史，产出项目审计报告（`audit.md`），然后基于现状规划后续工作。

---

## 日常工作流

### 提需求

1. 编辑 `kanban/user/requirements.md`，新增一个条目（参见[看板格式](docs/kanban-design.md)）
2. Agent 自动或手动触发 `/sps:propose <name>` 开始工作

### 报 Bug

1. 编辑 `kanban/user/bugs.md`，新增 bug 条目
2. PM agent 会将 bug 转为可执行任务，分配给 Implementer

### 回答 Agent 问题

当 `kanban/agent/blockers.md` 出现新条目时：

1. 打开文件，读懂 agent 的问题
2. 在 `kanban/user/confirmations.md` 中写下你的回答：

```markdown
- question_id: q-001
  answered_at: 2024-01-15
  answer: "用 SQLite，这是桌面应用"
```

3. 保存，agent 自动继续执行

---

## 变更管理

### 完整变更流程

```
你提需求 → PM 整理 + 选角色 → Architect 设计 + UI/UX 设计（并行）
→ Implementer 编码 → Tester 测试 → Reviewer 审查 
→ Docs 更新 → Ops 部署（如需）→ 归档
```

PM 会根据项目类型决定需要哪些角色。不是每个项目都需要全部角色。例如：
- 纯前端项目：PM → UI/UX → frontend-dev → Tester → Reviewer
- 后端 API：PM → Architect → backend-dev → Tester → Reviewer → Ops

每一步都有对应命令，也可以一键执行全流程：

```bash
/sps:run dark-mode-support
```

### 查看变更状态

```bash
/sps:status dark-mode-support
```

### 查看所有待处理事项

```bash
/sps:board
```

输出示例：
```
📋 SuperSpec Board
──────────────────────────────────────
📥 用户待处理 (2)
  req-002  导出 PDF 报告        [low]
  bug-001  点击设置按钮崩溃     [critical]

🤖 Agent 执行中 (1)
  dark-mode-support  [implementer]  已耗时 12m

⚠️  待您回答 (1)
  q-001  数据库选型问题 (architect)
──────────────────────────────────────
```

---

## 管理私密信息

**规则**：所有 API key、token、证书 → 放在 `super-spec/.private/`，**永不提交**。

### 写入私密配置

```bash
/sps:secrets set GITHUB_TOKEN
# 提示你输入值，不会回显，不会写到终端历史
```

或者直接编辑 `super-spec/.private/secrets.yaml`：

```yaml
GITHUB_TOKEN: "ghp_xxxx"
OPENAI_API_KEY: "sk-xxxx"
```

### 声明 Agent 需要读取私密配置

在 `changes/{name}/agents.yaml` 中：

```yaml
roles:
  implementer:
    needs_secrets: true
    secret_keys:
      - GITHUB_TOKEN
```

### 安全检查

在提交代码前扫描私密信息：

```bash
/sps:audit
```

---

## 查看 Agent 工作详情

### 正在执行什么

```
super-spec/kanban/agent/tasks.md
```

### 完成了什么

```
super-spec/kanban/agent/outputs.md
```

### 有什么问题需要你回答

```
super-spec/kanban/agent/blockers.md
```

---

## 文件快速导航

| 你想做的事 | 对应文件 |
|-----------|---------|
| 提新需求 | `kanban/user/requirements.md` |
| 报 Bug | `kanban/user/bugs.md` |
| 回答 agent 问题 | `kanban/user/confirmations.md` |
| 看 agent 在干什么 | `kanban/agent/tasks.md` |
| 看完成了什么 | `kanban/agent/outputs.md` |
| 看哪里需要你决策 | `kanban/agent/blockers.md` |
| 项目规范基准 | `specs/` |
| 进行中的变更 | `changes/` |
| 历史变更 | `archive/` |
| 私密配置 | `.private/secrets.yaml` |

---

## 进阶：手动控制流水线

如果你想自己控制每一步而不是自动执行：

```bash
# 1. 提案（PM）
/sps:propose dark-mode-support

# 2. 设计（Architect）
/sps:design dark-mode-support

# 3. 看设计文档，确认后继续
# 编辑 changes/dark-mode-support/design.md 如需调整

# 4. 实现（Implementer）
/sps:apply dark-mode-support

# 5. 测试（Tester）
/sps:verify dark-mode-support

# 6. 审查（Reviewer）
/sps:review dark-mode-support

# 7. 归档
/sps:archive dark-mode-support
```

---

## 理解 PM 自动分配的角色

当你启动一个变更后，PM 会分析项目类型并生成 `agents.yaml`。你可以在 `changes/{name}/agents.yaml` 中查看 PM 选择了哪些角色：

```bash
cat super-spec/changes/dark-mode/agents.yaml
```

如果你认为 PM 选错了角色（比如遗漏了 UI/UX），可以直接编辑这个文件，启用或禁用角色。

完整角色列表参见 [`docs/agent-roster.md`](docs/agent-roster.md)。

---

## 常见问题

**Q: Agent 卡住了，一直没有输出？**  
A: 检查 `kanban/agent/blockers.md`，可能有待回答的问题。

**Q: 我想取消一个进行中的变更？**  
A: 直接删除 `changes/{name}/` 目录，并在 `kanban/agent/tasks.md` 中将对应任务标记为 `cancelled`。

**Q: 我修改了 `kanban/agent/` 里的文件会怎样？**  
A: Agent 可能会覆盖你的修改。Agent 端文件只供 agent 写入，请不要手动修改。

**Q: 多人协作时，两个人同时提需求会冲突吗？**  
A: 不会。Agent 通过 git diff 识别新增条目，多人提的需求都会被处理。但建议同一时间只运行一个 `changes/` 变更，避免代码冲突。

**Q: 如何让新 agent（比如刚配置的 AI）快速了解项目？**  
A: 运行 `/sps:onboard`，它会生成一个上下文摘要文档。

---

## 详细参考文档

- [`docs/kanban-design.md`](docs/kanban-design.md) — 看板文件格式完整规范
- [`docs/agent-roster.md`](docs/agent-roster.md) — 每个 agent 角色的职责和权限
- [`docs/commands.md`](docs/commands.md) — 所有 `/sps:` 命令详细说明
- [`PRD.md`](PRD.md) — 产品需求文档（团队决策记录）
