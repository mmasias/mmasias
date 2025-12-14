# Metodología integrada de enseñanza en ingeniería informática

Enseñar programación como se trabaja en la realidad, no como piden los exámenes tradicionales

## ¿Por qué?

### Lo que no funciona

Hay una contradicción que vemos todos: enseñamos a resolver problemas complejos, a tomar decisiones de diseño, a argumentar soluciones técnicas... pero luego evaluamos con exámenes que miden memorización y reproducción de patrones en un contexto artificial.

### Tres síntomas del mismo problema

|Desconexión entre práctica y evaluación|Simulación vs. competencia real|Facilidad de fraude, dificultad de evidencia|
|-|-|-|
Los estudiantes pasan semanas desarrollando código, cometiendo errores específicos, evolucionando su comprensión.|En contextos profesionales, los ingenieros raramente escriben código desde cero sin restricciones.|Exámenes idénticos invitan a soluciones idénticas.
El examen final ignora completamente esta trayectoria individual y presenta un problema genérico desde cero.|Mantienen código existente, revisan implementaciones ajenas, justifican decisiones técnicas, depuran código heredado. |La detección de plagio se dificulta porque las respuestas correctas son necesariamente similares.
No existe relación entre lo que hicieron y lo que deben demostrar.|Pero evaluamos la capacidad de escribir código nuevo en papel, sin documentación, sin herramientas, sin colaboración.|Mientras tanto, el estudiante que realmente comprende no tiene forma de diferenciarse del que memorizó patrones.

### La llegada de los LLMs: ¿crisis o confirmación?

Cuando ChatGPT apareció en noviembre 2022, muchos docentes lo vivieron como crisis existencial. Si la IA podía generar código funcional en segundos, ¿cómo evaluar programación?

Pero esta "crisis" solo afecta a quien evaluaba mediante ejercicios genéricos de código. Si el examen consiste en "implementar un algoritmo de ordenamiento", efectivamente, ChatGPT lo resuelve en 10 segundos.

La pregunta real no es *¿cómo evitar que usen IA?* sino *¿por qué nuestro sistema de evaluación se vuelve inútil cuando los estudiantes tienen acceso a herramientas modernas?*

Esto es porque no evaluamos comprensión real, sino capacidad de reproducir patrones en contexto controlado.

### La idea base

Si un estudiante no puede explicar, defender y modificar el código que entrega, **ese código no demuestra aprendizaje**. Independientemente de cómo se haya generado.

Esta idea no nace con ChatGPT. Es la base de la competencia profesional en ingeniería: la responsabilidad técnica no se delega.

## ¿Qué?

### Tres ideas que se refuerzan entre sí

Lo que hacemos en el grado de Ingeniería Informática de UNEATLANTICO se basa en tres pilares complementarios:

<div align=center>

|Proceso sobre producto|Trazabilidad|Evaluación basada en defensa|
|-|-|-|
El aprendizaje ocurre durante la creación, no solo en el resultado final. Se captura, documenta y evalúa el proceso completo de desarrollo, no únicamente la entrega final.|Cada decisión, cada iteración, cada modificación queda registrada con autor, momento y contexto. El repositorio se convierte en fuente de verdad sobre qué produjo cada estudiante, cuándo y cómo evolucionó.|En lugar de exámenes genéricos idénticos para todos, cada estudiante defiende su propio código, explica sus decisiones, justifica sus soluciones y demuestra capacidad de modificación en vivo.

</div>

Estos pilares los veníamos aplicando **antes de que apareciera ChatGPT**, pero resultan naturalmente resistentes al uso indiscriminado de IA.

## ¿Para qué?

### ¿Qué buscamos?

#### Que sepan hacer lo que hacen los profesionales de verdad

- Capacidad de revisar y mantener código (propio y ajeno)
- Habilidad de justificar decisiones técnicas ante clientes y pares
- Competencia de modificar implementaciones ante nuevos requisitos
- Responsabilidad sobre el código producido

#### Distinguir quien *entiende* de quien *memoriza*

- Identificar quién realmente comprende vs. quién memorizó patrones
- Detectar cuando alguien entrega código que no entiende (sea de IA, compañeros o internet)
- Valorar la evolución del pensamiento, no solo el resultado final

#### Hacer que copiar no tenga sentido

