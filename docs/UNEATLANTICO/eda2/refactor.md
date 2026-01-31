# Lo que quiero para EDA2 2026

## 01. Análisis de Algoritmos

**Objetivo**: Sentar las bases teóricas del análisis de complejidad.

### 1. Fundamentos de la Medición (El Problema)

- Independencia del Hardware: por qué medir en segundos es inútil (dependencia de CPU, OS, carga)
- Necesidad de contar *operaciones* en función de la entrada (n)
- La Tiranía del Input (n): definición según el contexto (longitud de array, nodos en árbol, bits de un entero)
- Casos de Análisis:
  - Peor caso (el estándar de ingeniería: la garantía)
  - Caso promedio (la realidad estadística: difícil de probar)
  - Mejor caso (la ilusión: poco útil para diseño robusto)

### 2. Notación Asintótica (El Lenguaje)

- Big O (O): Cota superior. "No va a ser más lento que esto". *Foco principal del curso.*
- Big Omega (Ω): Cota inferior. "Al menos tardará esto"
- Big Theta (Θ): Cota ajustada. Cuando O y Ω coinciden
- Jerarquía de Complejidad (El Ranking):
  - O(1) - Constante (Ideal)
  - O(log n) - Logarítmico (Búsqueda binaria)
  - O(n) - Lineal (Iteración simple)
  - O(n log n) - Lineal-logarítmico (Límite práctico de ordenación)
  - O(n²) - Cuadrático (Bucles anidados, ingenuo)
  - O(2ⁿ)/O(n!) - Exponencial/Factorial (Intratable)

### 3. Metodología de Cálculo (La Técnica)

- Análisis Iterativo:
  - Sentencias secuenciales → Suma
  - Bucles → Multiplicación
  - Bucles dependientes (i de 0 a n, j de 0 a i) → Sumatorias (Serie aritmética)
- Análisis Recursivo (Intro ligera):
  - Visualización del árbol de recursión
  - Mención a relaciones de recurrencia (sin profundizar en Teorema Maestro aun, reservado para módulo Recursividad)

### 4. Complejidad Espacial (La Memoria)

- Memoria Auxiliar: diferencia entre el espacio de los datos de entrada y el espacio extra requerido
- Stack vs. Heap:
  - Coste oculto de la recursividad (Stack overflow)
  - Coste de estructuras duplicadas (Inmutabilidad)
- Concepto *In-place*: Algoritmos que operan con O(1) de espacio extra (mutando la entrada)

### 5. Mapa de Paradigmas (El "Trailer" del curso)

*Mencionar estas estrategias solo como categorías de solución, indicando que se verán en profundidad más adelante.*

- Fuerza Bruta: Probar todo (Referencia: Búsqueda lineal)
- Divide y Vencerás: Partir el problema (Referencia futura: MergeSort, QuickSort, Árboles)
- Voraces (Greedy): Tomar la mejor decisión local (Referencia futura: Algoritmos de grafos/rutas)
- Vuelta Atrás (Backtracking): Explorar y retroceder (Referencia futura: Laberintos, Sudoku en Recursividad)
- Programación Dinámica (Memoization): No repetir trabajo (Mención como optimización de la recursividad)

### 6. Trade-offs (La Conclusión)

- Tiempo vs. Espacio: usar más memoria permite ir más rápido (ej: Hashing)
- Legibilidad vs. Micro-optimización: cuándo parar de optimizar

## 02. Recursividad

**Objetivo**: El motor lógico para dividir problemas.

### Anatomía de la Función Recursiva

- Caso Base: La condición de parada obligatoria (evitar *Stack Overflow*)
- Caso Recursivo: La reducción del problema hacia el caso base

### La Pila de Llamadas (Call Stack)

- Visualización de *stack frames*
- Coste espacial implícito O(n) en recursión ingenua

### Patrones de Diseño Recursivo

- Acumuladores: Pasar el estado como argumento para evitar recálculos
- Recursión de Cola (Tail Recursion):
  - Concepto: La llamada recursiva es lo último que se ejecuta
  - Conexión con el diagrama inicial: Cómo el compilador puede transformar esto en un bucle iterativo (optimización TCO)

### Paradigma: Vuelta Atrás (Backtracking)

- Exploración de espacio de soluciones (ej: Laberintos, Sudoku)
- Concepto de "poda" (dejar de buscar por una rama inviable)

### Introducción a Memoization

- Guardar resultados intermedios para no repetir ramas (puente hacia Programación Dinámica)

## 03. Ordenación

**Objetivo**: La primera gran aplicación: poner orden en el caos.

