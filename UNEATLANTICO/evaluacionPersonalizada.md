# Evaluación personalizada mediante análisis de código en repositorios Git

Hacia un modelo de evaluación basado en la producción real del estudiante

> ## *TL;DR*
> 
> Metodología de evaluación que invierte el modelo tradicional: en lugar de presentar problemas genéricos a todos los estudiantes, cada uno recibe un examen único generado mediante análisis automatizado de su código en Git.
> 
> **Mecánica:** Sistema extrae fragmentos del código que el estudiante entregó durante el curso vía Pull Requests. LLM identifica patrones interesantes (lógica redundante, nomenclatura inconsistente, estructuras complejas). Se genera examen personalizado con 10 preguntas extraídas de commits específicos. Estudiante debe explicar y defender su propio código.
> 
> **Resultado:** 45 exámenes completamente diferentes, generados en 3 horas, con trazabilidad completa a código original. Imposibilidad técnica de plagio. Evaluación de competencia real (revisión de código propio) en lugar de conocimiento abstracto.
> 
> **Requisitos:** Git operativo, acceso a LLM, código producido por estudiantes durante el curso.
> 
> **Limitación crítica:** No validado empíricamente. Desviación de complejidad 1.71x entre exámenes plantea posible problema de equidad.

## ¿Por qué?

### El problema de la evaluación tradicional en programación

La enseñanza de programación presenta una contradicción fundamental: durante semanas, los estudiantes escriben código, cometen errores específicos, desarrollan patrones personales de resolución, evolucionan en su comprensión... pero el examen final ignora completamente esta trayectoria individual y presenta un problema genérico desde cero.

**Limitaciones estructurales del modelo actual:**

La evaluación tradicional opera mediante exámenes idénticos para todos los estudiantes. Este enfoque genera cinco problemas principales:

**Desconexión entre práctica y evaluación.** No existe relación entre el código que el estudiante entregó durante el curso y el contenido del examen. El estudiante puede haber trabajado intensamente en estructuras de control complejas, pero el examen evalúa arrays; o puede haber dominado la recursión, pero el examen se centra en bucles simples. La evaluación se desvincula del aprendizaje real.

**Contexto artificial.** Los problemas de examen se diseñan para ser genéricos y equivalentes en dificultad. Consecuencia: no reflejan las decisiones, errores o aprendizajes específicos de cada estudiante. Se evalúa competencia abstracta, no comprensión del código producido.

**Facilitación de plagio.** Exámenes idénticos invitan a soluciones idénticas. La detección de plagio se dificulta porque las respuestas correctas son necesariamente similares. No existe incentivo para desarrollar aproximaciones personales.

**Inviabilidad de personalización manual.** Crear N versiones diferentes de un examen, cada una calibrada individualmente, es inviable para un docente con 50+ estudiantes. La personalización colisiona con la escala.

**Externalización de responsabilidad.** El estudiante puede argumentar "este problema no lo vimos en clase" o "este enfoque es diferente al que usamos". La evaluación permite distancia entre el estudiante y el código examinado.

### La brecha entre competencias profesionales y evaluación académica

En contextos profesionales, los programadores raramente escriben código desde cero sin restricciones. Las actividades reales incluyen:

- Mantener y modificar código existente (propio o de terceros)
- Revisar código en code reviews, identificando problemas y justificando decisiones
- Explicar decisiones técnicas tomadas previamente
- Depurar código heredado o antiguo
- Proponer mejoras argumentadas sobre implementaciones existentes

La evaluación tradicional no replica ninguna de estas competencias. Pregunta fundamental: ¿por qué no evaluar directamente sobre el código que los estudiantes ya produjeron durante el curso?

### La tensión entre personalización y escala

Existe un dilema pedagógico conocido:

- Evaluación personalizada: alto valor pedagógico, feedback específico, imposibilidad de plagio → inviable con grupos grandes
- Evaluación masiva genérica: escalable, administrable → bajo valor pedagógico, feedback genérico, plagio facilitado

