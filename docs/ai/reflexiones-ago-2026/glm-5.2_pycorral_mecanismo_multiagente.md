# pyCorral: mecanismo multiagente, capa agnostica al procedimiento

> Sesion: 2026-08-07. Modelo: glm-5.2 via OpenCode.
> Origen: lectura de `/home/manuel/misRepos/pyCorral/` (README, docs/corral-rup.md, servers/base.py, servers/opencode_mcp.py, reflexiones/deZAi.md). El autor lo describe como "miRUP es la doctrina del corral", invitando a leer la base.

## Tesis central

Cualquier CLI con modo no interactivo puede convertirse en herramienta MCP invocable por Claude Code. La idea minima: **agente como herramienta**, no framework. Claude Code ya tiene el bucle de control, el acceso al filesystem y el criterio de parada; CORRAL expone cada CLI externo como tool, igual que `bash` o `Read`.

El contrato es agnostico al LLM: hoy son LLMs invocados desde CLI; manhana pueden ser PlantUML, Graphviz, TLC, Alloy, Csound, ffmpeg. El contrato es "ejecutable no interactivo que escribe a workdir", no "LLM".

## Lo bien

1. **Idea correcta y minima.** Es la solucion mas pequena posible al silo entre CLIs. No inventa framework, usa MCP nativo.

2. **Control plane / data plane bien trazado.** Un solo coordinador con criterio; los agentes ejecutan sin saber que estan orquestados. Evita el anti-patron CrewAI/AutoGen donde los "agentes" conversan dentro del mismo proceso Python.

3. **Filesystem como bus de datos.** Verificacion con Glob/Read/Grep, no parseo de texto volatil. Filosofia Unix aplicada a agentes.

4. **BaseAgentMCP abstraido.** `servers/base.py` (261 lineas) contiene el patron sync/async/done con persistencia y reconstruccion al arrancar. Cada server concreto baja a ~120 lineas, casi todo especifico del CLI. El refactor de mayor ROI que yo mismo pedi en `reflexiones/deZAi.md` (la critica externa previa sobre este repo, tambien mia) esta aplicado.

5. **Persistencia de `_jobs`.** `~/.local/share/corral/jobs_<agente>.json` con `_load_jobs` que reconstruye al arrancar. Otro punto que `deZAi.md` senalo como prioritario y esta resuelto.

6. **Documentacion honesta con sus limitaciones.** El README admite: sin retry automatico, sin observabilidad, jobs volatiles en logs `/tmp`. Madurez de ingenieria, no marketing.

7. **Agnosticismo procedimental como decision.** No acoplar el mecanismo a un procedimiento (miRUP u otro) permite reutilizarlo en flujos ad hoc, otros marcos metodologicos o experimentacion pura.

## Lo flojo

1. **Async sin timeout ni cancelacion.** Si un job async cuelga, `_done` devuelve "pendiente" eternamente. Sin API para matarlo. El sync tiene timeout (120s/300s); el async no tiene nada.

2. **`output.md` fijo colisiona en paralelo.** El README lo prohive en lugar de parametrizarlo. Duele especialmente en CORRAL-RUP: A2/D2/I3 son fan-out por caso de uso, y forzar un unico `output.md` por workdir obliga a un workdir distinto por becario. Restriccion del mecanismo filtrandose al procedimiento. Solucion: `output_path` como parametro.

3. **Sin tests.** Defendible para infra personal, pero cualquier refactor del `base.py` se hace a ciegas. Smoke test minimo (mock del CLI + verificar trio de tools) sigue siendo lo de mayor ROI.

4. **`setup.sh` no idempotente** (senalado en `deZAi.md:48`, no verificado en esta sesion pero probablemente sigue). Segunda ejecucion del setup se rompe si el server ya esta registrado. Falta guard `claude mcp list | grep -q` antes de anhadir.

## Lectura sobre CORRAL-RUP (docs/corral-rup.md)

CORRAL-RUP es la especializacion RUP del mecanismo CORRAL. Define dos Contratos:

- **Contrato 1 (esquema de slots):** `corral-rup/{fase}/{iteracion}/{disciplina}/{artefacto}` con sentinelas `_` para el caso degenerado. Bien trazado.
- **Contrato 2 (objeto milestone):** YAML con `evaluaciones`, `estado_actual` como proyeccion, no persistencia de derivados. Coherente con miRUP.

Lo mas valioso de CORRAL-RUP:

1. **Las dos vias de promocion resuelven el caso del modelo del dominio.** Via 1 (promocion desde iteracion), Via 2 (entrada directa como prerequisito). El modelo del dominio entra por Via 2 porque preexiste al proceso; sus ajustes posteriores entran por Via 1.
2. **Principio transversal "ningun estado derivado se persiste".** Aplica a `estado_actual`, al estado de promocion y a `pendiente`. Es la regla anti-doble-fuente-de-verdad aplicada con disciplina rara.
3. **El ejemplo trabajado de pySigHor** (CU-07 y CU-08 producidos pero no promovidos) materializa "artefacto existe pero no validado". Primera instancia real del registry, no teoria.

## La categoria real de CORRAL

La diferencia con Make/Snakemake/Airflow no es que los workers sean LLMs. Es que **el coordinador razona en tiempo de ejecucion**: decide qué delegar, a quien y cuando recoger, en funcion del estado real del proyecto, sin un DAG declarado de antemano.

Eso lo coloca en una categoria distinta:

- No es CrewAI/AutoGen (agentes conversando en mismo proceso).
- No es LangChain/LlamaIndex (abstraccion sobre RAG, no orquestacion).
- No es Make/Airflow (pipeline estatico sin razonamiento).

Es **pipeline agéntico**: orquestador de procesos con LLM como coordinador. La categoria no existe con nombre en la industria. Es contribucion original del autor.

## Veredicto

POC solido de la tesis "agente como herramienta", correctamente documentado, honesto con sus limites, deliberadamente agnostico al procedimiento. Las criticas operativas (timeout en async, `output_path` configurable, tests) siguen abiertas pero no comprometen el diseno.

El riesgo que `deZAi.md` apuntaba y sigue vigente: **circularidad interna**. pyCorral se valida con pySigHor que se valida con pyCelda que se valida con pyCorral. Para romper la circularidad hace falta un proyecto externo: otro usuario, otro equipo, otro dominio, aplicando el stack de punta a punta.

La frase del autor ("miRUP es la doctrina del corral") es precisa pero incompleta: pyCorral sin CORRAL-RUP es infraestructura para vibecoding mas elaborado (lo apunte en `deZAi.md:102` y sigue siendo cierto). La doctrina es lo que evita que la infraestructura sea amoral. Las dos capas juntas son lo que convierte a pyCorral de "infraestructura" en "runtime para procedimientos auditables".

Lo que el documento publicable deberia articular: **la categoria "pipeline agéntico" no existe; CORRAL es su primera instancia formalizada; CORRAL-RUP es su primera doctrina**. Cuando el autor decida publicarlo, ese es el angulo, no el codigo Python (que es correcto pero no revolucionario).
