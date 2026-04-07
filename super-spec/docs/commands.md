# SuperSpec Slash 命令参考

> **归属**: `super-spec/docs/commands.md`  
> **前缀**: `/sps:`

---

## 初始化

### `/sps:init`

在当前目录初始化 SuperSpec 结构。

```bash
/sps:init
```

**生成**：
```
super-spec/
├── kanban/user/{requirements,bugs,confirmations}.md
├── kanban/agent/{tasks,blockers,outputs}.md
├── specs/
├── changes/
├── archive/
├── .private/
│   └── .gitignore          # 内容: *
├── superspec.yaml
└── PRD.md                  # 可选，生成空模板
```

**自动操作**：
- 向根目录 `.gitignore` 追加 `super-spec/.private/`
- 生成 pre-commit hook 防止 `.private/` 内容意外提交

---

## 变更工作流

### `/sps:propose <name>`

启动一个新变更，触发 PM agent。

```bash
/sps:propose dark-mode-support
```

**生成**：`changes/dark-mode-support/proposal.md`（模板）  
**触发**：PM agent 读取 `kanban/user/requirements.md`，填充 proposal

---

### `/sps:design [name]`

触发 Architect agent 生成技术设计。

```bash
/sps:design dark-mode-support
```

**前置条件**：`changes/{name}/proposal.md` 存在  
**生成**：`changes/{name}/design.md`、`changes/{name}/specs/`

---

### `/sps:apply [name]`

触发 Implementer agent 执行代码实现。

```bash
/sps:apply dark-mode-support
```

**前置条件**：`changes/{name}/design.md` 存在  
**产出**：代码变更 + `kanban/agent/outputs.md` 更新

---

### `/sps:verify [name]`

触发 Tester agent 运行测试。

```bash
/sps:verify dark-mode-support
```

**产出**：测试报告写入 `kanban/agent/outputs.md`

---

### `/sps:review [name]`

触发 Reviewer agent 进行代码审查。

```bash
/sps:review dark-mode-support
```

**产出**：`changes/{name}/review.md`

---

### `/sps:archive [name]`

归档已完成的变更，更新 specs 基准。

```bash
/sps:archive dark-mode-support
```

**操作**：
1. 将 `changes/{name}/specs/` 合并到 `specs/`
2. 更新 `CHANGELOG.md`
3. 将 `changes/{name}/` 移动到 `archive/{date}-{name}/`
4. 更新 `kanban/agent/tasks.md`

---

### `/sps:run [name]`

一键执行完整流水线（propose → design → apply → verify → review → archive）。

```bash
/sps:run dark-mode-support
```

---

## 看板命令

### `/sps:board`

终端摘要视图：显示当前所有待处理条目和 agent 状态。

```bash
/sps:board
```

**输出示例**：
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
  → 在 kanban/user/confirmations.md 回答
──────────────────────────────────────
```

---

### `/sps:status [change]`

查看具体变更的执行状态。

```bash
/sps:status dark-mode-support
```

---

## 安全命令

### `/sps:audit`

扫描全部文件，检查是否有私密信息泄漏风险。

```bash
/sps:audit
```

**检查项**：`.private/` 内容、API key 模式、证书文件

---

### `/sps:secrets set <key>`

安全地向 `.private/secrets.yaml` 写入一个 key。

```bash
/sps:secrets set GITHUB_TOKEN
# 提示输入值（不回显）
```

---

## 维护命令

### `/sps:onboard`

为新加入的 agent 生成上下文摘要（读取 specs + 最近变更）。

```bash
/sps:onboard
```

**输出**：`super-spec/ONBOARD.md`（临时文件，不提交）

---

## 命令速查表

| 命令 | 说明 |
|------|------|
| `/sps:init` | 初始化目录结构 |
| `/sps:propose <name>` | 开始新变更 |
| `/sps:design [name]` | 生成技术设计 |
| `/sps:apply [name]` | 执行代码实现 |
| `/sps:verify [name]` | 运行测试 |
| `/sps:review [name]` | 代码审查 |
| `/sps:archive [name]` | 归档变更 |
| `/sps:run [name]` | 一键完整流水线 |
| `/sps:board` | 看板摘要 |
| `/sps:status [change]` | 变更状态 |
| `/sps:audit` | 安全扫描 |
| `/sps:secrets set <key>` | 写入私密配置 |
| `/sps:onboard` | 生成上下文摘要 |
