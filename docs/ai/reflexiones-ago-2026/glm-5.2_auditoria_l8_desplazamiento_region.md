# Auditoria L8: desplazamiento de region, madurez estructural, erosion lexica

> Sesion: 2026-08-07. Modelo: glm-5.2 via OpenCode.
> Origen: el usuario observa que la sesion de trabajo actual ha sido mas autonoma (10 CU de un tiron, relativamente poco debate). Pide verificacion con tres lentes sobre L8 de pyCelda, fuera del repo para no contaminarlo.

## El lote L8 en cifras

- **10 CU nuevos** sobre dos entidades: 5 `PonderacionEvaluacion` + 5 `ReferenciaBibliografica`.
- **1h 44m** entre el commit de L7 (`41bc821` 16:46:49) y el commit de L8 (`3920c05` 18:30:41): ~10 minutos por CU incluyendo los tres ficheros (`README.md`, `especificacion.puml`, `wireframes.puml`).
- **30 ficheros nuevos** en `RUP/01-requisitos/03-detalle-casos-uso/`, mas 12 SVGs derivados.
- Commit directo a `main`, **sin PR** (cambio de patron respecto a L0-L7, todos con PR: #10, #17, #22, #26, #29, #32, #35, #37).
- Issue de Revision #40 abierta el 16:31:20Z (no cerrada). Mismo patron para L7 (issue #36 abierta). El ritual de apertura se mantiene; el cierre se pospone o se diluye.

## Lo que el "poco debate" esconde (cambio de patron)

| Elemento | L1, L2, L4, L6 (lotes previos con discusion de cierre) | L7, L8 |
|---|---|---|
| Discussion de cierre previa | #15 (L1), #18 (L2), #27 (L4), #33 (L6) | ninguna |
| PR con lifespan formal | #17 (1m 44s), #22 (53s), #29 (1m 04s), #35 (6s) | #37 (L7), ninguno en L8 |
| Issue de Revision | #16, #21, #24, #28, #31, #34 (todas closed) | #36, #40 (ambas open) |

L7 y L8 marcan un cambio de patron: ya no se abre discussion de cierre previa para los huecos de diseno (porque no los hay, segun el README de la fase que los declaro cerrados en `#38` y `#39`), y el ritual del PR se omite en L8. La issue de Revision sigue abriendose pero el cierre queda pendiente.

Eso significa que **"poco debate" no es "sin revision"**: la issue de revision existe. Es "sin friccion de cierre": el autor no ha vuelto a esas issues para cerrarlas todavia. La diferencia es operacional.

## Resultado de las tres lentes

### Lente MECANICA

**Sintaxis**: los 20 `.puml` compilan correctamente (`@startuml`/`@enduml` balanceados, `state` bien formados, transiciones con `-->`, `<<choice>>` bien aplicados en `crearPonderacionEvaluacion/especificacion.puml:17` y `editarPonderacionEvaluacion/especificacion.puml:16`).

**Vocabulario cerrado — DESVIACION**: 2 fugas de `selecciona` en L8 (`crearPonderacionEvaluacion/especificacion.puml:29` y `editarPonderacionEvaluacion/especificacion.puml:28`). Mismo patron que las 2 desviaciones detectadas por la auditoria glm-5.2 previa en L4 (`asociarMetodologiaDocenteAMateria:25`, `asociarResultadoAprendizajeAMateria:25`).

Barrido completo del catalogo: **8 ocurrencias totales** de `selecciona`. Distribucion por lote:
- L4: 2 (detectadas por auditoria previa, sin corregir)
- L5: 1 (`crearAsignaturaGrado/especificacion.puml:33`)
- L6: 3 (`asignarProfesorAAsignaturaGrado:25`, `asociarMetodologiaDocenteAAsignaturaGrado:25`, `asociarResultadoAprendizajeAAsignaturaGrado:25`)
- L8: 2 (`crearPonderacionEvaluacion:29`, `editarPonderacionEvaluacion:28`)

El patron canonico de sustitucion es `introduce X` (`definirDirectorGrado/especificacion.puml:25`). La regla esta escrita (`README.md:55-63`), documentada en auditoria previa (`AUDITORIA_MECANICA_glm-5.2.md:21-24`), pero **no consolidada**: cada lote nuevo reincide porque la correccion no se mecaniza.

**Correspondencia wireframe ↔ especificacion**: cumple sin excepciones. Botones `[Abrir]`, `[Editar]`, `[Eliminar]`, `[Crear]`, `[Guardar]`, `[Confirmar]`, `[Cancelar]` en wireframes se corresponden con transiciones de especificacion y diagrama de contexto. Verificado en los 10 CU.

**Patron CRUD en diagrama de contexto**: cumple. `crearX()` lleva a `X_ABIERTO` con nota `editarX()` sin argumento (filosofia C→U), `editarX()` self-loop sobre `X_ABIERTO`, `eliminarX()` self-loop sobre `Xs_ABIERTO`. Retorno al hub reutiliza `abrirGuia()` en vez de `completarGestion()` propio, mismo criterio que el resto del catalogo.

**Aritmetica de recuentos**: cuadra. README de la fase declara L8 = 10 CU, total acumulado 81, pendiente 10 para L9 = 91.

### Lente LOGICA

**Coherencia contra modelo de dominio**: cumple. Los 4 atributos del modelo relevantes (`descripcion`, `ponderacion`, `tipo`, `referencia`) aparecen en wireframes sin invenciones. Las FKs (`SistemaEvaluacion` en `PonderacionEvaluacion`) se muestran como selectores, no como atributos.

**Aritmetica 100% vs rango por SistemaEvaluacion**: separacion de responsabilidades coherente. El modelo documenta dos reglas (`RUP/00-modelo-del-dominio/README.md:35,39`): suma total = 100% y rango `[min,max]` por `SistemaEvaluacion`. `enviarGuiaARevision` valida la primera; `crearPonderacionEvaluacion` y `editarPonderacionEvaluacion` validan la segunda. La validez la emite el `Sistema` en ambos casos, no el actor (no aparece "el profesor comprueba" ni "el profesor corrige").

**Issue #14 (categorias mezcladas de bibliografia)**: resuelto al nivel del modelo. El enum `tipo` cerrado de 4 valores (Basica, Complementaria, WebsReferencia, OtrasFuentes) materializa las 63 variantes de texto libre del seed. `abrirReferenciasBibliograficas/wireframes.puml:7-16` muestra las 10 referencias reales con sus 4 tipos. Selector `^Basica^` en `crearReferenciaBibliografica/wireframes.puml:9`. La deuda se hereda ya resuelta, ningun CU la arrastra.

**No se detectan justificaciones "facticamente falsas"** tipo L1 (`crearGrado/README.md:41`). Los READMEs de L8 citan discussions reales (#38, #39) y distinguen lo que es dato de seed de lo que es reconstruccion (`abrirPonderacionesEvaluacion/README.md:45`: "reparto reconstruido a partir de los rangos reales de la Materia, no aportado como tal en el seed").

### Lente AUSENCIA

- Atributos del modelo sin representacion: ninguno.
- Transiciones del diagrama de contexto sin CU: ninguna (10 transiciones nuevas en `diagramaContextoProfesor.puml:32-50`, las 10 con su CU).
- CU CRUD esperable: 5 por entidad, confirmado, sin huecos ni sobrantes.
- Completitud de los 3 ficheros: los 10 CU con `README.md` + `especificacion.puml` + `wireframes.puml`. Sin carpetas a medias.

## Comparativa con L0-L6: densidad asimetrica

L8 no es homogeneo internamente. Los 5 CU de `ReferenciaBibliografica` son **CRUD estandar** sin `<<choice>>`, equivalentes en densidad a `crearFacultad` (L1) o `crearMetodologiaDocente` (L1): especificaciones ~33-44 lineas, wireframes de un bloque, READMEs de justificacion minima.

Los 5 CU de `PonderacionEvaluacion` son **mas densos** que la media de L0-L6. `crearPonderacionEvaluacion/especificacion.puml` (56 lineas) introduce el primer `<<choice>>` del catalogo situado **despues** de la entrada de datos, no antes. Todos los `<<choice>>` previos (`eliminarFacultad`, `eliminarMateria`, `editarCursoAcademico`, los `desasociar` de L4/L6) validaban precondiciones estructurales antes de pedir nada. Aqui la validacion es de negocio post-input, con wireframe especifico para el estado de error (`crearPonderacionEvaluacion/wireframes.puml:25-49`) que muestra el margen recalculado y el motivo ("Evaluacion continua sumaria 65% -- fuera del rango 20%-60%").

Este nivel de detalle en el wireframe de error no tiene precedente en L0-L6, donde los `eliminarX()` con `<<choice>>` no mostraban wireframe de bloqueo (bastaba con el `[Cancelar]`). **L8 ha introducido un nuevo sub-patron estructural** (wireframe de error aritmetico), lo cual contradice la hipotesis de "lote trivial".

Ejemplo concreto de asimetria interna: `crearPonderacionEvaluacion/wireframes.puml:11` muestra "Ya asignado en esta Guia (Evaluacion continua): 50% (Examen Parcial, Actividades y ejercicios, Interes y participacion)" — un calculo derivado que el sistema presenta en funcion de las otras `PonderacionEvaluacion` de la misma Guia. `crearReferenciaBibliografica/wireframes.puml` no tiene nada equivalente; pide `tipo` y `referencia` punto.

## La asimetria que explica todo

Las reglas **estructurales** se cumplen sin excepciones:
- Patron CRUD y transiciones de diagrama de contexto.
- Filosofia C→U (`crear` delgado, transfiere a `editar`).
- `<<choice>>` correctamente aplicado.
- Separacion de responsabilidades entre `crear/editar/validar`.
- Coherencia con modelo de dominio.
- Correspondencia wireframe ↔ especificacion ↔ diagrama de contexto.

Las reglas **lexicas** no se cumplen: `selecciona` reaparece lote tras lote desde L4. La regla esta escrita, documentada y auditada, pero el metodo no la consolida.

Sugerencia: el metodo vigila bien la **forma del statechart** (lo que romperia compilacion o logica), pero el lexico narrativo de las `note on link` recibe menos atencion porque es texto "invisible" que no rompe nada. Cuando el humano revisa linea a linea (L0-L3), lo caza; cuando el humano aprueba rapido (L7-L8), se erosiona.

## Lo que L8 le dice a miRUP

La prediccion de miRUP (seccion "Los dos pliegues", `protocolo-iteracion.md:310-350`) es que tras 6 milestones limpios acumulados, la region de la pausa se desplaza del humano al LLM. Eso es lo que ha pasado en L8 en lo estructural: el LLM ha producido 10 CU coherentes con el modelo, sin huecos, con un nuevo sub-patron (wireframe de error aritmetico) que no existia antes. El desplazamiento funciona donde el metodo es checkable.

Pero miRUP no contempla que el desplazamiento **erosione** las correcciones menores que dependen de atencion humana linea a linea. Cuanto mas autonomo es el LLM, menos atencion recibe el lexico narrativo. El `riesgo_introducido` baja, pero el **coste de vigilancia lexica** sube en cuanto el humano deja de leer palabra por palabra.

Recomendacion operacional para miRUP: **cuando el desplazamiento es alto (region delegada o cercana), automatizar la verificacion mecanica** (linter lexico en pre-commit, script de barrido `selecciona -> introduce` antes de cerrar lote) para no depender del ojo humano. Las tres lentes que miRUP prescribe ya existen; lo que falta es **ejecutarlas como pipeline automatico** cuando el humano deja de ejecutarlas como inspeccion manual.

Esto enlaza con la `decisiones-descartadas.md` de miRUP, donde se descarto "meter la pausa en el esquema de slots". La pausa no va en slots, correcto, pero el **verificador mecanico de la pausa** si tendria que existir cuando el desplazamiento es alto. Es una mejora a miRUP no contemplada en el PR #2 que abri.

## Veredicto operacional (tercera via)

Ni madurez plena ni relajacion plena. **Madurez estructural con erosion lexica por desplazamiento**.

La estructura, los patrones y la coherencia con el modelo de dominio estan al nivel que cabe esperar de 6 milestones limpios. L8 introduce incluso un nuevo sub-patron (wireframe de error aritmetico) que enriquece el catalogo. Pero la reincidencia en `selecciona` (8 ocurrencias acumuladas, 6 posteriores a la auditoria que lo detecto) demuestra que el **bucle de correccion del lexico no esta cerrado** y que el "poco debate" esconde efectivamente revision insuficiente en ese flanco concreto.

El dato es util porque permite refinar la tesis del autor: el desplazamiento de region funciona donde el modelo es checkable (estructura, CRUD, validacion, coherencia); erosiona donde el modelo es narrativo (lexico, estilo). La formulacion operacional seria:

> **Con requisitado riguroso y milestones limpios acumulados, la delegacion al LLM sube en lo estructural sin degradar calidad, pero requiere compensar la reduccion de vigilancia humana con verificacion mecanica de lo no-estructural.**

Eso es medible, falsable y replicable. Es la refinement que L8 aporta a la tesis principal.

## Prediccion para L9 (ultimo lote)

Segun `RUP/01-requisitos/03-detalle-casos-uso/README.md:190`, L9 cierra el catalogo con 10 CU mas (91 total). Si el patron de L8 se mantiene, L9 tendra:
- ~10 minutos por CU, alta productividad.
- Estructura impecable, nuevos sub-patrones posibles.
- Nuevas fugas de `selecciona` (probabilidad alta si no se mecaniza el barrido).
- Issue de Revision abierta sin cierre inmediato.
- Posible ausencia de PR.

Si se mecaniza el linter lexico antes de L9, las fugas desaparecen. Si no, L9 aniade ~2 ocurrencias mas (estimacion: 1 por cada 5 CU con selectores de FK). La decision es del autor.

---

## ADDENDUM (mismo dia, posterior): correccion del veredicto

El autor me senala la discussion #38 (creada 2026-08-07T15:46:43Z, **antes** del commit L8 a las 18:30:41Z), punto 2, comment 3 (cierre):

> "selector de SistemaEvaluacion (los de la Materia de la AsignaturaGrado de la Guia) mas, para el seleccionado, rango + ya asignado en esta Guia bajo ese SistemaEvaluacion + margen disponible -- recalculado al cambiar el selector."

Las 2 ocurrencias de `selecciona` en L8 no son fuga lexica: **son el verbo tecnico correcto** para operar un selector (dropdown entre opciones preexistentes, no entrada de texto libre). El lexico escrito de 6 verbos no contempla selectores porque cuando se diseno (en discussion #9, durante L0) los formularios eran solo texto/boton. Cuando empezaron a aparecer CU con selectores de FK (L4 en adelante), el verbo `selecciona` se introdujo sin formalizar en el README de la fase.

### Las 8 ocurrencias acumuladas siguen el mismo patron

Revisando las ubicaciones:

- **L4**: `asociarMetodologiaDocenteAMateria:25`, `asociarResultadoAprendizajeAMateria:25` -- seleccionar entidad a asociar.
- **L5**: `crearAsignaturaGrado:33` -- seleccionar Asignatura + Grado.
- **L6**: `asignarProfesorAAsignaturaGrado:25`, `asociarMetodologiaDocenteAAsignaturaGrado:25`, `asociarResultadoAprendizajeAAsignaturaGrado:25` -- asociaciones con selector.
- **L8**: `crearPonderacionEvaluacion:29`, `editarPonderacionEvaluacion:28` -- seleccionar SistemaEvaluacion.

Las 8 ocurrencias son **operacion de selector de FK**. Ninguna es `selecciona` por error donde debia ser `introduce`. La auditoria glm-5.2 previa sobre L4 las marco como desviacion porque comparo contra la regla escrita de 6 verbos; no detecto que la regla practicada ya tenia 7.

### Donde estuvo mi error de auditoria

Juzgue contra la **regla escrita**, no contra el **patron practicado**. La lente mecanica de las tres lentes asume que la regla escrita es la fuente de verdad; cuando el metodo ha evolucionado por practica sin actualizar la regla, la lente mecanica da falsos positivos. Mi propia recomendacion ("linter lexico que reemplace `selecciona -> introduce`") habria sido **destructiva**: habria borrado una distincion semantica real (texto libre vs selector entre opciones preexistentes) por cumplir una regla incompleta.

### Veredicto corregido

El "punto debil recurrente no consolidado" del informe original es falso. L8 esta al nivel de madurez plena que miRUP predice:

- Estructura impecable (patron CRUD, `<<choice>>`, C->U, separacion de responsabilidades, validaciones).
- Nuevo sub-patron (wireframe de error aritmetico con margen recalculado en `crearPonderacionEvaluacion/wireframes.puml:25-49`) que **se debatio y aprueba en discussion #38** antes de codificarse -- no es ad-hoc, es decision cerrada con la metodologia establecida.
- Lexico practicado coherente con el patron de selectores establecido desde L4.

La unica deuda real es **formalizar el septimo verbo en el README de la fase** (`RUP/01-requisitos/03-detalle-casos-uso/README.md:55-63`), no corregir ocurrencias. El linter propuesto en el informe original no debe implementarse: la distincion `introduce` (texto libre) vs `selecciona` (selector de FK) es informacion semantica que conviene preservar.

### Lo que esto le añade a miRUP

La propuesta de "tres lentes de auditoria" del PR #2 necesita un matiz que no tenia: **la lente mecanica debe poder distinguir "violacion de regla escrita" de "uso de regla practicada no escrita"**. Esa distincion requiere cruce con discussions de cierre; sin ese cruce, la lente mecanica proyecta falsos defectos sobre metodos que han evolucionado por practica.

Esto conecta con el principio de no-persistir-derivados de CORRAL-RUP: la regla escrita es un derivado de la practica real; cuando la practica avanza sin actualizar el derivado, la regla escrita queda obsoleta. La lente mecanica pura toma el derivado como fuente de verdad yerra. Hace falta complemento: lente lexica con contexto pragmatico (lectura de discussions de cierre del lote).

### Lo que cambia respecto al debate previo

En el turno 7 del debate sobre la tesis del autor, aposte a que L7-L9 costaria 2-3x L0-L6 por workflow con estado complejo. L7+L8 refutan esa apuesta en **tiempo** (1h 44m para 10 CU). Este addendum refuta la apuesta tambien en **calidad**: no hay erosion ni en estructura ni en lexico. El desplazamiento de region funciona plenamente, sin puntos ciegos detectables.

La tesis del autor gana un punto mas fuerte del que le reconoci en el informe original. La refinacion operacional que proponia ("requiere compensar la reduccion de vigilancia humana con verificacion mecanica de lo no estructural") no aplica aqui: lo no estructural (lexico) esta tan consolidado por practica como lo estructural. Si aplica en general, no se ha manifestado todavia en L8.

### Leccion para el propio metodo de auditoria

Las tres lentes no son suficientes cuando la regla escrita se queda atras de la practicada. Hace falta una cuarta dimension (o un refinamiento de la lente mecanica): **cruce con el registro pragmatico** (discussions de cierre, decisiones del autor) antes de declarar desviacion. Sin ese cruce, la auditoria infravalora el metodo auditado.

Este addendum queda como evidencia del proceso: la auditoria tres-lentes pura, sin contexto pragmatico, produjo un falso positivo que la lectura de una sola discussion (#38) desmonto. La diferencia entre "punto debil recurrente no consolidado" y "metodo en madurez plena con lexico por formalizar" es exactamente esa lectura cruzada.

## Lo que este dato aporta al debate sobre la tesis

En el turno 7 del debate, aposte a que L7-L9 costaria 2-3x L0-L6 por aparicion de workflow con estado complejo. L7 + L8 refutan mi apuesta: 1h 44m para 10 CU de L8 es **mucho menos** de lo que predije. El workflow con estado complejo (Guia con maquina Borrador/EnRevision/Aprobada/Rechazada + PonderacionEvaluacion con aritmetica 100% + ReferenciaBibliografica con enum cerrado) no disparo el tiempo por CU.

Mi apuesta era pesimista. La tesis del autor gana un punto que yo no le daba.

Pero al mismo tiempo, mi advertencia sobre la reduction de vigilancia se confirma parcialmente: el desplazamiento de region erosiona la correccion lexica. Es un matiz nuevo, no una refutacion: la tesis en su forma operacional sigue siendo cierta; lo que se afina es que la delegacion alta requiere compensation mecanica en lo no-estructural.

## Cierre

El "poco debate" del que habla el usuario es real en superficie (menos discussions, menos ping-pong, sin PR en L8) pero no es "sin revision" (issues de Revision abiertas). Es revision sin friccion de cierre. La auditoria tres-lentes muestra que el LLM produce al nivel que miRUP predice bajo desplazamiento de region, pero con un punto ciego (lexico narrativo) que no estaba formalizado en el metodo.

Ese punto ciego es accionable: linter lexico pre-commit. Si el autor lo implementa antes de L9, la proxima auditoria deberia reportar 0 ocurrencias de `selecciona`. Si no, probablemente reportara ~10. Either way, el dato sera empiricamente util para miRUP.
