# gII@UNEATLANTICO - Nuestra política con respecto a la IA

La IA es herramienta legítima de aprendizaje.

El fraude no es usar IA, sino entregar un trabajo que no se puede defender o cuyo proceso de creación no se puede explicar.

## Marco operacional

Distinguimos dos categorías de uso con obligaciones diferenciadas

<div align=center>

|Uso instrumental-mecánico|Uso generativo/conceptual|
|-|-|
|*reformulación, corrección sintáctica, traducción entre lenguajes, generación de código base estándar*|*generación de lógica, estructuras de datos, algoritmos, diseño de clases*|
|Permitido sin documentación explícita|Permitido con documentación obligatoria: debe aparecer en commit message o PR description indicando qué se generó y qué herramienta se usó.
||Código generativo-conceptual sin documentación que el estudiante no puede explicar en code review se considera trabajo no defendible.
|Ejemplos: corregir errores de sintaxis, generar getters/setters, formatear código|Ejemplo mensaje commit: "Implementa búsqueda binaria. Claude generó estructura inicial del loop (líneas 23-35) tras descripción del algoritmo. Adapté manejo de caso base y condiciones límite manualmente."
|Justificación: equivalente a usar IDE con autocompletado|

</div>

**Delegación completa sin comprensión** no es categoría de uso sino **fraude académico**, detectable mediante *code review* donde el estudiante no puede justificar decisiones. No requiere prohibición explícita: nuestra metodología ya lo hace inviable

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

- Capacidad de **explicar** cada decisión de diseño
- Capacidad de **defender** por qué esa solución es apropiada
- Capacidad de **modificar** el código ante nuevos requisitos

Si usó IA para generar parte del código, debe haber interiorizado suficientemente el contenido para poder defenderlo. Usar IA y no comprender lo generado viola el principio de responsabilidad.

## Documento para alumnos

**Principio:** la IA es una herramienta legítima de aprendizaje. El criterio de evaluación no es si la usaste, es si puedes responsabilizarte del código que entregas.

**Tus obligaciones:**

- Si usas IA para generar lógica, estructuras de datos o algoritmos (no para corregir sintaxis o formato), documéntalo en el commit o en la descripción del PR: qué generó la IA, qué cambiaste tú y por qué.
- Tienes que poder explicar y modificar en vivo cualquier línea de tu código durante una revisión. Si no puedes, da igual quién la escribió — no demuestra que la entendiste.
- Tu examen se genera desde tu propio código. Vas a defender decisiones que tomaste tú, no a resolver un problema genérico.

**Consecuencias de no cumplirlas:**

- Código que no puedes explicar o modificar no demuestra aprendizaje, se haya generado como se haya generado.
- Las revisiones de código en clase van a detectar si entiendes lo que entregaste.
- El examen se construye con tu propio código: delegar sin comprender se vuelve inviable, no hace falta que nadie te lo prohíba.

## Relación con el protocolo institucional

Este documento describe el criterio pedagógico propio (exámenes personalizados, code reviews) para esta asignatura. La alineación con el protocolo de integridad académica de la universidad — niveles de uso de IA, declaración obligatoria, régimen de reclamaciones — vive en [aterrizajeProtocolo.md](aterrizajeProtocolo.md). Son complementarios: uno explica cómo se evalúa aquí, el otro cómo eso encaja con la normativa del grado.

## Pendiente

[Zonas de intervención por curso](topologiaActuacion.md) sigue sin desarrollar del todo, y en su estado actual propone prohibición por defecto en 1º y 2º curso — contradice la práctica ya establecida en PRG1/PRG2 (IA permitida con documentación, no prohibida). Requiere reconciliación antes de darlo por válido, no es solo cuestión de completarlo.

## Justificación

En ingeniería profesional, delegar trabajo a herramientas es práctica estándar. Lo inaceptable no es usar la herramienta sino entregar artefactos que no se puedan mantener, extender o defender técnicamente. 

Un ingeniero que usa biblioteca externa debe comprender qué hace esa biblioteca suficientemente para integrarla, debuggearla y adaptarla a requisitos cambiantes. 

El mismo principio aplica a código generado por IA: usarlo es legítimo; entregarlo sin comprenderlo es incompetencia técnica, independientemente de cómo se generó.

Nuestro grado forma ingenieros capaces de asumir responsabilidad técnica por el código que producen. Esta política replica expectativas profesionales donde la responsabilidad no se delega junto con la generación.
