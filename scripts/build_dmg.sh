#!/bin/bash
# build_dmg.sh — Build, sign, notarize and package CopilotIsland as a DMG
# Usage: bash scripts/build_dmg.sh [version]
#
# Environment variables for Developer ID signing + notarization (optional):
#   APPLE_TEAM_ID       — 10-char Team ID  (e.g. "ABCDE12345")
#   APPLE_ID            — Apple ID email   (e.g. "you@example.com")
#   APPLE_APP_PASSWORD  — App-Specific Password from appleid.apple.com
#
# If those vars are unset, falls back to ad-hoc signing (triggers Gatekeeper warning).
set -euo pipefail

VERSION="${1:-dev}"
SCHEME="CopilotIsland"
DERIVED_DATA="$(pwd)/.build"
DIST="$(pwd)/dist"
DMG_NAME="CopilotIsland-${VERSION}.dmg"
FINAL_DMG="${DIST}/${DMG_NAME}"
VOLUME_NAME="Copilot Island ${VERSION}"
ARCHIVE_PATH="${DERIVED_DATA}/CopilotIsland.xcarchive"

echo "🏝️  Building Copilot Island v${VERSION}…"

# ── 1. Generate Xcode project if needed ──────────────────────────────────────
if [ ! -f "CopilotIsland.xcodeproj/project.pbxproj" ]; then
    echo "📐 Generating Xcode project…"
    if ! command -v xcodegen &>/dev/null; then
        echo "⚠️  XcodeGen not found. Install with: brew install xcodegen"; exit 1
    fi
    xcodegen generate
fi

# ── 2. Archive ────────────────────────────────────────────────────────────────
HAS_DEVID=false
if security find-identity -v -p codesigning 2>/dev/null | grep -q "Developer ID Application"; then
    HAS_DEVID=true
fi

echo "📦 Archiving (Developer ID: $HAS_DEVID)…"
if [ "$HAS_DEVID" = "true" ]; then
    xcodebuild archive \
        -scheme "$SCHEME" \
        -configuration Release \
        -archivePath "$ARCHIVE_PATH" \
        -quiet
else
    xcodebuild archive \
        -scheme "$SCHEME" \
        -configuration Release \
        -archivePath "$ARCHIVE_PATH" \
        CODE_SIGN_IDENTITY="-" \
        CODE_SIGNING_REQUIRED=YES \
        CODE_SIGNING_ALLOWED=YES \
        -quiet
fi

# ── 3. Locate .app ────────────────────────────────────────────────────────────
APP_SRC=$(find "$ARCHIVE_PATH/Products" -name "CopilotIsland.app" -maxdepth 5 | head -1)
if [ -z "$APP_SRC" ]; then
    echo "❌ Could not locate CopilotIsland.app in archive"; exit 1
fi

# ── 4. Sign ───────────────────────────────────────────────────────────────────
if [ "$HAS_DEVID" = "true" ]; then
    echo "🔏 Signing with Developer ID…"
    codesign --force --deep --options runtime \
        --sign "Developer ID Application" "$APP_SRC"
else
    echo "🔏 Ad-hoc signing (no Developer ID found in Keychain)…"
    codesign --force --deep --sign - "$APP_SRC"
fi

# ── 5. Package DMG ────────────────────────────────────────────────────────────
mkdir -p "$DIST"
STAGING="${DIST}/dmg_staging"
rm -rf "$STAGING"
mkdir -p "$STAGING"
cp -R "$APP_SRC" "$STAGING/"
ln -s /Applications "$STAGING/Applications"

echo "💿 Creating DMG…"
hdiutil create \
    -volname "$VOLUME_NAME" \
    -srcfolder "$STAGING" \
    -ov -format UDZO \
    "$FINAL_DMG"
rm -rf "$STAGING"

if [ "$HAS_DEVID" = "true" ]; then
    codesign --force --sign "Developer ID Application" "$FINAL_DMG"
fi

# ── 6. Notarize + Staple (requires APPLE_ID + APPLE_APP_PASSWORD + APPLE_TEAM_ID) ──
if [ "$HAS_DEVID" = "true" ] \
   && [ -n "${APPLE_ID:-}" ] \
   && [ -n "${APPLE_APP_PASSWORD:-}" ] \
   && [ -n "${APPLE_TEAM_ID:-}" ]; then
    echo "📨 Submitting for notarization…"
    xcrun notarytool submit "$FINAL_DMG" \
        --apple-id "$APPLE_ID" \
        --password "$APPLE_APP_PASSWORD" \
        --team-id "$APPLE_TEAM_ID" \
        --wait
    echo "📎 Stapling notarization ticket…"
    xcrun stapler staple "$FINAL_DMG"
    echo "✅ Notarized and stapled."
else
    echo "ℹ️  Skipping notarization (set APPLE_ID, APPLE_APP_PASSWORD, APPLE_TEAM_ID to enable)."
fi

echo "✅ DMG ready: ${FINAL_DMG}"
du -sh "$FINAL_DMG" | cut -f1