- Cada examen es único porque deriva del código único de cada estudiante
- Copiar código de otro se vuelve un problema: te examinan sobre código que no entiendes
- Las revisiones continuas detectan cuando el estilo de código cambia repentinamente

#### Preparar para la realidad profesional (con IA)

- Usar IA como herramienta legítima, con responsabilidad sobre el output
- Documentar el proceso de creación, no solo el producto
- Demostrar capacidad de auditar, corregir y extender código generado

### Resultados observables

|Para los estudiantes|Para los docentes|Para la institución|
|-|-|-|
|Mayor conexión entre práctica y evaluación|Detección automática de entregas y su temporalidad|Integridad académica estructural, no dependiente de vigilancia
|Incentivo para comprender profundamente en lugar de memorizar|Evaluación personalizada a escala (50 exámenes únicos en 3 horas)|Metodología replicable y documentada
|Desarrollo de pensamiento crítico sobre código propio|Feedback continuo mediante revisiones de código|Adaptación natural a nuevas herramientas (LLMs, copilots, etc.)
|Preparación realista para entornos profesionales|Trazabilidad completa para casos de disputa académica|Evidencia de aprendizaje más allá de calificaciones numéricas

## ¿Cómo?

### Pilar 1: Captura del proceso de creación

#### Git no es solo para entregar trabajos

Los repositorios Git no son un simple buzón de entregas. Son la herramienta que captura todo el proceso de aprendizaje.

Cada asignatura opera sobre un repositorio central (ej: `mmasias/25-26-PRG1`) donde los estudiantes:

1. Crean copias personales a partir del repositorio principal (*forks*)
1. Desarrollan soluciones en su espacio
1. Envían entregas (*pull requests*)
1. Reciben revisiones del docente
1. Iteran basándose en feedback

El historial captura automáticamente:

- Código final de cada entrega
- Evolución temporal (entregas sucesivas *commits*)
- Versiones previas (historial de cambios)
- Contexto (comentarios en *pull requests*)
- Interacciones con el docente

#### Documentación activa del proceso

No se evalúa solo el código final. Se analiza:

- ¿Cómo evolucionó la solución? (commits incrementales vs. commit único final)
- ¿Qué decisiones se tomaron? (mensajes de commit descriptivos)
- ¿Cómo respondió al feedback? (iteraciones tras code review)
- ¿Qué patrones personales desarrolló? (estilo consistente a lo largo del tiempo)

Esta documentación permite distinguir:

- Trabajo incremental genuino vs. entrega de última hora
- Comprensión progresiva vs. código generado externamente
- Evolución de habilidades vs. estancamiento

### Pilar 2: Automatización del seguimiento

#### Sistema de control de entregas

Herramientas desarrolladas: funciones `verificaPR()` y `hayComentarios()` integradas en Google Sheets.

Capacidades:

- Verificación automática de entregas en plazo
- Detección de entregas tardías
- Confirmación de revisiones del docente
- Generación de enlaces directos a cada entrega
- Actualización en tiempo real

Beneficios operativos:

- El docente no dedica tiempo a verificar manualmente quién entregó
- Los estudiantes ven inmediatamente si su entrega fue registrada
- Se mantiene registro histórico automático de todas las entregas
- Se facilita la trazabilidad para casos de disputa

#### Monitor de cambios en Google Drive

Para documentos no versionados en Git (reflexiones, diagramas, documentación colaborativa):

Script de Google Apps Script que:

- Monitoriza carpetas específicas recursivamente
- Detecta modificaciones en cualquier archivo
- Envía notificaciones por email con detalles de cambios
- Mantiene registro de quién modificó qué

Aplicación pedagógica:

- Seguimiento de documentación de proyectos
- Verificación de contribuciones en trabajos grupales
- Detección de actividad cerca de fechas límite
- Evidencia para evaluación de trabajo colaborativo

#### Trackers visuales de actividad

Herramientas desarrolladas:

- Tracker v2: visualización de contribuciones por estudiante
- Navegador de commits: exploración del historial de desarrollo
- Estadísticas de participación en tiempo real

Estas herramientas permiten:

- Identificar estudiantes en riesgo (inactivos por periodos largos)
- Reconocer patrones de trabajo (concentración en últimas horas vs. distribución uniforme)
- Detectar anomalías (volumen de código inconsistente con historial previo)

