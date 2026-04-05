# Contributing to Copilot Island

Thank you for your interest in contributing! We welcome all contributions.

## How to Contribute

### Reporting Bugs

1. Check existing [issues](https://github.com/lordmos/copilot-island/issues) first
2. Open a new issue with:
   - macOS version
   - Copilot CLI version (`copilot --version`)
   - Steps to reproduce
   - Expected vs actual behavior
   - Console logs from `/Applications/Utilities/Console.app` filtered by "CopilotIsland"

### Feature Requests

Open an issue with the `enhancement` label. Describe the use case and expected behavior.

### Pull Requests

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Set up your development environment (see below)
4. Make your changes
5. Run any existing tests
6. Commit with clear messages
7. Push and open a PR against `main`

## Development Setup

```bash
# Prerequisites: Xcode 15+, Homebrew
git clone https://github.com/lordmos/copilot-island.git
cd copilot-island/copilot-island-project
chmod +x scripts/setup.sh && ./scripts/setup.sh
open CopilotIsland.xcodeproj
```

## Code Style

- Swift 5.9+ idioms
- `@MainActor` for all UI code
- `actor` for shared mutable state (see `SessionStore`)
- Structured concurrency (`async/await`, `AsyncStream`) — no callbacks
- No third-party dependencies except Sparkle (updates) and swift-markdown (rendering)

## Architecture Notes

Key files:
- `CopilotSessionWatcher.swift` — the FSEvents-based file watcher (core innovation)
- `SessionStore.swift` — actor-based central state
- `NotchView.swift` — root UI view, entry point for all UI changes
- `CopilotTheme.swift` — design system (add new design tokens here)

## License

By contributing, you agree your contributions will be licensed under Apache 2.0.
