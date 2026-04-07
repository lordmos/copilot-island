# SuperSpec Agent 角色方案

> **归属**: `super-spec/docs/agent-roster.md`  
> **上级文档**: [`../PRD.md`](../PRD.md)

---

## 设计原则

角色以**真实软件开发团队**为蓝本。关键区别：**PM 是核心调度者**，不是平级角色。

**核心原则**：
- **PM 先行**：任何项目启动，PM 先做需求整理和角色规划
- **角色动态生成**：PM 根据项目类型决定需要哪些角色（不是所有项目都需要全部角色）
- **文件协作**：角色之间通过 specs / change 文件夹传递上下文，不直接通信
- 所有角色都可以在 `blockers.md` 写阻塞，等待用户确认

---

## PM — 项目经理（核心角色）

PM 是**唯一的常驻角色**，负责：

1. **项目启动**：根据三种模式（从零/有需求/中途接入）完成初始整理
2. **角色规划**：分析项目类型，生成 `agents.yaml`，决定需要哪些专家角色
3. **工作目录搭建**：按项目类型创建合适的目录结构
4. **看板管理**：持续监控 `kanban/user/` 变化，分发新需求和 bug
5. **阶段规划**：维护 `phases.md`，拆分里程碑

### PM 的角色生成逻辑

```yaml
# PM 分析项目后，生成类似这样的 agents.yaml：

# 示例 1：纯前端项目
project_type: frontend
roles:
  ui-ux: { enabled: true }
  frontend-dev: { enabled: true, tech: ["React", "TypeScript"] }
  tester: { enabled: true }
  reviewer: { enabled: true }

# 示例 2：全栈项目 (Web + App + Server)
project_type: fullstack
workspace:
  web/: "前端 Web 应用"
  app/: "移动端 App"
  server/: "后端服务"
  shared/: "共享类型/工具"
roles:
  ui-ux: { enabled: true }
  frontend-dev: { enabled: true, scope: ["web/", "app/"] }
  backend-dev: { enabled: true, scope: ["server/"] }
  ops: { enabled: true }
  tester: { enabled: true }
  reviewer: { enabled: true }

# 示例 3：macOS 桌面应用（如 Copilot Island）
project_type: macos-app
workspace:
  Sources/: "Swift 源码"
  Tests/: "测试"
  Resources/: "资源文件"
roles:
  ui-ux: { enabled: true }
  swift-dev: { enabled: true, scope: ["Sources/"] }
  tester: { enabled: true }
  reviewer: { enabled: true }
```

### PM 读写权限

**读取**：所有文件（全局视野）  
**写入**：
- `changes/{name}/proposal.md`（需求整理）
- `changes/{name}/phases.md`（阶段计划）
- `changes/{name}/audit.md`（项目审计，模式 C）
- `changes/{name}/agents.yaml`（角色分配）
- `kanban/agent/tasks.md`（任务分发）
- `kanban/agent/blockers.md`（提问）

---

### 2. `architect` — 系统架构师

**职责**：技术方案设计、API 契约、模块边界

**读取**：`changes/{name}/proposal.md`、`specs/`、`kanban/user/confirmations.md`  
**写入**：`changes/{name}/design.md`、`changes/{name}/specs/`、`kanban/agent/blockers.md`  
**触发**：PM 完成 proposal 后 / `/sps:design`

---

### 3. `ui-ux` — UI/UX 设计师 🆕

**职责**：设计系统、交互规范、视觉一致性审计

**读取**：`changes/{name}/proposal.md`、`specs/`、代码中的 UI 文件  
**写入**：
- `changes/{name}/design-ui.md`（UI 设计规范：配色、组件、间距、动画）
- `changes/{name}/wireframes/`（线框图描述，文本格式）
- `kanban/agent/blockers.md`

