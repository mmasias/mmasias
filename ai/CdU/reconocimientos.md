# CdU > Reconocimientos

## ¿Para qué?

Evaluar y comparar el contenido de guías docentes de asignaturas de dos universidades para determinar si cumplen con al menos un 70% de similitud en términos de contenidos.

## ¿Qué?

- Proceso:
  - Utilizar ChatGPT para procesar y analizar el contenido de Documento A y Documento B.
  - Comparar y evaluar la similitud entre los dos documentos.
  - Calcular el grado de similitud entre los contenidos, expresado como un porcentaje.
  - Generar un informe de evaluación que muestre el grado de similitud encontrado.
- Entradas:
  - Documento A (Guía Docente de Universidad A).
  - Documento B (Guía Docente de Universidad B).
- Salida:
  - Informe de Evaluación:
  - Porcentaje de similitud entre Documento A y Documento B.
  - Confirmación de si la similitud es igual o superior al 70%.

## ¿Por qué?

- Automatizar el proceso de evaluación y comparación de guías docentes de asignaturas de diferentes universidades para determinar si cumplen con un nivel mínimo de similitud del 70%.
- Ahorrar tiempo y esfuerzo en la revisión manual de los contenidos de las guías docentes.
- Facilitar la toma de decisiones sobre la equivalencia de asignaturas entre universidades o la transferencia de créditos.

## ¿Cómo?

|||
|-|-|
Paso 1: Preparación de Datos|Obtener los documentos (Guías Docentes) de las dos universidades que se desean comparar.
Paso 2: Procesamiento de Datos|Utilizar un LLM de procesamiento de lenguaje natural basada para analizar y procesar los contenidos de ambos documentos.
Paso 3: Comparación de Contenidos|Comparar el resultado del procesamiento para ambos documentos.<br>Calcular la similitud entre los contenidos utilizando métricas adecuadas.
Paso 4: Generación de Informe|Generar un informe que incluya el porcentaje de similitud calculado.<br>Confirmar si el porcentaje de similitud es igual o superior al 70%.
Paso 5: Toma de Decisiones|Basándose en el informe, tomar decisiones sobre la equivalencia de asignaturas o la transferencia de créditos entre las dos universidades.

### 🤖: Claude.ai

|Prompt|Pa' qué|Comentario
|-|-|-
Compara los contenidos de las asignaturas que te envío y dime si coinciden en al menos en un 70%, utilizando como referencia los contenidos del documento de la Universidad Europea del Atlántico. Crea una tabla que muestre esta comparación, con una columna por asignatura y los contenidos en las filas. En los encabezados de las columnas pones los nombres de cada archivo y agrega una columna adicional que diga si hay coincidencia o no. Luego compara también las competencias especificas y los resultados de aprendizaje|Ayuda para evaluar el reconocimiento de asignaturas|Necesita supervisión
Compara las competencias y los resultados de aprendizaje|Extender la comparación|

#### Respuesta 
---

Aquí está la tabla comparativa de los contenidos de las dos asignaturas de Programación I:

| Introduccion_al_Software.pdf | C1S1 - IYA003 - Programacion I - rMMV-2022-09-02.docx | ¿Coinciden? |
|-|-|-|
| Fundamentos de programación en C. Estructura de un programa C. Entrada/salida de texto y de caracteres. Entrada/salida de números. Funciones | Tema 2: El lenguaje de programación JAVA. Características. Instalación y Primeros programas. | No |
| Datos y expresiones. Tipos primitivos. Variables y constantes. Operadores y expresiones. Conversión de tipos. Paso de parámetros. Uso de funciones matemáticas. | Tema 3: Variables, Tipos de Datos y Operadores. Variables y tipos de datos. Identificador de variable. Operadores aritméticos. Operadores de asignación. | Parcialmente |
| Estructuras algorítmicas. Instrucción condicional. Instrucción condicional múltiple. Instrucciones de bucle. Recursividad. Descripción de algoritmos mediante pseudocódigo. | Tema 5: Estructuras de control alternativas. Construcción de expresiones lógicas. Operadores lógicos y relacionales. Estructura alternativa simple y doble. Estructura alternativa múltiple. Tema 6: Estructuras de control repetitivas. Estructuras de control repetitivas. Estructura de control repetitiva while y do-while. Estructura de control repetitiva for. | Sí |  
| Datos compuestos. Arrays y tablas unidimensionales. Algoritmos de recorrido y búsqueda. Arrays multidimensionales. Tipos enumerados. Estructuras | Tema 7: Tipos de variables II. Arreglos. Introducción a los arreglos. Arreglos unidimensionales. Operaciones básicas sobre arreglos. Arreglos multidimensionales. | Sí |
| Programación modular. Diseño modular. Ámbito de las variables. Bibliotecas | Tema 8: Métodos estáticos. Introducción. Declaración de métodos. Paso de variables. | Sí |
| Estructuras de datos dinámicas. Definición. Declaración de punteros y asignación de memoria. Reserva dinámica de memoria. Punteros y funciones. Punteros y estructuras |  | No |
| Uso de sistemas operativos. Uso de un entorno integrado de desarrollo de programas. Uso de una hoja de cálculo. Uso de una base de datos. |  | No |

En cuanto a las competencias específicas y los resultados de aprendizaje, ambas coinciden en desarrollar:

- Conocimientos sobre programación en un lenguaje como Java/C.  
- Capacidad para implementar algoritmos y programas.
- Manejo de variables, tipos de datos, sentencias de control, funciones, etc.

En conclusión, diría que el contenido de las dos asignaturas tiene aproximadamente un 70-80% de coincidencia en los conceptos centrales de programación imperativa y estructurada en un lenguaje como Java/C. Las diferencias se encuentran en algunos contenidos específicos de cada una.