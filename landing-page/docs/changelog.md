---
layout: doc
---

# Changelog

All notable changes to Copilot Island are documented here.

---

## v0.1.8 — 2026-04-07

### Features
- **Auto-update via Sparkle** — Copilot Island now checks for updates automatically using the Sparkle framework. Updates are served securely via GitHub Pages.

### Fixes
- App version display and menu layout width adjustments
- Sparkle `SUFeedURL` configuration for reliable update detection

---

## v0.1.7 — 2026-04-06

This release is a major overhaul of the notch UI, event system, and sound effects.

### Features
- **Peek state machine** — The left peek icon animates based on session state: idle breathing, working pulse, 3-second trophy 🏆 on task complete, 3-second failure ❌ on abort/error/shutdown
- **8-bit sound effects** — Ascending chime on task completion; descending square-wave on failure. Sounds only play for live events (< 5 seconds old at startup)
- **Failure sounds** — Distinct sound for `abort`, `session.error`, and `session.shutdown` events
- **Concatenated assistant messages** — Assistant output within the same turn is joined into one readable message block instead of many fragments
- **Startup filter** — On launch, only the current task (from the last `user.message` onward) is loaded to avoid replaying full session history
- **Check for Updates** — Settings panel now includes an "About" page with a version check button powered by Sparkle
- **Settings redesign** — Cleaner layout, corrected toggle colors, proper theme color usage throughout

### Fixes
- **Panel aligned to screen top** — Expanded notch panel now starts flush with the physical screen edge (no gap below the notch)
- **Eliminated startup flicker** — Session list no longer re-renders hundreds of times on startup; batch processing emits a single state update
- **Sound timing corrected** — Completion sound fires at `assistant.turn_end` after `session.task_complete`, not prematurely at the task complete event itself
- **Real-time chat updates** — Session detail view now polls for new messages every second
- **Dynamic notch dimensions** — Panel width and height are calculated from actual macOS screen APIs (`auxiliaryTopLeftArea` / `auxiliaryTopRightArea`)
- **Unified notch bar** — Closed state shows a single seamless black bar covering left icon, center dots, and right session count
- **Color audit** — Fixed unreadable placeholder text colors, inconsistent toggle accent colors, and off-brand blue tones in settings

---

## v0.1.6 — 2026-04-02

### Fixes
- Re-sign Sparkle XPC services with Developer ID certificate for notarization compliance

---

## v0.1.5 — 2026-04-02

### Fixes
- Fetch notarytool rejection log when notarization status is `Invalid` to aid debugging

---

## v0.1.4 — 2026-04-02

### Fixes
- Add `--timestamp` flag to `codesign` for notarization compliance

---

## v0.1.3 — 2026-04-02

### Fixes
- Make notarization step non-fatal so GitHub releases publish even if notarization returns a 401 error
- Add secret availability diagnostics to the release workflow
- Fix conditional checks in the release workflow for signing steps

---

## v0.1.2 — 2026-04-02

*(Tagged together with v0.1.3 — see v0.1.3 notes)*

---

## v0.1.1 — 2026-04-01

### Features
- Developer ID signing + notarization workflow in GitHub Actions

### Fixes
- `build_dmg.sh` falls back to Apple Development certificate when Developer ID is unavailable
- DMG is now created in a single `hdiutil` step using UDZO compression

---

## v0.1.0 — 2026-03-31

🎉 **Initial release** of Copilot Island.

### Features
- Notch overlay window that monitors `~/.copilot/session-state/` in real-time
- Session list showing all active and recent Copilot CLI sessions
- Chat history view with Markdown rendering, code blocks, and tool results
- Collapsed "pill" state with left status icon and right session count
- Expand/collapse on notch click or hover
- Copilot-inspired dark sage-green theme
- Flat-top notch shape flush with screen edge, rounded bottom corners
- Sound effect on agent task completion
- macOS 14.0+ (Sonoma), MacBook notch support
- Apache 2.0 open source license
