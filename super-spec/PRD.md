# SuperSpec — Product Requirements Document

> **状态**: 活跃草稿  
> **版本**: 0.2.0  
> **项目性质**: 独立开源项目（暂托管于 copilot-island 仓库，经验提炼后独立）

---

## 一、产品定位

SuperSpec 是一个**以 agent 编排为核心的软件开发协作框架**。它基于 OpenSpec 的规范理念，新增了：

- **双端看板（Kanban）** — 纯 Markdown 文件夹，用户端写需求/bug/确认，agent 端写状态/阻塞/产出
- **多 Agent 编排** — 声明式角色分工，参考软件开发团队结构
- **私密文件区** — `.private/` 目录，多层 `.gitignore` 保护，永不提交
- **零安装协议** — 核心是目录约定，无需 runtime；可选 CLI 工具

**相关参考**: [OpenSpec](https://github.com/Fission-AI/OpenSpec) | 独立项目，不依赖 Copilot Island

---

## 二、目标用户

| 类型 | 场景 |
|------|------|
| 个人开发者 | 一人 + AI agent，让工作有章可循 |
| 小团队（2-8人）| 人机混合开发，清晰分工与状态可见 |
| AI-first 团队 | 多 agent 并行，需编排层防冲突 |

---

## 三、目录结构

```
super-spec/
├── .private/              # 🔒 本地私密区（永不提交）→ 见 §私密文件规则
│   ├── .gitignore         # 内容：* （自动生成）
│   └── secrets.yaml       # API keys、tokens 等
│
├── kanban/                # 📋 双端看板（纯 Markdown 文件）
│   ├── user/              # 👤 用户写入区
│   │   ├── requirements.md
│   │   ├── bugs.md
│   │   └── confirmations.md
│   └── agent/             # 🤖 Agent 写入区
│       ├── tasks.md
│       ├── blockers.md
│       └── outputs.md
│
├── specs/                 # 📖 系统行为基准（当前 truth）
│   └── {domain}/spec.md
│
├── changes/               # 🔄 进行中的变更
│   └── {name}/
│       ├── proposal.md
│       ├── design.md
│       ├── tasks.md
│       ├── specs/         # Delta specs
│       └── agents.yaml    # Agent 分工声明
│
├── archive/               # 🗄️ 已归档变更
├── docs/                  # 📚 详细设计文档（file pointers）
│   ├── kanban-design.md   # → 看板文件格式规范
│   ├── agent-roster.md    # → 软件开发 agent 角色完整方案
│   └── commands.md        # → Slash 命令参考
│
├── USER-MANUAL.md         # 用户手册
└── superspec.yaml         # 项目配置
```

---

## 四、功能优先级

### P0 — MVP

- `superspec init`：生成目录结构 + 自动 `.gitignore`
- Kanban 文件夹及 Markdown 模板
- Specs 基准层（兼容 OpenSpec 格式）
- Change 工作流：proposal → design → tasks → archive
- `/sps:propose`、`/sps:apply`、`/sps:archive` slash 命令

### P1 — 差异化

- Agent 编排声明（`agents.yaml`）→ 详见 [`docs/agent-roster.md`](docs/agent-roster.md)
- 阻塞 → 确认 loop（`blockers.md` ↔ `confirmations.md`）
- Kanban 变更检测（agent 读 git diff 识别新条目）
- `superspec board` CLI 终端摘要视图

### P2 — 增强

- 变更冲突检测
- `superspec onboard` 为新 agent 生成上下文摘要
- VS Code 扩展（侧边栏看板）
- 多语言模板支持

---

## 五、关键决策记录

| 决策项 | 结论 |
|--------|------|
| 看板格式 | Markdown + YAML frontmatter（人可读 + agent 可解析）|
| 看板 UI | 无独立 UI，就是 `kanban/` 文件夹，用户直接编辑 Markdown |
| 私密文件加密 | 不加密，依赖 `.gitignore` + pre-commit hook 双重保护 |
| Agent 编排深度 | 声明式分工（非运行时调度器）；角色参考软件开发团队 |
| 命令前缀 | `/sps:` |
| 项目性质 | 独立项目 |
| 项目名 | SuperSpec |

---

## 详细文档

- [`docs/kanban-design.md`](docs/kanban-design.md) — 看板文件格式、frontmatter 规范、交互规则
- [`docs/agent-roster.md`](docs/agent-roster.md) — 软件开发 agent 角色完整方案
- [`docs/commands.md`](docs/commands.md) — 所有 `/sps:` slash 命令参考
- [`USER-MANUAL.md`](USER-MANUAL.md) — 面向用户的操作手册
