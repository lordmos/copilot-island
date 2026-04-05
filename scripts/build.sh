#!/bin/bash
# build.sh — Build CopilotIsland.app
set -e

SCHEME="CopilotIsland"
CONFIGURATION="${1:-Release}"
BUILD_DIR="$(pwd)/.build"

echo "🏝️  Building Copilot Island ($CONFIGURATION)…"

# Generate Xcode project if needed
if [ ! -f "CopilotIsland.xcodeproj/project.pbxproj" ]; then
    echo "📐 Generating Xcode project with XcodeGen…"
    if ! command -v xcodegen &>/dev/null; then
        echo "⚠️  XcodeGen not found. Install with: brew install xcodegen"
        exit 1
    fi
    xcodegen generate
fi

xcodebuild \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -derivedDataPath "$BUILD_DIR" \
    build

APP_PATH=$(find "$BUILD_DIR" -name "CopilotIsland.app" -maxdepth 5 | head -1)
echo "✅ Built: $APP_PATH"