Este dilema se asumía como restricción estructural. Personalizar = sacrificar escala. Escalar = sacrificar personalización.

## ¿Qué?

### Evaluación sobre código real mediante análisis automatizado

El modelo propuesto invierte el flujo tradicional: en lugar de presentar problemas al estudiante, se extraen problemas del código que el estudiante escribió.

**Principio central:** Cada estudiante recibe un examen único generado mediante análisis automatizado de sus entregas de código en un repositorio Git. Las preguntas no se inventan, se descubren. El LLM no evalúa, identifica fragmentos interesantes. El estudiante debe entonces demostrar comprensión de su propio código.

**Arquitectura del sistema:**

El modelo combina cuatro componentes:

**Git/GitHub como infraestructura pedagógica.** No es un sistema de entrega, es la plataforma de captura de evidencias. Cada commit, cada Pull Request, cada modificación queda registrada con timestamp y autor. El repositorio se convierte en fuente de verdad sobre lo que el estudiante produjo, cuándo y cómo evolucionó.

**Pull Requests como mecanismo de entrega y trazabilidad.** Cada entrega es un PR. Cada PR contiene archivos específicos, cambios concretos, comentarios del docente. Esta estructura permite extracción precisa: "En tu PR #3, archivo `Reto2.java`, líneas 47-52, escribiste este código".

**LLM como asistente de análisis, no como evaluador.** El modelo de lenguaje analiza el código buscando patrones: lógica redundante, nomenclatura inconsistente, estructuras complejas innecesarias, errores tipográficos. No determina corrección/incorrección, solo señala fragmentos que merecen reflexión.

**Evaluación formativa basada en reflexión crítica.** El formato de pregunta es siempre: "Observa este fragmento de tu código. ¿Qué identificas? ¿Es correcto o hay problema? Si hay problema, ¿cuál es y cómo lo corregirías?". El estudiante debe ejercer pensamiento crítico sobre su propia producción.

## ¿Para qué?

### Cómo este modelo resuelve los problemas identificados

**Elimina la desconexión entre práctica y evaluación.**

El examen se construye directamente del código entregado. Imposible que el estudiante argumente "esto no lo vimos en clase": es su código, decidió escribirlo así. La evaluación se convierte en continuación natural del proceso de aprendizaje, no en evento desconectado.

**Genera contexto auténtico.**

Cada pregunta referencia código real que el estudiante escribió en contexto específico (resolver el Reto 2, implementar validación de entrada, etc.). El estudiante debe defender decisiones que realmente tomó, no resolver problemas hipotéticos.

**Imposibilita el plagio.**

Cada examen es único porque cada código es único. No se pueden copiar respuestas porque las preguntas son diferentes. Copiar código de otro durante el curso se vuelve contraproducente: generará un examen sobre código que no se entiende.

**Hace viable la personalización a escala.**

La generación asistida por LLM permite crear 50 exámenes personalizados en 3-4 horas. El costo temporal se reduce dramáticamente mientras el valor pedagógico se maximiza. Se rompe el dilema escala vs. personalización.

**Fuerza responsabilidad directa.**

El estudiante no puede externalizar. No es "el profesor me puso este problema", es "yo escribí este código". El examen revela un mapa de decisiones propias que deben explicarse. Cambio de mentalidad: de receptor pasivo a autor responsable.

### Alineación con competencias profesionales

El formato replica exactamente las actividades de un programador profesional:

- Revisión de código: identificar problemas en fragmentos específicos
- Justificación técnica: explicar por qué una implementación es problemática
- Propuesta de mejora: no solo identificar error, sino proponer corrección argumentada
- Ownership: defender código propio, no especular sobre código ajeno

La evaluación deja de ser simulacro artificial y se convierte en práctica auténtica de actividad profesional.

### Valor formativo implícito

Cada pregunta del examen constituye feedback indirecto:

