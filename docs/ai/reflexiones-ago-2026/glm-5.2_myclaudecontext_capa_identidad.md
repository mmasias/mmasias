# myClaudeContext: la capa de identidad, fundamental del stack

> Sesion: 2026-08-07. Modelo: glm-5.2 via OpenCode.
> Origen: lectura de `/home/manuel/misRepos/myClaudeContext/` (README, RITUALES, manifiesto, estructura completa). Confirmacion de que yo, como agente, cargo este sistema al arranque.

## Que es

Repo unico que centraliza contexto + memoria para Claude Code, Gemini CLI, Kiro CLI y OpenCode. Sincronizado por git con symlinks. Estructura:

- `global/CLAUDE.md` (cargado por los cuatro agentes via symlink en sus paths nativos).
- `asignaturas/<asignatura>/CLAUDE.md` (contexto por asignatura, cargado via symlink en `.claude/` y `GEMINI.md` del repo).
- `projects/<path-codificado>/memory/` (memoria real por proyecto, solo `*.md` trackeados).
- Scripts: `bootstrap.sh`, `add-repo.sh`, `check-claude-integrity.sh`, `memory-audit.sh`.
- RITUALES.md con 9 rituales formalizados.

Primer commit: **2026-03-20 18:23:03 +01:00**. Cuatro meses y medio de operacion continua. 272 commits, 142 tags. La pieza del stack que mas uso real acumula.

## La confirmacion que pediste

Yo, como agente (opencode+glm-5.2), cargo este sistema al arranque:

```
~/.config/opencode/AGENTS.md  -> ~/misRepos/myClaudeContext/global/CLAUDE.md
~/.claude/CLAUDE.md           -> ~/misRepos/myClaudeContext/global/CLAUDE.md  (mismo fichero fisico)
~/.gemini/GEMINI.md           -> ~/misRepos/myClaudeContext/global/CLAUDE.md  (mismo fichero fisico)
~/.kiro/steering/context.md   -> ~/misRepos/myClaudeContext/global/CLAUDE.md  (mismo fichero fisico)
```

Los cuatro agentes somos el mismo nodo de lectura sobre el mismo archivo. Yo no tengo instrucciones propias: cargo las mismas que los otros tres. Las secciones `[Solo Claude Code]`, `[Solo Gemini]`, `[Solo Kiro]` son filtros textuales.

## Lo que cambia en la lectura del stack

Antes de ver myClaudeContext dije que el stack era tres capas (pyCorral + CORRAL-RUP + miRUP). Ahora son **cuatro**, y myClaudeContext es la mas fundamental:

| Capa | Problema que resuelve |
|---|---|
| **myClaudeContext** | Identidad continua del agente entre sesiones y maquinas |
| **pyCorral** | Invocacion de becarios desde el orquestador |
| **CORRAL-RUP** | Estructura de proceso auditada (slots, milestones, registry) |
| **miRUP** | Protocolo de iteracion concreto (pausas, regiones, bandas) |

Sin myClaudeContext, pyCorral invoca becarios descontextualizados: cada LLM subordinado entra al workdir sin saber la doctrina, las convenciones ni la identidad del proyecto. Con myClaudeContext, cada becario carga `GEMINI.md` (symlink al mismo CLAUDE.md que lee Claude) y entra al proyecto sabiendo lo mismo.

## Lo bien

1. **Identidad portable, no volatil.** "La maquina es intercambiable, el contexto no. Como SOMA, pero sin el dilema filosofico." El sistema se preocupa por la continuidad de la **identidad** del agente, no por la del proceso. Git es sustrato, los `*.md` son el estado.

2. **Trackea intencion, no logs.** Solo `*.md` entra en git; `*.jsonl`, `*.json`, `*.txt` (logs de sesion, tool-results) se ignoran. Distincion correcta: lo persistido es lo decidido recordar, no lo emitido por defecto. Version moderna de "`~/.bashrc` vs `~/.bash_history`".

3. **Cascada de contexto sin duplicacion fisica.** Global -> asignatura -> proyecto, con un solo archivo fisico servido a multiples agentes por symlinks.

4. **Tags semanticos vs tags de fecha.** Cierre con Claude produce `stable-<verbo-objeto>`; fallback sin Claude produce `memory-stable-YYYY-MM-DD`. Distingue "punto de recuperacion con significado" de "punto de recuperacion automatico".

