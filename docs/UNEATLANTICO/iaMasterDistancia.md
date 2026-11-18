# IA y evaluación en un máster a distancia

> *Notas para la dirección de un máster no presencial (caso de partida: Máster en Proyectos) preocupada por el mal uso de la IA. Lo que se propone no es teórico: cada medida enlaza al artefacto que ya funciona en asignaturas del [Grado en Ingeniería Informática](README.md) o en el [protocolo institucional](https://github.com/mmasias/pyAI-edu). La adaptación a un máster de proyectos es lo único nuevo.*

## ¿Por qué?

### El síntoma

Hay alumnos que, haciendo mal uso de la IA, terminan el máster en muy poco tiempo. El síntoma dice más de la evaluación que de la IA: si se puede acelerar sin aprender, la evaluación no exige haber aprendido.

### El origen: la evaluación mide producto, no estado cognitivo

La evaluación siempre fue una inferencia: el docente no ve el aprendizaje, ve salidas (trabajos, exámenes, informes) y deduce el aprendizaje a partir de ellas. Funcionaba porque para producir cierta salida había que poseer cierta competencia. La IA rompe esa correlación: produce salidas de calidad sin que la competencia exista en quien entrega.

La opacidad no es nueva. Encargar el trabajo a un tercero o copiar sin citar existía antes; la IA solo la hizo gratuita e instantánea. Un sistema de evaluación poco observable ya lo era antes de la IA.

> Desarrollado en [Observabilidad aplicada al problema docente con IA](https://github.com/mmasias/pyProtocoloIA/blob/main/conceptos/observabilidad.md).

### Por qué detectar no es la salida

La reacción natural es buscar un detector. Es un callejón sin salida por dos razones:

<div align=center>

|Técnica|Conceptual|
|-|-|
|Los detectores se entrenan sobre generadores que ya cambiaron: la carrera la ganan los generadores por diseño. Los falsos positivos son frecuentes justo en el registro académico formal, y sancionar sobre esa base es jurídicamente indefendible.|"¿Usó IA?" no es la pregunta que importa. La que importa es "¿aprendió?". Se puede no usar IA y no aprender (copiando a un compañero) y se puede usar IA y aprender exactamente lo que la actividad buscaba.|

</div>

> Desarrollado en [Por qué el protocolo no pivota sobre la detección de IA](https://github.com/mmasias/pyProtocoloIA/blob/main/conceptos/porQueNoDeteccion.md). La regla operativa vigente: un detector puede ser **disparador**, nunca **prueba** ([regla de cautela](https://github.com/mmasias/pyAI-edu/blob/main/RESUMEN-OPERATIVO.md#6-regla-de-cautela)).

Atención: el [Protocolo para la modalidad virtual e híbrida](https://github.com/mmasias/pyProtocoloIA/blob/main/protocolo/Identidad_Autoria_Evaluacion_Modalidad_Distancia_Hibrida.md) (apartado 3.2.2.1) todavía presenta Turnitin y Grammarly como herramientas capaces de revelar texto generado por IA. Esa lectura debe subordinarse a la regla de cautela: un porcentaje de "probabilidad de IA" no funda ninguna decisión.

### Lo que agrava la distancia

En presencialidad, el profesor reconoce sin herramientas una discontinuidad: un trabajo muy por encima de lo que el alumno demuestra en clase. A distancia ese conocimiento directo no existe o es débil, y la evaluación queda sostenida casi solo por el producto entregado. Es la combinación más vulnerable.

## ¿Qué?

Desplazar el foco **del producto al proceso y a la conversación**: la pregunta deja de ser "¿usó IA?" y pasa a ser "¿puedo inferir que el estado cognitivo que esta actividad debía desarrollar existe en este alumno?".

Cuatro mecanismos, ninguno de detección:

<div align=center>

|Mecanismo|Qué hace|Evidencia en asignaturas propias|
|-|-|-|
|**Declaración explícita**|El uso de IA se fija por actividad y se declara. El uso no autorizado deja de ser "uso de IA" y pasa a ser "ocultación", falta distinta y más fácil de demostrar.|[Rúbrica de uso responsable de IA (IdSw1)](https://github.com/mmasias/26-27-idsw1/blob/main/evaluaciones/SdR/l%27Rubrica.uRIA.md)|
|**Instrumentación del proceso**|El trabajo deja rastro fechado de su elaboración. Un trabajo fabricado en la última noche tiene un rastro distinto al construido durante semanas.|[Repositorio Git como trazabilidad](https://github.com/mmasias/pyProtocoloIA/blob/main/herramientas/repoGitHub.md) / [panel sobre 28 forks](https://github.com/mmasias/pyAI-edu/discussions/2)|
|**Verificación directa**|Una pregunta oral sobre una decisión concreta del propio trabajo no se puede preparar de forma genérica: exige que el alumno conozca lo que entregó.|[Guion canónico de defensa oral](https://github.com/mmasias/pyAI-edu/blob/main/docs/plantillas/guion-defensa-canonico.md)|
|**La IA como objeto evaluado**|En lugar de esconder la IA, se evalúa lo que el alumno hace con ella: qué acepta, qué rechaza, qué corrige y por qué.|[Sesiones de VibeCoding (IdSw2)](https://github.com/mmasias/25-26-IDSW2/blob/main/evaluaciones/SdVc.md)|

</div>

### El suelo institucional ya existe

Antes de diseñar nada conviene revisar qué exige ya el [Protocolo para la modalidad virtual e híbrida](https://github.com/mmasias/pyProtocoloIA/blob/main/protocolo/Identidad_Autoria_Evaluacion_Modalidad_Distancia_Hibrida.md) (apartado 3.2.2.1, de carácter obligatorio):

<div align=center>

|Exigencia|Másteres profesionalizantes|Másteres de investigación|
|-|:-:|:-:|
|Horas de la materia en sincronía docente-alumnado|15%|18%|
|Sesiones en línea por asignatura dedicadas a realizar actividades de evaluación continua|mínimo 2 x 2 h|mínimo 2 x 2 h|
|Trabajos y actividades prácticas|vídeo de defensa de autoría + declaración de autoría|ídem|
|Pruebas parciales y examen final|sistema Proctor|ídem|
|TFM|defensa oral|ídem|

</div>

Si hay alumnos que terminan el máster "en poco tiempo", lo primero es comprobar si esta parte síncrona se está cumpliendo como está diseñada. Un máster con un 15% real de sincronía y dos sesiones evaluables en vivo por asignatura difícilmente se puede recorrer a toda velocidad sin que se note.

## ¿Para qué?

<div align=center>

|Problema (¿Por qué?)|Consecuencia de la propuesta|
|-|-|
|La evaluación mide producto, no aprendido|La nota vuelve a informar sobre el estado cognitivo: se evalúa también el proceso y la capacidad de defender lo entregado.|
|Detectar es técnicamente frágil e indefendible|Las decisiones se fundan en la conversación con el alumno, no en un porcentaje; son defendibles en una reclamación o en un expediente.|
|A distancia no se conoce al alumno|La trazabilidad pasiva construye el histórico que permite ver discontinuidades sin conocimiento directo.|
|Acelerar sin aprender sale a cuenta|Deja de salir a cuenta: lo que acelera la IA (el producto) pesa menos; lo que no acelera (defender, decidir, auditar) pesa más.|
|El rápido legítimo queda bajo sospecha|No: un profesional con años dirigiendo proyectos que termina rápido defiende su trabajo sin dificultad. La verificación protege al honesto.|

</div>

Y un beneficio que no es de control: el egresado de un máster en proyectos va a trabajar con IA. Saber auditar un plan generado por IA es una competencia profesional que hoy el máster puede enseñar y evaluar.

## ¿Cómo?

### Paso 0: diagnóstico

Antes de proponer medidas conviene conocer:

1. Qué pesa en la nota: entregas escritas asíncronas frente a momentos síncronos.
2. Si hay calendario marcado o cada alumno avanza a su ritmo.
3. Cuántos alumnos atiende cada tutor: de eso depende cuánta verificación oral es viable.
4. Qué fija la memoria verificada: si un cambio de evaluación cabe dentro de las horquillas de ponderación aprobadas, basta con la guía docente; si no, exige modificación ante la agencia.
5. Si el 15% de sincronía y las dos sesiones evaluables por asignatura se cumplen hoy.

### Costo bajo (aplicable este curso)

#### 1. Régimen de uso de IA por actividad

Cada actividad evaluable declara su régimen con una sola pregunta: **¿la IA es medio para producir el resultado o es el objeto que se evalúa?**

<div align=center>

|Régimen|Cuándo|Qué se evalúa|
|-|-|-|
|**A**|Sin IA|El trabajo, con independencia de cualquier herramienta|
|**B**|IA como medio|El resultado, con independencia de la herramienta|
|**D**|IA como objeto evaluado|La interacción del alumno con la IA|

</div>

- Qué hacer, paso a paso: [QUE-HACER.md](https://github.com/mmasias/pyAI-edu/blob/main/QUE-HACER.md).
- Bloques de consigna listos para pegar: [consigna-abd.md](https://github.com/mmasias/pyAI-edu/blob/main/docs/plantillas/consigna-abd.md).
- [Asistente de redacción de consignas](https://mmasias.github.io/pyAI-edu/tools/asistente-consignas-profesor.html) (profesorado).

#### 2. Declaraciones de autoría y de uso de IA

Autoría: una línea en toda entrega. Uso de IA: herramienta, finalidad y fase, en B y D. Elimina el "no sabía que no se podía".

- Plantillas: [declaración de autoría](https://github.com/mmasias/pyAI-edu/blob/main/docs/plantillas/declaracion-autoria.md) / [declaración de uso de IA](https://github.com/mmasias/pyAI-edu/blob/main/docs/plantillas/declaracion-uso-ia.md).
- [Asistente de declaración](https://mmasias.github.io/pyAI-edu/tools/asistente-declaracion-alumno.html) (alumnado).
- Evidencia en uso: la [rúbrica de uso responsable de IA de IdSw1](https://github.com/mmasias/26-27-idsw1/blob/main/evaluaciones/SdR/l%27Rubrica.uRIA.md) exige qué se pidió, qué se aceptó, qué se descartó y por qué, con innegociables explícitos (sin declaración se resta nota; evidencia fabricada anula la nota).

#### 3. Documento compartido desde el primer día

En el GII la trazabilidad es el historial de Git. En un máster sin Git, el equivalente cuesta cero: el trabajo de régimen B o D se redacta **en un documento compartido con el profesor desde el día uno**, nunca se pega un documento final. El historial de versiones de Google Docs/Sheets guarda cada revisión con fecha del servidor, no editable por el alumno.

- Por qué esto basta en aulas sin Git o masivas: [P8](https://github.com/mmasias/pyAI-edu/blob/main/docs/articulos/P8.md).
- El modelo con Git: [repositorio como trazabilidad](https://github.com/mmasias/pyProtocoloIA/blob/main/herramientas/repoGitHub.md), [tracker de contribuciones](https://manuel.masiasweb.com/github-stats-page-contributors.html), [monitor de archivos en Google Drive](monitorArchivosGDrive.md).

#### 4. TFM: acuerdo de supervisión y defensa que reconstruye el proceso

El TFM ya tiene defensa oral obligatoria. Falta fijar el régimen al arranque (no al depósito) y orientar la defensa a reconstruir el proceso, no solo a exponer el resultado.

- [Acuerdo de supervisión TFG/TFM/tesis](https://github.com/mmasias/pyAI-edu/blob/main/docs/plantillas/acuerdo-supervision-tfg-tfm.md) y su porqué: [P7](https://github.com/mmasias/pyAI-edu/blob/main/docs/articulos/P7.md).
- Punto crítico para un máster a distancia: el acuerdo distingue **dirección activa** de **dirección nominal**. Si la dirección es nominal (sin revisión real de versiones intermedias), la defensa final es el único mecanismo que sostiene la autoría y no puede tratarse como trámite.

### Costo medio

#### 5. Entregas escalonadas y encadenadas

Partir cada trabajo en hitos con valor evaluativo, donde cada hito queda congelado y el siguiente debe ser coherente con él. La incoherencia entre hitos es una señal observable sin herramientas.

- Fundamento: [entrega escalonada](https://github.com/mmasias/pyProtocoloIA/blob/main/herramientas/entregaEscalonada.md), [portafolio de proceso](https://github.com/mmasias/pyProtocoloIA/blob/main/herramientas/portafolioProceso.md).
- Evidencia: en las [sesiones de requisitado](https://github.com/mmasias/26-27-idsw1/blob/main/evaluaciones/SdR/README.md) el borrador del modelo se entrega al cliente entre sesiones, se corrige en la segunda sesión y se defiende al final. A mayor escala, la cadena IdSw1 -> IdSw2: los artefactos de requisitos de un curso son el insumo del siguiente y ["cada fase valida la anterior"](https://github.com/mmasias/25-26-IDSW2/blob/main/evaluaciones/SdVc.md).
- Adaptación a proyectos: acta de constitución -> EDT -> cronograma -> registro de riesgos -> informe de cierre, todos sobre el mismo proyecto y en el mismo documento compartido.

#### 6. Verificación oral reactiva

No se verifica a todos: se verifica cuando hay un indicio documentado, y una sola conversación breve funda la decisión.

- Tres categorías de indicio (producto, proceso, interacción), registro sin texto libre: [registro-indicio.md](https://github.com/mmasias/pyAI-edu/blob/main/docs/plantillas/registro-indicio.md) y su porqué: [P10](https://github.com/mmasias/pyAI-edu/blob/main/docs/articulos/P10.md).
- Cuatro preguntas fijas: [guion canónico](https://github.com/mmasias/pyAI-edu/blob/main/docs/plantillas/guion-defensa-canonico.md). Adaptación a proyectos de la pregunta "modifica esto en vivo": *"cambia esta dependencia y recalcula el camino crítico delante de mí"*.
- Formato breve (3-5 minutos) y fundamento: [verificación oral de autoría](https://github.com/mmasias/pyProtocoloIA/blob/main/herramientas/verificacionOral.md).
- Dónde hacerla: en las dos sesiones síncronas obligatorias por asignatura. El vídeo asíncrono de defensa que prevé el protocolo de modalidad virtual sirve como mínimo, pero es más débil: se puede guionizar.
- La velocidad de avance puede orientar dónde mirar, pero lo que se registra y activa la verificación es un indicio de producto, proceso o interacción, no la rapidez.

#### 7. Diseñar primero, ejecutar después

El alumno fija sus decisiones sin IA en un momento controlado; después ejecuta con IA permitida; se evalúa la fidelidad a lo que diseñó. La IA deja de sustituir al alumno y pasa a ser su herramienta de ejecución.

- Evidencia: [examen parcial de EDA1 26-27](https://github.com/mmasias/26-27-eda1/blob/main/evaluaciones/examenes/examenParcial/PILA/README.md). Parte 1, 60 minutos sin ordenador: diseño congelado que actúa como contrato. Parte 2, 60 minutos con ordenador e IA: se evalúa la fidelidad al diseño, no que el código funcione.
- Variante: [`QUE_HACE.md`](https://github.com/mmasias/25-26-idsw2-sdVC/blob/main/QUE_HACE.md) en las sesiones de VibeCoding, una frase en el primer commit que ya no se modifica: el alumno no puede redefinir su objetivo después de saber qué consiguió construir.
- Adaptación a proyectos: en una de las sesiones síncronas obligatorias, el alumno fija sin IA alcance, supuestos, criterio de éxito en una frase y estrategia frente a los tres riesgos principales. Después desarrolla el plan con IA. Las desviaciones respecto a lo fijado se justifican por escrito.

### Costo alto (rediseño)

#### 8. Consignas ancladas a un contexto que la IA no tiene

Un caso genérico de manual se resuelve con un prompt. Un proyecto real del propio alumno (su organización, sus interesados, sus restricciones) exige información que solo él posee y que se puede contrastar en la defensa.

- Fundamento: [consignas ancladas](https://github.com/mmasias/pyProtocoloIA/blob/main/herramientas/consignasAncladas.md).
- Evidencia: [sesiones de requisitado con clientes reales](https://github.com/mmasias/26-27-idsw1/blob/main/evaluaciones/SdR/README.md), con el ruido natural de un relato no preparado y un 40% de la nota puesto por el cliente.
- Lo que ya no basta: parametrizar el enunciado con datos del alumno (el viejo "número N" derivado del carné). Un LLM también calcula con el parámetro.

#### 9. La IA como objeto evaluado (régimen D)

Entregar al alumno una salida de IA con errores y evaluar su capacidad de auditarla. Mide lo que el profesional necesitará: revisar lo que su IA le entrega.

- Evidencia: [examen parcial de EDA1 24-25](https://github.com/mmasias/24-25-EDA1-ExamenParcial/blob/main/README.md), análisis crítico de implementaciones alternativas (aliasing, copia frente a referencia). Las [sesiones de VibeCoding](https://github.com/mmasias/25-26-IDSW2/blob/main/evaluaciones/SdVc.md) con su [`conversation-log.md`](https://github.com/mmasias/25-26-idsw2-sdVC/blob/main/conversation-log.md): cada intercambio con la IA registra prompt, resultado y **decisión** (qué se aceptó, qué se rechazó y por qué), escrito durante la sesión y usado después como fuente primaria del examen de análisis.
- Adaptación a proyectos: un plan generado por IA con errores sembrados (camino crítico mal calculado, holguras imposibles, riesgos sin responsable, presupuesto que no cuadra con la EDT). Se pide una auditoría razonada.

#### 10. Examen personalizado sobre la producción del propio alumno

Cada alumno recibe preguntas extraídas de lo que él mismo entregó durante el curso. No hay respuesta que copiar porque no hay dos exámenes iguales.

- Evidencia: [evaluación personalizada mediante análisis de repositorios](evaluacionPersonalizada.md) (45 exámenes distintos generados en 3 horas a partir de commits de cada alumno). Limitaciones declaradas en el propio documento: no validado empíricamente y desviación de complejidad entre exámenes.
- Adaptación a proyectos: generar las preguntas del examen supervisado (Proctor) o de la defensa a partir de los documentos compartidos de cada alumno.

#### 11. Rúbrica de proceso y producto

Separar en la rúbrica lo que mide el producto de lo que mide el proceso. Un producto excelente sin proceso coherente es una discontinuidad visible en la propia nota.

- Fundamento: [rúbrica de proceso y producto](https://github.com/mmasias/pyProtocoloIA/blob/main/herramientas/rubricaProceso.md).
- Evidencia: el baremo de doble eje de [#2Think](https://github.com/mmasias/25-26-idsw2-sdVC/blob/main/2Think.md). Académicamente, *"llegué hasta aquí" tiene valor si el análisis es bueno*; profesionalmente, *sistema que no funciona no existe*.

### Hoja de ruta sugerida

<div align=center>

|Momento|Medidas|Condición|
|-|-|-|
|Este curso|1, 2, 3, 4|Solo guías docentes y plantillas|
|Piloto en una asignatura|5 + 7 o 9|Medir antes y después la distribución de tiempos de finalización y de notas|
|Siguiente curso|6, 8, 10, 11|Horas docentes presupuestadas; revisar si la memoria verificada lo admite|

</div>

## ¿Y ahora qué?

### Límites que conviene decir en voz alta

- **Sin momento síncrono no hay garantía de autoría, solo indicios.** Si el máster no puede sostener ningún momento en vivo, las demás medidas reducen el problema pero no lo cierran.
- **La verificación cuesta horas docentes.** La verificación reactiva (solo bajo indicio) contiene ese costo, pero no lo anula. Lo que hay que negociar con la dirección son las horas, no la idea.
- **El registro de decisiones es fabricable.** El cruce entre registro e historial verifica que ambos sean simultáneos, no que digan la verdad, y un historial con fechas manipuladas lo derrota. Por eso ningún registro sustituye a la conversación: el registro orienta y la defensa decide.
- **Lo no probado.** El guion de defensa cubre bien productos de texto y código; la parte de cálculo de un máster de proyectos (cronogramas, presupuestos, valor ganado) necesita adaptar la pregunta de modificación en vivo, como se sugiere en la medida 6.

### Para seguir

- Marco completo y vigente: [pyAI-edu](https://github.com/mmasias/pyAI-edu) ([resumen operativo](https://github.com/mmasias/pyAI-edu/blob/main/RESUMEN-OPERATIVO.md)).
- Aterrizaje por titulación: [plantilla de aterrizaje](https://github.com/mmasias/pyProtocoloIA/blob/main/aterrizajes/PLANTILLA-aterrizaje.md), sobre la que el máster podría redactar el suyo (la plantilla conserva los cuatro regímenes previos al cribado; usar A/B/D).
- Política del grado: [nuestra política con respecto a la IA](2Think.md) / [metodología integrada](metodologiaIntegrada.md).
