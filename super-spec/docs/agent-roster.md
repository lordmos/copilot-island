# SuperSpec Agent 角色方案

> **归属**: `super-spec/docs/agent-roster.md`  
> **上级文档**: [`../PRD.md`](../PRD.md)

---

## 设计原则

以**软件开发团队**为蓝本，每个 agent 对应一个专业角色。角色之间通过 specs 文件和 change 文件夹传递上下文，不直接通信。

**核心原则**：
- 每个 role 只执行其职责范围内的工作
- 所有角色都可以在 `blockers.md` 写阻塞，等待用户确认
- Agent 不直接相互调用；通过共享文件协作

---

## 角色定义

### 1. `pm` — 产品经理

**职责**：需求拆解、变更提案、优先级维护

**读取**：
- `kanban/user/requirements.md`
- `kanban/user/bugs.md`
- `specs/`

**写入**：
- `changes/{name}/proposal.md`（变更提案）
- `kanban/agent/blockers.md`（需求不清晰时提问）

**触发条件**：
- 用户在 `requirements.md` 新增需求条目
- 用户执行 `/sps:propose <name>`

**示例任务**：
```yaml
- role: pm
  trigger: kanban/user/requirements.md#new-entry
  actions:
    - create: changes/{req.id}/proposal.md
    - annotate: 拆分为可执行任务，估算复杂度
```

---

### 2. `architect` — 系统架构师

**职责**：技术方案设计、API 契约、模块边界

**读取**：
- `changes/{name}/proposal.md`
- `specs/`
- `kanban/user/confirmations.md`

**写入**：
- `changes/{name}/design.md`（技术设计文档）
- `changes/{name}/specs/`（Delta specs，新增或修改的规范）
- `kanban/agent/blockers.md`

**触发条件**：
- PM 完成 `proposal.md` 后
- 用户执行 `/sps:design`

**示例 design.md**：
```markdown
## 技术方案：深色模式

### 方案选择
- ✅ 跟随系统 NSAppearance（符合用户确认 q-001-A）
- ❌ 自定义主题存储（过度设计）

### 影响范围
- ThemeManager.swift（新建）
- 所有 SwiftUI View 需注入 @Environment(\.colorScheme)

### API 契约
ThemeManager.current: ColorScheme  // 只读，不可手动切换
```

---

### 3. `implementer` — 开发实现

**职责**：按设计文档写代码，最小化改动

**读取**：
- `changes/{name}/design.md`
- `changes/{name}/specs/`
- `specs/`（参考基准）

**写入**：
- 项目代码文件（声明在 `agents.yaml#allowed_paths`）
- `kanban/agent/outputs.md`

**触发条件**：
- Architect 完成 `design.md` 后
- 用户执行 `/sps:apply`

**约束**：
```yaml
# agents.yaml 中声明
roles:
  implementer:
    allowed_paths:
      - "src/**"
      - "tests/**"
    forbidden_paths:
      - "specs/**"       # 不能改基准规范
      - "kanban/**"      # 不能写看板（除 outputs.md）
```

---

### 4. `tester` — 测试工程师

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

### 5. `reviewer` — 代码审查

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

### 6. `docs-writer` — 文档维护

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

### 7. `security-guard` — 安全守卫（可选）

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

## `agents.yaml` 完整示例

```yaml
# super-spec/changes/dark-mode/agents.yaml
version: 1
change: dark-mode-support

roles:
  pm:
    enabled: true
    trigger: manual   # /sps:propose
    
  architect:
    enabled: true
    trigger: after:pm
    needs_secrets: false
    
  implementer:
    enabled: true
    trigger: after:architect
    allowed_paths:
      - "CopilotIsland/**/*.swift"
      - "tests/**"
    forbidden_paths:
      - "specs/**"
      - ".private/**"
    needs_secrets: false
    
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
    
  security-guard:
    enabled: true
    trigger: pre-commit   # 自动

# 阻塞处理策略
blocking:
  strategy: pause          # pause | skip | escalate
  notify: kanban/agent/blockers.md
  resume_trigger: kanban/user/confirmations.md
```

---

## 执行流水线

```
用户 /sps:propose dark-mode
         │
         ▼
    [PM] 读 requirements.md → 生成 proposal.md
         │
         ▼
    [Architect] 读 proposal.md → 生成 design.md
         │ 遇到问题？→ blockers.md → 等待 confirmations.md
         ▼
    [Implementer] 读 design.md → 写代码
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
    用户 /sps:archive → 合并 specs，归档 changes/
```

---

## 与 Copilot Island 项目对照

| Copilot Island 实践 | SuperSpec 角色 |
|---------------------|----------------|
| PM Audit Agent | `pm` |
| UI/UX Designer Agent | `architect` (设计决策) |
| 实现 Agent（多个并行）| `implementer` |
| 构建/测试 Agent | `tester` |
| Security Auditor | `security-guard` |
| 文档 Agent | `docs-writer` |
| 探索/研究 Agent | → `architect` 前置步骤 |
