# SuperSpec — Product Requirements Document

> **状态**: 草稿 · 待用户补充确认  
> **版本**: 0.1.0-draft  
> **负责人**: lordmos + Copilot Agent Team

---

## 一、产品背景与动机

### 1.1 OpenSpec 的价值与局限

OpenSpec 解决了一个真实痛点：**AI coding agent 在没有结构化规范时，行为是不可预测的**。它的做法是在仓库里维护一个轻量级 `openspec/` 目录，包含 specs（系统行为基准）和 changes（每个功能变更的 proposal/design/tasks）。

**但 OpenSpec 存在几个核心缺口：**

| 缺口 | 描述 |
|------|------|
| 📋 无看板 | agent 和用户的协作完全靠 Markdown 文件，没有可视化状态追踪 |
| 🤝 无用户与 agent 的分离 | 所有文件混在一起，agent 不知道哪些是"用户输入"，哪些是"agent 执行产物" |
| 🔒 无私密文件管理 | 没有提供一个安全、禁止提交的私密数据区域 |
| 🤖 无 agent 编排层 | 只支持单 agent 工作流，无法描述多 agent 并行协作 |
| 🔄 无实时双向同步 | 用户和 agent 之间的状态更新是手动的，缺少反应式机制 |

### 1.2 SuperSpec 的定位

SuperSpec 是一个**以 agent 编排为核心的软件开发协作框架**，融合了：

- **结构化规范（基于 OpenSpec 理念）** — 功能提案、设计、任务
- **双端看板** — 用户端（需求、确认、bug）和 agent 端（任务状态、产出、阻塞）
- **私密文件区** — 本地敏感信息，`.gitignore` 保护，永不泄漏
- **多 agent 编排** — 明确描述哪个 agent 负责哪个任务，支持并行
- **反应式同步** — 用户更新看板 → agent 自动读取并响应

---

## 二、目标用户

| 用户类型 | 场景 |
|----------|------|
| **个人开发者** | 一个人用 Copilot/Claude 等 AI 做项目，想让 agent 工作有章可循 |
| **小团队（2-8人）** | 人 + AI 混合开发，需要清晰的任务分工与状态可见性 |
| **AI-first 团队** | 大量使用 agent 并行工作，需要编排层防止冲突和重复工作 |

---

## 三、核心概念

### 3.1 目录结构总览

```
super-spec/
├── .private/                   # 🔒 私密区（永不提交）
│   ├── .gitignore              # 自动生成，忽略整个 .private/
│   ├── secrets.yaml            # API keys、tokens 等
│   └── local-overrides.yaml   # 本地环境配置
│
├── board/                      # 📋 双端看板
│   ├── user/                   # 用户端（人类写入）
│   │   ├── requirements.md     # 需求变更、新想法
│   │   ├── confirmations.md    # 待确认事项（agent 提问 → 用户回答）
│   │   └── bugs.md             # Bug 反馈
│   └── agent/                  # Agent 端（agent 写入）
│       ├── tasks.md            # 当前执行任务状态
│       ├── blockers.md         # 阻塞项（需要用户决策）
│       └── outputs.md          # 产出摘要、已完成工作记录
│
├── specs/                      # 📖 系统行为基准（当前 truth）
│   └── {domain}/
│       └── spec.md
│
├── changes/                    # 🔄 进行中的变更（参考 OpenSpec）
│   └── {change-name}/
│       ├── proposal.md
│       ├── specs/              # 本次变更的 delta specs
│       ├── design.md
│       ├── tasks.md
│       └── agents.yaml         # 🆕 Agent 编排配置
│
├── agents/                     # 🤖 Agent 编排定义
│   ├── roster.yaml             # 注册的 agent 角色
│   └── workflows/              # 多 agent 工作流模板
│       └── {workflow-name}.yaml
│
├── archive/                    # 🗄️ 已完成变更归档
│
└── superspec.yaml              # 项目级配置
```

### 3.2 双端看板设计

这是 SuperSpec 相对 OpenSpec **最大的差异化创新**。

```
┌─────────────────────────────────────────────────────────┐
│                    SuperSpec Board                       │
├──────────────────────┬──────────────────────────────────┤
│    👤 USER BOARD     │         🤖 AGENT BOARD           │
├──────────────────────┼──────────────────────────────────┤
│ 需求变更             │ 任务列表（当前执行中）            │
│ ──────────────       │ ──────────────────────           │
│ [ ] 需求 #1          │ [🔄] 实现登录功能 (agent-α)      │
│ [ ] 需求 #2          │ [✅] 创建数据库 schema (agent-β) │
│                      │ [⏸] 写单元测试 (blocked)        │
│ Bug 反馈             │                                  │
│ ──────────────       │ 阻塞项（需用户决策）              │
│ [🐛] Bug #1          │ ──────────────────────           │
│                      │ ❓ 登录超时时间设为多少分钟？    │
│ 待确认               │                                  │
│ ──────────────       │ 已完成产出                       │
│ ✅ 确认 #1 → 答复    │ ──────────────────────           │
│                      │ 📄 auth.service.ts 已创建       │
└──────────────────────┴──────────────────────────────────┘
```

