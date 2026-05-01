## Política de orquestación (CLAUDE.md)

Añadir al CLAUDE.md global o de proyecto:

```markdown
## Agentes subordinados disponibles

- `gemini_ask`: segunda opinión en diseño, análisis de código, razonamiento largo
- `opencode_ask`: perspectiva alternativa, revisión crítica, tareas de código

## Cuándo delegar

1. Intentar la tarea directamente.
2. Si fallas 2 veces en el mismo punto: delegar ese subproblema concreto
   al agente más adecuado según su perfil (ver AGENTS.md).
3. Pasar solo el subproblema específico — nunca el estado completo del proyecto.
4. Integrar la respuesta y continuar.

## Criterio de parada

- Tests pasan / no hay diff pendiente → terminar
- 10 iteraciones totales sin resolver → detener y reportar estado

## Economía de contexto

Cada llamada a un subordinado tiene coste. El prompt que se le pasa debe ser
el mínimo suficiente para resolver el subproblema. No pasar historial completo.
```