### Pilar 3: La evaluación

#### Exámenes personalizados desde código real

Lo hacemos desde el curso 2024-25:

En lugar de dar el mismo examen a todos, cada estudiante recibe preguntas únicas generadas automáticamente desde su propio código en Git.

Cómo funciona:

1. Sistema extrae código de todos los PRs del estudiante
1. LLM analiza el código buscando fragmentos interesantes (lógica redundante, nomenclatura inconsistente, estructuras complejas, errores tipográficos)
1. Se genera examen con 10 preguntas extraídas de commits específicos del estudiante
1. El estudiante debe explicar y defender su propio código

Formato de pregunta:
```
En tu entrega del Reto 2, archivo Validacion.java, líneas 47-49
[enlace al commit específico], escribiste:

if (edad >= 18 == true) {
    // ...
}

Observa este fragmento. ¿Qué identificas? ¿Es correcto o hay algún problema?
Si hay problema, ¿cuál es y cómo lo corregirías? Justifica tu respuesta.
```

Resultados del caso de estudio (curso 25-26, PRG1):

- 45 exámenes personalizados (estudiantes con entregas)
- 10 exámenes genéricos (estudiantes sin entregas)
- 450 preguntas únicas generadas
- 100% trazabilidad con enlaces a commits
- Generación: ~3 horas para 52 estudiantes

Ventajas demostradas:

- Imposibilidad técnica de plagio (cada examen es único)
- Evaluación de competencia real (code review de código propio)
- Conexión directa entre práctica y evaluación
- El estudiante no puede argumentar "esto no lo vimos" (es su código)

#### Rúbricas de defensa de código

Criterios de evaluación cuando el estudiante presenta código (con o sin asistencia de IA):

<div align=center>

| Criterio | Suspenso | Aprobado | Sobresaliente |
|-|-|-|-|
| **Comprensión lógica** | No explica el flujo de control | Explica línea a línea pero no conexiones | Explica fluidamente, anticipa efectos |
| **Justificación de diseño** | No justifica decisiones | Justifica funcionalidad básica | Argumenta compromisos (rendimiento vs. legibilidad) |
| **Manejo de IA** | Niega asistencia evidente | Declara uso pero no detalla proceso | Documenta prompts, iteraciones, correcciones |
| **Modificación en vivo** | Incapaz de modificar | Modifica con dificultad | Implementa cambios con soltura |

</div>

Esta rúbrica se aplicaba ya **antes de ChatGPT** porque ya evaluábamos mediante defensa oral de código. La columna "Manejo de IA" se añadió en 2023, pero el principio permanece: **si no puedes defender tu código, no demuestras aprendizaje**.

#### Criterios de valoración centrados en comprensión

En lugar de preguntas de opción múltiple o ejercicios algorítmicos aislados, se evalúa:

<div align=center>

| Criterio | Qué se evalúa | Cómo se evidencia |
|-|-|-|
| **Comprensión y conocimiento** | Explicar conceptos con propias palabras | Respuesta a "¿Por qué funciona esto?" |
| **Aplicación y análisis** | Usar conceptos en situaciones nuevas | "¿Cómo adaptarías esto si...?" |
| **Argumentación y justificación** | Defender decisiones con fundamentos | "¿Por qué elegiste X en lugar de Y?" |
| **Claridad y organización** | Estructurar ideas coherentemente | Calidad de documentación y explicaciones |
| **Ejemplos y evidencia** | Ilustrar conceptos con casos concretos | Capacidad de conectar teoría con práctica |
| **Innovación y pensamiento crítico** | Proponer soluciones originales | "¿Qué alternativas consideraste?" |

</div>

Estos criterios no pueden satisfacerse mediante memorización. Requieren comprensión profunda.

#### Nuestra postura sobre el uso de IA

Lo tenemos claro "desde siempre" y explicitado el curso 2025-26:

**La idea base:** La IA es una herramienta legítima. El problema no es usarla, sino entregar código que no puedes explicar.

**Dos situaciones diferentes:**

<div align=center>