**关键交互规则：**
- 用户**只写** `board/user/`，agent**只写** `board/agent/`（防止混乱）
- Agent 读取 `board/user/` 来获取最新需求和确认信息
- Agent 在 `board/agent/blockers.md` 写入问题 → 用户在 `board/user/confirmations.md` 回答
- 看板文件是普通 Markdown，任何编辑器都能操作

### 3.3 Agent 编排（agents.yaml）

每个 change 可以声明它需要哪些 agent 角色及其职责：

```yaml
# changes/add-auth/agents.yaml
change: add-auth

agents:
  - id: arch-agent
    role: architect
    responsibilities:
      - 设计整体 auth 架构
      - 编写 design.md
    outputs:
      - design.md
    must_complete_before: [impl-agent]

  - id: impl-agent
    role: implementer
    responsibilities:
      - 实现 auth.service.ts
      - 实现 login.controller.ts
    depends_on: [arch-agent]

  - id: test-agent
    role: tester
    responsibilities:
      - 为 auth service 编写单元测试
    depends_on: [impl-agent]

parallelism:
  max_concurrent: 2   # 最多同时跑 2 个 agent
```

### 3.4 私密文件区（.private/）

```
.private/
├── .gitignore        # 内容：*  (忽略整个目录)
├── secrets.yaml      # 本地 API keys
└── local-env.yaml    # 本地覆盖配置
```

**强制保护规则：**
- `super-spec init` 时自动在 `.private/` 下生成 `.gitignore`（内容为 `*`）
- 项目根 `.gitignore` 也自动追加 `super-spec/.private/`
- Agent 可以读取 `.private/secrets.yaml`（通过声明 `needs_secrets: true`），但**绝不会将其内容写入任何其他文件**
- CI/CD 环境通过 environment variables 注入，`.private/` 只用于本地开发

---

## 四、功能需求

### P0 — 核心功能（MVP）

| 功能 | 描述 |
|------|------|
| `superspec init` | 初始化目录结构，生成 `.gitignore` 保护 `.private/` |
| 双端看板文件 | `board/user/` 和 `board/agent/` 目录及模板文件 |
| Specs 基准层 | 与 OpenSpec 兼容的 `specs/{domain}/spec.md` 格式 |
| Change 工作流 | proposal → design → tasks → archive 完整流程 |
| 私密区保护 | 自动 `.gitignore`，init 时 warning，commit 时 pre-commit hook 检查 |
| Agent slash 命令 | `/sps:propose`, `/sps:board`, `/sps:done`, `/sps:archive` |

### P1 — 核心差异化功能

| 功能 | 描述 |
|------|------|
| Agent 编排声明 | `changes/{name}/agents.yaml` 中声明多 agent 分工 |
| 阻塞 → 确认 loop | Agent 写 `blockers.md` → 格式化提示用户 → 用户写 `confirmations.md` → agent 继续 |
| Board 变更检测 | Agent 读取 `board/user/` 的 Git diff，自动识别新需求/bug/确认 |
| 看板 CLI 视图 | `superspec board` 命令在终端展示双端看板摘要 |
| 工作流模板 | 内置 solo/pair/team 三种 agent 编排模板 |

### P2 — 增强功能

| 功能 | 描述 |
|------|------|
| Web 看板 UI | 本地 web server，浏览器内操作双端看板（类 GitHub Projects 轻量版）|
| 变更冲突检测 | 多个 change 修改同一 spec 时自动警告 |
| Agent 执行日志 | `board/agent/outputs.md` 结构化记录每个 agent 的操作历史 |
| 多语言支持 | 看板模板支持中文/英文/日文 |
| VS Code 扩展 | 侧边栏看板面板，快捷键操作 |

---

## 五、Slash 命令设计

| 命令 | 功能 |
|------|------|
| `/sps:propose <name>` | 在 `changes/` 下创建新变更，生成 proposal.md 模板 |
| `/sps:board` | 读取并展示双端看板当前状态摘要 |
| `/sps:board:update <item>` | Agent 更新 agent 侧看板（任务状态/阻塞/产出）|
| `/sps:block <question>` | Agent 在 `blockers.md` 登记阻塞项并暂停 |
| `/sps:confirm <id>` | 用户确认 `confirmations.md` 中的某一条目 |
| `/sps:apply [change]` | 执行 change 中的 tasks（参考 `/opsx:apply`）|
| `/sps:verify` | 验证实现是否符合 specs |
| `/sps:archive [change]` | 归档变更，merge specs |
| `/sps:secret <key>` | 从 `.private/secrets.yaml` 读取某个 key（不打印完整值）|
| `/sps:onboard` | 为新 agent 生成项目上下文摘要 |