- "Encontré esto en tu código" implica "deberías revisar este aspecto"
- La distribución de preguntas (70% lógica simple, 15% lógica compleja, 4% nomenclatura) revela el mapa de fortalezas y debilidades del estudiante
- Los fragmentos seleccionados actúan como guía de qué mejorar en futuras entregas

El examen mismo funciona como herramienta de aprendizaje, no solo como instrumento de medición.

## ¿Cómo?

### Implementación técnica del sistema

#### Fase 1: Captura de código

**Estructura del repositorio:**

El curso opera sobre un repositorio central (ejemplo: `mmasias/25-26-PRG1`) con la siguiente arquitectura:

```
curso-prg1/
├── retos/                    # Enunciados de los retos
│   ├── reto1/
│   ├── reto2/
│   └── reto3/
├── entregas/                 # Zona de entregas
│   ├── estudiante1/
│   ├── estudiante2/
│   └── ...
└── evaluaciones/
    └── examenes/
        └── examenParcial/
            └── enunciados/   # Exámenes generados
```

**Flujo de trabajo del estudiante:**

1. El estudiante crea una branch personal: `entregas/nombreEstudiante` (o bien forkea el repo)
2. Desarrolla su solución en su directorio: `entregas/nombreEstudiante/reto2/` (o bien, modifica únicamente su archivo personalizado)
3. Crea un Pull Request contra la rama principal
4. El docente revisa y hace merge (o solicita cambios)
5. El historial completo queda registrado: qué código, cuándo, qué cambios

Este flujo captura automáticamente:

- Código final de cada entrega
- Evolución temporal (commits sucesivos)
- Versiones previas (historial de cambios)
- Contexto (comentarios en PRs)

#### Fase 2: Análisis automatizado

**Extracción de datos mediante GitHub API:**

[Script de análisis](scriptsEvaluacionPersonalizada/scriptAnalisis.py) recorre la lista de estudiantes y por cada uno:

Para cada PR, se descargan los archivos `.java` (o el lenguaje relevante) y se construye un corpus del código del estudiante.

**Análisis mediante LLM:**

El prompt al modelo de lenguaje sigue esta estructura:

```
Analiza el siguiente código Java de un estudiante de programación nivel inicial.

TAREA: Identificar 10 fragmentos de código que presenten oportunidades de reflexión.
Buscar específicamente:

1. Lógica redundante o innecesariamente compleja
2. Condiciones que pueden simplificarse
3. Nomenclatura inconsistente o no descriptiva
4. Errores tipográficos en identificadores
5. Estructuras de control anidadas excesivamente
6. Uso de conceptos más avanzados de lo esperado
7. Reuso incorrecto de variables
8. Comparaciones que pueden optimizarse

IMPORTANTE: No determinar si es correcto o incorrecto. Solo identificar fragmentos
interesantes que ameriten que el estudiante reflexione sobre ellos.

Por cada fragmento identificado, proporcionar:
- Fragmento de código exacto
- Ubicación (archivo, líneas aproximadas)
- Categoría (lógica simple, lógica compleja, nomenclatura, etc.)
- Nivel de complejidad (1-5)
- Enlace al commit donde aparece

CÓDIGO DEL ESTUDIANTE:
[aquí se inserta el código extraído de los PRs]
```

El LLM retorna un JSON estructurado:

```json
{
  "fragmentos": [
    {
      "codigo": "if (edad >= 18 == true) { ... }",
      "archivo": "entregas/estudiante1/reto2/Validacion.java",
      "lineas": "47-49",
      "categoria": "logica_simple",
      "complejidad": 2,
      "commit_url": "https://github.com/repo/commit/abc123",
      "observacion": "Comparación redundante con true"
    },
    {
      "codigo": "String LUZ_ENCENCIDA = \"ON\";",
      "archivo": "entregas/estudiante1/reto3/Control.java",
      "lineas": "12",
      "categoria": "nomenclatura",
      "complejidad": 1,
      "commit_url": "https://github.com/repo/commit/def456",
      "observacion": "Error tipográfico en constante"
    }
  ]
}
```

**Categorización de fragmentos:**

