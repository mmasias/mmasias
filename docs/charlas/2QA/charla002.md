# QA: visión, responsabilidades y batería de preguntas

> Charla 2 de 2 para FUNIBER. Sesión de 20 minutos. Audiencia: solo equipo QA.

> "Si la mayoría de los proyectos de tu organización son obsesivamente cortos, proyectos conducidos por el calendario, hay algo muy, muy malo. Cambios radicales en la organización del proceso de desarrollo software son necesarios, antes de que la compañía o su gente se arruine."
> — Booch, *Object Solutions*

## ¿Por qué?

"Si no vas a velocidad límite, alguien lo hará y se comerá tu comida" (Kent Beck). La presión de velocidad es real y no desaparece porque un equipo de QA la señale. Precisamente por eso el valor de QA no es "encontrar más defectos que nadie": es ser el punto de la organización cuyo criterio no está capturado por los mismos incentivos que sacaron el código con prisa a producción. Esa independencia es lo que una función de QA vende, no la habilidad técnica de testear.

Esa independencia no depende de que unas personas sean mejores probando que otras -- depende de que quien verifica no tenga el mismo interés en que la respuesta salga bien. Un ejemplo real, entre dos sesiones de un mismo proyecto con el mismo nivel técnico: una construía siguiendo el encargo de otra, y en vez de asumir un dato de ese encargo, fue a comprobarlo contra el código real -- y encontró que el encargo tenía un supuesto equivocado. No fue una cuestión de jerarquía ni de quién sabía más: fue que a esa sesión, en ese momento, le tocaba el papel de comprobar antes de construir, y lo hizo. La estructura produjo la verificación; nadie confió en que "seguro que alguien se dará cuenta".

## ¿Qué?

Primero, la incomodidad de vocabulario que nadie les dijo. Tres términos que no son sinónimos:

<div align=center>

|Calidad|Garantía de calidad (QA)|Control de calidad (QC)|
|-|-|-|
|Apto para el uso o propósito: satisfacer las necesidades y expectativas del cliente (funcionalidad, diseño, confiabilidad, durabilidad, precio). |Una declaración positiva que da confianza: la certeza de que un producto o servicio funcionará bien según lo esperado. |El conjunto de mecanismos, acciones y herramientas realizados para detectar la presencia de errores. |

</div>

RUP no tiene ninguna disciplina llamada "QA". Lo que un equipo de pruebas ejecuta es la **Disciplina de Pruebas**, y eso es QC: detecta defectos en el producto ya construido, no da garantías sobre el proceso que lo produjo. Se llaman "equipo QA" por costumbre de la industria, no porque ejerzan QA.

Si un equipo quiere de verdad ejercer QA y no solo la Disciplina de Pruebas disfrazada de QA, **no basta con auditar el código, hay que auditar el juicio que lo produjo, y también el proceso que dejó pasar ese juicio sin revisar.**

¿El desarrollador entendió el criterio de aceptación real, o solo compiló el camino feliz?

Los equipos que se limitan a ejecutar una lista de casos mecánicamente, sin cuestionar si esos casos son los que importan, ni siquiera QC hacen bien: es una función decorativa.

Esa pregunta -- ¿son los casos que importan? -- es la diferencia entre verificar (hacerlo correcto: el código cumple lo que el propio código promete) y validar (hacer lo correcto: eso era lo que realmente hacía falta). No son alternativas, hace falta responder las dos: una suite entera en verde certifica lo primero, nunca lo segundo.

## ¿Para qué?

Las actividades de QA detalladas en ¿Cómo? existen para producir algo medible: trazabilidad completa (saber qué NO se está probando ahora mismo), un criterio de salida que no vive solo en la cabeza de alguien y una métrica propia de la función, la **fuga de defectos** (porcentaje de defectos que se detectan en producción en vez de antes), que mide si QA está haciendo su trabajo, no solo cuántos defectos encontró.

## ¿Cómo?

QA no es un estado, es un ciclo. El ciclo de Deming aplicado al proceso de software:

<div align=center>

