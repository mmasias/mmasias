# Joel test

## ¿Por qué?

- Las prácticas de desarrollo de software son fundamentales para la calidad del producto final
- En 2000, no existía una forma simple de evaluar estas prácticas
- Las metodologías existentes (como CMM) eran demasiado complejas para evaluaciones rápidas

## ¿Qué?

- El Joel Test es una lista de 12 preguntas binarias (sí/no) creada por [Joel Spolsky](https://es.wikipedia.org/wiki/Joel_Spolsky)
- Cada respuesta positiva suma un punto, con una puntuación máxima de 12
- Un equipo con menos de 10 puntos probablemente tiene problemas serios
- Las preguntas abarcan control de versiones, pruebas, entorno de trabajo y procesos

## ¿Para qué?

- Evaluar rápidamente la madurez de un equipo de desarrollo
- Identificar áreas de mejora en los procesos de desarrollo
- Establecer estándares mínimos de calidad en equipos de software
- Servir como guía para mejorar prácticas de desarrollo

## ¿Cómo?

|Pregunta|Reflexión|
|-|-|
|¿Usas control de versiones?|El control de versiones es fundamental. En 2000 no era universal, pero hoy es impensable no usar Git u otra herramienta similar. Permite colaboración, seguimiento de cambios y recuperación ante errores. Su ausencia es una señal clara de problemas serios en el proceso de desarrollo.|
|¿Puedes hacer una compilación en un solo paso?|La compilación debe ser reproducible y automatizada. Si requiere pasos manuales o documentación extensa, hay riesgo de errores y pérdida de tiempo. Las herramientas modernas de CI/CD han hecho esto más accesible, pero sigue siendo un indicador válido de madurez.|
|¿Haces compilaciones diarias?|Las compilaciones diarias han evolucionado hacia integración continua. La pregunta sigue siendo relevante, pero el estándar actual es mucho más frecuente. No tener al menos compilaciones diarias indica problemas serios de integración y calidad.|
|¿Tienes una base de datos de errores?|El seguimiento sistemático de errores es crucial para la calidad. Va más allá de una simple lista: debe incluir priorización, asignación y seguimiento. Las herramientas modernas como Jira han expandido esto a gestión completa de proyectos.|
|¿Corriges los errores antes de escribir código nuevo?|La deuda técnica puede acumularse rápidamente si se ignoran los errores. Esta práctica refleja la disciplina del equipo y su compromiso con la calidad. Es especialmente relevante en desarrollo ágil, donde cada iteración debe entregar valor sin arrastrar problemas.|
|¿Tienes un calendario actualizado?|La planificación y visibilidad son esenciales. El calendario debe ser realista y mantenerse actualizado. Las metodologías ágiles han cambiado el enfoque hacia sprints y entregas incrementales, pero la necesidad de planificación persiste.|
|¿Tienes especificaciones (claras)?|Las especificaciones claras son la base de un desarrollo exitoso. Han evolucionado desde documentos formales hacia historias de usuario y criterios de aceptación, pero su importancia para alinear expectativas y guiar el desarrollo sigue siendo crítica.|
|¿Los programadores tienen un ambiente tranquilo de trabajo?|El entorno afecta directamente la productividad. Con el trabajo remoto, esta pregunta se extiende al espacio personal. Un ambiente sin interrupciones constantes es esencial para tareas complejas que requieren concentración profunda.|
|¿Usas las mejores herramientas que el dinero puede comprar?|Las herramientas adecuadas multiplican la productividad. No se trata solo de comprar lo más caro, sino de proporcionar lo necesario para trabajar eficientemente. El costo de herramientas inadecuadas supera ampliamente el ahorro en su adquisición.|
|¿Tienes testers?|El testing profesional aporta una perspectiva única y valiosa. Aunque los desarrolladores deben hacer testing, los testers dedicados aseguran cobertura completa y calidad. Las prácticas modernas integran QA en el proceso de desarrollo desde el inicio.|
|¿Los nuevos candidatos escriben código durante su entrevista?|La evaluación práctica es esencial en la contratación. El código real muestra habilidades que no se reflejan en el CV o preguntas teóricas. Las pruebas técnicas deben ser relevantes y representativas del trabajo real.|
|¿Haces pruebas de usabilidad?|El feedback de usuarios reales es invaluable. Las pruebas informales complementan el testing formal y proporcionan perspectivas inesperadas. En la era digital, estas pruebas pueden realizarse remotamente, pero mantienen su importancia.|

- Se responde cada pregunta con un sí (1 punto) o no (0 puntos)
- Las respuestas deben ser honestas y reflejar la realidad actual del equipo
- La evaluación puede realizarse en pocos minutos
- Los resultados pueden usarse para crear planes de mejora priorizando las áreas con respuestas negativas
- Se recomienda reevaluar periódicamente para medir el progreso

