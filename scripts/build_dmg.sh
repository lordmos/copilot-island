#!/bin/bash
# build_dmg.sh — Build CopilotIsland.app and package it as a DMG
# Usage: bash scripts/build_dmg.sh [version]
# Example: bash scripts/build_dmg.sh 1.0.0
set -euo pipefail

VERSION="${1:-dev}"
SCHEME="CopilotIsland"
DERIVED_DATA="$(pwd)/.build"
DIST="$(pwd)/dist"
DMG_NAME="CopilotIsland-${VERSION}.dmg"
VOLUME_NAME="Copilot Island ${VERSION}"

echo "🏝️  Building Copilot Island v${VERSION}…"

# ── 1. Generate Xcode project if needed ─────────────────────────────────────
if [ ! -f "CopilotIsland.xcodeproj/project.pbxproj" ]; then
    echo "📐 Generating Xcode project…"
    if ! command -v xcodegen &>/dev/null; then
        echo "⚠️  XcodeGen not found. Install with: brew install xcodegen"; exit 1
    fi
    xcodegen generate
fi

# ── 2. Archive ───────────────────────────────────────────────────────────────
ARCHIVE_PATH="${DERIVED_DATA}/CopilotIsland.xcarchive"
echo "📦 Archiving…"
xcodebuild archive \
    -scheme "$SCHEME" \
    -configuration Release \
    -archivePath "$ARCHIVE_PATH" \
    CODE_SIGN_IDENTITY="-" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO \
    -quiet

# ── 3. Export .app ───────────────────────────────────────────────────────────
APP_EXPORT="${DERIVED_DATA}/export"
echo "📤 Exporting .app…"
xcodebuild -exportArchive \
    -archivePath "$ARCHIVE_PATH" \
    -exportPath "$APP_EXPORT" \
    -exportOptionsPlist scripts/ExportOptions.plist \
    -quiet 2>/dev/null || true

# Fall back to copying directly from the archive if exportArchive fails (no signing)
APP_SRC=$(find "$ARCHIVE_PATH" -name "CopilotIsland.app" -maxdepth 5 | head -1)
if [ -z "$APP_SRC" ]; then
    echo "❌ Could not locate CopilotIsland.app in archive"; exit 1
fi

# ── 4. Package as DMG via hdiutil ────────────────────────────────────────────
mkdir -p "$DIST"
STAGING="${DIST}/dmg_staging"
rm -rf "$STAGING"
mkdir -p "$STAGING"

cp -R "$APP_SRC" "$STAGING/"
# Symlink to /Applications for drag-install UX
ln -s /Applications "$STAGING/Applications"

echo "💿 Creating DMG…"
# Single-step compressed DMG (avoids hdiutil convert resource-lock issue)
hdiutil create \
    -volname "$VOLUME_NAME" \
    -srcfolder "$STAGING" \
    -ov \
    -format UDZO \
    "$FINAL_DMG"
rm -rf "$STAGING"

echo "✅ DMG ready: ${FINAL_DMG}"
echo "   Size: $(du -sh "$FINAL_DMG" | cut -f1)"
