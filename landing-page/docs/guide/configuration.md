# Configuration

Copilot Island requires minimal configuration and works out of the box.

## Settings Panel

Access settings by clicking the **⚙️ gear icon** in the expanded notch panel.

### GitHub Token

Required for the GitHub Models AI Chat feature.

1. Visit [github.com/settings/tokens](https://github.com/settings/tokens)
2. Create a new token with `models:read` permission
3. Paste the token in **Settings → GitHub Token**

Your token is stored securely in macOS Keychain, never on disk in plain text.

### Model Selection

Choose your default AI model for the chat feature:

| Model | Description |
|-------|-------------|
| `gpt-4o` | Best for complex coding tasks |
| `gpt-4o-mini` | Fast and efficient for simple queries |
| `claude-3-5-sonnet` | Excellent reasoning and code generation |
| `meta-llama-3.1-70b-instruct` | Open-source option |

### Notifications

Enable system notifications to be alerted when:
- A new Copilot session starts
- A session completes

## Session Watching

Copilot Island automatically watches `~/.copilot/session-state/` for changes.  
No configuration needed — it just works.

## macOS Permissions

On first launch, grant these permissions when prompted:

- **Files and Folders** → Allow access to read Copilot CLI session files
- **Network** → Required for GitHub Models API calls (AI chat feature)
