---
layout: home

hero:
  name: "Copilot Island"
  text: "Tu muesca MacBook, impulsada por GitHub Copilot"
  tagline: Monitorea sesiones de Copilot CLI y navega conversaciones con IA — todo desde la muesca.
  image:
    src: /hero.svg
    alt: Copilot Island
  actions:
    - theme: brand
      text: Descargar para Mac
      link: https://github.com/lordmos/copilot-island/releases/latest
    - theme: alt
      text: Ver en GitHub
      link: https://github.com/lordmos/copilot-island
    - theme: alt
      text: Inicio rápido →
      link: /guide/quick-start

features:
  - icon: 🔔
    title: Monitoreo de sesiones en vivo
    details: Observa cada sesión de Copilot CLI en tiempo real directamente desde la muesca de tu MacBook. Nunca pierdas lo que está haciendo la IA.

  - icon: ⚡
    title: Feed de actividad de herramientas
    details: Ve exactamente qué herramientas está ejecutando Copilot — escrituras de archivos, comandos shell, búsquedas web — con argumentos, todo en la muesca.

  - icon: 💬
    title: Historial completo de chat
    details: Navega toda la conversación con hermoso renderizado Markdown. Bloques de código y resultados de herramientas incluidos.

  - icon: 🎨
    title: Diseño inspirado en Copilot
    details: Diseñado con el lenguaje de diseño de GitHub. Paleta verde salvia suave, tema oscuro y animaciones fluidas nativas en macOS.

  - icon: 🔓
    title: Completamente de código abierto
    details: Licencia Apache 2.0. Inspecciona el código, contribuye funciones, reporta errores. Construido con ❤️ por la comunidad.
---

## Cómo funciona

```bash
# 1. Instala Copilot Island (descarga desde Releases)
# 2. Ejecuta tu sesión de Copilot CLI normalmente
copilot "Agregar pruebas unitarias para el módulo de autenticación"

# 3. Copilot Island detecta automáticamente la sesión
#    y la muestra en la muesca de tu MacBook — ¡sin configuración!
```

> Copilot Island monitorea `~/.copilot/session-state/` y transmite eventos en tiempo real desde el registro JSONL nativo de Copilot CLI. Cero configuración requerida.

## Requisitos

- macOS 14.0+ (Sonoma o posterior)
- MacBook Pro o MacBook Air **con muesca** (2021 o posterior)
- GitHub Copilot CLI instalado y autenticado