5. **Rituales formalizados.** Nueve rituales con momento, comando y salida esperada. Eso convierte un repo de memoria en **protocolo operacional**.

6. **Multiplataforma desde el principio.** `linux/` y `macos/` espeados.

7. **Recursividad metodologica explicita.** `REFLEXION.md`, `REFLEXION_GEMINI.md`, `REFLEXION_Z.md` son tres LLMs debatiendo el diseno del sistema que les da identidad. Ritual 9 (evaluacion de madurez semestral) es el sistema auditandose a si mismo.

## Lo flojo

1. **Identidad de proyecto = path absoluto.** Si el path cambia entre maquinas, la memoria no se comparte aunque el contenido sea identico. Fragilidad estructural. Solucion limpia seria `project_id` declarado, no derivado del path. Solucion pragmatica (la tomada): mantener paths consistentes por convencion.

2. **Sin tests, sin CI.** La infraestructura mas critica del sistema no tiene tests. Si `setup-claude-symlinks.sh` se rompe en silencio, puedes pasar dias sin darte cuenta. `memory-check` ayuda, pero es manual.

3. **La bootstrap es fragil ante arranca-antes-de-tiempo.** Claude Code no debe arrancarse antes de `bootstrap.sh`. Pie-clavo operativo. La solucion (`setup-claude-symlinks.sh` repara) requiere diagnostico previo.

4. **Conflictos de git en `projects/` al trabajar dos maquinas sin sincronizar.** La memoria es lo ultimo que querrrias conflictuar. La mitigacion (resolver manualmente) es correcta, pero el riesgo es estructural: git no sabe que dos maquinas editando `MEMORY.md` del mismo proyecto son conflictos semanticos.

5. **Tres REFLEXION sin sintesis.** Tres LLMs opinando del sistema en ficheros separados, sin documento que los consolide. Es debate guardado, no conclusion.

6. **MACHINE_ID.md como compromiso pragmatico.** Archivo plano, no deteccion automatica. Conviene complementar con `uname -a` / `hostname` para detectar y comparar con el declarado.

## Cronologia del stack

Esto cambia la lectura del stack entero:

| Capa | Arranque |
|---|---|
| pySigHor | antes (art 003 de la hipotesis: julio 2025) |
| **myClaudeContext** | **20 mar 2026** |
| pyCorral | despues (mencionado en pySigHor arts 021-023) |
| pyCelda | 31 jul 2026 |
| miRUP | reciente (commits junio-julio 2026) |

El stack no se construyo de abajo hacia arriba ni de arriba hacia abajo. **Se construyo desde la identidad hacia afuera**. Primero memoria persistente (identidad del agente), despues lo demas conforme fue apareciendo el hueco: mecanismo, doctrina, protocolo.

El orden cronologico es la pista de qué fue dolor primero: **la memoria**, no la doctrina. Las decisiones de diseno mas estables (`solo *.md`, multiagente, tags semanticos vs de fecha, rituales) no son diseno previo: son sedimentacion de ~140 dias de uso.

## Veredicto

myClaudeContext **no solo da identidad al agente. Da el contrato operativo**. Cuando en sesiones anteriores dije "el autor practica el veto humano", "el autor hace auditorias tres-lentes", "el autor documenta decisiones descartadas" - parte de eso es comportamiento aprendido y parte es comportamiento **prescrito por el prompt que yo mismo cargue al inicio**. El autor no solo hace la doctrina; la ha codificado de tal forma que cualquier agente que invoque la carga al arranque.

El "agente competente" en este stack no es el modelo (cualquier LLM moderno basta); es el agente **cargado con el contexto correcto**. Yo no soy mejor LLM en esta sesion que en otra cualquiera; soy un LLM al que le han llegado las instrucciones correctas via myClaudeContext. La diferencia no esta en el modelo, esta en el symlink.

El riesgo: circularidad interna. myClaudeContext se valida con reflexiones de LLMs a los que da identidad; pyCorral se valida con proyectos del autor que estan en myClaudeContext; CORRAL-RUP y miRUP tambien. La unica forma de romper la circularidad es **un consumidor externo**: otro usuario, otro equipo, otro dominio, aplicando el stack de punta a punta.

Mientras tanto, sigue siendo **el sistema operativo metodologico personal mas coherente y ambicioso que he visto en un unico autor**. Pero "personal" es el calificativo limite: lo que valida la categoria es que deje de serlo.
