# Session Monitoring

Copilot Island's core feature is real-time monitoring of your GitHub Copilot CLI sessions.

## How Sessions Are Detected

Copilot Island watches `~/.copilot/session-state/` using macOS **FSEvents** — the same low-latency file system notification API used by Xcode and Spotlight. When Copilot CLI creates a new session directory, Copilot Island detects it within milliseconds.

```
~/.copilot/session-state/
└── {UUID}/                    ← new directory triggers detection
    ├── workspace.yaml         ← session metadata
    └── events.jsonl           ← event stream (appended in real-time)
```

No hooks, no plugins, no CLI modification required.

## Session Cards

Each session is displayed as a card in the notch panel showing:

| Field | Description |
|-------|-------------|
| 🟢 Status dot | Green = active, Grey = ended |
| Project path | The `cwd` from `workspace.yaml` |
| Git branch | Current branch (if in a git repo) |
| Session summary | Auto-generated summary from Copilot CLI |
| Elapsed time | Time since session started |

## Event Stream

Inside each session, Copilot Island tails `events.jsonl` and processes these event types:

| Event Type | What it means |
|-----------|---------------|
| `session.start` | A new Copilot CLI session has begun |
| `user.message` | You sent a message to Copilot |
| `assistant.turn_start` | Copilot started thinking/responding |
| `assistant.message` | Copilot produced a response |
| `tool.execution_start` | Copilot is about to run a tool |
| `tool.execution_complete` | Tool finished (success or error) |
| `assistant.turn_end` | Copilot completed its response turn |
| `abort` | Session was aborted by the user |
| `session.shutdown` | Copilot CLI process exited |

## Multiple Sessions

Copilot Island tracks **all concurrent sessions**. If you have multiple terminal windows running `copilot`, each session appears as a separate card. Sessions are sorted by most recently active.

## Session Retention

Ended sessions remain visible for the current app launch. Sessions are not persisted across app restarts (to keep the app lightweight and respect your privacy).

## Privacy

Copilot Island reads session data **locally** from your Mac. Nothing is uploaded or shared. The GitHub Models API chat feature is the only network feature, and it's entirely opt-in.
