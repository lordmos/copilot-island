---
layout: doc
---

# Monitoreo de Sesiones

La funcionalidad principal de Copilot Island es el monitoreo en tiempo real de tus sesiones de GitHub Copilot CLI.

## Cómo se Detectan las Sesiones

Copilot Island observa `~/.copilot/session-state/` usando **FSEvents** de macOS — la misma API de notificaciones del sistema de archivos de baja latencia utilizada por Xcode y Spotlight. Cuando el Copilot CLI crea un nuevo directorio de sesión, Copilot Island lo detecta en milisegundos.

```
~/.copilot/session-state/
└── {UUID}/                    ← nuevo directorio activa la detección
    ├── workspace.yaml         ← metadatos de sesión
    └── events.jsonl           ← flujo de eventos (agregado en tiempo real)
```

Sin hooks, sin plugins, sin modificación del CLI.

## Tarjetas de Sesión

Cada sesión se muestra como una tarjeta en el panel de la muesca con:

| Campo | Descripción |
|-------|-------------|
| 🟢 Punto de estado | Verde = activa, Gris = finalizada |
| Ruta del proyecto | El `cwd` de `workspace.yaml` |
| Rama de Git | Rama actual (si está en un repositorio git) |
| Resumen de sesión | Resumen generado automáticamente por el Copilot CLI |
| Tiempo transcurrido | Tiempo desde que comenzó la sesión |

## Flujo de Eventos

Dentro de cada sesión, Copilot Island sigue `events.jsonl` y procesa estos tipos de eventos:

| Tipo de Evento | Qué significa |
|---------------|---------------|
| `session.start` | Ha comenzado una nueva sesión del Copilot CLI |
| `user.message` | Enviaste un mensaje a Copilot |
| `assistant.turn_start` | Copilot comenzó a pensar/responder |
| `assistant.message` | Copilot produjo una respuesta |
| `tool.execution_start` | Copilot está a punto de ejecutar una herramienta |
| `tool.execution_complete` | La herramienta finalizó (éxito o error) |
| `assistant.turn_end` | Copilot completó su turno de respuesta |
| `abort` | La sesión fue cancelada por el usuario |
| `session.shutdown` | El proceso del Copilot CLI terminó |

## Múltiples Sesiones

Copilot Island rastrea **todas las sesiones concurrentes**. Si tienes múltiples ventanas de terminal ejecutando `copilot`, cada sesión aparece como una tarjeta separada. Las sesiones se ordenan por la más recientemente activa.

## Retención de Sesiones

Las sesiones finalizadas permanecen visibles durante el lanzamiento actual de la app. Las sesiones no persisten entre reinicios de la app (para mantenerla ligera y respetar tu privacidad).

## Privacidad

Copilot Island lee los datos de sesión **localmente** desde tu Mac. Nada se sube ni se comparte. La función de chat con la API de GitHub Models es la única función de red y es completamente opcional.