**典型产出**：
```markdown
## UI 规范：深色模式

### 配色方案
- 背景: #1A1A2E → #16213E (渐变)
- 文字: #EAEAEA (主) / #8E8E93 (次)
- 强调色: #0A84FF (同亮色模式)

### 需检查项
- [ ] 所有文字对比度 ≥ 4.5:1 (WCAG AA)
- [ ] 图标在深色背景可见
- [ ] 动画不受主题影响
```

**什么时候需要此角色**：有 UI 的项目（Web/App/桌面端）

---

### 4. `implementer` — 开发实现

**职责**：按设计文档写代码。PM 可按项目类型细分为 `frontend-dev`、`backend-dev`、`swift-dev` 等。

**读取**：`changes/{name}/design.md`、`changes/{name}/design-ui.md`、`specs/`  
**写入**：项目代码（`agents.yaml#allowed_paths`）、`kanban/agent/outputs.md`  
**触发**：Architect + UI/UX 完成设计后 / `/sps:apply`

**约束**：
```yaml
roles:
  implementer:
    allowed_paths:
      - "src/**"
      - "tests/**"
    forbidden_paths:
      - "specs/**"
      - "kanban/**"
```

---

### 5. `tester` — 测试工程师

**职责**：编写/运行测试，验证实现是否符合 specs

**读取**：
- `changes/{name}/specs/`（新增规范）
- `specs/`（基准规范）
- 代码文件

**写入**：
- 测试文件（`tests/**`）
- `kanban/agent/outputs.md`（测试报告）

**触发条件**：
- Implementer 完成代码后
- 用户执行 `/sps:verify`

**产出示例**：
```markdown
## 测试报告 2024-01-15

- 覆盖率: 87%
- 通过: 42 / 42
- 失败: 0
- 新增测试: 8 个（deep-mode-support）
```

---

### 6. `reviewer` — 代码审查

**职责**：代码质量检查，安全审查，最佳实践

**读取**：
- `changes/{name}/` 全部文件
- 项目代码（via git diff）

**写入**：
- `changes/{name}/review.md`（审查意见）
- `kanban/agent/blockers.md`（需用户决策的大问题）

**触发条件**：
- Tester 测试通过后
- 用户执行 `/sps:review`

**审查维度**：
- 代码可读性
- 是否遵循 specs 约束
- 安全风险（尤其是 `.private/` 文件泄漏）
- 性能影响
- 破坏性变更

---

### 7. `docs-writer` — 文档维护

**职责**：更新 README、changelog、specs 文档

**读取**：
- `changes/{name}/proposal.md`
- `changes/{name}/outputs.md`
- 现有文档

**写入**：
- `CHANGELOG.md`
- `docs/**`
- `specs/`（仅文档类内容）

**触发条件**：
- Review 通过，准备归档前
- 用户执行 `/sps:archive`

---

### 8. `security-guard` — 安全守卫（可选）

**职责**：扫描私密文件泄漏，检查依赖漏洞

**读取**：
- 全部 staged 文件（只读）

**写入**：
- `kanban/agent/blockers.md`（发现问题立即阻塞）

**触发条件**：
- Pre-commit hook（自动）
- 用户执行 `/sps:audit`

**检查规则**：
```yaml
security:
  forbidden_patterns:
    - ".private/"
    - "*.pem"
    - "*.key"
    - "password:"
    - "secret:"
    - "api_key:"
```

---

### 9. `ops` — 运营/DevOps 🆕

**职责**：CI/CD 配置、部署流程、环境管理、发布管理

**读取**：项目全部文件、`changes/{name}/design.md`  
**写入**：
- CI/CD 配置文件（`.github/workflows/`、`Makefile`、`Dockerfile` 等）
- 部署脚本（`scripts/`）
- `kanban/agent/outputs.md`（部署报告）

**典型产出**：
```yaml
# .github/workflows/ci.yml — 由 ops agent 生成
name: CI
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci && npm test
```

**什么时候需要此角色**：需要持续部署、多环境、容器化的项目

---

## `agents.yaml` 完整示例

