# El Método de la Tabla: Descubriendo Recursividad Paso a Paso

## Introducción

La recursividad es uno de los conceptos más desafiantes de la programación. Muchos estudiantes luchan por encontrar la **relación recursiva** que conecta un problema con su versión más pequeña.

Este artículo presenta un **método sistemático y visual** para descubrir recursividades: **El Método de la Tabla**.

---

## El Método en 5 Pasos

| Paso | Acción | Propósito |
|------|--------|-----------|
| 1 | Crear tabla de 2 columnas (Entrada → Salida) | Establecer el marco visual |
| 2 | Identificar **caso(s) base** (cima de la tabla) | Definir el punto de parada |
| 3 | Elegir un ejemplo **concreto alejado** del caso base | Tener un objetivo claro |
| 4 | Bajar **un escalón** hacia el caso base | Acercarse al caso base |
| 5 | **La Magia**: relacionar entrada actual con salida(s) anterior(es) | Descubrir la relación recursiva |

---

## Ejemplo 1: Factorial

### Aplicando el método

**Paso 1-2:** Tabla y caso base

El factorial de 0 es 1 por definición.

| Entrada (n) | Salida (n!) |
|-------------|-------------|
| 0           | 1           |
| ...         | ...         |

**Paso 3:** Ejemplo concreto alejado

| Entrada (n) | Salida (n!) |
|-------------|-------------|
| 0           | 1           |
| ...         | ...         |
| 5           | 120         |

**Paso 4:** Bajar un escalón

| Entrada (n) | Salida (n!) |
|-------------|-------------|
| 0           | 1           |
| ...         | ...         |
| 4           | 24          |
| 5           | 120         |

**Paso 5: ¡La Magia!**

¿Cómo llego al 120 usando el 5 y el 24?

```
5 × 24 = 120
```

**Relación descubierta:** `n × (n-1)! = n!`

### Traducción a código

```python
def factorial(n):
    if n == 0:              # Caso base (paso 2)
        return 1
    return n * factorial(n - 1)  # Relación del paso 5
```

---

## Ejemplo 2: Sucesión de Fibonacci

### Aplicando el método

**Paso 1-2:** Tabla y casos base

Fibonacci tiene **dos casos base** por definición.

| Entrada (n) | Salida (Fib(n)) |
|-------------|-----------------|
| 0           | 0               |
| 1           | 1               |
| ...         | ...             |

**Paso 3:** Ejemplo concreto alejado

| Entrada (n) | Salida (Fib(n)) |
|-------------|-----------------|
| 0           | 0               |
| 1           | 1               |
| ...         | ...             |
| 6           | 8               |

**Paso 4:** Bajar un escalón... ¡y otro!

| Entrada (n) | Salida (Fib(n)) |
|-------------|-----------------|
| 0           | 0               |
| 1           | 1               |
| ...         | ...             |
| 4           | 3               |
| 5           | 5               |
| 6           | 8               |

**Paso 5: ¡La Magia!**

¿Cómo llego al 8?

```
3 + 5 = 8
```

**Relación descubierta:** `Fib(n-2) + Fib(n-1) = Fib(n)`

### Lección importante

A veces necesitas **bajar más de un escalón** para ver el patrón. Cuando la magia no funciona con un solo escalón, baja otro más.

### Traducción a código

```python
def fibonacci(n):
    if n == 0:              # Caso base 1
        return 0
    if n == 1:              # Caso base 2
        return 1
    return fibonacci(n-2) + fibonacci(n-1)  # Relación del paso 5
```

---

## Ejemplo 3: Suma de una Lista

### Aplicando el método

**Paso 1-2:** Tabla y caso base

La suma de una lista vacía es 0.

| Entrada | Salida |
|---------|--------|
| []      | 0      |
| ...     | ...    |

**Paso 3:** Ejemplo concreto alejado

| Entrada | Salida |
|---------|--------|
| []      | 0      |
| ...     | ...    |
| [1,2,3,4,5] | 15 |

**Paso 4:** Bajar un escalón

"Quitar" el primer elemento:

| Entrada | Salida |
|---------|--------|
| []      | 0      |
| ...     | ...    |
| [2,3,4,5] | 14   |
| [1,2,3,4,5] | 15 |

**Paso 5: ¡La Magia!**

```
1 + 14 = 15
```

**Relación descubierta:** `primero + suma(resto) = suma_total`

### Lección importante

**"Bajar un escalón"** no siempre significa `n-1`. Con listas significa **"hacer la lista más pequeña"** (quitar un elemento).

### Traducción a código

