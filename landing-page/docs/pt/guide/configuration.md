---
layout: doc
---

# Configuração

O Copilot Island requer configuração mínima e funciona imediatamente.

## Painel de Configurações

Acesse as configurações clicando no **ícone de menu ⋯** no painel expandido do notch e selecionando **Configurações**.

### Efeitos Sonoros

Ative ou desative o toque de conclusão e o som de falha:

- **Som de conclusão** — toca quando o agente conclui uma tarefa (`session.task_complete` → `assistant.turn_end`)
- **Som de falha** — toca em `abort`, `session.error`, ou `session.shutdown` inesperado

### Sobre e Atualizações

A aba **Sobre** nas Configurações exibe a versão atual do app e permite **Verificar Atualizações** (com suporte do Sparkle). O Copilot Island notificará você quando um novo release estiver disponível no GitHub.

## Monitoramento de Sessões

O Copilot Island monitora automaticamente `~/.copilot/session-state/` em busca de alterações.  
Nenhuma configuração é necessária — simplesmente funciona.

Na inicialização, apenas a **tarefa atual** (eventos a partir do último `user.message`) é carregada para manter a interface ágil. O histórico anterior não é reproduzido.

## Permissões do macOS

Na primeira inicialização, conceda esta permissão quando solicitada:

- **Arquivos e Pastas** → Permitir acesso para leitura dos arquivos de sessão do Copilot CLI no seu diretório home
