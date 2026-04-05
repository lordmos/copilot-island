---
layout: home

hero:
  name: "Copilot Island"
  text: "Your MacBook Notch, Powered by GitHub Copilot"
  tagline: Monitor Copilot CLI sessions and browse AI conversations — all from the notch.
  image:
    src: /hero.svg
    alt: Copilot Island
  actions:
    - theme: brand
      text: Download for Mac
      link: https://github.com/lordmos/copilot-island/releases/latest
    - theme: alt
      text: View on GitHub
      link: https://github.com/lordmos/copilot-island
    - theme: alt
      text: Quick Start →
      link: /guide/quick-start

features:
  - icon: 🔔
    title: Live Session Monitoring
    details: Watch every Copilot CLI session in real-time directly from your MacBook notch. Never miss what the AI is doing.

  - icon: ⚡
    title: Tool Activity Feed
    details: See exactly which tools Copilot is running — file writes, shell commands, web searches — with arguments, all in the notch.

  - icon: 💬
    title: Full Chat History
    details: Browse the entire conversation with beautiful Markdown rendering. Scroll through AI reasoning, code blocks, and tool results.

  - icon: 🎨
    title: Copilot-Inspired Design
    details: Crafted with GitHub's design language. Muted sage-green palette, dark theme, and fluid animations that feel native on macOS.

  - icon: 🔓
    title: Fully Open Source
    details: Apache 2.0 licensed. Inspect the code, contribute features, report bugs. Built with ❤️ by the community.
---

## How It Works

```bash
# 1. Install Copilot Island (download from releases)
# 2. Run your Copilot CLI session as usual
copilot "Add unit tests for the auth module"

# 3. Copilot Island automatically detects the session
#    and shows it in your MacBook notch — no config needed!
```

> Copilot Island watches `~/.copilot/session-state/` and streams real-time events  
> directly from Copilot CLI's native JSONL event log. Zero configuration required.

## Requirements

- macOS 14.0+ (Sonoma or later)
- MacBook Pro or MacBook Air with notch (2021 or later)
- GitHub Copilot CLI installed and authenticated

