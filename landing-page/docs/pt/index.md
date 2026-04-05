---
layout: home

hero:
  name: "Copilot Island"
  text: "Seu MacBook Notch, potencializado pelo GitHub Copilot"
  tagline: Monitore sessões do Copilot CLI e navegue pelas conversas com IA — tudo no notch.
  image:
    src: /hero.svg
    alt: Copilot Island
  actions:
    - theme: brand
      text: Baixar para Mac
      link: https://github.com/lordmos/copilot-island/releases/latest
    - theme: alt
      text: Ver no GitHub
      link: https://github.com/lordmos/copilot-island
    - theme: alt
      text: Início rápido →
      link: /guide/quick-start

features:
  - icon: 🔔
    title: Monitoramento de sessões ao vivo
    details: Observe cada sessão do Copilot CLI em tempo real diretamente do notch do seu MacBook. Nunca perca o que a IA está fazendo.

  - icon: ⚡
    title: Feed de atividade de ferramentas
    details: Veja exatamente quais ferramentas o Copilot está executando — escritas de arquivos, comandos shell, pesquisas web — com argumentos, tudo no notch.

  - icon: 💬
    title: Histórico completo de chat
    details: Percorra toda a conversa com bela renderização Markdown. Blocos de código e resultados de ferramentas incluídos.

  - icon: 🎨
    title: Design inspirado no Copilot
    details: Criado com a linguagem de design do GitHub. Paleta verde-sálvia suave, tema escuro e animações fluidas nativas no macOS.

  - icon: 🔓
    title: Totalmente open source
    details: Licença Apache 2.0. Inspecione o código, contribua com recursos, reporte bugs. Construído com ❤️ pela comunidade.
---

## Como funciona

```bash
# 1. Instale o Copilot Island (baixe dos Releases)
# 2. Execute sua sessão do Copilot CLI normalmente
copilot "Adicionar testes unitários para o módulo de autenticação"

# 3. O Copilot Island detecta automaticamente a sessão
#    e a exibe no notch do seu MacBook — sem configuração!
```

> O Copilot Island monitora `~/.copilot/session-state/` e transmite eventos em tempo real do log JSONL nativo do Copilot CLI. Zero configuração necessária.

## Requisitos

- macOS 14.0+ (Sonoma ou posterior)
- MacBook Pro ou MacBook Air **com notch** (2021 ou posterior)
- GitHub Copilot CLI instalado e autenticado
