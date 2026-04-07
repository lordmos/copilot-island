---
layout: doc
---

# Sitzungsüberwachung

Die Kernfunktion von Copilot Island ist die Echtzeit-Überwachung Ihrer GitHub Copilot CLI-Sitzungen.

## Wie Sitzungen erkannt werden

Copilot Island überwacht `~/.copilot/session-state/` mithilfe von macOS **FSEvents** — derselben latenzarmen Dateisystem-Benachrichtigungs-API, die von Xcode und Spotlight verwendet wird. Wenn das Copilot CLI ein neues Sitzungsverzeichnis erstellt, erkennt Copilot Island dies innerhalb von Millisekunden.

```
~/.copilot/session-state/
└── {UUID}/                    ← neues Verzeichnis löst Erkennung aus
    ├── workspace.yaml         ← Sitzungsmetadaten
    └── events.jsonl           ← Ereignisstrom (wird in Echtzeit ergänzt)
```

Keine Hooks, keine Plugins, keine CLI-Modifikation erforderlich.

## Sitzungskarten

Jede Sitzung wird als Karte im Notch-Panel angezeigt und zeigt:

| Feld | Beschreibung |
|------|-------------|
| 🟢 Statuspunkt | Grün = aktiv, Grau = beendet |
| Projektpfad | Das `cwd` aus `workspace.yaml` |
| Git-Branch | Aktueller Branch (falls in einem Git-Repository) |
| Sitzungszusammenfassung | Automatisch generierte Zusammenfassung vom Copilot CLI |
| Verstrichene Zeit | Zeit seit Sitzungsbeginn |

## Ereignisstrom

Innerhalb jeder Sitzung verfolgt Copilot Island `events.jsonl` und verarbeitet diese Ereignistypen:

| Ereignistyp | Bedeutung |
|------------|-----------|
| `session.start` | Eine neue Copilot CLI-Sitzung hat begonnen |
| `user.message` | Sie haben eine Nachricht an Copilot gesendet |
| `assistant.turn_start` | Copilot hat begonnen zu denken/zu antworten |
| `assistant.message` | Copilot hat eine Antwort produziert |
| `tool.execution_start` | Copilot steht kurz vor der Ausführung eines Werkzeugs |
| `tool.execution_complete` | Werkzeug abgeschlossen (Erfolg oder Fehler) |
| `assistant.turn_end` | Copilot hat seinen Antwort-Durchgang abgeschlossen |
| `abort` | Die Sitzung wurde vom Benutzer abgebrochen |
| `session.shutdown` | Der Copilot CLI-Prozess wurde beendet |

## Mehrere Sitzungen

Copilot Island verfolgt **alle gleichzeitigen Sitzungen**. Wenn Sie mehrere Terminal-Fenster haben, in denen `copilot` läuft, erscheint jede Sitzung als separate Karte. Sitzungen werden nach der zuletzt aktiven sortiert.

## Sitzungsaufbewahrung

Beendete Sitzungen bleiben für den aktuellen App-Start sichtbar. Sitzungen werden nicht über App-Neustarts hinweg gespeichert (um die App leichtgewichtig zu halten und Ihre Privatsphäre zu respektieren).

## Datenschutz

Copilot Island liest Sitzungsdaten **lokal** von Ihrem Mac. Es wird nichts hochgeladen oder geteilt. Die Chat-Funktion über die GitHub Models API ist die einzige Netzwerkfunktion und vollständig optional.
