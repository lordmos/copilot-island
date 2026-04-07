---
layout: doc
---

# Configuración

Copilot Island requiere una configuración mínima y funciona de inmediato.

## Panel de Ajustes

Accede a los ajustes haciendo clic en el **ícono de menú ⋯** en el panel expandido de la muesca y luego seleccionando **Ajustes**.

### Efectos de Sonido

Activa o desactiva el tono de finalización y el sonido de fallo:

- **Sonido de finalización** — suena cuando el agente completa una tarea (`session.task_complete` → `assistant.turn_end`)
- **Sonido de fallo** — suena en `abort`, `session.error`, o `session.shutdown` inesperado

### Acerca de y Actualizaciones

La pestaña **Acerca de** en Ajustes muestra la versión actual de la app y te permite **Buscar Actualizaciones** (impulsado por Sparkle). Copilot Island te notificará cuando haya una nueva versión disponible en GitHub.

## Monitoreo de Sesiones

Copilot Island monitorea automáticamente `~/.copilot/session-state/` en busca de cambios.  
No se necesita configuración — simplemente funciona.

Al inicio, solo se carga la **tarea actual** (eventos desde el último `user.message` en adelante) para mantener la interfaz ágil. El historial anterior no se reproduce.

## Permisos de macOS

Al iniciar por primera vez, concede este permiso cuando se solicite:

- **Archivos y Carpetas** → Permite el acceso para leer los archivos de sesión del Copilot CLI en tu directorio de inicio
