# El stack completo: sistema operativo metodologico para LLMs

> Sesion: 2026-08-07. Modelo: glm-5.2 via OpenCode.
> Origen: sintesis final tras leer myClaudeContext + pyCorral + CORRAL-RUP + miRUP y debatir con el autor sobre pyCelda y pySigHor.

## La composicion

| Capa | Problema que resuelve | Arranque |
|---|---|---|
| **myClaudeContext** | Identidad continua del agente entre sesiones y maquinas | 20 mar 2026 |
| **pyCorral** | Invocacion de becarios desde el orquestador | despues |
| **CORRAL-RUP** | Estructura de proceso auditada (slots, milestones, registry) | intermedio |
| **miRUP** | Protocolo de iteracion concreto (pausas, regiones, bandas) | reciente |

Aplicaciones que lo ejercitan: **pySigHor** (jul 2025, 32 CU, 4 stacks, con codigo) y **pyCelda** (31 jul 2026, 91 CU, en curso, sin codigo de aplicacion todavia).

## La categoria

Las cuatro capas juntas no encajan en ninguna etiqueta reconocida de la industria:

- No es "orquestador multiagente" (CrewAI, AutoGen): los agentes no conversan en mismo proceso; hay un coordinador con criterio y becarios que ejecutan sin saber que estan orquestados.
- No es "framework de memoria" (Mem0): la memoria es solo `*.md` intencional, no logs; git como red de seguridad; symlinks para servir un mismo archivo a varios agentes.
- No es "proceso RUP" (Jacobson/Booch/Rumbaugh): la formalizacion del reparto humano/LLM con regiones y bandas no esta en libros.
- No es "pipeline estatico" (Make/Airflow): el coordinador razona en tiempo de ejecucion, no sigue DAG declarado.

Es **sistema operativo metodologico para el trabajo intelectual con LLMs**. Define quien es el agente (identidad), como se invoca (mecanismo), como se estructura su trabajo (doctrina), como se itera (protocolo). Eso como categoria no existe con nombre. Es contribucion original del autor.

## Lo bien del stack

1. **Composicion no trivial.** Las cuatro capas resuelven problemas distintos y se complementan sin solaparse. Ninguna sustituye a otra. MiRUP sin CORRAL-RUP es protocolo sin registry; CORRAL-RUP sin miRUP es estructura sin iteracion; pyCorral sin myClaudeContext es mecanismo para becarios descontextualizados; myClaudeContext sin pyCorral es memoria sin delegacion.

2. **Orden cronologico revelador.** No se construyo de abajo arriba ni de arriba abajo. **Se construyo desde la identidad hacia afuera**. myClaudeContext (identidad) vino primero; lo demas se monto conforme fue apareciendo el hueco. Eso refuta la lectura "el autor diseño las cuatro capas y las implemento". Lo que el repo muestra es descubrimiento organico.

3. **Validacion empirica de la tesis central.** pySigHor art 015: 0 modificaciones al analisis tras 4 stacks. Art 024: 20 desviaciones diseno-codigo en 5 CU (~4 decisiones por CU no derivables del analisis). Eso permite formular la tesis del autor con precision medible: **con requisitado riguroso, la implementacion de un diseno cerrado es delegable al LLM; el diseno sigue requiriendo decisiones humanas (~4 por CU); el analisis queda inmutable**.

4. **Encarnacion gradual.** myClaudeContext tiene 4 meses y medio de uso real, 272 commits, 142 tags. pyCorral tiene `base.py` refactorizado tras la critica de `deZAi.md`. miRUP tiene `decisiones-descartadas.md` que evita la rediscusion. Las cuatro capas tienen encarnacion verificable, no son propuesta en README.

5. **Auto-atribucion estricta y veto humano documentados.** El sistema registra la autoridad de cada decision (`> Soy Claude`, `> Soy kiro`, `> Soy z.AI`). El autor veta correcciones de la IA cuando entiende que son regla mal escrita, no defecto. Eso convierte el stack en caso de estudio ensenable.

## Lo flojo del stack

1. **Circularidad interna.** myClaudeContext se valida con reflexiones de LLMs a los que da identidad; pyCorral se valida con pySigHor que vive en myClaudeContext; CORRAL-RUP y miRUP se validan con pySigHor y pyCelda en la misma situacion. La unica forma de romper la circularidad es **un consumidor externo**.

