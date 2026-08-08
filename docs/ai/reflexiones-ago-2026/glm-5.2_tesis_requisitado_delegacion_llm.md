# Tesis del autor: requisitado riguroso vs delegacion al LLM

> Sesion: 2026-08-07. Modelo: glm-5.2 via OpenCode.
> Origen: debate con el autor tras las dos auditorias sobre pyCelda. El autor formula su tesis: "con requisitado riguroso, la programacion es trivial y delegable casi al 100% a un LLM".

## La tesis en su forma literal

"Mi proyecto esta hecho asi a proposito: para demostrar que hecho el requisitado con esta rigurosidad, el desarrollo (la programacion) es trivial y, ahora si, delegable casi al 100% a un LLM."

Blanco critico declarado por el autor: los "vibecoding" y "spec-driven development" del marketing, tildados de "poco precisos" / "hype-driven" (no "mentirosos": esa fue la formulacion conversacional, despues corregida).

## Lo verdadero de la tesis

El requisitado riguroso convierte en triviales varias clases de codigo que normalmente consumen semanas:

1. **Logica de negocio y validaciones.** Con modelo de dominio cerrado (unicidades, enums, aritmetica de suma 100% en enviarGuiaARevision), el codificador no decide: ejecuta.
2. **Workflow de estados.** Maquina Borrador/EnRevision/Aprobada/Rechazada con precondiciones y transiciones especificadas: generacion mecanica.
3. **CRUD sobre catalogo.** 91 CU con vocabulario cerrado a 6 verbos, fichas con wireframes y notas de salida: cualquier LLM con contexto genera endpoints y vistas sin decisiones abiertas.
4. **Tests de aceptacion.** Las fichas de CU son casi literales como Gherkin.
5. **Trazabilidad para verificacion.** Cualquier linea contrastable contra spec original; el pipeline de auditoria que ya funciona sobre `.puml` funciona igual sobre codigo.

Eso cubre el **30-50% del esfuerzo de implementacion**. Es ganancia real, no retorica.

## Lo que el requisitado no cubre

Lo que la spec no contesta, en orden de cuanto sorprende en produccion:

1. **Persistencia.** SQL/NoSQL, schema, indices, migraciones.
2. **API y contrato de transporte.** REST/GraphQL, paginacion, campos devueltos.
3. **Autenticacion y autorizacion.** RBAC/ABAC, sesion, JWT.
4. **Concurrencia y consistencia.** Lock optimist/pessimist, merge, last-write-wins.
5. **Transaccionalidad.** Atomicidad de `crearAsignatura + asignarProfesor`.
6. **Tratamiento de errores e i18n.**
7. **Migracion de datos reales.** El extractor ya choco con 63 variantes; la 835a guia con variante nueva no esta en seed.
8. **Integracion con ecosistema.** "GUIAA (el ERP de la universidad)": sincronizacion, despliegue, backups, observabilidad.

Esa lista la hace el diseno (Analisis -> Diseno en RUP), no el requisitado. Una parte la hace el codigo cuando se descubre que se olvido una decision.

## El extractor.py como prueba parcial

664 lineas exitosas no validan la tesis general: el extractor es **un script unidireccional sin estado** (docx -> json). LLM brilla ahi sin friccion: pipeline puro, sin workflow, sin UI, sin concurrencia, sin autorizacion. pyCelda productivo tendra workflow con maquina de estados, tres actores con permisos distintos, edicion concurrente y generacion de PDF. Eso es otro deporte.

## La hipotesis es testeable

La tesis es prediccion empirica con forma testeable:

- **P1 (confirma).** Implementar L0-L6: tiempo de codificacion por CU < 30 min incluyendo tests.
- **P2 (confirma).** Ratio lineas-espec / lineas-codigo se mantiene alto (>1:3) sin "obviously wrong".
- **P3 (refutaria o matiza).** L7-L9 (Guia con workflow completo): tiempo por CU se dispara. Prediccion mia: 2-3x L0-L6, no 5x.
- **P4 (refutaria).** Aparecen issues de produccion (concurrencia, transaccionalidad, migracion) no reflejadas en ninguna de las 91 fichas.

Apuesta: P1 y P2 se cumplen, P3 se cumple parcialmente, **P4 aparecen entre 3 y 5 issues**. Esas 3-5 issues son el "casi" que queda fuera del 100%.

## La lectura critica del "vibecoding/spec-driven"

La formulacion seria de la critica no es "vibecoding malo" (espantapajos) sino:

> El spec-driven que vende el marketing cubre el **contrato tecnico** (API, schema, persistencia) pero no cubre la **semantica de negocio** (workflow, invariantes, reglas de dominio). La parte que cubren es la facil de delegar; la que no cubren es la que produce los bugs caros. Por eso parece que funciona y luego duele.

Eso es defendible y **falsable**: predice que un proyecto con TypeSpec perfecto pero sin requisitado RUP fallara en semantica de negocio aunque tenga API perfecta. Prediccion concreta que otros pueden comprobar.

## El desconfirmador que el autor declaro

Pregunta: "que contarias como desconfirmacion de tu tesis?". Respuesta del autor: "por eso estoy documentando todo -en el momento que aparece-".

Documentar en el momento es necesario pero no suficiente. Para que la generalizacion sostenga hace falta:

1. **Operacionalizar las definiciones.** Que es "riguroso" (umbral medible), "trivial" (tiempo X, decisiones = 0), "casi 100%" (ratio Y).
2. **Definir linea roja de desconfirmacion.** Que observacion haria decir "mi tesis no se cumple".
3. **Clases de dominio.** Para que software aplica (CRUD+workflow) y para cual no (tiempo real, embebido).
4. **Comparar con rival real, no espantapajos.** TypeSpec, OpenAPI codegen, Buf/gRPC.
5. **Documentar fracasos tambien.** Si solo se registran exitos, la evidencia queda sesgada a confirmacion.

## N=2 y la generalizacion

pyCelda (en curso) + pySigHor (con codigo, 4 stacks) son dos proyectos del mismo autor. La tesis se valida **para su metodo de trabajo**, no para "cualquier desarrollador con LLM". La diferencia entre las dos formulationes es lo que separa "esto funciona para mi" (confirmado con datos primarios) de "esto funcionaria para vosotros" (pendiente de muestra externa).

Laboratorio natural disponible: IDSW1 e IDSW2 (asignaturas del autor). Si alumnos siguen el metodo y se mide su ratio de exito vs vibecoding directo, hay N grande y publiable.

## Veredicto

La tesis es **cierta con calificacion**:

- Verdadera para el 30-50% del codigo: logica de negocio, workflow, CRUD, tests, trazabilidad.
- Falsa o no demostrada para el resto: arquitectura tecnica, decisiones de stack, integracion, fallos en produccion, migracion de datos reales.
- El limite empirico esta documentado por el propio autor en pySigHor art 024: **20 desviaciones diseno-codigo en 5 CU implementadas (~4 decisiones por CU no derivables del analisis)**.

La formulacion fuerte ("programacion trivial, delegable al 100%") es cierta para implementar un diseno ya decidido. Es falsa para decidir el diseno: ahi hay ~4 decisiones por CU que requieren humano dirigiendo al LLM con criterio.

La formulacion operacionalizable seria: **"con requisitado riguroso, la implementacion de un diseno cerrado es delegable al LLM; el diseno sigue requiriendo decisiones humanas (~4 por CU); el analisis queda inmutable"**. Eso es medible y replicable. La tesis en su forma original es mas ambiciosa que esa formulation; la formulation es lo que sobrevive a evidencia.
