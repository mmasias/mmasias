# gII@UNEATLANTICO - Nuestra política con respecto a la IA - Documento de trabajo

La IA es herramienta legítima de aprendizaje. El fraude no es usar IA, sino entregar trabajo que no se puede defender o cuyo proceso de creación no se puede explicar.

## Marco operacional

Distinguimos dos categorías de uso con obligaciones diferenciadas

|Uso instrumental-mecánico|Uso generativo-conceptual|
|-|-|
|*reformulación, corrección sintáctica, traducción entre lenguajes, generación de código base estándar*|*generación de lógica, estructuras de datos, algoritmos, diseño de clases*|
|Permitido sin documentación explícita|Permitido con documentación obligatoria: debe aparecer en commit message o PR description indicando qué se generó y qué herramienta se usó.
||Código generativo-conceptual sin documentación que el estudiante no puede explicar en code review se considera trabajo no defendible.
|Ejemplos: corregir errores de sintaxis, generar getters/setters, formatear código|Ejemplo mensaje commit: "Implementa búsqueda binaria. Claude generó estructura inicial del loop (líneas 23-35) tras descripción del algoritmo. Adapté manejo de caso base y condiciones límite manualmente."
|Justificación: equivalente a usar IDE con autocompletado|

**Delegación completa sin comprensión** no es categoría de uso sino **fraude académico**, detectable mediante code review donde el estudiante no puede justificar decisiones. No requiere prohibición explícita: nuestra metodología ya lo hace inviable

## Criterios evaluativos

- En commits/PRs
  - Verificar que decisiones arquitectónicas no triviales estén explicadas
  - Cuando aparece código conceptualmente complejo sin historial gradual de construcción, exigir explicación en code review
- En code reviews públicos
  - Preguntar decisiones de diseño específicas: *¿por qué usa array en lugar de una lista?*
  - Solicitar modificación en vivo: *¿cómo cambiaría esto si el requisito fuera X?*
  - Si el alumno no puede responder, se evidencia delegación no comprendida independientemente de si usó IA
- En exámenes personalizados desde código real
  - Preguntar sobre decisiones tomadas en su propio código
  - Pedir extensiones o modificaciones de su implementación
  - El alumno que delegó sin comprender tendrá evidentes dificultades

## Exigencia de responsabilidad

El alumno asume responsabilidad completa del código entregado. Esto significa:

- Capacidad de explicar cada decisión de diseño
- Capacidad de defender por qué esa solución es apropiada
- Capacidad de modificar el código ante nuevos requisitos

Si usó IA para generar parte del código, debe haber interiorizado suficientemente el contenido para poder defenderlo. Usar IA y no comprender lo generado viola el principio de responsabilidad.

## 2DO!!!

Documento para alumnos: redactar política de una página con esta estructura:

- Principio: La IA es herramienta legítima. El criterio de evaluación es tu capacidad de responsabilizarte del código entregado.
- Obligaciones:
  - Documentar en commits/PRs cuando se use IA para generar lógica o estructuras no triviales
  - Estar preparado para explicar y modificar cualquier línea de código en code reviews
  - Asumir que será evaluado sobre su código real en exámenes personalizados
- Consecuencias:
  - Código que no se puede explicar o modificar no demuestra aprendizaje, independientemente de cómo se generó
  - Code reviews detectarán si comprende su propio código
  - Exámenes personalizados desde su código hacen inviable la delegación no comprendida

## Justificación

En ingeniería profesional, delegar trabajo a herramientas es práctica estándar. Lo inaceptable no es usar la herramienta sino entregar artefactos que no se puedan mantener, extender o defender técnicamente. 

Un ingeniero que usa biblioteca externa debe comprender qué hace esa biblioteca suficientemente para integrarla, debuggearla y adaptarla a requisitos cambiantes. 

El mismo principio aplica a código generado por IA: usarlo es legítimo; entregarlo sin comprenderlo es incompetencia técnica, independientemente de cómo se generó.

Nuestro grado forma ingenieros capaces de asumir responsabilidad técnica por el código que producen. Esta política replica expectativas profesionales donde la responsabilidad no se delega junto con la generación.

# 2Think.

- [¿Qué vende exactamente la universidad?](https://www.wosu.org/2025-06-17/ohio-state-university-will-discipline-fewer-students-for-using-ai-under-new-initiative)
- [Open Letter: Stop the Uncritical Adoption of AI Technologies in Academia](https://openletter.earth/open-letter-stop-the-uncritical-adoption-of-ai-technologies-in-academia-b65bba1e)

- [La revista Ethics -la principal revista científica de filosofía en el mundo- acaba de publicar las pautas para el uso de IA](https://www.journals.uchicago.edu/journals/et/ai-policy)

> Tensión fundamental: La política valoriza "creatividad humana" y "ideas originales del autor" mientras permite uso instrumental de IA. Pero no define dónde termina lo instrumental y comienza la coautoría. Si un autor usa IA para:
> 
> - Corregir gramática: ¿instrumental?
> - Reformular argumentos por claridad: ¿instrumental o coautoría?
> - Generar ejemplos que ilustran tesis del autor: ¿instrumental o coautoría?
> - Generar objeciones que el autor luego refuta: ¿instrumental o coautoría?7
> 
