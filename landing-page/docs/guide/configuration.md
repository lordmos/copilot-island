# Configuration

Copilot Island requires minimal configuration and works out of the box.

## Settings Panel

Access settings by clicking the **⋯ menu icon** in the expanded notch panel, then selecting **Settings**.

### Sound Effects

Toggle the completion chime and failure sound on or off:

- **Completion sound** — plays when the agent finishes a task (`session.task_complete` → `assistant.turn_end`)
- **Failure sound** — plays on `abort`, `session.error`, or unexpected `session.shutdown`

### About & Updates

The **About** tab in Settings shows the current app version and lets you **Check for Updates** (powered by Sparkle). Copilot Island will notify you when a new release is available on GitHub.

## Session Watching

Copilot Island automatically watches `~/.copilot/session-state/` for changes.  
No configuration needed — it just works.

On startup, only the **current task** (events from the last `user.message` onward) is loaded to keep the UI fast. Older history is not replayed.

## macOS Permissions

On first launch, grant this permission when prompted:

- **Files and Folders** → Allow access to read Copilot CLI session files in your home directory
