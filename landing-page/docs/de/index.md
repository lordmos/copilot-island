---
layout: home

hero:
  name: "Copilot Island"
  text: "Deine MacBook-Notch, angetrieben von GitHub Copilot"
  tagline: Überwache Copilot CLI-Sitzungen und sieh dir KI-Gespräche an – direkt aus der Notch.
  image:
    src: /hero.svg
    alt: Copilot Island
  actions:
    - theme: brand
      text: Für Mac herunterladen
      link: https://github.com/lordmos/copilot-island/releases/latest
    - theme: alt
      text: Auf GitHub ansehen
      link: https://github.com/lordmos/copilot-island
    - theme: alt
      text: Schnellstart →
      link: /guide/quick-start

features:
  - icon: 🔔
    title: Live-Sitzungsüberwachung
    details: Beobachte jede Copilot CLI-Sitzung in Echtzeit direkt aus der MacBook-Notch. Verpasse nie, was die KI gerade macht.

  - icon: ⚡
    title: Werkzeug-Aktivitätsfeed
    details: Sieh genau, welche Werkzeuge Copilot ausführt — Dateischreibungen, Shell-Befehle, Websuchen — mit Argumenten, alles in der Notch.

  - icon: 💬
    title: Vollständiger Gesprächsverlauf
    details: Durchsuche das gesamte Gespräch mit schönem Markdown-Rendering. Code-Blöcke und Werkzeug-Ergebnisse inklusive.

  - icon: 🎨
    title: Copilot-inspiriertes Design
    details: Mit Githubs Designsprache gestaltet. Gedämpfte Salbei-Grün-Palette, dunkles Thema, fließende Animationen, die sich nativ auf macOS anfühlen.

  - icon: 🔓
    title: Vollständig Open Source
    details: Apache 2.0 Lizenz. Code einsehen, Features beitragen, Bugs melden. Mit ❤️ von der Community gebaut.
---

## So funktioniert es

```bash
# 1. Copilot Island installieren (aus den Releases herunterladen)
# 2. Copilot CLI-Sitzung wie gewohnt starten
copilot "Unit-Tests für das Authentifizierungsmodul hinzufügen"

# 3. Copilot Island erkennt die Sitzung automatisch
#    und zeigt sie in der MacBook-Notch an — keine Konfiguration nötig!
```

> Copilot Island überwacht `~/.copilot/session-state/` und streamt Ereignisse in Echtzeit aus dem nativen JSONL-Ereignisprotokoll von Copilot CLI. Null Konfiguration erforderlich.

## Voraussetzungen

- macOS 14.0+ (Sonoma oder neuer)
- MacBook Pro oder MacBook Air **mit Notch** (2021 oder neuer)
- GitHub Copilot CLI installiert und authentifiziert
