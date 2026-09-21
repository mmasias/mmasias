# QA: visión, responsabilidades y batería de preguntas

> Charla 2 de 2 para FUNIBER. Sesión de 20 minutos. Audiencia: solo equipo QA.

> "Si la mayoría de los proyectos de tu organización son obsesivamente cortos, proyectos conducidos por el calendario, hay algo muy, muy malo. Cambios radicales en la organización del proceso de desarrollo software son necesarios, antes de que la compañía o su gente se arruine."
> — Booch, *Object Solutions*

## ¿Por qué?

"Si no vas a velocidad límite, alguien lo hará y se comerá tu comida" (Kent Beck). La presión de velocidad es real y no va a desaparecer porque ustedes la señalen. Precisamente por eso el valor de QA no es "encontrar más defectos que nadie": es ser el punto de la organización cuyo criterio no está capturado por los mismos incentivos que sacaron el código con prisa a producción. Esa independencia es el producto que venden, no la habilidad técnica de testear.

## ¿Qué?

Primero, la incomodidad de vocabulario que nadie les dijo: RUP no tiene ninguna disciplina llamada "QA". Lo que ustedes ejecutan es la **Disciplina de Pruebas**, y eso es Control de Calidad (QC): detecta defectos en el producto ya construido. Aseguramiento de Calidad (QA) es otra cosa, previene mejorando el proceso, y en RUP vive repartido en el propio diseño iterativo (evaluación de iteración), en Gestión de Proyecto (gestión de riesgo) y en Entorno (guías, plantillas, el "caso de desarrollo"). Se llaman "equipo QA" por costumbre de la industria, no porque ejerzan QA.

Dicho eso, la visión sin anestesia: si quieren de verdad ejercer QA y no solo la Disciplina de Pruebas disfrazada de QA, **no basta con auditar el código, hay que auditar el juicio que lo produjo, y también el proceso que dejó pasar ese juicio sin revisar.** ¿El desarrollador entendió el criterio de aceptación real, o solo compiló el camino feliz? Si se limitan a ejecutar una lista de casos mecánicamente, sin cuestionar si esos casos son los que importan, ni siquiera QC hacen bien, es una función decorativa.

Responsabilidades concretas, tomadas de las actividades reales de la disciplina de pruebas (no inventadas):

- Planificar pruebas: estrategia, alcance, riesgos a cubrir, no solo "qué voy a clicar".
- Diseñar pruebas con trazabilidad explícita a requisitos/casos de uso.
- Definir y hacer cumplir criterios de entrada/salida.
- Pruebas de integración y de sistema (las de unidad son responsabilidad del desarrollador).
- Evaluar pruebas: informe de riesgo residual, no un simple semáforo verde/rojo.

Sobre ese último punto, la advertencia es vieja y sigue vigente:

> "Me esperaba un alto nivel de cobertura (80%-90%)! A veces los gerentes requieren una. Hay una diferencia sutil."
> — Brian Marick

El semáforo en verde de una batería de pruebas no certifica nada por sí mismo si nadie audita qué cubre y qué deja fuera. Y evaluar pruebas a veces significa decir lo que nadie quiere firmar:

> "No parchear, reescribirlo. A menudo, puede ser mucho más barato y menos doloroso tirar un fragmento de código que tiene un montón de errores y reescribirlo desde cero."

## ¿Para qué?

Cada responsabilidad de la lista existe para producir algo medible: trazabilidad completa (saber qué NO se está probando ahora mismo), un criterio de salida que no vive solo en la cabeza de alguien y una métrica propia de la función, la **fuga de defectos** (porcentaje de defectos que se detectan en producción en vez de antes), que mide si QA está haciendo su trabajo, no solo cuántos defectos encontró.

## ¿Cómo?

Formato taller, no charla: lanzar cada pregunta y dejar que incomode antes de seguir a la siguiente.

- ¿Quién decide que una funcionalidad está "hecha", ustedes o quien la programó?
- Un "ya lo he probado" de un desarrollador, ¿es evidencia que aceptan o una afirmación que verifican?
- ¿Pueden nombrar, ahora mismo, qué parte del sistema no tiene ningún caso de prueba asociado?
- Cuando encuentran un defecto, ¿lo diagnostican o ya proponen el arreglo? ¿Dónde se cruza esa línea en su día a día?
- ¿Cuál es su criterio de salida por escrito? Si no existe, ¿quién lo decide y con qué criterio?
- Del último fallo grave que llegó a producción, ¿se auditó qué parte del proceso no hizo ruido, o solo se cerró la incidencia?

## ¿Y ahora qué?

Cierre con la pregunta más incómoda, dejada abierta a propósito: "si mañana desaparecieran como equipo, ¿qué es lo que dejaría de pasar que hoy da por hecho la organización?" Sin respuesta clara y compartida a eso, la función de QA no está justificando su lugar en el proceso.

---

**Fuentes de las citas**: C. Kaner / J. Falk / H.Q. Nguyen (*Testing Computer Software*), Brian Marick, Kent Beck (*Extreme Programming Explained*) y Booch (*Object Solutions*), tal como aparecen citados como epígrafes en el material de Luis (`3-publicaciones/USantaTecla/4-pruebas`, `5-rup/6-gestion` y `6-agiles/3-eXteProgramming`). El aforismo sobre reescribir vs. parchear es afirmación propia de Luis en `5-rup/5-pruebas`, actividad "Evaluar Pruebas".
