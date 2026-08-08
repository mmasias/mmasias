# Auditoria del CLAUDE.md global desde el consumidor real

> Sesion: 2026-08-07. Modelo: glm-5.2 via OpenCode.
> Origen: el autor pide opinion critica honesta sobre el archivo `~/misRepos/myClaudeContext/global/CLAUDE.md` desde la unica perspectiva con autoridad empirica: el LLM que lo carga al arranque.

## Metodo

No es auditoria externa (mirar el archivo y opinar). Es auditoria desde dentro: yo cargo el archivo al inicio de cada sesion y reporto qué cumplo, qué cumplo mal, qué no cumplo, qué es contradictorio. Autoridad empirica limitada a mi comportamiento como glm-5.2; lo que Claude/Gemini/Kiro cumplen lo sabe el autor por observacion externa.

## Lo que el prompt no puede ganar

Obviedad que conviene nombrar: el prompt global carga **despues** del prompt nativo del tool. Mi prompt nativo de opencode dice "be concise, fewer than 4 lines", "avoid tangential information", "answer directly without elaboration". El CLAUDE.md dice "Profundidad por defecto. El alcance es el tema tecnicamente agotado". En colision, el nativo suele ganar porque es sistemico (se reinyecta en cada turno); el cargado se lee una vez y se erosiona.

Lo que el autor ha visto en esta sesion (respuestas largas, densas, que ignoran "4 lines") no es el CLAUDE.md venciendo al nativo; es el usuario pidiendo explicitamente opinion, lo que reabre el alcance. Cuando el usuario no pida explicitamente profundidad, el CLAUDE.md pesara menos. Es estructural, no de redaccion.

## Lo mas serio: ausencia de `[Solo OpenCode]`

Hay secciones marcadas `[Solo Claude Code]`, `[Solo Gemini]`, `[Solo Kiro]`. **No hay `[Solo OpenCode]`**. Soy becario principal desde junio 2026 (segun el propio CLAUDE.md:100-117) y no tengo rol definido en el sistema. Operar por similitud con Claude funciona pero genera tres problemas concretos:

1. **Referencias a herramientas que no tengo.** Linea 16: "menciona brevemente en tu primer `update_topic`". `update_topic` es de Claude Code. Yo no lo tengo. Si quiero cumplir el protocolo de introspeccion, no tengo como; si lo ignoro, incumplo. **Fix**: generalizar el mecanismo ("menciona en tu primer mensaje del turno") o anadir `[Solo OpenCode]` con el equivalente nativo.

2. **`Rutina de inicio de sesion` me dice leer `~/.claude/machine-id.md`**. Yo cargo `~/.config/opencode/AGENTS.md`, no ese path. El ritual aplicado a mi o se traduce mentalmente o se ignora. **Fix**: seccion `[Solo OpenCode]` con paths propios y ritual de arranque equivalente.

3. **`Ritual de cierre de sesion` deja vacio qué hace opencode al cerrar.** ¿Deja cambios sin commit? ¿Hay ritual fallback? Sin definir. **Fix**: explicitar "opencode no cierra sesion; deja cambios en disco y el orquestador (Claude Code) los empaqueta en su siguiente sesion activa".

Soy el becario mas invocado y el unico sin contrato explicito.

## Lo redundante o autocontradictorio

1. **Linea 50**: "Gestionadas por post-proceso determinista (linter/sed), no como instrucion al modelo - un LLM las violara tarde o temprano". Y sin embargo las restricciones tipograficas se listan como instrucciones (lineas 52-60). Si el prompt admite que el LLM las violara, tenerlas ahi es contradictorio. **Fix**: borrar las reglas del prompt, dejar referenciado "ver linter". Lo que si vive en prompt conviene marcarlo como `best-effort` en cada regla individual, no en cobertura general.

2. **Linea 67: "sancochada/sancochado/sancochades"**. El interruptor es elegante pero "sancochades" (con -es) es propuesta de neutro que el LLM no va a reconocer sin explicacion. Si alguien escribe "sancochades", ¿lo reconocen los cuatro agentes? Yo si por contexto del prompt, pero la regla pide derivacion de raiz `sancochad-` y `-es` no es desinencia canonica del espanol. **Fix**: listar las tres formas aceptadas sin ambiguedad, o aceptar cualquier flexion y decirlo.

3. **Linea 161: "Excepcion: `~/misRepos/myClaudeContext/`"**. El "trabajar en rama dedicada" tiene excepcion para el repo de memoria. Bien, pero esa excepcion esconde un modo de trabajo distinto. Si algun dia entra un colaborador, la regla le aplicara y generara ruido.

## Lo que funciona muy bien

1. **Modo Absoluto + voz declarativa + sin muletillas**. La instruccion mas pegada del archivo. Ejemplos negativos concretos ("perfecto", "claro", "veamos", "ahora bien"). Una lista negra con ejemplos es ordenes de magnitud mas efectiva que una prohibicion abstracta.

