---
layout: home

hero:
  name: "Copilot Island"
  text: "您的 MacBook 刘海屏，由 GitHub Copilot 驱动"
  tagline: 在刘海屏中实时监控 Copilot CLI 会话，浏览 AI 对话历史。
  image:
    src: /hero.svg
    alt: Copilot Island
  actions:
    - theme: brand
      text: 下载 Mac 版
      link: https://github.com/lordmos/copilot-island/releases/latest
    - theme: alt
      text: 在 GitHub 查看
      link: https://github.com/lordmos/copilot-island
    - theme: alt
      text: 快速开始 →
      link: /guide/quick-start

features:
  - icon: 🔔
    title: 实时会话监控
    details: 直接从 MacBook 刘海屏实时监控每个 Copilot CLI 会话，随时掌握 AI 的工作状态。

  - icon: ⚡
    title: 工具调用动态
    details: 实时查看 Copilot 正在运行的每个工具——文件写入、终端命令、网络搜索——所有参数一览无余。

  - icon: 💬
    title: 完整对话历史
    details: 浏览完整的对话记录，支持精美的 Markdown 渲染，代码块和工具结果清晰展示。

  - icon: 🎨
    title: Copilot 风格设计
    details: 以 GitHub 设计语言精心打造。低饱和草绿色调、深色主题，流畅动画完美融入 macOS。

  - icon: 🔓
    title: 完全开源
    details: Apache 2.0 许可证。查看代码、贡献功能、反馈问题。由社区用 ❤️ 共同构建。
---

## 工作原理

```bash
# 1. 安装 Copilot Island（从 Releases 下载）
# 2. 正常运行 Copilot CLI 会话
copilot "为认证模块添加单元测试"

# 3. Copilot Island 自动检测会话
#    并在 MacBook 刘海屏中显示——无需任何配置！
```

> Copilot Island 监控 `~/.copilot/session-state/` 目录，实时读取 Copilot CLI 原生的 JSONL 事件日志，零配置即可运行。

## 系统要求

- macOS 14.0+（Sonoma 或更高版本）
- 带刘海屏的 MacBook Pro 或 MacBook Air（2021 年或更新款）
- 已安装并登录 GitHub Copilot CLI
