# Taxonomía de patrones temporales y estructurales

## ¿Por qué?

El lenguaje común usa términos como *repetición*, *ciclo*, *patrón*, *recurrencia* de forma intercambiable. Esta imprecisión léxica oculta diferencias estructurales fundamentales entre fenómenos que superficialmente parecen similares.

Considerar que "los lunes se repiten" y "las tormentas se repiten" describe ambos fenómenos con la misma palabra, pero el primero tiene periodicidad fija y consecutiva mientras el segundo es eventual e impredecible. Aplicar la misma categoría conceptual a ambos impide análisis preciso de sus propiedades causales y predictivas.

Esta confusión no es meramente semántica. Cuando se diseñan soluciones a problemas ingenieriles, la incapacidad de distinguir qué tipo de patrón subyace lleva a implementaciones que fuerzan estructuras inadecuadas: aplicar iteración donde hay recursividad estructural o viceversa. El resultado es complejidad artificial, código frágil e ineficiencia.

La necesidad es doble: **vocabulario preciso** para clasificar fenómenos y **criterios explícitos** para determinar qué categoría aplica a cada caso.

## ¿Qué?

Se proponen cuatro categorías que capturan distinciones fundamentales:

|Secuencial|Recurrente|Iterativo|Recursivo|
|-|-|-|-|
|**Definición**
|Proceso o estructura donde los elementos tienen orden temporal o lógico determinado.|Fenómeno que reaparece eventualmente sin patrón temporal fijo.|Proceso donde la misma estructura operacional se repite consecutivamente sin saltos.|Estructura que se contiene a sí misma.|
|*A precede a B, B precede a C.*|*Los intervalos entre apariciones son variables o impredecibles. No hay garantía de consecutividad.*|*Cada instancia es cualitativamente similar a las anteriores. La repetición es predecible y regular.*|*Un patrón se replica dentro de sí mismo a diferentes escalas o niveles.*|
|No implica repetición ni causalidad entre elementos, solo ordenamiento.|El fenómeno puede estar ausente durante periodos indefinidos antes de reaparecer.|Cada ciclo es estructuralmente independiente: el ciclo N no determina causalmente el ciclo N+1.|No es primariamente temporal sino relacional: la entidad completa y sus componentes comparten la misma organización estructural.|
|**Propiedad distintiva**
|La eliminación del orden destruye el proceso.|Intermitencia. La reaparición es eventual, no programada.|Consecutividad. Entre dos instancias iterativas no hay intervalos aleatorios.|Autosimilitud o autorreferencia. La definición del todo incluye instancias del todo mismo.|
|**Ejemplos**
|Desarrollo biológico (embrión → feto → neonato), preparación de cemento (mezcla seca → añadir agua → amasar), fases de proyecto (análisis → diseño → implementación).|Días lluviosos, terremotos en una falla geológica, epidemias, crisis económicas, erupciones solares.|Días de la semana, ciclo cardíaco, rotación planetaria, turnos de trabajo, latido del metrónomo.|Sistemas fluviales (río contiene afluentes que contienen subafluentes), estructura gramatical (cláusula subordinada dentro de cláusula), jerarquías organizacionales (departamento → secciones → equipos con misma lógica), fractales geométricos, anatomía corporal (bronquios → bronquiolos con patrón de ramificación).|

> *Nota: En otros contextos "recurrente" denota la dependencia causal donde el estado N determina el estado N+1 (relaciones de recurrencia matemáticas, procesos con memoria). Esta segunda acepción es ortogonal a la distinción iterativo/recurrente aquí propuesta. Ambos sentidos son válidos pero miden dimensiones diferentes del fenómeno.*

## ¿Para qué?

|||
|-|-|
|**Precisión analítica**|Permite describir fenómenos sin ambigüedad.
||En lugar de "esto se repite", se especifica: "esto es iterativo con periodo fijo" o "esto es recurrente sin patrón temporal".
|**Predicción diferenciada**|Cada categoría implica estrategia predictiva distinta:
||- ***Secuencial***: requiere mapa completo de fases
||- ***Recurrente***: requiere modelo probabilístico o análisis de precursores
||- ***Iterativo***: se predice desde la periodicidad del ciclo
||- ***Recursivo***: requiere identificar regla de autorreplicación y condición de terminación
|**Reconocimiento de isomorfismos**|Permite identificar que fenómenos superficialmente distintos comparten estructura profunda.
||Esta identificación habilita transferencia de soluciones entre dominios.
||Un sistema de archivos con carpetas anidadas, un árbol genealógico y una ecuación con paréntesis anidados son todos recursivos.
|**Criterio de diseño**|Cuando se implementa procesamiento de datos:
||- ***Estructuras secuenciales*** sugieren pipeline lineal
||- ***Estructuras iterativas*** sugieren bucles con estado que se reinicia cada ciclo
||- ***Estructuras recursivas*** sugieren funciones que se invocan sobre subestructuras

Forzar recursión sobre datos planos o iteración sobre datos anidados genera complejidad innecesaria. El reconocimiento del patrón subyacente determina qué estrategia es natural vs. forzada.

## ¿Cómo?

**Criterios de identificación**

Para determinar si un fenómeno es:

|Secuencial|Recurrente|Iterativo|Recursivo|
|-|-|-|-|
|¿Existe orden inherente al proceso?|¿El fenómeno reaparece después de periodos de ausencia?|¿Se repite la misma estructura operacional?|¿La estructura se contiene a sí misma?
|¿La alteración del orden destruye el proceso o su significado?|¿Los intervalos entre apariciones son variables o impredecibles?|¿La repetición es consecutiva sin saltos?|¿Hay autosimilitud a diferentes escalas?
|¿Cada fase es cualitativamente distinta de las otras?||¿Las instancias son intercambiables estructuralmente?|¿Puedes identificar el mismo patrón organizacional en el todo y en las partes?
|¿La progresión es unidireccional?||¿Cada ciclo es independiente del anterior?|¿La definición del objeto incluye referencias al objeto mismo?

**Relaciones entre categorías**

<div align=center>

||||
|-|-|-|
|Lo iterativo es necesariamente secuencial (requiere orden), pero no todo lo secuencial es iterativo (puede no repetirse).|Lo recurrente puede ser secuencial si las reapariciones mantienen orden, pero no necesariamente.|Lo recursivo es ortogonal al eje temporal. Puede manifestarse en estructuras estáticas (fractales espaciales) o en procesos temporales (algoritmos recursivos), pero la recursividad como tal denota organización estructural, no patrón temporal.

|![](/images/docs/UNEATLANTICO/eda2/recursividad/d1.svg)
|-

</div>

**Casos híbridos**

Algunos fenómenos exhiben múltiples categorías simultáneamente:

- Clima terrestre: iterativo (ciclos anuales) + recurrente (fenómenos como El Niño con periodicidad variable)
- Respiración: iterativo (se repite) + recursivo (estructura bronquial ramificada)
- Transmisión cultural: secuencial (progresión generacional) + recursivo (conocimiento con estructura jerárquica autosimilar)

En estos casos, identificar todas las categorías presentes proporciona análisis más completo que forzar clasificación única.

### Aplicación

Enfrentado a un fenómeno, proceso o estructura de datos:

1. Determinar si tiene orden inherente (secuencial o no)
2. Si hay repetición, determinar si es consecutiva (iterativo) o eventual (recurrente)
3. Examinar si la estructura se contiene a sí misma (recursivo)
4. Identificar dependencias causales si son relevantes

Este análisis precede cualquier decisión de implementación. La estructura del problema dicta la estrategia de solución natural.