El sistema clasifica los fragmentos identificados en categorías con distribución aproximada (basada en el caso de estudio con 45 estudiantes):

- Lógica simple (~70%): `if (x == true)`, `while (condicion == false)`, comparaciones redundantes
- Lógica compleja (~15%): anidamiento excesivo, múltiples condiciones combinadas
- Nomenclatura (~4%): variables mal nombradas, identificadores no descriptivos
- Errores tipográficos (~8%): `PORCENTAJE_EXITO_VAMPRIO`, `LUZ_ENCENCIDA`
- Estructura (~1%): reuso incorrecto de variables, declaraciones duplicadas
- Avanzados (~2%): uso de ArrayList, métodos, conceptos fuera de temario básico

#### Fase 3: Generación de exámenes

**Formato markdown del examen:**

Por cada estudiante, se genera un archivo markdown siguiendo esta plantilla:

[Plantilla](scriptsEvaluacionPersonalizada/plantillaExamen.md)

**Trazabilidad completa:**

Cada pregunta incluye:
- Contexto específico (qué reto, qué archivo)
- Código exacto extraído
- Enlace directo al commit donde aparece ese código
- Formato consistente para todas las preguntas

Esta trazabilidad permite:
- Verificar que el código es auténtico del estudiante
- Detectar intentos de plagio (código inconsistente con el estilo personal)
- Facilitar revisión por parte del docente
- Permitir al estudiante revisar el contexto original

#### Fase 4: Evaluación por parte del estudiante

**Estructura de la respuesta esperada:**

Por cada pregunta seleccionada (5 de 10), el estudiante debe proporcionar:

```markdown
**Respuesta Pregunta X**

**Observación:**
[Descripción de qué identifica en el código]

**Análisis:**
[Determina si es correcto o problemático, con justificación]

**Corrección propuesta (si aplica):**
[Código corregido o explicación de por qué no requiere corrección]

**Justificación:**
[Argumentación técnica de la respuesta]
```

**Criterios de evaluación del docente:**

El docente evalúa:

1. **Capacidad de identificación:** ¿Detecta el estudiante el problema/característica relevante del fragmento?
2. **Comprensión conceptual:** ¿Entiende por qué es problemático (o por qué no lo es)?
3. **Propuesta de solución:** ¿La corrección propuesta es técnicamente correcta?
4. **Argumentación:** ¿Justifica adecuadamente sus afirmaciones?

No se evalúa si el código original era correcto/incorrecto, sino si el estudiante demuestra comprensión crítica sobre su propio código.

### Automatización del proceso completo

**Script de generación de exámenes:**

[Script](scriptsEvaluacionPersonalizada/scriptGeneracion.py)

**Tiempo de ejecución:**

Para 50 estudiantes:
- Extracción de código vía GitHub API: ~30 minutos
- Análisis con LLM (50 llamadas, ~30 segundos c/u): ~25 minutos
- Generación de markdown: ~5 minutos
- **Total: ~60 minutos de ejecución automatizada**

El docente necesita:
- ~30 minutos: configuración inicial del script
- ~60 minutos: ejecución automatizada
- ~30 minutos: revisión y ajustes finales

**Total: ~2 horas para 50 exámenes personalizados**

### Resultados del caso de estudio

**Contexto:**

- Asignatura: Programación 1, UNEATLANTICO
- Periodo: Septiembre-Octubre 2025
- Estudiantes totales: 52
- Estudiantes con entregas: 45
- Retos base: 3 principales

**Producción:**

- 45 exámenes personalizados (estudiantes activos)
- 10 exámenes genéricos (estudiantes sin entregas)
- 450 preguntas únicas generadas (45 × 10)
- Trazabilidad: 100% de fragmentos con enlaces a commits
- Tiempo de generación: ~3 horas (incluyendo ajustes manuales)

**Distribución de categorías en las preguntas generadas:**

