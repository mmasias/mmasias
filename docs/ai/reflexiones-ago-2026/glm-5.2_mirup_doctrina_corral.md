# miRUP: doctrina del corral, protocolo de iteracion

> Sesion: 2026-08-07. Modelo: glm-5.2 via OpenCode.
> Origen: lectura de `/home/manuel/misRepos/_ASIGNATURAS/mirup/` (protocolo-iteracion.md, decisiones-descartadas.md). Solicitud del autor de enriquecerlo con lecciones de pyCelda y pySigHor.

## Que es miRUP

Protocolo de iteracion RUP formalizado: 8 pasos (modelo del dominio, casos de uso, detalle+prototipo, estructuracion, analisis, diseno, implementacion, pruebas), con pausas arquitectonicas entre disciplinas, patrón de delegabilidad, espacio de gobierno humano/LLM con tres regiones (delegada, retenida, banda) y reglas de transicion definidas por pliegues sobre datos derivables.

Inspirado en Luis Fernandez Munoz. Es **procedimiento concreto**, no framework abstracto.

## Lo solido

1. **Formaliza lo tacito sin traicionarlo.** Convertir el "instinto del director" en reglas con criterios de entrada/salida y contraindicaciones explicitas. La estructura "¿que produces / desde donde derivas / hacia quien traza / cuando cierras?" en cada disciplina es la unidad minima correcta.

2. **El patron de delegabilidad es la pieza de mayor valor.** Distincion esqueleto/integracion (no delegable: A1, D1, I1, A4, D4, I2) vs relleno (delegable: A2, D2, I3). Generalizable mas alla de RUP. Cualquier disciplina con esqueleto + fan-out + fan-in cabe en el.

3. **`decisiones-descartadas.md` es madurez de ingenieria.** Documentar qué se considero y se descarto (con razon) evita la rediscusion eterna. Equivalente metodologico de un archivo de ADRs bien llevado.

4. **El principio de no persistir derivados.** Region y riesgo se recalculan por replay, no cacheados. Evita dos fuentes de verdad. Coste nulo (5 valores por ramillete).

5. **La divergencia humano/CORRAL explicita en tres puntos.** Retroceso, correspondencia ramillete-iteracion, quien ejecuta la pausa. Honestidad operacional.

6. **La tesis contra el vibecoding es correcta.** El vibecoding delega sin pausas, sin atribucion y sin criterio de cierre. miRUP ataca los tres puntos: puertas discretas entre fases (pausa arquitectonica), atribucion de defectos al origen aguas arriba (regla de validacion entre disciplinas), cierre validado por milestone ternario.

## Lo cuestionable

1. **Es un documento, no un sistema.** No hay registry, no hay tooling que verifique "esta pausa esta en region X, este ramillete acumula riesgo Y". La sofisticacion de las reglas (herencia monotona de riesgo, residencia_min, anti-colapso) se aplica de oido y se erosiona. Falta una encarnacion verificable: registry CORRAL-RUP con comprobador que lea frontmatters de pausa y valide transiciones.

2. **La "banda como area difusa" es elegante en abstracto, pero toda pausa concreta se resuelve discreta.** En cada pausa, el orquestador esta en una region operativa concreta. Decir "es un area" describe el espacio de diseno, no la ejecucion. Util como advertencia contra falsa precision, pero operationally cada pausa es un punto.

3. **La sofisticacion de la regla de transicion puede ser desproporcionada al uso real.** Tres regiones, herencia monotona, residencia_min = {1,2,3}, anti-colapso con suelo absoluto en uno, replay path-dependent sobre milestones limpios. Es un modelo formal rico. Conviene aplicarlo a 3-4 ramilletes reales y ver si las distinciones finas discriminan o un esquema mas simple captura el 90%.

4. **Gestion de configuracion y gestion de proyecto fuera sin tratamiento.** El comentario HTML final del `protocolo-iteracion.md` lo admite. Son las disciplinas de soporte RUP y las que mas friccion tienen con el modo agentico: quien commitea, como se versionan los transversales, qué hace el orquestador cuando dos ramilletes tocan el mismo diagrama de clases de diseno. Es el punto abierto mas relevante.

5. **Le falta caso aplicado canonico.** El propio `decisiones-descartadas.md:27` lo apunta: "Corregir editarAula / crearEdificio para usarlo de ejemplo canonico. Descartado a favor de elegir un ramillete que cierre limpio". Sin ese ramillete canonico, miRUP es teoria pura y quien entra frio se pierde. pyCelda puede producirlo cuando llegue a L7-L8.

6. **Mezcla miRUP+CORRAL-RUP en un fichero.** El autor lo defiende por decision explicita. Funciona ahora; cuando el documento crezca (con pruebas, GC/GP) se hara dificil navegar. La opcion de separar esta en standby; conviene revisitarla antes de que el fichero pase de 1500 lineas.

## Lo que aporte a miRUP desde pyCelda y pySigHor (PR #2)

Siete mejoras propuestas, cada una en su commit atomico, sobre rama `enriquece-desde-pycelda`:

1. **Tres lentes de auditoria** (mecanica, logica, ausencia) en espacio de gobierno.
2. **Calibracion empirica de `riesgo_introducido(diseno)`** anclada al dato pySigHor (~4 decisiones por CU).
3. **Validacion del modelo del dominio contra corpus real** cuando exista.
4. **Trazabilidad de autoria de ideas** (humano / LLM-A / LLM-B) en la pausa.
5. **Dashboard de seguimiento** como artefacto transversal.
6. **Analisis inmutable respecto al stack** (leccion pySigHor articulada).
7. **Entradas en `decisiones-descartadas.md`** sobre lo que se dejo fuera (nivel playbook).

De las siete, la #2 (calibracion empirica) viola la propia regla del autor (`decisiones-descartadas.md:29`: "no elevar a principio con una sola instancia") porque la elevo con una sola instancia (pySigHor art 024). Si el autor aplica su metodo, deberia rechazar ese commit o matizarlo. Lo senale en el PR.

La #4 (trazabilidad de autoria) es la mas exigente: en ping-pong entre varios LLMs la atribucion fina de "quien propuso esto" se difumina. Puede quedar como aspiracional mas que como regla operativa.

## Veredicto

Spec metodologico ambicioso, internamente coherente, con una tesis clara contra el vibecoding. Su debilidad estructural no es de contenido sino de **encarnacion**: hasta que no tenga un registry verificable y 3-4 ramilletes reales que lo ejerciten de punta a punta, sigue siendo una propuesta elegante sin evidencia de que las distinciones finas discriminan mejor que un esquema mas simple.

**La prioridad deberia ser aplicarlo, no seguir refinandolo.** pySigHor lo ha ejercitado parcialmente; pyCelda tiene la oportunidad de aplicarlo de punta a punta con disciplina de registro (ratio tiempo-requisitado / tiempo-codigo, desviaciones diseno-codigo). Cuando eso ocurra, miRUP pasa de propuesta a metodo probado.

Como doctrina, miRUP es la respuesta responsable al vibecoding: formaliza lo que el director humano hace por instinto en reglas que un LLM puede seguir. Sin esta doctrina, CORRAL es infraestructura para vibecoding mas elaborado; con ella, CORRAL se vuelve runtime para procedimientos auditables.