|Uso básico (correcciones, formato)|Uso avanzado (generar lógica)|
|-|-|
| Corrección de sintaxis, reformulación, código estándar | Generación de algoritmos, estructuras de datos, lógica compleja |
| No hace falta documentarlo | Hay que documentarlo en commits/PRs |
| Como usar el autocompletado del editor | Tienes que poder explicarlo en las revisiones |

</div>

#### Lo que pedimos al estudiante

Debe ser capaz de:

- Explicar cada decisión de diseño
- Defender por qué esa solución es apropiada
- Modificar el código ante nuevos requisitos

Si usó IA y no puede defender lo generado, viola el principio de responsabilidad.

**Detección mediante metodología existente:**

- Code reviews públicos detectan incomprensión
- Exámenes personalizados desde código real hacen inviable la delegación ciega
- Historial de commits revela inconsistencias de estilo

Lo crítico: esta política **no prohíbe IA, exige responsabilidad**. El mismo principio que aplicábamos cuando los estudiantes copiaban de StackOverflow o de compañeros.

**Ejemplo de documentación transparente:**

Este mismo documento aplica el principio de transparencia en el uso de herramientas. Ver [sistema de etiquetado ético](../ai/etiquetadoEtico.md) para más detalles sobre cómo documentar contribuciones humano-IA.

### Cómo se conecta todo

Estos tres pilares no están aislados. Se refuerzan entre sí:

|El proceso capturado en Git alimenta la evaluación personalizada|Las herramientas automáticas liberan tiempo para lo importante|La evaluación sobre código propio incentiva documentación honesta|El sistema es resistente a IA no porque la bloquee, sino porque la integra con responsabilidad|
|-|-|-|-|
Los commits del estudiante son la materia prima para generar su examen único. No hay desconexión entre lo que hizo durante el curso y lo que debe defender.|El docente no pierde horas verificando entregas manualmente, sino que dedica ese tiempo a revisiones de código significativas.|Si sé que me van a preguntar sobre mi código, tengo incentivo para comprenderlo realmente, no solo para que funcione. Si usé IA, debo documentarlo porque me ayudará a recordar qué generé y qué adapté.|Usar ChatGPT para generar código no es trampa. Entregar código que no puedes explicar, sí.

### La cronología que importa

|2022-2023: Antes de ChatGPT|Noviembre 2022: Aparece ChatGPT|2023-2024: Ajustes|2024-2025: A toda máquina|2025-2026: Por escrito|
|-|-|-|-|-|
|Ya usábamos Git para todo|No cambiamos lo fundamental|Seguimiento automatizado de entregas|45 exámenes personalizados en 3 horas|Política sobre IA por escrito (lo que ya hacíamos)
|Ya evaluábamos con defensa oral|Pedimos documentar cuando la IA genera lógica|Primera prueba de exámenes personalizados|Sistema de seguimiento en todas las asignaturas
|Ya se podía consultar material en exámenes|Más énfasis en revisiones de código||Herramientas públicas de actividad
|Ya buscábamos comprensión vs. memorización|Aceleramos el sistema de exámenes personalizados (ya lo teníamos planeado)||

**La lección:** No adaptamos nuestro sistema para resistir a la IA. Nuestro sistema ya era resistente porque nunca evaluamos memorización. Los LLMs solo hicieron evidente lo que siempre fue verdad: los exámenes tradicionales no miden comprensión real.

## ¿Y ahora qué?

### Si quieres aplicar esto en tu contexto

#### Qué hace falta

|Técnicos|De enseñanza|De organización|
|-|-|-|
|Git funcionando (GitHub, GitLab, Bitbucket)|Que los estudiantes usen Git habitualmente|Aceptar que cada examen es diferente (y eso está bien)
|Acceso a IA para generar exámenes (opcional, va más rápido)|Estudiantes que entreguen código regularmente
|Saber algo de programación básica (Python, Google Apps Script)|Docente dispuesto a que las preguntas las genere el sistema
||Tiempo para revisar código (que se gana automatizando el seguimiento)

#### Esto sirve para más cosas, no solo programación

Aunque lo desarrollamos para ingeniería informática, funciona en cualquier disciplina donde:

- Exista producción incremental de artefactos (código, diseños, textos, modelos)
- Se valore el proceso sobre el producto final
- La comprensión profunda sea más importante que la memorización
- Las herramientas automatizadas (IA u otras) estén disponibles para estudiantes

Adaptaciones posibles:

