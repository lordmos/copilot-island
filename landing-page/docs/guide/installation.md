# Installation

## Requirements

- **macOS 14.0+** (Sonoma or later)
- MacBook Pro or MacBook Air **with notch** (2021 or later)
- [GitHub Copilot CLI](https://docs.github.com/en/copilot/github-copilot-in-the-cli) installed and authenticated

## Option 1: Download Release (Recommended)

1. Go to the [Releases page](https://github.com/lordmos/copilot-island/releases/latest)
2. Download `CopilotIsland.dmg`
3. Open the DMG and drag Copilot Island to your Applications folder
4. Launch Copilot Island from Applications (or Spotlight)
5. The app will appear in your MacBook notch

## Option 2: Build from Source

```bash
# Clone the repository
git clone https://github.com/lordmos/copilot-island.git
cd copilot-island

# Run setup (installs XcodeGen, generates Xcode project)
chmod +x scripts/setup.sh && ./scripts/setup.sh

# Open in Xcode
open CopilotIsland.xcodeproj
```

Then press **⌘R** to build and run.

## First Launch

On first launch, Copilot Island will:
1. Request permission to access files in your home directory
2. Start monitoring `~/.copilot/session-state/` automatically
3. Show a collapsed pill in your MacBook notch

No additional configuration is needed — just start using `copilot` in your terminal!
