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

## 二、项目启动模式

任何项目都必须经过一个**启动阶段**，由 PM agent 主导，产出物统一为：**需求整理 + 阶段工作计划**。

### 模式 A：从零开始（Greenfield）

场景：用户有一个 idea，还没有代码、没有需求文档。

```
用户描述 idea
     │
     ▼
[PM] 引导头脑风暴 → 产出 proposal.md（需求整理）
     │
     ▼
[PM] 生成 phases.md（阶段工作计划）
     │
     ▼
[PM] 分析项目类型 → 生成 agents.yaml（角色 + 工作目录）
```

PM 会：
1. 引导用户澄清核心需求、目标用户、边界
2. 将想法转化为结构化的 `proposal.md`
3. 按复杂度拆分阶段（`phases.md`）
4. 根据项目类型（前端/全栈/移动端等）生成合适的 agent 角色和项目目录结构

### 模式 B：已有需求文档（Requirements-driven）

场景：用户有 PRD、设计稿、需求列表等现有文档。

```
用户提供需求文档
     │
     ▼
[PM] 阅读 + 结构化整理 → 产出 proposal.md
     │
     ▼
[PM] 识别缺失信息 → blockers.md（向用户提问）
     │
     ▼
[PM] 生成 phases.md + agents.yaml
```

PM 会：
1. 解析现有文档，提取功能点和约束
2. 发现歧义或缺失时，写入 `blockers.md` 等待用户确认
3. 输出标准化的需求整理和阶段计划

### 模式 C：中途接入（Mid-project Join）

场景：项目已有代码和历史，agent 团队中途加入。

```
用户指定项目目录
     │
     ▼
[PM] 扫描项目结构、代码、文档、git 历史
     │
     ▼
[PM] 产出 audit.md（项目现状审计）
     │
     ▼
[PM] 整理待办 → proposal.md + phases.md + agents.yaml
```

PM 会：
1. 扫描代码结构、依赖、测试覆盖率、文档完整度
2. 读取用户看板中的需求和 bug
3. 生成项目现状审计报告（`audit.md`）
4. 基于审计结果规划后续工作

---

## 三、目标用户

| 类型 | 场景 |
|------|------|
| 个人开发者 | 一人 + AI agent，让工作有章可循 |
| 小团队（2-8人）| 人机混合开发，清晰分工与状态可见 |
| AI-first 团队 | 多 agent 并行，需编排层防冲突 |

---

## 四、目录结构

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
│       ├── proposal.md    # 需求整理（PM 产出）
│       ├── phases.md      # 阶段工作计划（PM 产出）
│       ├── audit.md       # 项目审计（仅模式 C）
│       ├── design.md      # 技术设计（Architect 产出）
│       ├── tasks.md
│       ├── specs/         # Delta specs
│       └── agents.yaml    # Agent 分工声明（PM 按项目类型生成）
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

## 五、功能优先级

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

## 六、关键决策记录

| 决策项 | 结论 |
|--------|------|
| 看板格式 | Markdown + YAML frontmatter（人可读 + agent 可解析）|
| 看板 UI | 无独立 UI，就是 `kanban/` 文件夹，用户直接编辑 Markdown |
| 私密文件加密 | 不加密，依赖 `.gitignore` + pre-commit hook 双重保护 |
| 项目启动 | 三种模式（从零/有需求/中途接入），PM 统一产出需求整理 + 阶段计划 |
| Agent 编排深度 | PM 为核心调度者，按项目类型动态生成角色；声明式分工 |
| 命令前缀 | `/sps:` |
| 项目性质 | 独立项目 |
| 项目名 | SuperSpec |

---

## 详细文档

- [`docs/kanban-design.md`](docs/kanban-design.md) — 看板文件格式、frontmatter 规范、交互规则
- [`docs/agent-roster.md`](docs/agent-roster.md) — 软件开发 agent 角色完整方案
- [`docs/commands.md`](docs/commands.md) — 所有 `/sps:` slash 命令参考
- [`USER-MANUAL.md`](USER-MANUAL.md) — 面向用户的操作手册