- Arquitectura: defensa de decisiones de diseño en proyectos iterativos
- Redacción académica: explicación de evolución de argumentos a través de borradores
- Ingeniería en general: justificación de cálculos y suposiciones en entregas
- Diseño: defensa de iteraciones y decisiones estéticas

El principio permanece: **si no puedes defender tu trabajo, no demuestras aprendizaje**.

### Dónde no funciona

**Esto no sirve para todo:**

- No aplica cuando no existe producción previa. Primera semana de curso, conceptos puramente teóricos sin implementación, estudiantes que no entregaron nada. Solución: mantener banco de evaluaciones tradicionales para estos casos.

- No evalúa conocimiento abstracto directamente. Complejidad algorítmica teórica, teoría de tipos, paradigmas sin implementación. Requiere evaluación complementaria tradicional.

- Genera exámenes de dificultad variable. El estudiante que produjo código más sofisticado enfrenta examen más complejo. Esto es característica (evalúa lo que hicieron), pero puede percibirse como inequidad. Requiere comunicación clara.

- Necesita tecnología. Requiere Git, APIs, acceso a IA. Sin estos recursos, hay que hacerlo manualmente (funciona pero lleva mucho más tiempo).

- No elimina completamente la posibilidad de fraude sofisticado. Un estudiante podría pagar a alguien para que le genere código y luego estudiar ese código para defenderlo. Pero esto requiere esfuerzo equivalente a aprender genuinamente.

### Conclusión

No tuvimos que reinventar nada cuando apareció ChatGPT porque nunca evaluamos la capacidad de memorizar y reproducir.

Cuando los estudiantes pueden generar código en segundos con ChatGPT, la pregunta importante no es "¿cómo lo evitamos?" sino **"¿qué estábamos evaluando realmente?"**

Si evaluábamos escribir algoritmos estándar sin ayuda, sí, los LLMs rompen ese modelo. Pero si evaluábamos **comprensión, capacidad de justificar decisiones y responsabilidad sobre el código**, los LLMs no afectan. De hecho, son una herramienta más que los estudiantes deben aprender a usar con responsabilidad.

Este sistema no se diseñó para resistir a la IA. Se diseñó para medir aprendizaje real. Y resulta que medir aprendizaje real es resistente a cualquier herramienta de generación automática, porque **comprender no es lo mismo que generar**.

La lección: si tu sistema de evaluación deja de funcionar cuando los estudiantes tienen acceso a herramientas modernas, el problema no son las herramientas. El problema es que nunca estuviste evaluando lo que creías.

## Referencias

- [Evaluación personalizada](evaluacionPersonalizada.md) - Detalle técnico del sistema de exámenes
- [Proceso de creación](../procesoDeCreacion.md) - Filosofía del proceso sobre producto
- [Rúbricas de defensa](Rubricus.md) - Criterios de evaluación de código
- [Control de entregas](entregasGithub.md) - Sistema automatizado de seguimiento
- [Monitor de archivos](monitorArchivosGDrive.md) - Seguimiento en Google Drive
- [Criterios de valoración](CdEx.md) - Framework de evaluación
- [Cuadrantes de competencia](cuadrantes.md) - Conocer vs. saber usar
- [Política de IA](2Think.md) - Marco para uso responsable de herramientas
- [Etiquetado ético](../ai/etiquetadoEtico.md) - Transparencia en contribuciones humano-IA - [Debate sobre esto durante la creación de este documento](metaEtiqueda.md)

### Sobre este documento

<div align=center>

|H|IA|
|-|-|
|70|30|

</div>

**Desglose por roles:**

- **Conceptualización:** 100% humano (metodología desarrollada 2018-2025, 7 años de implementación)
- **Análisis:** 70% humano, 30% IA (selección y organización de contenidos desde documentos existentes)
- **Implementación:** 60% IA (redacción estructura inicial), 40% humano (tablas, ajustes, reorganización)
- **Validación:** 100% humano (revisión final, correcciones, aprobación)

Todo el conocimiento, experiencia y casos de estudio son resultado de implementación real en aula. La IA asistió en síntesis y estructura, pero no generó contenido original. Ver [propuesta de etiquetado ético](../ai/etiquetadoEtico.md) para más detalles sobre este sistema de transparencia.