### Clasificación de Algoritmos

- Iterativos / Cuadráticos O(n²):
  - Burbuja, Selección, Inserción
  - Valor: Simplicidad, bajo overhead para n pequeño, eficiencia en listas "casi" ordenadas (Inserción)
- Recursivos / Log-Lineales O(n log n):
  - MergeSort: Paradigma "Divide y Vencerás" puro. Estabilidad garantizada.
  - QuickSort: Rendimiento práctico superior (cache-friendly), peor caso O(n²), particionado *in-place*

### Conceptos Críticos

- Estabilidad: ¿Se mantiene el orden relativo de elementos iguales? (Vital para ordenaciones múltiples)
- In-place vs. Out-of-place: Coste de memoria auxiliar

### Límites Teóricos

- Demostración de que no se puede ordenar por comparación en menos de O(n log n)
- Mención a ordenación sin comparación (Radix/Counting Sort) para casos específicos

## 04. Búsquedas

**Objetivo**: Recuperación eficiente de información.

### Búsqueda Lineal

- La única opción para datos desordenados
- El centinela (micro-optimización)

### Búsqueda Binaria

- Requisito fuerte: Datos ordenados
- Paradigma "Divide y Vencerás" (versión iterativa y recursiva)
- Cálculo del índice medio (evitar *integer overflow*)
- Variantes: *Lower Bound* y *Upper Bound* (primer/último elemento coincidente)

### Búsqueda por Interpolación

- Concepto de "guía telefónica" (estimar posición por valor)
- Rendimiento O(log log n) en distribución uniforme vs. O(n) en peor caso

## 05. Hashing

**Objetivo**: Rompiendo la barrera del logaritmo: acceso O(1).

### Concepto Base

- Transformar una clave (string, objeto) en un índice de array
- Trade-off: Sacrificamos orden y memoria para ganar velocidad constante

### La Función Hash

- Determinismo
- Uniformidad (evitar aglomeraciones)
- Eficiencia de cálculo

### Gestión de Colisiones (El problema real)

- Encadenamiento (Chaining): Listas enlazadas (o árboles) en cada bucket
- Direccionamiento Abierto: Sondeo lineal, cuadrático, doble hashing

### Factor de Carga y Rehashing

- Cuándo redimensionar la tabla para mantener la eficiencia
- Coste amortizado de la inserción

### Aplicaciones

- Diccionarios, Conjuntos (Sets), Cachés

### Hashing Dual

- Hashing para estructuras de datos: acceso O(1), tablas hash
- Hashing criptográfico: integridad de datos, contraseñas, actas
- Mismo concepto matemático, aplicaciones radicalmente diferentes

## 06. Estructuras de Datos Avanzadas

**Objetivo**: Más allá de la linealidad.

### Árboles

- Terminología (Raíz, Hoja, Altura, Profundidad, Grado)
- Recorridos: Pre-orden, In-orden (da datos ordenados en BST), Post-orden, Niveles (BFS)

### Árboles de Búsqueda Binaria (BST)

- Lógica de inserción/búsqueda
- El problema del árbol degenerado (lista enlazada encubierta)

### Árboles Balanceados (Concepto)

- Necesidad de rotaciones para mantener O(log n)
- Mención a AVL o Red-Black (sin obligar a implementarlos completos si es excesivo, pero entendiendo la mecánica)

### Montículos (Heaps) / Colas de Prioridad

- Estructura de árbol completo representada en array
- Propiedad de orden (padre vs hijos) distinta a BST (izquierda vs derecha)
- Aplicaciones: Planificadores de tareas, Dijkstra

### Grafos (Intro)

- Matriz de adyacencia vs. Lista de adyacencia (Trade-off espacio/tiempo)

## 07. Inmutabilidad

**Objetivo**: Gestión de Estado y Concurrencia.

### El Problema de la Mutabilidad

- Race conditions en entornos concurrentes
- Efectos secundarios (Side effects) impredecibles

### Definición de Inmutabilidad

- Una vez creado, no cambia. "Modificar" significa "Crear copia con cambios"

### Estructuras de Datos Persistentes

- Structural Sharing (Compartición Estructural): Cómo evitar copiar todo el árbol al modificar una hoja (Path copying)
- Eficiencia visualizada: DAG (Directed Acyclic Graph) de versiones

### Beneficios

- Thread-safety "gratis" (sin locks)
- Historial / Undo-Redo trivial

### Conexión con Programación Funcional

- Uso de `Map`, `Filter`, `Reduce` sobre estructuras inmutables
