# Copilot Island 🏝️

<p align="center">
  <img src="landing-page/docs/public/hero.svg" width="128" height="128" alt="Copilot Island Logo"/>
</p>

<p align="center">
  <strong>Lleva GitHub Copilot CLI a la muesca de tu MacBook</strong><br/>
  Monitorea sesiones y navega por conversaciones con IA — todo desde la muesca.
</p>

<p align="center">
  <a href="https://github.com/lordmos/copilot-island/releases/latest">
    <img src="https://img.shields.io/github/v/release/lordmos/copilot-island?style=flat-square&color=6CBB98" alt="Última versión"/>
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
  <a href="README.de.md">Deutsch</a> ·
  <a href="README.pt.md">Português</a> ·
  <strong>Español</strong>
</p>

---

## ¿Qué es Copilot Island?

Copilot Island es una **aplicación macOS gratuita y de código abierto** que reside en la muesca de tu MacBook y muestra en tiempo real todo lo que está haciendo GitHub Copilot CLI.

Inspirado en [ClaudeIsland](https://github.com/celestialglobe/claude-island), Copilot Island lleva la misma interfaz elegante basada en muesca a los usuarios de GitHub Copilot CLI.

### Características

| Característica | Descripción |
|----------------|-------------|
| 🔔 **Sesiones en vivo** | Detección automática de todas las sesiones activas de Copilot CLI |
| ⚡ **Feed de herramientas** | Visualiza cada llamada a herramienta (read_file, run_command, etc.) en tiempo real |
| 💬 **Historial de chat** | Navega por la conversación completa con renderizado Markdown |
| 🎨 **Diseño verde salvia** | Paleta verde salvia suave, tema oscuro, animaciones fluidas |
| 🔒 **Privado y seguro** | Sin análisis, sin telemetría, funciona 100% en el dispositivo |

## Requisitos

- **macOS 14.0+** (Sonoma o posterior)
- MacBook Pro o MacBook Air **con muesca** (2021 o posterior)
- [GitHub Copilot CLI](https://docs.github.com/en/copilot/github-copilot-in-the-cli) instalado

## Instalación

### Descarga

Ve a [Releases](https://github.com/lordmos/copilot-island/releases/latest) y descarga el último `CopilotIsland.dmg`.

### Compilar desde el código fuente

```bash
git clone https://github.com/lordmos/copilot-island.git
cd copilot-island/copilot-island-project
chmod +x scripts/setup.sh && ./scripts/setup.sh
open CopilotIsland.xcodeproj
```

Requisitos de compilación: Xcode 15+, macOS 14+, Homebrew (para XcodeGen).

## Cómo funciona

Copilot Island monitorea `~/.copilot/session-state/` via macOS `FSEvents`. Cada evento se transmite en tiempo real desde los archivos `events.jsonl`.

```
~/.copilot/
├── session-state/
│   └── {UUID}/
│       ├── workspace.yaml    ← Metadatos de sesión (directorio, rama, etc.)
│       └── events.jsonl      ← Flujo de eventos append-only ← monitorado por Copilot Island
```

Sin hooks de Python. Sin modificación del CLI. Cero configuración.

## ⭐ Historial de estrellas

[![Star History Chart](https://api.star-history.com/svg?repos=lordmos/copilot-island&type=Date)](https://star-history.com/#lordmos/copilot-island&Date)

## Contribuciones

¡Las contribuciones son bienvenidas! Consulta [CONTRIBUTING.md](CONTRIBUTING.md) para las pautas.

## Licencia

Apache License 2.0 — ver [LICENSE](LICENSE) para más detalles.

---

<p align="center">
  Hecho con ❤️ por <a href="https://github.com/lordmos">lordmos</a> y compañeros de IA
</p>
