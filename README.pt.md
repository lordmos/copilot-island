# Copilot Island 🏝️

<p align="center">
  <img src="landing-page/docs/public/hero.svg" width="128" height="128" alt="Copilot Island Logo"/>
</p>

<p align="center">
  <strong>Leve o GitHub Copilot CLI para o notch do seu MacBook</strong><br/>
  Monitore sessões e navegue por conversas com IA — tudo no notch.
</p>

<p align="center">
  <a href="https://github.com/lordmos/copilot-island/releases/latest">
    <img src="https://img.shields.io/github/v/release/lordmos/copilot-island?style=flat-square&color=6CBB98" alt="Última versão"/>
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
  <strong>Português</strong> ·
  <a href="README.es.md">Español</a>
</p>

---

## O que é o Copilot Island?

O Copilot Island é um **aplicativo macOS gratuito e open source** que reside no notch do seu MacBook e exibe em tempo real tudo que o GitHub Copilot CLI está fazendo.

Inspirado pelo [ClaudeIsland](https://github.com/celestialglobe/claude-island), o Copilot Island traz a mesma UI elegante baseada em notch para os usuários do GitHub Copilot CLI.

### Funcionalidades

| Funcionalidade | Descrição |
|----------------|-----------|
| 🔔 **Sessões ao vivo** | Detecção automática de todas as sessões ativas do Copilot CLI |
| ⚡ **Feed de ferramentas** | Visualize cada chamada de ferramenta (read_file, run_command, etc.) em tempo real |
| 💬 **Histórico de chat** | Navegue pela conversa completa com renderização Markdown |
| 🎨 **Design verde-sálvia** | Paleta verde-sálvia suave, tema escuro, animações fluidas |
| 🔒 **Privado e seguro** | Sem análise, sem telemetria, funciona 100% no dispositivo |

## Requisitos

- **macOS 14.0+** (Sonoma ou posterior)
- MacBook Pro ou MacBook Air **com notch** (2021 ou posterior)
- [GitHub Copilot CLI](https://docs.github.com/en/copilot/github-copilot-in-the-cli) instalado

## Instalação

### Download

Acesse [Releases](https://github.com/lordmos/copilot-island/releases/latest) e baixe o último `CopilotIsland.dmg`.

### Compilar do código-fonte

```bash
git clone https://github.com/lordmos/copilot-island.git
cd copilot-island/copilot-island-project
chmod +x scripts/setup.sh && ./scripts/setup.sh
open CopilotIsland.xcodeproj
```

Requisitos de compilação: Xcode 15+, macOS 14+, Homebrew (para XcodeGen).

## Como funciona

O Copilot Island monitora `~/.copilot/session-state/` via macOS `FSEvents`. Cada evento é transmitido em tempo real dos arquivos `events.jsonl`.

```
~/.copilot/
├── session-state/
│   └── {UUID}/
│       ├── workspace.yaml    ← Metadados da sessão (diretório, branch, etc.)
│       └── events.jsonl      ← Fluxo de eventos append-only ← monitorado pelo Copilot Island
```

Sem hooks Python. Sem modificação do CLI. Zero configuração.

## ⭐ Histórico de estrelas

[![Star History Chart](https://api.star-history.com/svg?repos=lordmos/copilot-island&type=Date)](https://star-history.com/#lordmos/copilot-island&Date)

## Contribuição

Contribuições são bem-vindas! Consulte [CONTRIBUTING.md](CONTRIBUTING.md) para as diretrizes.

## Licença

Apache License 2.0 — veja [LICENSE](LICENSE) para detalhes.

---

<p align="center">
  Feito com ❤️ por <a href="https://github.com/lordmos">lordmos</a> e colegas de IA
</p>