---

## 六、与 OpenSpec 的对比

| 维度 | OpenSpec | SuperSpec |
|------|----------|-----------|
| 规范格式 | ✅ specs + changes | ✅ 兼容，扩展 delta specs |
| 看板 | ❌ 无 | ✅ 双端看板（用户 + agent）|
| Agent 分工 | ❌ 单 agent | ✅ 多 agent 编排声明 |
| 私密文件 | ❌ 无 | ✅ `.private/` 自动保护 |
| 阻塞/确认 loop | ❌ 无 | ✅ blockers → confirmations |
| Web UI | ❌ 无（CLI only）| 🔜 P2 计划 |
| 安装方式 | npm 全局包 | 目录协议（无需安装，纯文件）|
| 锁定 AI 工具 | ❌ 不锁定（支持 20+ 工具）| ✅ 不锁定（优先 Copilot CLI）|

---

## 七、技术方向（初步）

### 7.1 "零安装"策略

SuperSpec 的核心是**纯文件协议**，不依赖任何 runtime：

- 目录结构 = 协议本身
- Slash 命令 = agent 的 instruction markdown（放在 `.claude/`、`.github/copilot-instructions.md` 等标准位置）
- 看板 = 普通 Markdown，任何工具都能读写

可选安装 CLI（`npm install -g superspec`）用于：
- `superspec init` 初始化
- `superspec board` 终端看板视图
- pre-commit hook 注入（保护 `.private/`）

### 7.2 文件格式选择

| 文件 | 格式 | 理由 |
|------|------|------|
| specs, board, proposal | Markdown | 人和 AI 都能读写，Git diff 友好 |
| agents.yaml, superspec.yaml | YAML | 结构化声明，agent 易解析 |
| secrets | YAML | 简单 KV，本地加密可选 |

### 7.3 Agent 指令注入

通过在 agent 的 system prompt / instructions 文件中注入：

```markdown
## SuperSpec Protocol

This project uses SuperSpec. Before starting any task:
1. Read `super-spec/board/user/` for latest requirements and confirmations
2. Check `super-spec/changes/` for active change context
3. Write your status updates to `super-spec/board/agent/tasks.md`
4. If blocked, write to `super-spec/board/agent/blockers.md` and STOP

Never read or write `super-spec/.private/` unless explicitly authorized.
```

---

## 八、待讨论 / 待补充（请用户填写）

以下问题需要你确认方向：

1. **看板格式** — 用纯 Markdown 文件，还是 YAML/JSON 结构化文件（方便 agent 解析）？  
   建议：Markdown（人读） + 结构化 frontmatter（agent 解析）

2. **Web 看板优先级** — P2 是否要提前到 MVP？还是先做纯文件版本验证概念？

3. **私密文件加密** — `.private/secrets.yaml` 是否需要本地加密（如 age/sops），还是纯文本（依赖 OS 权限）？

4. **多 agent 编排的深度** — 目前设计停在"声明分工"层面，是否要做真正的 agent 调度器（orchestrator），自动拉起多个 agent 进程并行？

5. **与 Copilot Island 的关系** — SuperSpec 是独立项目还是 Copilot Island 的配套工具？

6. **命令前缀** — `/sps:` 还是 `/ss:` 还是 `/superspec:`？

7. **项目名** — "SuperSpec" 还是有其他候选名？

---

## 九、开放问题 & 头脑风暴记录

**Agent 团队内部讨论（PM + 架构师 + UX）：**

> **PM**: OpenSpec 最大的痛点是"agent 不知道用户想要什么变了"。用户改了需求，但 agent 还在按旧 tasks 执行。双端看板解决这个问题——用户端的每次更新都是 agent 可以 poll 的信号。

> **架构师**: 纯文件协议的优势是零依赖，但看板的"反应式"特性需要 agent 主动轮询。可以设计一个约定：agent 每次 tool call 之前先 `read_file(board/user/requirements.md)` 检查变更。比 webhook 更简单，兼容所有 agent。

> **UX**: 双端看板最大的 UX 风险是"用户不知道该往哪里写"。建议每个文件都有清晰的模板和写作指引，第一行就告诉用户"这是你的写作区，agent 只读不写这里"。

> **安全顾问**: `.private/` 保护必须是自动的、多层的。只靠 `.gitignore` 不够——需要 pre-commit hook 作为第二道防线，检测任何 `.private/` 下的文件是否被意外 stage。

---

*本文档为初稿，等待用户补充第八节"待讨论"中的方向确认。*
