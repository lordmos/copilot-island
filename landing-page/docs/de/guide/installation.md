---
layout: doc
---

# Installation

## Voraussetzungen

- **macOS 14.0+** (Sonoma oder neuer)
- MacBook Pro oder MacBook Air **mit Notch** (2021 oder neuer)
- [GitHub Copilot CLI](https://docs.github.com/de/copilot/github-copilot-in-the-cli) installiert und authentifiziert

## Option 1: Release herunterladen (empfohlen)

1. Gehen Sie zur [Releases-Seite](https://github.com/lordmos/copilot-island/releases/latest)
2. Laden Sie `CopilotIsland.dmg` herunter
3. Öffnen Sie das DMG und ziehen Sie Copilot Island in Ihren Ordner „Programme"
4. Starten Sie Copilot Island aus dem Ordner „Programme" (oder über Spotlight)
5. Die App erscheint im Notch Ihres MacBook

## Option 2: Aus dem Quellcode erstellen

```bash
# Repository klonen
git clone https://github.com/lordmos/copilot-island.git
cd copilot-island

# Setup ausführen (installiert XcodeGen, generiert das Xcode-Projekt)
chmod +x scripts/setup.sh && ./scripts/setup.sh

# In Xcode öffnen
open CopilotIsland.xcodeproj
```

Drücken Sie dann **⌘R**, um das Projekt zu erstellen und auszuführen.

## Erster Start

Beim ersten Start wird Copilot Island:
1. Die Berechtigung anfordern, auf Dateien in Ihrem Home-Verzeichnis zuzugreifen
2. `~/.copilot/session-state/` automatisch zu überwachen beginnen
3. Eine eingeklappte Pille im Notch Ihres MacBook anzeigen

Es ist keine weitere Konfiguration erforderlich — verwenden Sie einfach `copilot` in Ihrem Terminal!