```yaml
# 由 PM 根据项目分析自动生成
# super-spec/changes/dark-mode/agents.yaml
version: 1
change: dark-mode-support
project_type: macos-app

# PM 生成的工作目录（仅新项目）
# workspace:
#   Sources/: "Swift 源码"
#   Tests/: "测试"

roles:
  pm:
    enabled: true
    trigger: manual   # /sps:propose
    
  architect:
    enabled: true
    trigger: after:pm
    
  ui-ux:
    enabled: true          # 有 UI → 启用
    trigger: parallel:architect   # 和架构师并行
    scope: ["CopilotIsland/UI/**"]
    
  implementer:
    alias: swift-dev       # PM 按项目类型命名
    enabled: true
    trigger: after:architect,ui-ux   # 等两者都完成
    allowed_paths:
      - "CopilotIsland/**/*.swift"
      - "tests/**"
    forbidden_paths:
      - "specs/**"
      - ".private/**"
    
  tester:
    enabled: true
    trigger: after:implementer
    allowed_paths:
      - "tests/**"
      
  reviewer:
    enabled: true
    trigger: after:tester
    
  docs-writer:
    enabled: true
    trigger: after:reviewer
    
  ops:
    enabled: false         # 桌面应用暂不需要
    
  security-guard:
    enabled: true
    trigger: pre-commit    # 自动

# 阻塞处理策略
blocking:
  strategy: pause
  notify: kanban/agent/blockers.md
  resume_trigger: kanban/user/confirmations.md
```

---

## 执行流水线

```
用户 /sps:propose dark-mode（或 /sps:init 新项目）
         │
         ▼
    [PM] 需求整理 → proposal.md + phases.md
    [PM] 分析项目类型 → 生成 agents.yaml（选择角色 + 目录）
         │
         ├──────────────────┐
         ▼                  ▼
    [Architect]         [UI/UX]         ← 并行
    design.md           design-ui.md
         │                  │
         └────────┬─────────┘
                  ▼
    [Implementer] 读 design + design-ui → 写代码
         │
         ▼
    [Tester] 跑测试 → outputs.md（测试报告）
         │ 失败？→ 回到 Implementer
         ▼
    [Reviewer] 审查 → review.md
         │ 大问题？→ blockers.md
         ▼
    [Docs Writer] 更新文档 + changelog
         │
         ▼
    [Ops] 更新 CI/CD（如需要）
         │
         ▼
    用户 /sps:archive → 合并 specs，归档 changes/
```

---

## 角色总览

| 角色 | 常驻 | 职责 | 什么项目需要 |
|------|------|------|-------------|
| `pm` | ✅ 是 | 需求整理、角色规划、工作分发 | 所有项目 |
| `architect` | 否 | 技术方案、API 设计 | 有复杂架构的项目 |
| `ui-ux` | 否 | 设计系统、配色、交互规范 | 有 UI 的项目 |
| `implementer` | 否 | 写代码（可细分前端/后端/移动端） | 所有项目 |
| `tester` | 否 | 测试编写和运行 | 所有项目 |
| `reviewer` | 否 | 代码审查 | 所有项目 |
| `docs-writer` | 否 | 文档维护 | 有公开文档的项目 |
| `security-guard` | 否 | 安全扫描 | 有私密信息的项目 |
| `ops` | 否 | CI/CD、部署、发布 | 需要部署的项目 |

---

## 与 Copilot Island 项目对照

| Copilot Island 实践 | SuperSpec 角色 |
|---------------------|----------------|
| PM Audit Agent | `pm` |
| UI/UX Designer Agent | `ui-ux` |
| 实现 Agent（多个并行）| `implementer` (细分为 swift-dev) |
| 构建/测试 Agent | `tester` |
| Security Auditor | `security-guard` |
| 文档 Agent | `docs-writer` |
| CI/CD Agent | `ops` |
| 探索/研究 Agent | → `architect` 前置步骤 |
