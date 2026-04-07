---
layout: doc
---

# Instalación

## Requisitos

- **macOS 14.0+** (Sonoma o posterior)
- MacBook Pro o MacBook Air **con muesca** (2021 o posterior)
- [GitHub Copilot CLI](https://docs.github.com/en/copilot/github-copilot-in-the-cli) instalado y autenticado

## Opción 1: Descargar la Versión (Recomendado)

1. Ve a la [página de Releases](https://github.com/lordmos/copilot-island/releases/latest)
2. Descarga `CopilotIsland.dmg`
3. Abre el DMG y arrastra Copilot Island a tu carpeta de Aplicaciones
4. Inicia Copilot Island desde Aplicaciones (o Spotlight)
5. La aplicación aparecerá en la muesca de tu MacBook

## Opción 2: Compilar desde el Código Fuente

```bash
# Clonar el repositorio
git clone https://github.com/lordmos/copilot-island.git
cd copilot-island

# Ejecutar setup (instala XcodeGen, genera el proyecto de Xcode)
chmod +x scripts/setup.sh && ./scripts/setup.sh

# Abrir en Xcode
open CopilotIsland.xcodeproj
```

Luego presiona **⌘R** para compilar y ejecutar.

## Primer Inicio

Al iniciar por primera vez, Copilot Island:
1. Solicitará permiso para acceder a archivos en tu directorio de inicio
2. Comenzará a monitorear `~/.copilot/session-state/` automáticamente
3. Mostrará una pastilla colapsada en la muesca de tu MacBook

¡No se necesita configuración adicional — simplemente comienza a usar `copilot` en tu terminal!
