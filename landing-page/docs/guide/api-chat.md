# GitHub Models AI Chat

Copilot Island includes a built-in AI chat panel powered by the **GitHub Models API** — allowing you to chat with powerful AI models directly from the notch, without needing to start a Copilot CLI session.

## Supported Models

GitHub Models offers a generous free tier with access to:

| Model | Best for |
|-------|----------|
| `gpt-4o` | Complex reasoning, detailed code review |
| `gpt-4o-mini` | Fast responses, simple questions |
| `claude-3-5-sonnet` | Long context, nuanced understanding |
| `meta-llama-3.1-70b-instruct` | Open-source alternative |
| `mistral-large` | European data residency |

Models are selectable in **Settings → Model**.

## Setup

### 1. Create a GitHub Token

1. Go to [github.com/settings/tokens](https://github.com/settings/tokens) → **Fine-grained tokens**
2. Click **Generate new token**
3. Set an expiration (90 days recommended)
4. Under **Permissions**, find **Models** → set to **Read**
5. Click **Generate token** and copy it

### 2. Add Token to Copilot Island

1. Open Copilot Island (click the notch)
2. Navigate to **⚙️ Settings → GitHub Token**
3. Paste your token and press **Save**

Your token is stored in **macOS Keychain** — never written to disk in plain text.

## Using the Chat

1. Open Copilot Island and select the **🤖 AI Chat** tab
2. Type your message in the input field
3. Press **Return** or click **Send**

Responses are **streamed in real-time** — you see text appear as the model generates it, just like in the Copilot CLI.

## Chat Features

- **Markdown rendering** — code blocks, bold, lists all render properly
- **Streaming responses** — see output token by token
- **Conversation history** — the full context is maintained within a session
- **Model switching** — change models between messages
- **Clear chat** — start a fresh conversation anytime

## API Endpoint

Copilot Island uses the official GitHub Models API endpoint:

```
https://models.inference.ai.azure.com/chat/completions
```

This is the same Azure-hosted endpoint used by GitHub Codespaces and the GitHub Models playground.

## Rate Limits

GitHub Models free tier has rate limits. If you hit them, you'll see a rate limit error in the chat. Limits reset hourly. For production use, consider upgrading to a paid GitHub plan.

## Privacy

- Your conversations are sent to GitHub Models API (Microsoft Azure)
- No conversation data is stored by Copilot Island
- Your token is never logged or transmitted anywhere except to the GitHub Models API
