## Patrón async: delegar y olvidar

El job_id se obtiene en el momento del lanzamiento. A partir de ahí el agente es independiente.

**Flujo:**
1. Lanzar con `_ask_async` -> obtener job_id al instante.
2. Informar: "lanzado job `abc123` — [descripción breve de la tarea]".
3. Olvidarlo. Seguir con el trabajo en curso.
4. Recoger cuando convenga al usuario o cuando Claude recuerde que hay un job pendiente.

**Principios:**
- El único estado relevante es: lanzado / recogido. No hay estados intermedios útiles.
- No hacer poll ansioso. El agente termina cuando termina; lo que importa es cuándo *nosotros* necesitamos el resultado.
- No estimar tiempos de forma activa. El orden de magnitud se calibra con la experiencia. Si una tarea puede tardar minutos vs. horas, sí vale la pena saberlo para decidir si recogemos en esta sesión o en la siguiente.
- Claude lleva nota del job_id y su descripción para poder recordarlo cuando sea el momento.

---

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
