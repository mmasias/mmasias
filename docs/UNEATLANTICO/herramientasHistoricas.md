# Herramientas de reproducción de escritura para educadores

## ¿Por qué?

La evaluación tradicional de trabajos escritos opera sobre el producto final: el texto entregado. Este enfoque presenta dos deficiencias estructurales. Primera, invisibiliza el proceso cognitivo del escritor, que incluye pausas, revisiones, reelaboraciones y saltos de productividad — señales diagnósticas que el texto pulido elimina. Segunda, no discrimina entre escritura humana y generación automatizada: un texto producido por IA y uno escrito laboriosamente pueden ser indistinguibles en su forma final.

La proliferación de herramientas de IA generativa agrava el segundo problema hasta convertirlo en urgente para cualquier contexto de evaluación formal.

## ¿Qué?

Una herramienta de reproducción de escritura (*writing replay tool*) registra cada acción del escritor durante la producción de un documento — pulsaciones, borrados, pausas, pegados — y genera una grabación reproducible de esa sesión. El evaluador accede a una reconstrucción cronológica del proceso, no solo al resultado.

Las herramientas actuales del mercado son: GPTZero Writing Report, Draftback, Grammarly Authorship y Turnitin Clarity. De estas, GPTZero es la única que opera sin abandonar Google Docs, soporta múltiples editores sobre el mismo documento y combina la reproducción con detección de IA integrada.

## ¿Para qué?

Dos finalidades principales, no excluyentes:

**Detección de uso de IA.** La escritura humana produce un patrón característico: bloques discontinuos, retrocesos frecuentes, revisiones iterativas. La escritura delegada a IA produce el patrón opuesto: pegados masivos con escasa intervención posterior. La reproducción permite al evaluador observar ese patrón sin depender exclusivamente de un clasificador automático cuyo veredicto el escritor puede impugnar.

**Retroalimentación pedagógica.** La grabación identifica dónde el escritor se bloquea, qué partes reescribe más veces, cuánto tiempo invierte en cada sección. Esto convierte la evaluación en diagnóstico y abre la posibilidad de retroalimentación dirigida al proceso, no solo al resultado.

Un beneficio adicional en trabajos colaborativos: herramientas como GPTZero permiten desagregar las contribuciones por editor, lo que resuelve un problema recurrente en trabajos grupales donde la carga real de trabajo es desigual.

## ¿Cómo?

El flujo operativo general:

1. El escritor instala la extensión correspondiente (Chrome, en la mayoría de casos) y la activa antes de comenzar a escribir.
2. La herramienta registra la sesión en segundo plano durante todo el proceso de redacción.
3. Al concluir, se genera un informe accesible mediante enlace compartible o exportación en PDF.
4. El evaluador reproduce la grabación, con controles de velocidad de reproducción y, en el caso de GPTZero, marcadores sobre la barra de progreso que señalan los momentos de mayor actividad de pegado.

### Comparativa operativa relevante

| Herramienta | Integración | Múltiples editores | Detección IA | Marcadores en barra |
|---|---|---|---|---|
| GPTZero | Dentro de Google Docs | Sí | Sí | Sí |
| Draftback | Tab separada | No | No | No |
| Grammarly Authorship | Tab separada | No | Parcial | No |
| Turnitin Clarity | Editor propio | No | Sí | Sí |

La restricción principal de Turnitin Clarity — exigir que el estudiante escriba en su propio entorno — limita su aplicabilidad en contextos donde Google Docs u otros editores en línea son el estándar del curso.


## ¿Y ahora qué?

La adopción de estas herramientas en entornos educativos plantea una cuestión de diseño curricular: la eficacia de la reproducción como mecanismo de evaluación depende de que los estudiantes sepan desde el inicio que el proceso será registrado. Esto no elimina el valor de la herramienta — al contrario, el conocimiento previo del registro funciona como incentivo para una escritura auténtica — pero requiere que el docente lo establezca explícitamente como parte de la metodología del curso.
