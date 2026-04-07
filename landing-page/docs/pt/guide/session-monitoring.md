---
layout: doc
---

# Monitoramento de Sessões

O recurso principal do Copilot Island é o monitoramento em tempo real das suas sessões do GitHub Copilot CLI.

## Como as Sessões São Detectadas

O Copilot Island monitora `~/.copilot/session-state/` usando **FSEvents** do macOS — a mesma API de notificação do sistema de arquivos de baixa latência usada pelo Xcode e pelo Spotlight. Quando o Copilot CLI cria um novo diretório de sessão, o Copilot Island o detecta em milissegundos.

```
~/.copilot/session-state/
└── {UUID}/                    ← novo diretório aciona a detecção
    ├── workspace.yaml         ← metadados da sessão
    └── events.jsonl           ← fluxo de eventos (adicionado em tempo real)
```

Sem hooks, sem plugins, sem modificação do CLI.

## Cards de Sessão

Cada sessão é exibida como um card no painel do notch mostrando:

| Campo | Descrição |
|-------|-----------|
| 🟢 Ponto de status | Verde = ativa, Cinza = encerrada |
| Caminho do projeto | O `cwd` de `workspace.yaml` |
| Branch do Git | Branch atual (se estiver em um repositório git) |
| Resumo da sessão | Resumo gerado automaticamente pelo Copilot CLI |
| Tempo decorrido | Tempo desde o início da sessão |

## Fluxo de Eventos

Dentro de cada sessão, o Copilot Island acompanha o `events.jsonl` e processa estes tipos de evento:

| Tipo de Evento | O que significa |
|---------------|-----------------|
| `session.start` | Uma nova sessão do Copilot CLI foi iniciada |
| `user.message` | Você enviou uma mensagem ao Copilot |
| `assistant.turn_start` | O Copilot começou a pensar/responder |
| `assistant.message` | O Copilot produziu uma resposta |
| `tool.execution_start` | O Copilot está prestes a executar uma ferramenta |
| `tool.execution_complete` | A ferramenta foi concluída (sucesso ou erro) |
| `assistant.turn_end` | O Copilot concluiu seu turno de resposta |
| `abort` | A sessão foi cancelada pelo usuário |
| `session.shutdown` | O processo do Copilot CLI foi encerrado |

## Múltiplas Sessões

O Copilot Island rastreia **todas as sessões simultâneas**. Se você tiver múltiplas janelas de terminal executando `copilot`, cada sessão aparece como um card separado. As sessões são ordenadas pela mais recentemente ativa.

## Retenção de Sessões

As sessões encerradas permanecem visíveis durante o lançamento atual do app. As sessões não são persistidas entre reinicializações do app (para manter o app leve e respeitar sua privacidade).

## Privacidade

O Copilot Island lê os dados de sessão **localmente** do seu Mac. Nada é enviado ou compartilhado. O recurso de chat com a API do GitHub Models é o único recurso de rede e é totalmente opcional.
