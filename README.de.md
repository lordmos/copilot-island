# Copilot Island 🏝️

<p align="center">
  <img src="landing-page/docs/public/hero.svg" width="128" height="128" alt="Copilot Island Logo"/>
</p>

<p align="center">
  <strong>Bringe GitHub Copilot CLI in deine MacBook-Notch</strong><br/>
  Überwache Sitzungen und lies KI-Gespräche — direkt aus der Notch.
</p>

<p align="center">
  <a href="https://github.com/lordmos/copilot-island/releases/latest">
    <img src="https://img.shields.io/github/v/release/lordmos/copilot-island?style=flat-square&color=6CBB98" alt="Neueste Version"/>
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/license-Apache%202.0-blue?style=flat-square" alt="Apache 2.0"/>
  </a>
  <img src="https://img.shields.io/badge/macOS-14%2B-brightgreen?style=flat-square" alt="macOS 14+"/>
  <img src="https://img.shields.io/badge/Swift-5.9-orange?style=flat-square&logo=swift" alt="Swift 5.9"/>
</p>

<p align="center">
  <a href="README.md">English</a> ·
  <a href="README.zh-Hans.md">简体中文</a> ·
  <a href="README.zh-Hant.md">繁體中文</a> ·
  <a href="README.ja.md">日本語</a> ·
  <a href="README.ko.md">한국어</a> ·
  <a href="README.fr.md">Français</a> ·
  <strong>Deutsch</strong> ·
  <a href="README.pt.md">Português</a> ·
  <a href="README.es.md">Español</a>
</p>

---

## Was ist Copilot Island?

Copilot Island ist eine **kostenlose Open-Source-macOS-Notch-App**, die in der Notch deines MacBooks wohnt und in Echtzeit alles anzeigt, was GitHub Copilot CLI macht.

Inspiriert von [ClaudeIsland](https://github.com/celestialglobe/claude-island) bringt Copilot Island die gleiche elegante Notch-basierte UI zu GitHub Copilot CLI-Nutzern.

### Funktionen

| Funktion | Beschreibung |
|----------|--------------|
| 🔔 **Live-Sitzungen** | Automatische Erkennung aller aktiven Copilot CLI-Sitzungen |
| ⚡ **Werkzeug-Feed** | Jeder Werkzeugaufruf (read_file, run_command, etc.) in Echtzeit |
| 💬 **Gesprächsverlauf** | Vollständiges Gespräch mit Markdown-Rendering durchsuchen |
| 🎨 **Salbeigrünes Design** | Gedämpfte Salbeigrün-Palette, dunkles Thema, fließende Animationen |
| 🔒 **Privat & Sicher** | Keine Analysen, kein Telemetrie, läuft 100% lokal |

## Voraussetzungen

- **macOS 14.0+** (Sonoma oder neuer)
- MacBook Pro oder MacBook Air **mit Notch** (2021 oder neuer)
- [GitHub Copilot CLI](https://docs.github.com/en/copilot/github-copilot-in-the-cli) installiert

## Installation

### Download

Gehe zu [Releases](https://github.com/lordmos/copilot-island/releases/latest) und lade die neueste `CopilotIsland.dmg` herunter.

### Aus dem Quellcode bauen

```bash
git clone https://github.com/lordmos/copilot-island.git
cd copilot-island/copilot-island-project
chmod +x scripts/setup.sh && ./scripts/setup.sh
open CopilotIsland.xcodeproj
```

Build-Anforderungen: Xcode 15+, macOS 14+, Homebrew (für XcodeGen).

## Wie es funktioniert

Copilot Island überwacht `~/.copilot/session-state/` über macOS `FSEvents`. Jedes Ereignis wird in Echtzeit aus den `events.jsonl`-Dateien gestreamt.

```
~/.copilot/
├── session-state/
│   └── {UUID}/
│       ├── workspace.yaml    ← Sitzungsmetadaten (cwd, Branch, etc.)
│       └── events.jsonl      ← Append-only Ereignisstrom ← von Copilot Island überwacht
```

Keine Python-Hooks. Keine CLI-Änderungen. Null Konfiguration.

## ⭐ Star-Verlauf

[![Star History Chart](https://api.star-history.com/svg?repos=lordmos/copilot-island&type=Date)](https://star-history.com/#lordmos/copilot-island&Date)

## Beiträge

Wir begrüßen Beiträge! Siehe [CONTRIBUTING.md](CONTRIBUTING.md) für Richtlinien.

## Lizenz

Apache License 2.0 — siehe [LICENSE](LICENSE) für Details.

---

<p align="center">
  Mit ❤️ von <a href="https://github.com/lordmos">lordmos</a> und KI-Teamkollegen gebaut
</p>
