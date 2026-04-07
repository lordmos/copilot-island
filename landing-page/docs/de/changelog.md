---
layout: doc
---

# Änderungsprotokoll

Alle wesentlichen Änderungen an Copilot Island sind hier dokumentiert.

---

## v0.1.8 — 2026-04-07

### Funktionen
- **Automatische Updates über Sparkle** — Copilot Island sucht jetzt automatisch nach Updates mithilfe des Sparkle-Frameworks. Updates werden sicher über GitHub Pages bereitgestellt.

### Fehlerbehebungen
- Anpassungen der App-Versionsanzeige und der Menü-Layout-Breite
- Sparkle `SUFeedURL`-Konfiguration für zuverlässige Update-Erkennung

---

## v0.1.7 — 2026-04-06

Dieses Release ist eine umfassende Überarbeitung der Notch-Benutzeroberfläche, des Ereignissystems und der Soundeffekte.

### Funktionen
- **Vorschau-Zustandsmaschine** — Das linke Vorschau-Symbol animiert basierend auf dem Sitzungszustand: ruhiges Atmen im Leerlauf, arbeitender Puls, 3-sekündige Trophäe 🏆 bei Aufgabe abgeschlossen, 3-sekündiger Fehler ❌ bei Abbruch/Fehler/Herunterfahren
- **8-Bit-Soundeffekte** — Aufsteigender Chime bei Aufgabenabschluss; absteigende Rechteckwelle bei Fehler. Sounds werden nur für Live-Ereignisse abgespielt (< 5 Sekunden beim Start)
- **Fehlertöne** — Eigener Sound für `abort`-, `session.error`- und `session.shutdown`-Ereignisse
- **Verkettete Assistentennachrichten** — Assistentenausgabe innerhalb desselben Durchgangs wird zu einem lesbaren Nachrichtenblock zusammengefasst statt vieler Fragmente
- **Startfilter** — Beim Start wird nur die aktuelle Aufgabe (ab der letzten `user.message`) geladen, um das erneute Abspielen des vollständigen Sitzungsverlaufs zu vermeiden
- **Nach Updates suchen** — Das Einstellungs-Panel enthält jetzt eine „Info"-Seite mit einer Versions-Prüfschaltfläche, unterstützt durch Sparkle
- **Einstellungen neu gestaltet** — Übersichtlicheres Layout, korrigierte Umschalterfarben, korrekte Verwendung der Themenfarben durchgehend

### Fehlerbehebungen
- **Panel am oberen Bildschirmrand ausgerichtet** — Das erweiterte Notch-Panel beginnt jetzt bündig mit dem physischen Bildschirmrand (kein Abstand unterhalb des Notch)
- **Startflimmern beseitigt** — Die Sitzungsliste wird beim Start nicht mehr hunderte Male neu gerendert; die Stapelverarbeitung gibt ein einzelnes Statusupdate aus
- **Soundzeitpunkt korrigiert** — Der Abschlussklang wird bei `assistant.turn_end` nach `session.task_complete` ausgelöst, nicht vorzeitig beim Aufgabe-abgeschlossen-Ereignis selbst
- **Echtzeit-Chat-Updates** — Die Sitzungsdetailansicht fragt jetzt jede Sekunde nach neuen Nachrichten
- **Dynamische Notch-Dimensionen** — Panel-Breite und -Höhe werden aus den tatsächlichen macOS-Bildschirm-APIs berechnet (`auxiliaryTopLeftArea` / `auxiliaryTopRightArea`)
- **Einheitliche Notch-Leiste** — Der geschlossene Zustand zeigt eine nahtlose schwarze Leiste, die das linke Symbol, mittlere Punkte und die rechte Sitzungsanzahl abdeckt
- **Farbprüfung** — Unleserliche Platzhaltertextfarben, inkonsistente Umschalter-Akzentfarben und markenfremde blaue Töne in den Einstellungen behoben

---

## v0.1.6 — 2026-04-02

### Fehlerbehebungen
- Sparkle XPC-Dienste mit Developer ID-Zertifikat für die Notarisierungskonformität neu signieren

---

## v0.1.5 — 2026-04-02

### Fehlerbehebungen
- Notarytool-Ablehnungsprotokoll abrufen, wenn der Notarisierungsstatus `Invalid` ist, um das Debugging zu erleichtern

---

## v0.1.4 — 2026-04-02

### Fehlerbehebungen
- `--timestamp`-Flag zu `codesign` für die Notarisierungskonformität hinzufügen

---

## v0.1.3 — 2026-04-02

### Fehlerbehebungen
- Notarisierungsschritt nicht-fatal machen, damit GitHub-Releases veröffentlicht werden, auch wenn die Notarisierung einen 401-Fehler zurückgibt
- Diagnosefunktion für die Verfügbarkeit von Secrets zum Release-Workflow hinzufügen
- Bedingte Prüfungen im Release-Workflow für Signing-Schritte korrigieren

---

## v0.1.2 — 2026-04-02

*(Zusammen mit v0.1.3 getaggt — siehe Hinweise zu v0.1.3)*

---

## v0.1.1 — 2026-04-01

### Funktionen
- Developer ID-Signierung + Notarisierungs-Workflow in GitHub Actions

### Fehlerbehebungen
- `build_dmg.sh` fällt auf Apple Development-Zertifikat zurück, wenn Developer ID nicht verfügbar ist
- DMG wird jetzt in einem einzigen `hdiutil`-Schritt mit UDZO-Komprimierung erstellt

---

## v0.1.0 — 2026-03-31

🎉 **Erstveröffentlichung** von Copilot Island.

### Funktionen
- Notch-Overlay-Fenster, das `~/.copilot/session-state/` in Echtzeit überwacht
- Sitzungsliste mit allen aktiven und aktuellen Copilot CLI-Sitzungen
- Chat-Verlaufsansicht mit Markdown-Darstellung, Code-Blöcken und Werkzeugergebnissen
- Eingeklappter „Pillen"-Zustand mit linkem Status-Symbol und rechter Sitzungsanzahl
- Aufklappen/Einklappen per Notch-Klick oder Hover
- Copilot-inspiriertes dunkles Salbeigrün-Thema
- Flache Notch-Form bündig mit dem Bildschirmrand, abgerundete untere Ecken
- Soundeffekt bei abgeschlossener Agenten-Aufgabe
- macOS 14.0+ (Sonoma), MacBook Notch-Unterstützung
- Apache 2.0 Open-Source-Lizenz
