# QA en el proceso de software: límites y responsabilidades

> Charla 1 de 2 para FUNIBER. Sesión de 20 minutos. Audiencia: equipo completo (devs + QA).

> "No existe ninguna otra actividad de pruebas que produzca una detección y corrección de errores de forma más eficiente (inversión/ahorro de tiempo y coste) que las pruebas estáticas basadas en revisiones."
> — C. Kaner, J. Falk, H.Q. Nguyen, *Testing Computer Software*

## ¿Por qué?

Un fallo que llega a producción no es una anécdota puntual, es un fallo silencioso que finalmente hizo ruido, demasiado tarde. RUP separa el rol "Ingeniero de pruebas" del "Ingeniero de componentes" por una razón de diseño, no burocrática: quien construye algo no puede ser el único juez de que está bien construido. Esa es la motivación entera de por qué QA existe como función independiente y no como "el desarrollador que prueba al final".

## ¿Qué?

Primera precisión, incómoda a propósito: RUP no tiene ninguna disciplina llamada "QA". Lo que corre en paralelo a Análisis, Diseño e Implementación es la **Disciplina de Pruebas** (Test), y eso es Control de Calidad (QC), no Aseguramiento de Calidad (QA). QC detecta defectos en el producto ya construido. QA previene mejorando el proceso que lo construye. Son categorías distintas, no sinónimos con nombre bonito.

Con esa precisión hecha, el límite de responsabilidad concreto ya está en el propio RUP, actividad "Realizar Pruebas de Integración":

> "Informe los defectos **al ingeniero de componentes**, que es responsable de los componentes que probablemente contengan la falla" frente a "Informar los defectos **a los diseñadores de pruebas**, quienes luego utilizan los defectos para evaluar los resultados generales del esfuerzo de prueba."

Traducido a los dos roles de esta sala:

- **QA diagnostica**: reproduce, aporta evidencia, clasifica severidad/prioridad, no propone la solución técnica.
- **Desarrollador repara**: dueño del código, dueño del arreglo.

Vocabulario que necesitan compartir para que esto no sea ambiguo:

| Término | Qué es | Confusión habitual |
|---|---|---|
| QA *vs* <br>QC *vs* <br>Testing | QA = proceso (prevenir defectos).<br>QC = producto (detectarlos).<br>Testing = técnica de QC. | Llamar "QA" a "los que testean" ya es síntoma de falta de rigor. |
| Verificación *vs* <br>Validación | Verificación: ¿construimos el producto correctamente?<br>Validación: ¿construimos el producto correcto? | Pasar el 100% de los tests y entregar algo inútil: falla la validación, no la verificación. |
| Defecto *vs*<br>Fallo | Defecto: error en el artefacto.<br>Fallo: su manifestación observable en ejecución. | Un defecto puede vivir meses sin fallar. No detectarlo no es "no pasa nada", es un fallo silencioso en espera. |
| Severidad *vs*<br>Prioridad | Severidad: impacto técnico.<br>Prioridad: urgencia de negocio. | Se mezclan constantemente al priorizar la lista de defectos pendientes. |

## ¿Para qué?

Separar diagnóstico de reparación evita que el límite se disuelva junto con la responsabilidad de quién responde de qué. Y resuelve, de raíz, el problema real: **"ya lo he probado" dicho por un desarrollador no es evidencia, es una afirmación.** Verificar con evidencia directa antes de dar algo por bueno no es desconfianza personal, es el motivo por el que el rol de pruebas existe como rol separado. Dicho más corto: **más vale prevenir que currar.**

## ¿Cómo?

Sin anestesia, esto es lo que rompe el límite en un equipo sin rigor, dicho en voz alta con ejemplos reconocibles:

- Pruebas solo al final, todo de golpe, que contradice la naturaleza iterativa del propio proceso que siguen.
- Reportes de defecto sin pasos de reproducción ni evidencia (capturas, logs, entorno).
- Sin trazabilidad caso de uso -> caso de prueba: nadie sabe qué parte del sistema no se ha tocado.
- Criterios de entrada/salida inexistentes o informales ("cuando esté tranquilo lo paso a producción").
- QA proponiendo el arreglo técnico, o el desarrollador decidiendo unilateralmente qué no hace falta probar.

Un equipo con este límite claro, en cambio, **rara vez** discute en la incidencia quién tiene la culpa, **rara vez** repite la pregunta "¿esto es tuyo o mío?", y **rara vez** descubre en producción algo que ya sabía que no había probado.

## ¿Y ahora qué?

> "Las buenas prácticas no son suficientes por sí mismas, tienen que entenderse bajo un conjunto de valores y principios que permiten al equipo comportarse como una unidad con un objetivo común."
> — Kent Beck, *Extreme Programming Explained*

Turno de dudas y preguntas. Cierre puente a la charla 2: un fallo en producción no es un fracaso del desarrollador ni de QA individualmente, es que el proceso no hizo ruido a tiempo. Eso se audita, no solo se cierra la incidencia.

---

**Fuentes de la cita RUP**: tabla de roles en `idsw1/temario/00002-rup.md`; actividad "Realizar Pruebas de Integración" en el material de Luis (`3-publicaciones/USantaTecla/5-rup/5-pruebas`), adaptación directa del Rational Unified Process; corroborado externamente por OpenUP (Eclipse Process Framework, derivado abierto oficial de RUP), que define **Developer** y **Tester** como roles separados.
