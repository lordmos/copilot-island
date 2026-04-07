---
layout: doc
---

# Changelog

Todas as alterações notáveis do Copilot Island estão documentadas aqui.

---

## v0.1.8 — 2026-04-07

### Funcionalidades
- **Atualização automática via Sparkle** — O Copilot Island agora verifica atualizações automaticamente usando o framework Sparkle. As atualizações são servidas com segurança via GitHub Pages.

### Correções
- Ajustes na exibição da versão do app e na largura do layout do menu
- Configuração do `SUFeedURL` do Sparkle para detecção confiável de atualizações

---

## v0.1.7 — 2026-04-06

Esta versão é uma revisão major da interface do notch, do sistema de eventos e dos efeitos sonoros.

### Funcionalidades
- **Máquina de estados do peek** — O ícone de prévia esquerdo anima com base no estado da sessão: respiração idle, pulso de trabalho, troféu 🏆 de 3 segundos ao concluir tarefa, falha ❌ de 3 segundos em cancelamento/erro/encerramento
- **Efeitos sonoros de 8 bits** — Toque ascendente ao concluir tarefa; onda quadrada descendente em falha. Os sons tocam apenas para eventos ao vivo (< 5 segundos na inicialização)
- **Sons de falha** — Som distinto para os eventos `abort`, `session.error` e `session.shutdown`
- **Mensagens do assistente concatenadas** — A saída do assistente dentro do mesmo turno é unida em um único bloco de mensagem legível em vez de muitos fragmentos
- **Filtro de inicialização** — Na inicialização, apenas a tarefa atual (a partir do último `user.message`) é carregada para evitar reproduzir o histórico completo da sessão
- **Verificar Atualizações** — O painel de Configurações agora inclui uma página "Sobre" com botão de verificação de versão com suporte do Sparkle
- **Redesign das Configurações** — Layout mais limpo, cores de toggle corrigidas, uso correto das cores do tema

### Correções
- **Painel alinhado ao topo da tela** — O painel expandido do notch agora começa rente à borda física da tela (sem espaço abaixo do notch)
- **Eliminado flickering na inicialização** — A lista de sessões não renderiza mais centenas de vezes na inicialização; o processamento em lote emite uma única atualização de estado
- **Sincronização do som corrigida** — O som de conclusão dispara em `assistant.turn_end` após `session.task_complete`, não prematuramente no evento de tarefa concluída
- **Atualizações do chat em tempo real** — A visão de detalhe da sessão agora busca novas mensagens a cada segundo
- **Dimensões dinâmicas do notch** — Largura e altura do painel são calculadas a partir das APIs de tela reais do macOS (`auxiliaryTopLeftArea` / `auxiliaryTopRightArea`)
- **Barra do notch unificada** — O estado fechado exibe uma única barra preta contínua cobrindo o ícone esquerdo, os pontos centrais e o contador de sessões direito
- **Auditoria de cores** — Corrigidas cores de texto placeholder ilegíveis, cores de acento de toggle inconsistentes e tons de azul fora da identidade visual nas configurações

---

## v0.1.6 — 2026-04-02

### Correções
- Assinar novamente os serviços XPC do Sparkle com certificado Developer ID para conformidade com notarização

---

## v0.1.5 — 2026-04-02

### Correções
- Buscar o log de rejeição do notarytool quando o status de notarização for `Invalid` para auxiliar na depuração

---

## v0.1.4 — 2026-04-02

### Correções
- Adicionar flag `--timestamp` ao `codesign` para conformidade com notarização

---

## v0.1.3 — 2026-04-02

### Correções
- Tornar o passo de notarização não fatal para que os releases do GitHub sejam publicados mesmo que a notarização retorne erro 401
- Adicionar diagnósticos de disponibilidade de segredos ao workflow de release
- Corrigir verificações condicionais no workflow de release para os passos de assinatura

---

## v0.1.2 — 2026-04-02

*(Tagueado junto com v0.1.3 — ver notas do v0.1.3)*

---

## v0.1.1 — 2026-04-01

### Funcionalidades
- Workflow de assinatura com Developer ID + notarização no GitHub Actions

### Correções
- `build_dmg.sh` usa o certificado Apple Development como fallback quando o Developer ID não está disponível
- O DMG agora é criado em um único passo `hdiutil` usando compressão UDZO

---

## v0.1.0 — 2026-03-31

🎉 **Lançamento inicial** do Copilot Island.

### Funcionalidades
- Janela sobreposta no notch que monitora `~/.copilot/session-state/` em tempo real
- Lista de sessões exibindo todas as sessões ativas e recentes do Copilot CLI
- Visão do histórico de chat com renderização Markdown, blocos de código e resultados de ferramentas
- Estado "pílula" recolhido com ícone de status esquerdo e contador de sessões direito
- Expandir/recolher ao clicar ou passar o cursor sobre o notch
- Tema escuro verde-sálvia inspirado no Copilot
- Forma de notch plana no topo rente à borda da tela, cantos inferiores arredondados
- Efeito sonoro ao concluir tarefa do agente
- macOS 14.0+ (Sonoma), suporte ao notch do MacBook
- Licença open source Apache 2.0
