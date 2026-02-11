# Clasificación

<div align=center>

|Categoría|Casos|
|-|-|
|**Secuencial**|Un niño crece, La erosión profundiza surcos|
|**Recurrente**|Los terremotos ocurren, Las crisis económicas regresan, Las migrañas reaparecen|
|**Iterativo**|El corazón late, Las estaciones cambian, Los semáforos ciclan|
|**Recursivo**|Un río se ramifica, Una oración se anida|

</div>

## ¿Por qué?

### Secuencial

- *Niño crece*: Progresión unidireccional, fases cualitativamente distintas, no hay repetición
- *Erosión surcos*: Proceso que progresa acumulativamente, cada estado causado por el anterior

### Recurrente

- *Terremotos, crisis, migrañas*: Reaparecen eventualmente, intervalos impredecibles, sin consecutividad garantizada

### Iterativo

- *Corazón, estaciones, semáforos*: Repetición consecutiva, periodicidad fija/regular, cada ciclo independiente del anterior

### Recursivo

- *Río, oración*: Estructura autocontenida, autosimilitud a diferentes escalas, definición autorreferente

## Debatible

- **La erosión** ¿es secuencial puro o tiene elementos recurrentes? Cada ciclo de lluvia erosiona más, pero no es iterativo (cada evento depende causalmente del estado anterior). Es secuencial con memoria acumulativa.


## *#2Think*

|||
|-|-|
Como tantas otras veces en la carrera y en la vida, no existe una "respuesta única perfecta" sino que hace falta que apliquemos el razonamiento ***explícito y formal*** sobre qué dimensiones pesan más en cada clasificación.|El valor no está en memorizar "X es iterativo, Y es recursivo", sino en **poder justificar** la clasificación usando los criterios que hemos revisado. Dos personas pueden clasificar el mismo fenómeno diferente y ambas tener razón si sus justificaciones son coherentes con los criterios aplicados.
