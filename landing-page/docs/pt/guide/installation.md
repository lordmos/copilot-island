---
layout: doc
---

# Instalação

## Requisitos

- **macOS 14.0+** (Sonoma ou posterior)
- MacBook Pro ou MacBook Air **com notch** (2021 ou posterior)
- [GitHub Copilot CLI](https://docs.github.com/en/copilot/github-copilot-in-the-cli) instalado e autenticado

## Opção 1: Baixar o Release (Recomendado)

1. Acesse a [página de Releases](https://github.com/lordmos/copilot-island/releases/latest)
2. Baixe o `CopilotIsland.dmg`
3. Abra o DMG e arraste o Copilot Island para sua pasta Aplicativos
4. Inicie o Copilot Island a partir dos Aplicativos (ou pelo Spotlight)
5. O app aparecerá no notch do seu MacBook

## Opção 2: Compilar a partir do Código-Fonte

```bash
# Clonar o repositório
git clone https://github.com/lordmos/copilot-island.git
cd copilot-island

# Executar o setup (instala o XcodeGen, gera o projeto Xcode)
chmod +x scripts/setup.sh && ./scripts/setup.sh

# Abrir no Xcode
open CopilotIsland.xcodeproj
```

Depois pressione **⌘R** para compilar e executar.

## Primeiro Acesso

Na primeira inicialização, o Copilot Island irá:
1. Solicitar permissão para acessar arquivos no seu diretório home
2. Iniciar o monitoramento de `~/.copilot/session-state/` automaticamente
3. Exibir uma pílula recolhida no notch do seu MacBook

Nenhuma configuração adicional é necessária — basta começar a usar o `copilot` no seu terminal!