| Planificar | Hacer | Verificar | Actuar |
|---|---|---|---|
| Definir los objetivos de proceso y qué se requiere para entregar un producto final de alta calidad. | Desarrollar y probar procesos, no solo código. | Monitorear los procesos y verificar si cumplen los objetivos predeterminados. | Implementar las acciones necesarias para lograr mejoras en los procesos. |

</div>

Traducido a actividades concretas: **auditoría de calidad, definición de procesos, selección de herramientas, capacitación en estándares.** Nada de eso está en el día a día de la mayoría de "equipos QA", y por eso lo que hacen hoy es QC, no QA, por mucho que diga su tarjeta de presentación.

Responsabilidades concretas, tomadas de las actividades reales de la disciplina de pruebas (no inventadas):

- Planificar pruebas: estrategia, alcance y riesgos a cubrir, no la simple ejecución mecánica de casos.
- Diseñar pruebas con trazabilidad explícita a requisitos/casos de uso.
- Definir y hacer cumplir criterios de entrada/salida.
- Pruebas de integración y de sistema (las de unidad son responsabilidad del desarrollador).
- Evaluar pruebas: informe de riesgo residual, no un simple semáforo verde/rojo.

Matiz real, de un proyecto que no encaja en el reparto clásico de la lista anterior: en un caso reciente, la suite entera (más de 700 casos) no tiene ni un solo test unitario con dependencias sustituidas por dobles -- todo es integración real contra una base de datos real, incluidos los tests que escribe quien construye. Ahí la frontera no puede trazarse por nivel (unidad vs. integración) porque el nivel unidad casi no existe: se traza por quién verifica sin interés en que el resultado salga bien. Es la misma idea de fondo, aplicada donde la división por nivel deja de servir.

Sobre ese último punto, la advertencia es vieja y sigue vigente:

> "Me esperaba un alto nivel de cobertura (80%-90%)! A veces los gerentes requieren una. Hay una diferencia sutil."
> — Brian Marick

El semáforo en verde de una batería de pruebas no certifica nada por sí mismo si nadie audita qué cubre y qué deja fuera. Y evaluar pruebas a veces significa decir lo que nadie quiere firmar:

> "No parchear, reescribirlo. A menudo, puede ser mucho más barato y menos doloroso tirar un fragmento de código que tiene un montón de errores y reescribirlo desde cero."

- ¿Quién decide que una funcionalidad está "hecha": el equipo de QA o quien la programó?
- Un "ya lo he probado" de un desarrollador, ¿es evidencia que el equipo acepta, o una afirmación que verifica?
- ¿Puede el equipo nombrar, ahora mismo, qué parte del sistema no tiene ningún caso de prueba asociado?
- Cuando se encuentra un defecto, ¿se diagnostica o ya se propone el arreglo? ¿Dónde se cruza esa línea en el día a día del equipo?
- ¿Cuál es el criterio de salida por escrito del equipo? Si no existe, ¿quién lo decide y con qué criterio?
- Del último fallo grave que llegó a producción, ¿se auditó qué parte del proceso no hizo ruido, o solo se cerró la incidencia?
- ¿El equipo confirma un despliegue con evidencia propia (el sistema real, los logs, los commits), o da por bueno el reporte de quien lo hizo?

## ¿Y ahora qué?

"Si el equipo de QA desapareciera mañana, ¿qué es lo que dejaría de pasar que hoy da por hecho la organización?" Sin respuesta clara y compartida a eso, la función de QA no está justificando su lugar en el proceso.

---

**Fuentes de las citas**: Brian Marick, Kent Beck (*Extreme Programming Explained*) y Booch (*Object Solutions*), tal como aparecen citados como epígrafes en el material de Luis (`3-publicaciones/USantaTecla/4-pruebas`, `5-rup/6-gestion` y `6-agiles/3-eXteProgramming`). El aforismo sobre reescribir vs. parchear es afirmación propia de Luis en `5-rup/5-pruebas`, actividad "Evaluar Pruebas".

**Fuente de la tabla Calidad/QA/QC y el ciclo de Deming**: apartado "Gestión de Calidad Software" del material de Luis (`3-publicaciones/USantaTecla/4-pruebas/0-itinerario`, sección ¿Cómo?).