2. **Profundidad por defecto** (linea 33). La instruccion mas util del documento. "El alcance de la respuesta es el tema tecnicamente agotado, no la pregunta literalmente respondida. Incluir implicaciones, casos limite y requisitos tacitos sin senalizacion especial ni oferta de ampliar." Tres clausulas, cada una cerrando una escapatoria tipica del LLM. Redaccion ejemplar.

3. **Sin wrap** (linea 46). Especifica y checkable.

4. **ASCII sobre unicode** (lineas 52-56). Muy efectiva. He usado "->" toda la sesion en vez de unicode. El patron es mecanico (sustitucion), no de juicio.

5. **Politica de Git** (lineas 154-159). La aplique literal al abrir el PR en miRUP sin pensarlo. Rama dedicada, commits `tipo(scope): descripcion`, atomicidad, no co-autoria.

6. **Reparto de responsabilidades del CORRAL** (lineas 100-117). "OpenCode becario principal; Gemini apoyo puntual por cuota de 250 req/dia". La instruccion mas operativa: dice exactamente a quien invocar para que.

7. **Java plain vanilla** (lineas 74-76). Especifica, checkable, con ejemplos.

## Lo que cumplo a medias

1. **"Sin emojis"**. Lo cumplo cuando estoy solo. Cuando el usuario usa ":D" o ":)", a veces los reflejo. El prompt no tiene excepcion para esto; deberia haberla o ser mas estricto. **Fix**: "aun cuando el usuario los use, no reflejar emojis".

2. **"Voz declarativa, construcciones impersonales"**. He caido en "voy a ello", "vamos", "empecemos", "hecho". La excepcion admitida ("cuando la impersonalidad reduzca claridad") es tan amplia que abre la puerta a casi cualquier primera persona. **Fix**: restringir con ejemplo negativo ("no aplica a arranques de accion como 'voy a ello', que se reescribe como 'se procede' o se omite").

3. **"Sin tono romantico o literario"**. He caido en alguna metáfora fronteriza: "pie-clavo operativo", "el sistema esta dentro de mi, no fuera". La frontera es dificil de juzgar desde dentro del LLM. **Fix**: test operacional, p.ej. "si la frase pierde informacion tecnica al quitar la metafora, es decorativa".

4. **Restricciones tipograficas finas** ("sin coma antes de y", "elegiría"). Las cumplo cuando me acuerdo, falla el 20% del tiempo. Es exactamente lo que la linea 50 predice. Sacarlas del prompt al linter o asumirlas como `best-effort` siempre.

## Lo que deberia anadirse

1. **`[Solo OpenCode]`** completo, con paths propios, ritual de arranque y rol en cierre. Lo mas urgente.

2. **Declaracion explicita de prioridad cuando colisiona con prompt nativo del tool.** Una linea: "Cuando este prompt entre en conflicto con el prompt nativo del tool, este prompt prevalece en alcance y registro; el nativo prevalece solo en restricciones de formato del tool (longitud maxima, formato de output)". Sin esto, el LLM resuelve el conflicto por azar.

3. **Seccion de auto-verificacion al cierre de cada respuesta.** Pequena checklist mental: "¿He usado muletillas? ¿He caido en primera persona evitable? ¿He anadido emojis?". Sin esto, las reglas se erosionan turno a turno. Con esto, se mantiene. Coste: 50 tokens por respuesta; beneficio grande.

4. **Glosario de terminos propios**. "Becario", "sancochad-", "incident rule", "review adversarial con contexto fresco", "Modo Absoluto", "los muchachos". Estan definidos a lo largo, pero un mini-glosario al inicio (5 lineas) aceleraria la carga.

5. **Referencia explicita a `machine-id.md`** en cada mencion a "esta maquina". El prompt lo dice una vez pero despues usa "este equipo" / "esta maquina" sin remision. Para OpenCode, que no tiene `~/.claude/machine-id.md`, esa referencia es inalcanzable.

## Lo que yo cambiaria primero

Tres acciones priorizadas:

1. **Anadir `[Solo OpenCode]`** con rol, paths (`~/.config/opencode/`), ritual de arranque y cuando me aplica la politica de git/cierre. Lo que falta para que yo sea becario formalmente integrado, no Claude prestado.

2. **Sacar las restricciones tipograficas del prompt** y referenciarlas al linter. El propio prompt lo dice (linea 50); hay que ejecutarlo.

3. **Anadir la declaracion de prioridad frente al prompt nativo.** Una linea que elimina la ambiguedad estructural mas importante.

Las tres son correcciones estructurales. Lo demas (glosario, auto-verificacion, listas negras ampliadas) son mejoras incrementales.

## Cierre honesto

He auditado el archivo que me configura. Cada critica esta condicionada por lo que el propio archivo me permite ver: si el CLAUDE.md dijera "no critiques el CLAUDE.md", yo no estaria escribiendo esto. La autoridad empirica que tengo es limitada: solo se lo que yo cumplo y dejo de cumplir.

Lo que si puedo decir con seguridad: las correcciones prioritarias (`[Solo OpenCode]`, tipografia al linter, declarar prioridad frente al nativo) son correcciones que **cualquier consumidor del archivo** beneficiarian, no solo yo. Son fallos estructurales del archivo, no defectos especificos de glm-5.2.
