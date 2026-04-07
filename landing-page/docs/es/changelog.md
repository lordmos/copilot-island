---
layout: doc
---

# Registro de Cambios

Todos los cambios notables de Copilot Island están documentados aquí.

---

## v0.1.8 — 2026-04-07

### Funcionalidades
- **Actualización automática con Sparkle** — Copilot Island ahora busca actualizaciones automáticamente usando el framework Sparkle. Las actualizaciones se sirven de forma segura a través de GitHub Pages.

### Correcciones
- Ajustes en la visualización de la versión de la app y el ancho del diseño del menú
- Configuración de `SUFeedURL` de Sparkle para una detección de actualizaciones fiable

---

## v0.1.7 — 2026-04-06

Esta versión es una revisión mayor de la interfaz de la muesca, el sistema de eventos y los efectos de sonido.

### Funcionalidades
- **Máquina de estados del peek** — El ícono de vista previa izquierdo se anima según el estado de la sesión: respiración inactiva, pulso de trabajo, trofeo 🏆 de 3 segundos al completar la tarea, fallo ❌ de 3 segundos en cancelación/error/cierre
- **Efectos de sonido de 8 bits** — Tono ascendente al completar la tarea; onda cuadrada descendente al fallar. Los sonidos solo suenan para eventos en vivo (< 5 segundos al inicio)
- **Sonidos de fallo** — Sonido distintivo para los eventos `abort`, `session.error` y `session.shutdown`
- **Mensajes del asistente concatenados** — La salida del asistente dentro del mismo turno se une en un solo bloque de mensaje legible en lugar de muchos fragmentos
- **Filtro de inicio** — Al iniciar, solo se carga la tarea actual (desde el último `user.message` en adelante) para evitar reproducir el historial completo de la sesión
- **Buscar Actualizaciones** — El panel de Ajustes ahora incluye una página "Acerca de" con un botón de verificación de versión impulsado por Sparkle
- **Rediseño de Ajustes** — Diseño más limpio, colores de interruptores corregidos, uso correcto de colores del tema

### Correcciones
- **Panel alineado al borde superior de la pantalla** — El panel expandido de la muesca ahora comienza al ras del borde físico de la pantalla (sin espacio debajo de la muesca)
- **Eliminado el parpadeo al inicio** — La lista de sesiones ya no se vuelve a renderizar cientos de veces al iniciar; el procesamiento por lotes emite una sola actualización de estado
- **Sincronización del sonido corregida** — El sonido de finalización se activa en `assistant.turn_end` después de `session.task_complete`, no prematuramente en el evento de tarea completada
- **Actualizaciones del chat en tiempo real** — La vista de detalle de sesión ahora sondea nuevos mensajes cada segundo
- **Dimensiones dinámicas de la muesca** — El ancho y la altura del panel se calculan desde las APIs de pantalla reales de macOS (`auxiliaryTopLeftArea` / `auxiliaryTopRightArea`)
- **Barra de muesca unificada** — El estado cerrado muestra una única barra negra continua que cubre el ícono izquierdo, los puntos centrales y el contador de sesiones derecho
- **Auditoría de colores** — Corregidos colores de texto de marcador de posición ilegibles, colores de acento de interruptor inconsistentes y tonos azules fuera de marca en los ajustes

---

## v0.1.6 — 2026-04-02

### Correcciones
- Volver a firmar los servicios XPC de Sparkle con el certificado Developer ID para cumplimiento de notarización

---

## v0.1.5 — 2026-04-02

### Correcciones
- Obtener el registro de rechazo de notarytool cuando el estado de notarización es `Invalid` para facilitar la depuración

---

## v0.1.4 — 2026-04-02

### Correcciones
- Agregar la bandera `--timestamp` a `codesign` para cumplimiento de notarización

---

## v0.1.3 — 2026-04-02

### Correcciones
- Hacer que el paso de notarización no sea fatal para que los releases de GitHub se publiquen incluso si la notarización devuelve un error 401
- Agregar diagnósticos de disponibilidad de secretos al flujo de trabajo de releases
- Corregir las comprobaciones condicionales en el flujo de trabajo de releases para los pasos de firma

---

## v0.1.2 — 2026-04-02

*(Etiquetado junto con v0.1.3 — ver notas de v0.1.3)*

---

## v0.1.1 — 2026-04-01

### Funcionalidades
- Flujo de trabajo de firma con Developer ID + notarización en GitHub Actions

### Correcciones
- `build_dmg.sh` usa el certificado Apple Development como respaldo cuando el Developer ID no está disponible
- El DMG ahora se crea en un solo paso `hdiutil` usando compresión UDZO

---

## v0.1.0 — 2026-03-31

🎉 **Lanzamiento inicial** de Copilot Island.

### Funcionalidades
- Ventana superpuesta en la muesca que monitorea `~/.copilot/session-state/` en tiempo real
- Lista de sesiones que muestra todas las sesiones activas y recientes del Copilot CLI
- Vista del historial de chat con renderizado Markdown, bloques de código y resultados de herramientas
- Estado "pastilla" colapsado con ícono de estado izquierdo y contador de sesiones derecho
- Expandir/colapsar al hacer clic o pasar el cursor sobre la muesca
- Tema oscuro verde salvia inspirado en Copilot
- Forma de muesca plana en la parte superior al ras del borde de la pantalla, esquinas inferiores redondeadas
- Efecto de sonido al completar la tarea del agente
- macOS 14.0+ (Sonoma), soporte para muesca del MacBook
- Licencia de código abierto Apache 2.0
