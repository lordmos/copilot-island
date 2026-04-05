#!/bin/bash
# setup.sh — One-time setup for Copilot Island development
set -e

echo "🏝️  Setting up Copilot Island development environment…"
echo ""

# 1. Check Xcode
if ! xcode-select -p &>/dev/null; then
    echo "❌  Xcode Command Line Tools not found."
    echo "    Run: xcode-select --install"
    exit 1
fi
echo "✅  Xcode: $(xcode-select -p)"

# 2. Check Homebrew
if ! command -v brew &>/dev/null; then
    echo "❌  Homebrew not found. Install from https://brew.sh"
    exit 1
fi
echo "✅  Homebrew: $(brew --version | head -1)"

# 3. Install XcodeGen
if ! command -v xcodegen &>/dev/null; then
    echo "📦  Installing XcodeGen…"
    brew install xcodegen
fi
echo "✅  XcodeGen: $(xcodegen --version)"

# 4. Generate Xcode project
echo ""
echo "📐  Generating Xcode project…"
xcodegen generate

echo ""
echo "✅  Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Open CopilotIsland.xcodeproj in Xcode"
echo "  2. Set your Apple Developer Team ID in Xcode (Signing & Capabilities)"
echo "  3. Press ⌘R to build and run"
echo ""
echo "  Or build from command line:"
echo "  ./scripts/build.sh"
