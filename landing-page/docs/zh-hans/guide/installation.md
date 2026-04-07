---
layout: doc
---

# 安装

## 系统要求

- **macOS 14.0+**（Sonoma 或更高版本）
- 带有**刘海**的 MacBook Pro 或 MacBook Air（2021 年或更新款）
- 已安装并完成身份验证的 [GitHub Copilot CLI](https://docs.github.com/en/copilot/github-copilot-in-the-cli)

## 方式一：下载发布版本（推荐）

1. 前往 [发布页面](https://github.com/lordmos/copilot-island/releases/latest)
2. 下载 `CopilotIsland.dmg`
3. 打开 DMG 文件，将 Copilot Island 拖入「应用程序」文件夹
4. 从「应用程序」（或 Spotlight）启动 Copilot Island
5. 应用将出现在 MacBook 刘海中

## 方式二：从源代码构建

```bash
# 克隆仓库
git clone https://github.com/lordmos/copilot-island.git
cd copilot-island

# 运行设置脚本（安装 XcodeGen 并生成 Xcode 项目）
chmod +x scripts/setup.sh && ./scripts/setup.sh

# 在 Xcode 中打开
open CopilotIsland.xcodeproj
```

然后按 **⌘R** 进行构建并运行。

## 首次启动

首次启动时，Copilot Island 将：
1. 请求访问您主目录中文件的权限
2. 自动开始监控 `~/.copilot/session-state/`
3. 在 MacBook 刘海中显示一个折叠的胶囊图标

无需额外配置 — 只需在终端中开始使用 `copilot` 即可！
