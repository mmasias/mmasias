# Modelado

## ¿Por qué?

En el modelado del dominio con UML, existe una tendencia común entre los estudiantes a representar todas las conexiones entre conceptos mediante relaciones de uso (dependencias). Esta práctica, influenciada por la familiaridad con los mapas mentales donde todo se conecta mediante líneas simples, produce diagramas que técnicamente son correctos pero semánticamente pobres.

El problema surge cuando se observa un sistema de gestión de horarios universitarios. Si se modela únicamente con relaciones de uso, el diagrama resultante sería:

![](/images/UNEATLANTICO/idsw1/modelado/modelado000.svg)

Este enfoque genera varios problemas fundamentales. 

- Primero, se pierde la riqueza semántica: todas las conexiones se ven iguales, sin diferencias en su naturaleza o significado.
- Segundo, no se captura la multiplicidad de las relaciones: ¿cuántos profesores puede tener un curso? ¿cuántas aulas puede usar un horario?
- Tercero, la navegabilidad queda indefinida: ¿se puede navegar en ambas direcciones? ¿qué significa realmente cada conexión?

Además, se ocultan aspectos estructurales importantes como la composición y la agregación, que son fundamentales para entender cómo los objetos se relacionan en términos de todo-parte o dependencia existencial.

## ¿Qué?

El enriquecimiento del modelo consiste en el uso diferenciado de múltiples tipos de relaciones UML, cada una con su propio significado semántico específico. En lugar de depender exclusivamente de las relaciones de uso, se debe incorporar un vocabulario más amplio de conexiones.

Las relaciones disponibles incluyen la asociación simple para conexiones bidireccionales, la composición para relaciones todo-parte con dependencia existencial, la agregación para relaciones todo-parte sin dependencia existencial, y la herencia para relaciones de generalización-especialización.

Cada tipo de relación aporta información específica sobre la naturaleza de la conexión, permitiendo que el modelo comunique no solo que dos conceptos están relacionados, sino cómo están relacionados y qué implica esa relación en términos del dominio.

## ¿Para qué?

El uso diferenciado de relaciones resuelve directamente los problemas identificados en el modelo simple. La riqueza semántica se recupera al elegir la relación que mejor represente la naturaleza real de cada conexión. Un horario no solo "usa" un aula; está "asociado" con ella de manera específica durante ciertos períodos.

La multiplicidad se puede expresar claramente: un curso se asocia con exactamente un programa, pero un programa puede tener múltiples cursos. Un horario se compone de múltiples bloques horarios, y sin el horario, estos bloques no tienen sentido independiente.

La navegabilidad se vuelve explícita: desde un aula se puede navegar hacia los edificios que la contienen, y desde un profesor se puede acceder a los recursos que prefiere u ofrece. Cada flecha tiene un significado específico que enriquece la comprensión del dominio.

Los aspectos estructurales se capturan correctamente: el campus universitario está compuesto por edificios, y estos por aulas. Esta jerarquía de composición refleja la realidad física del dominio de manera que las simples dependencias no pueden expresar.

## ¿Cómo?

La transformación del modelo simple al enriquecido requiere analizar cada conexión individual y determinar su naturaleza real. El proceso comienza identificando las relaciones todo-parte verdaderas, donde la existencia de una parte depende del todo.

![](/images/UNEATLANTICO/idsw1/modelado/modelado001.svg)

Un horario está compuesto por bloques horarios. Sin el horario, los bloques no tienen sentido independiente. Esta es una relación de composición clara.

Para las relaciones estructurales físicas, se identifica la jerarquía de contención:

![](/images/UNEATLANTICO/idsw1/modelado/modelado002.svg)

Las asociaciones simples se usan para conexiones donde ambos objetos pueden existir independientemente:

![](/images/UNEATLANTICO/idsw1/modelado/modelado003.svg)

Las relaciones de preferencia o suministro se modelan como asociaciones con roles específicos:

![](/images/UNEATLANTICO/idsw1/modelado/modelado004.svg)

El modelo completo enriquecido combina todos estos tipos de relaciones:

![](/images/UNEATLANTICO/idsw1/modelado/modelado005.svg)

Un diagrama con relaciones diversificadas se encuentra mejor posicionado para el debate y la discusión entre diferentes opciones de modelado. Cuando las relaciones son semánticamente ricas, se puede debatir si una relación debe ser composición o agregación, si la navegabilidad es correcta, o si los roles están bien definidos.

Por ejemplo, consideremos esta alternativa de modelado para el mismo dominio:

![](https://github.com/mmasias/pySigHor/raw/main/images/RUP/00-casos-uso/00-modelo-del-dominio/modelo-dominio.svg)

En este modelo alternativo se puede debatir si el CampusUniversitario debe agregarse directamente con Aula o si debe mantener la jerarquía através de Edificio. También se puede discutir si BloqueHorario debería ser composición o agregación con Horario, o si las relaciones del Profesor con Recurso requieren navegabilidad bidireccional.

La práctica con dominios diversos permite desarrollar la intuición para elegir el tipo de relación más apropiado en cada contexto.

## ¿Y ahora qué?

Una vez comprendida la importancia de diversificar las relaciones, se puede practicar con dominios más complejos que requieran mayor variedad de tipos de relaciones.

Consideremos el dominio de un videojuego clásico como Pacman.

![](/images/UNEATLANTICO/idsw1/modelado/modelado006-simple.svg)

Este modelo demuestra cómo un dominio aparentemente simple requiere múltiples tipos de relaciones para ser representado adecuadamente. La composición define las jerarquías estructurales, la agregación muestra contenido opcional, las asociaciones simples expresan conexiones dinámicas, y las dependencias conectan las clases con sus tipos enumerados.

![](/images/UNEATLANTICO/idsw1/modelado/modelado006-completo.svg)