| Categoría | Porcentaje | Ejemplos característicos |
|-----------|------------|-------------------------|
| Lógica simple | ~70% | `if (x == true)`, `while (!flag == true)`, `return x == 5 ? true : false` |
| Lógica compleja | ~15% | Anidamiento >3 niveles, múltiples condiciones combinadas sin paréntesis |
| Nomenclatura | ~4% | `int x1`, `String s`, `boolean flag2` (no descriptivos) |
| Errores tipográficos | ~8% | `PORCENTAJE_EXITO_VAMPRIO`, `LUZ_ENCENCIDA`, `calidficacion` |
| Estructura | ~1% | Reuso de variables temporales, declaraciones duplicadas |
| Avanzados | ~2% | Uso de `ArrayList`, métodos con parámetros complejos, recursión |

**Análisis de complejidad:**

Se calculó un índice de complejidad (1-5) para cada examen basado en:
- Proporción de preguntas de lógica compleja
- Presencia de conceptos avanzados
- Sofisticación del código analizado

Resultados:
- Examen más simple: índice 2.40
  - 40% errores tipográficos evidentes
  - 30% lógica simple
  - 0% conceptos avanzados
  
- Examen más complejo: índice 4.10
  - 30% conceptos avanzados (métodos, estructuras de datos)
  - 30% lógica compleja
  - 20% lógica simple
  
- Desviación: 1.71x entre el más simple y el más complejo

**Interpretación de la desviación:**

Esta variación no constituye un problema, es una característica del sistema. Refleja que:

- Estudiantes que produjeron código más sofisticado deben poder explicar esa sofisticación
- La dificultad del examen escala con la ambición del código producido
- Es una evaluación justa: cada estudiante responde sobre lo que eligió producir
- Incentiva calidad: mejor código genera mejores preguntas (más interesantes, no necesariamente más difíciles)

## ¿Alternativas?

**Evaluación continua mediante micro-exámenes semanales.** En lugar de un examen final, generar mini-exámenes de 3 preguntas cada semana basados en las últimas entregas. Ventaja: feedback inmediato y continuo. Inconveniente: mayor carga administrativa semanal.

**Evaluación colaborativa entre pares.** Parejas de estudiantes intercambian exámenes generados de sus propios códigos y se evalúan mutuamente. Ventaja: desarrollo de pensamiento crítico al analizar código ajeno antes de aplicarlo al propio. Inconveniente: requiere entrenamiento previo en evaluación entre pares.

**Evaluación con progresión temporal.** Incluir preguntas que comparen versiones sucesivas del mismo código (commit anterior vs commit actual), preguntando qué mejoró, qué empeoró, y por qué se hizo ese cambio. Ventaja: evalúa evolución y reflexión sobre el proceso. Inconveniente: requiere que los estudiantes hayan iterado significativamente sobre su código.

## ¿Y ahora qué?

### Líneas de investigación abiertas

El modelo presentado abre preguntas de investigación que requieren estudios empíricos:

**Impacto en aprendizaje.** ¿Cómo afecta este tipo de evaluación a la retención de conocimientos comparado con exámenes tradicionales? ¿Los estudiantes desarrollan mejor pensamiento crítico sobre código? Se requiere estudio longitudinal con grupo de control.

**Patrones de error por nivel.** ¿Qué errores son más comunes en estudiantes de nivel inicial vs intermedio vs avanzado? ¿Estos patrones son transferibles entre cohortes? Un análisis de corpus extenso permitiría identificar progresiones típicas.

**Efecto conductual.** ¿Cambia la calidad del código que los estudiantes entregan cuando saben que será material de examen? ¿Se vuelven más cuidadosos? ¿O simplemente más conservadores? Análisis comparativo antes/después de implementar el sistema.

**Estrategias de selección.** Cuando se permite elegir 5/10 preguntas, ¿qué estrategias usan los estudiantes? ¿Eligen las más fáciles? ¿Las que mejor entienden? ¿Las que representan sus fortalezas? Estudio de estrategias metacognitivas.

### Extensiones técnicas del sistema