```python
def suma_lista(lista):
    if lista == []:              # Caso base
        return 0
    return lista[0] + suma_lista(lista[1:])  # cabeza + suma(cola)
```

---

## Ejemplo 4: Buscar un Elemento en una Lista

### Aplicando el método

**Paso 1-2:** Tabla y caso base

Buscar en lista vacía devuelve `False`.

| Entrada | Salida |
|---------|--------|
| ([], 3) | False  |
| ...     | ...    |

**Paso 3:** Ejemplo concreto alejado

Buscar `3` en `[1,2,3,4,5]`:

| Entrada | Salida |
|---------|--------|
| ([], 3) | False  |
| ...     | ...    |
| ([1,2,3,4,5], 3) | True |

**Paso 4:** Bajar un escalón

| Entrada | Salida |
|---------|--------|
| ([], 3) | False  |
| ...     | ...    |
| ([2,3,4,5], 3) | True  |
| ([1,2,3,4,5], 3) | True |

**Paso 5: ¡La Magia!**

Aquí la magia es **lógica**, no aritmética:

```
¿1 == 3? No → entonces depende del resto
```

**Relación descubierta:** 
- Si el primero es el buscado: `True`
- Si no: buscar en el resto

### Traducción a código

```python
def buscar(lista, x):
    if lista == []:              # Caso base
        return False
    if lista[0] == x:            # ¡Encontrado!
        return True
    return buscar(lista[1:], x)  # Buscar en el resto
```

### Lección importante

La "magia" del paso 5 **no siempre es una operación matemática**. Puede ser:
- Una **comparación** (`cabeza == x`)
- Una **decisión** (si es igual, retorna; si no, continúa)
- Una **condición lógica**

---

## Sistematización Completa

### Plantilla Universal

```
┌─────────────────────────────────────────┐
│  TABLA DE RECURSIVIDAD                  │
├─────────────────┬───────────────────────┤
│   ENTRADA       │      SALIDA           │
├─────────────────┼───────────────────────┤
│   caso base     │   resultado base      │  ← CIMA
│   ...           │   ...                 │
│   n-1           │   salida(n-1)         │
│   n             │   salida(n)           │  ← FONDO
└─────────────────┴───────────────────────┘
                    ↑
              ¡LA MAGIA!
    ¿Cómo llego aquí usando lo de arriba?
```

### Preguntas Guía del Paso 5

| Tipo de problema | Pregunta clave |
|------------------|----------------|
| Acumulativo (suma, producto) | ¿Qué operación con la salida anterior da la actual? |
| Secuencial (Fibonacci) | ¿Cuántos escalones atrás necesito? |
| Búsqueda | ¿La cabeza cumple la condición? |
| Transformación | ¿Cómo transformo la cabeza + resultado del resto? |

---

## Ventajas del Método

| Ventaja | Descripción |
|---------|-------------|
| **Visual** | Convierte lo abstracto en concreto |
| **Sistemático** | Sigue pasos claros, no depende de intuición |
| **Descubrimiento guiado** | La recursividad se *revela*, no se impone |
| **Generalizable** | Funciona para múltiples tipos de problemas |
| **Pedagógico** | Ideal para enseñar: se *ve* el patrón antes de codificar |

---

## Limitaciones y Extensiones

### Cuando un escalón no basta

Como vimos con Fibonacci, a veces necesitas **dos o más escalones** hacia atrás. El método lo revela naturalmente: cuando la magia no funciona, baja otro escalón.

### Cuando la salida no es un número

Con búsquedas o transformaciones booleanas, la "magia" es **lógica** o **condicional**, no aritmética.

### Problemas con múltiples casos base

Algunos problemas (como Fibonacci) tienen **más de un caso base**. Anótalos todos en la cima de la tabla.

---

## Conclusión

El Método de la Tabla transforma el desafío de encontrar recursividades de **"adivinar la fórmula"** a **"observar y conectar"**.

La clave está en el **Paso 5**: en lugar de preguntar *"¿cuál es la fórmula recursiva?"*, preguntas:

> **"¿Cómo llego a esta salida usando lo que ya tengo abajo en la tabla?"**

Ese pequeño cambio de perspectiva hace toda la diferencia.

---

## Ejercicio para el Lector

Aplica el método a los siguientes problemas:

1. **Potencia:** `base^exponente`
2. **Longitud de una lista:** contar elementos
3. **Invertir una lista:** `[1,2,3]` → `[3,2,1]`
4. **Máximo de una lista:** encontrar el valor mayor

¡La práctica hace al maestro!

---

*¿Tienes un problema recursivo que no puedes resolver? ¡Prueba el Método de la Tabla!*