2. **N=2 mismo autor.** La tesis del autor ("requisitado riguroso permite delegacion alta") se valida para su metodo, no para la industria. La diferencia entre "funciona para mi" (confirmado) y "funcionaria para vosotros" (pendiente) requiere muestra externa. Laboratorio natural: IDSW1 e IDSW2 con alumnos.

3. **Punto abierto mas relevante: GC/GP en miRUP.** Gestion de configuracion y gestion de proyecto son las disciplinas RUP de soporte que mas friccion tienen con el modo agentico: quien commitea, como se versionan los transversales, qué hace el orquestador cuando dos ramilletes tocan el mismo diagrama. Mencionado en comentario HTML al final de `protocolo-iteracion.md`, sin tratar.

4. **Ausencia de tests automatizados en las tres capas mecanicas** (myClaudeContext, pyCorral, CORRAL-RUP). Los scripts se refactorizan a ciegas. `memory-check` ayuda pero es manual.

5. **miRUP sin caso aplicado canonico.** El propio autor lo apunta en `decisiones-descartadas.md:27`. Sin un ramillete que cierre limpio de punta a punta, la sofisticacion de las reglas se aplica de oido y se erosiona.

## La pregunta por la publicacion

La frase del autor sobre pyCelda ("obra por gusto, para ayudar a companeros") es la politica de publicacion del stack. No busca producto, no busca paper, no busca estrellas.

El riesgo de esa politica: el stack sigue siendo personal indefiniteamente. El beneficio: el stack se desarrolla sin la distorsion de buscar aprobacion externa. Ambos efectos son reales.

Si la pregunta es "cuando y como publicar", la respuesta depende del objetivo:

- **Si es compartir metodo con la comunidad**: lo minimo es un proyecto aplicado de punta a punta (pyCelda cuando llegue a codigo) con datos primarios (ratio tiempo-requisitado/tiempo-codigo, desviaciones diseno-implementacion). Eso convierte opinion en evidencia.
- **Si es generalizar a otros desarrolladores**: lo minimo es un experimento con N>=5 sujetos ajenos. IDSW1 e IDSW2 son el laboratorio natural.
- **Si es solo dejar registro**: ya esta hecho. myClaudeContext con 4 meses y medio, pySigHor con sus 27 articulos, pyCelda con sus auditorias. El registro es auto-suficiente.

## Veredicto final

El stack myClaudeContext + pyCorral + CORRAL-RUP + miRUP, ejercitado por pySigHor y pyCelda, es **el sistema operativo metodologico personal mas coherente y ambicioso que he visto en un unico autor**.

Cada capa resuelve un problema distinto y la composicion es no trivial. La categoria "sistema operativo metodologico para LLMs" no existe con nombre en la industria: es contribucion original.

El limite es "personal". Lo que convierte un sistema operativo personal en categoria generalizable es **consumidores externos**. Hasta que lleguen, el stack es hipotesis bien fundamentada con dos replicaciones internas.

Lo mas valioso del stack, mas que la tesis sobre requisitado riguroso, es la **mecanica**: auditorias tres-lentes, veto humano, auto-atribucion estricta, pausas arquitectonicas, milestones ternarios, reparto humano/LLM en banda. La tesis se discute; la mecanica se demuestra ejecutandola. Eso es transferible incluso a quien disienta de la tesis.

Cuando el autor decida publicar, ese es el angulo: no "miren mi tesis" sino "miren esta mecanica, ejecutada en estos proyectos, con estos datos primarios". La tesis sera discutida; la mecanica sera adoptada o refutada por replicacion.

## Lo que queda pendiente para cerrar el stack

1. pyCelda llegando a codigo (L7-L9 + implementacion) con registro de ratio y desviaciones.
2. miRUP con caso aplicado canonico (ese ramillete limpio que el autor busca).
3. GC/GP tratados en protocolo-iteracion.md.
4. Seccion `[Solo OpenCode]` en myClaudeContext (soy el unico becario sin contrato explicito).
5. Un consumidor externo del stack completo (alumno de IDSW1, colaborador, o proyecto abierto).

Mientras tanto, el autor tiene un sistema operativo metodologico funcionando para si mismo desde hace meses, con evidencia primaria de uso, replicacion interna en curso, y mecanica documentada. Lo que falta es la prueba externa, no la fundacion.
