---
layout: doc
---

# Konfiguration

Copilot Island erfordert minimale Konfiguration und funktioniert sofort einsatzbereit.

## Einstellungen-Panel

Öffnen Sie die Einstellungen, indem Sie auf das **⋯ Menüsymbol** im erweiterten Notch-Panel klicken und dann **Einstellungen** auswählen.

### Soundeffekte

Aktivieren oder deaktivieren Sie den Abschluss-Chime und den Fehlerton:

- **Abschlussklang** — wird abgespielt, wenn der Agent eine Aufgabe abschließt (`session.task_complete` → `assistant.turn_end`)
- **Fehlerton** — wird bei `abort`, `session.error` oder unerwartetem `session.shutdown` abgespielt

### Info & Updates

Der Tab **Info** in den Einstellungen zeigt die aktuelle App-Version und ermöglicht es, **Nach Updates zu suchen** (unterstützt durch Sparkle). Copilot Island benachrichtigt Sie, wenn eine neue Version auf GitHub verfügbar ist.

## Sitzungsüberwachung

Copilot Island überwacht `~/.copilot/session-state/` automatisch auf Änderungen.  
Keine Konfiguration erforderlich — es funktioniert einfach.

Beim Start wird nur die **aktuelle Aufgabe** (Ereignisse ab der letzten `user.message`) geladen, um die Benutzeroberfläche schnell zu halten. Älterer Verlauf wird nicht erneut abgespielt.

## macOS-Berechtigungen

Beim ersten Start erteilen Sie diese Berechtigung, wenn Sie dazu aufgefordert werden:

- **Dateien und Ordner** → Zugriff zum Lesen der Copilot CLI-Sitzungsdateien in Ihrem Home-Verzeichnis gewähren
