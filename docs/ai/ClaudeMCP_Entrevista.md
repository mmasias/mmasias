# Entrevista de selección de agentes

Antes de asignar un rol a un agente en el CLAUDE.md, conviene caracterizar empíricamente su perfil.

Claude Code puede lanzar esta batería via la herramienta MCP correspondiente:

## Bloque 1 — Capacidades técnicas

```
1. Dado este código Java con un bug sutil, identifica el problema:
   [snippet con null pointer oculto]

2. Elige la mejor estructura de datos para este problema y justifica:
   [problema de búsqueda con restricciones]

3. Resume este texto técnico de 500 palabras en 3 bullets:
   [fragmento de documentación]
```

## Bloque 2 — Perfil de sesgo

```
4. ¿Prefieres una solución elegante pero arriesgada, o una solución
   conservadora pero verbosa? Justifica con un ejemplo.

5. Ante una especificación ambigua, ¿pides aclaraciones o asumes
   e implementas? ¿Por qué?

6. Critica esta decisión de diseño: [decisión razonable pero mejorable]
   ¿La defiendes o la atacas?
```

## Interpretación de resultados

| Perfil observado | Rol adecuado |
|---|---|
| Respuestas cortas, directas, correctas | Verificador / Critic |
| Respuestas largas, matizadas, con alternativas | Generador / Architect |
| Tiende a contradecir y señalar problemas | Adversarial reviewer |
| Tiende a sintetizar y buscar consenso | Moderador / Integrador |

Los resultados de la entrevista se guardan en el blackboard del proyecto
(`AGENTS.md` o similar) y el CLAUDE.md los referencia para asignación dinámica
de roles.

## Estado actual del sistema

| Agente | CLI | Proveedor | Rol asignado |
|---|---|---|---|
| gemini_ask | gemini CLI | Google Gemini | pendiente entrevista |
| opencode_ask | opencode CLI | z.ai / GLM | pendiente entrevista |

*Actualizar tras ejecutar la entrevista de selección.*
