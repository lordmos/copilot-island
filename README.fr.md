# Copilot Island 🏝️

<p align="center">
  <img src="landing-page/docs/public/hero.svg" width="128" height="128" alt="Copilot Island Logo"/>
</p>

<p align="center">
  <strong>Apportez GitHub Copilot CLI à l'encoche de votre MacBook</strong><br/>
  Surveillez les sessions et parcourez les conversations IA — directement depuis l'encoche.
</p>

<p align="center">
  <a href="https://github.com/lordmos/copilot-island/releases/latest">
    <img src="https://img.shields.io/github/v/release/lordmos/copilot-island?style=flat-square&color=6CBB98" alt="Dernière version"/>
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
  <strong>Français</strong> ·
  <a href="README.de.md">Deutsch</a> ·
  <a href="README.pt.md">Português</a> ·
  <a href="README.es.md">Español</a>
</p>

---

## Qu'est-ce que Copilot Island ?

Copilot Island est une **application macOS gratuite et open source** qui réside dans l'encoche de votre MacBook et affiche en temps réel tout ce que fait GitHub Copilot CLI.

Inspiré par [ClaudeIsland](https://github.com/celestialglobe/claude-island), Copilot Island apporte la même interface élégante basée sur l'encoche aux utilisateurs de GitHub Copilot CLI.

### Fonctionnalités

| Fonctionnalité | Description |
|----------------|-------------|
| 🔔 **Sessions en direct** | Détection automatique de toutes les sessions Copilot CLI actives |
| ⚡ **Fil d'outils** | Visualisez chaque appel d'outil (read_file, run_command, etc.) en temps réel |
| 💬 **Historique des conversations** | Parcourez la conversation complète avec rendu Markdown |
| 🎨 **Design vert sauge** | Palette vert sauge apaisante, thème sombre, animations fluides |
| 🔒 **Privé et sécurisé** | Pas d'analyse, pas de télémétrie, fonctionne 100% en local |

## Configuration requise

- **macOS 14.0+** (Sonoma ou version ultérieure)
- MacBook Pro ou MacBook Air **avec encoche** (2021 ou version ultérieure)
- [GitHub Copilot CLI](https://docs.github.com/en/copilot/github-copilot-in-the-cli) installé

## Installation

### Téléchargement

Rendez-vous sur [Releases](https://github.com/lordmos/copilot-island/releases/latest) et téléchargez le dernier `CopilotIsland.dmg`.

### Compiler depuis les sources

```bash
git clone https://github.com/lordmos/copilot-island.git
cd copilot-island/copilot-island-project
chmod +x scripts/setup.sh && ./scripts/setup.sh
open CopilotIsland.xcodeproj
```

Prérequis : Xcode 15+, macOS 14+, Homebrew (pour XcodeGen).

## Comment ça fonctionne

Copilot Island surveille `~/.copilot/session-state/` (le répertoire de sessions natif de Copilot CLI) via macOS `FSEvents`. Chaque événement est diffusé en temps réel depuis les fichiers `events.jsonl`.

```
~/.copilot/
├── session-state/
│   └── {UUID}/
│       ├── workspace.yaml    ← Métadonnées de session (cwd, branche, etc.)
│       └── events.jsonl      ← Flux d'événements append-only ← surveillé par Copilot Island
```

Pas de hooks Python. Pas de modification du CLI. Aucune configuration.

## ⭐ Historique des étoiles

[![Star History Chart](https://api.star-history.com/svg?repos=lordmos/copilot-island&type=Date)](https://star-history.com/#lordmos/copilot-island&Date)

## Contribution

Les contributions sont les bienvenues ! Consultez [CONTRIBUTING.md](CONTRIBUTING.md) pour les directives.

## Licence

Apache License 2.0 — voir [LICENSE](LICENSE) pour les détails.

---

<p align="center">
  Créé avec ❤️ par <a href="https://github.com/lordmos">lordmos</a> et ses coéquipiers IA
</p>