**Integración con IDE.** Desarrollar plugin que analice código en tiempo real durante desarrollo, generando micro-feedback instantáneo similar a las preguntas de examen. Estudiante escribe código → plugin identifica fragmento interesante → presenta pregunta de reflexión.

**Sistema de dificultad adaptativa.** Ajustar automáticamente la dificultad de futuras preguntas basándose en el desempeño en exámenes anteriores. Estudiante demuestra dominio de lógica simple → próximo examen enfatiza lógica compleja.

**Análisis comparativo anónimo.** Generar reportes que comparen (de forma anónima) el código de un estudiante con patrones típicos de la cohorte. "Tu uso de bucles anidados es 2.3x más frecuente que el promedio de la clase" → invita a reflexión sobre patrones personales.

### Implementación gradual para docentes

Para docentes que quieran experimentar con este modelo:

**Fase piloto (1-2 semanas):** Seleccionar 5 estudiantes voluntarios. Generar manualmente exámenes personalizados (sin automatización) para validar el concepto pedagógico. Recoger feedback cualitativo.

**Fase semi-automatizada (1 mes):** Implementar script básico de extracción de código. Usar LLM para análisis pero revisar manualmente cada examen generado. Documentar problemas y ajustar prompts.

**Fase automatizada (semestre completo):** Extender a toda la clase. Automatizar completamente la generación. Monitorear métricas: tiempo de generación, distribución de categorías, feedback de estudiantes.

### Condiciones para replicabilidad

Este modelo es replicable en cualquier contexto con las siguientes condiciones mínimas:

**Requisitos técnicos:**
- Repositorio Git operativo (GitHub, GitLab, Bitbucket)
- Acceso a API del repositorio
- Acceso a LLM (Claude, GPT-4, o similar)
- Conocimientos básicos de scripting (Python o similar)

**Requisitos pedagógicos:**
- Estudiantes que entreguen código periódicamente
- Cultura de uso de control de versiones establecida
- Docente dispuesto a ceder control de generación de preguntas al proceso automatizado

**Requisitos organizacionales:**
- Permiso institucional para uso de LLMs en evaluación
- Presupuesto para costos de API (estimado: €2-5 por estudiante)
- Tiempo de configuración inicial (5-10 horas primera vez, 2 horas subsiguientes)

### Limitaciones reconocidas y casos no cubiertos

El sistema no aplica cuando:

**No existe código previo.** Primera semana de curso, conceptos puramente teóricos, estudiantes sin entregas. Solución: mantener banco de preguntas genéricas para estos casos.

**Evaluación de conceptos abstractos.** Complejidad algorítmica, teoría de tipos, paradigmas de programación. Estos requieren evaluación tradicional complementaria.

**Estudiantes sin historial Git.** Quienes no entregaron nada no pueden evaluarse con este método. Se requiere plan B (examen genérico o evaluación alternativa).

### Próximos desarrollos en este documento

Los siguientes aspectos requieren desarrollo adicional:

**Marco de evaluación de calidad de preguntas.** Definir métricas objetivas para determinar si una pregunta generada es pedagógicamente valiosa. ¿Qué hace que una pregunta sea "buena" vs "trivial" vs "confusa"?

**Análisis de sesgo del LLM.** Investigar si el LLM presenta sesgos en qué tipos de código identifica como problemáticos. ¿Favorece ciertos estilos de programación? ¿Penaliza implícitamente aproximaciones válidas pero no convencionales?

**Integración con sistemas de gestión de aprendizaje.** Explorar conexión con Moodle, Canvas u otros LMS para automatizar distribución de exámenes y recolección de respuestas.

---

**Documento elaborado:** Noviembre 2025  
**Autor:** Manuel Masías  
**Institución:** UNEATLANTICO  
**Caso de estudio:** 52 estudiantes, Programación 1, curso 2025-26

Repositorios del caso: [github.com/mmasias/25-26-PRG1](https://github.com/mmasias/25-26-PRG1) [github.com/mmasias/25-26-PRG1-ExamenParcial](https://github.com/mmasias/25-26-PRG1-ExamenParcial)
