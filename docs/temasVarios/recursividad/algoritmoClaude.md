# El Método de la Tabla: Descubriendo la Recursividad

## Introducción

La recursividad es uno de los conceptos más desafiantes para quienes aprenden programación. A menudo, se enseña mostrando ya la solución recursiva, sin explicar cómo se llegó a ella. Este documento presenta un método sistemático y visual para **descubrir** la recursividad a partir de ejemplos concretos, en lugar de simplemente memorizar fórmulas.

## El Método

El método consiste en construir una tabla de dos columnas que nos permite visualizar la relación entre diferentes niveles del problema y extraer la fórmula recursiva.

### Estructura de la Tabla

| Entrada | Salida |
|---------|--------|
| ? | ? |

La **primera columna** representa la entrada del problema.
La **segunda columna** representa la salida correspondiente.

### Los Cuatro Pasos

#### Paso 1: Identificar el/los Casos Base

Los casos base son las situaciones más simples, dadas por la propia definición del problema. Se colocan en la **cima** de la tabla.

> **¿Qué es un caso base?**
> Es el punto donde la recursividad se detiene. Sin casos base, la recursividad sería infinita.

#### Paso 2: Tomar un Valor Alejado

Elegimos un valor que esté alejado de los casos base. Esto nos permite trabajar con un ejemplo concreto no trivial.

#### Paso 3: Bajar un Orden

Desde ese valor alejado, bajamos un "orden" hacia los casos base. La noción de "orden" depende del problema:
- Para números: restar 1
- Para listas: quitar el primer elemento
- Para cadenas: tomar una subcadena

Este valor intermedio se coloca en la tabla, **entre los casos base y el valor alejado**.

#### Paso 4: La Magia (Encontrar la Relación Recursiva)

Aquí es donde ocurre la revelación. Cruzamos en aspa:
- La entrada del nivel actual
- Con la salida del nivel anterior

La pregunta clave es: **¿Cómo llego de estos dos valores a la salida esperada?**

La respuesta a esta pregunta es la fórmula recursiva.

---

## Ejemplos Completos

### Ejemplo 1: Factorial

**Problema**: Calcular el factorial de un número n (definido como n × (n-1) × ... × 1)

#### Paso 1: Casos Base

Por definición matemática: 0! = 1

| Entrada | Salida |
|---------|--------|
| 0 | 1 |

#### Paso 2: Valor Alejado

Tomamos el 5: 5! = 120

| Entrada | Salida |
|---------|--------|
| 0 | 1 |
| | |
| | |
| | |
| 5 | 120 |

#### Paso 3: Bajar un Orden

Desde el 5, bajamos al 4: 4! = 24

| Entrada | Salida |
|---------|--------|
| 0 | 1 |
| | |
| | |
| 4 | 24 |
| 5 | 120 |

#### Paso 4: La Magia

¿Cómo llego del **5** y del **24** al **120**?

```
5 × 24 = 120
```

Es decir: el número actual multiplicado por el factorial del anterior.

**Fórmula recursiva**:
```
factorial(n) = n × factorial(n-1)
```

**Código (Python)**:
```python
def factorial(n):
    if n == 0:  # Caso base
        return 1
    return n * factorial(n - 1)  # Llamada recursiva
```

---

### Ejemplo 2: Fibonacci

**Problema**: Calcular el n-ésimo número de Fibonacci (donde cada número es la suma de los dos anteriores: 0, 1, 1, 2, 3, 5, 8, ...)

#### Paso 1: Casos Base

Por definición:
- fib(0) = 0
- fib(1) = 1

| Entrada | Salida |
|---------|--------|
| 0 | 0 |
| 1 | 1 |

#### Paso 2: Valor Alejado

Tomamos el 5: fib(5) = 5

| Entrada | Salida |
|---------|--------|
| 0 | 0 |
| 1 | 1 |
| | |
| | |
| | |
| 5 | 5 |

#### Paso 3: Bajar un Orden

Bajamos al 4: fib(4) = 3

| Entrada | Salida |
|---------|--------|
| 0 | 0 |
| 1 | 1 |
| | |
| | |
| 4 | 3 |
| 5 | 5 |

#### Paso 4: La Magia

¿Cómo llego del **5** y del **3** al **5**?

Aquí algo no funciona... 5 y 3 no conectan directamente a 5 con una operación simple.

**Aprendizaje**: A veces necesitamos bajar **más órdenes** para ver el patrón completo.

Completamos más filas:

| Entrada | Salida |
|---------|--------|
| 0 | 0 |
| 1 | 1 |
| 2 | 1 |
| 3 | 2 |
| 4 | 3 |
| 5 | 5 |

Ahora vemos la magia:
```
fib(5) = 5 = 3 + 2 = fib(4) + fib(3)
```

**Fórmula recursiva**:
```
fib(n) = fib(n-1) + fib(n-2)
```

**Código (Python)**:
```python
def fibonacci(n):
    if n == 0:  # Caso base 1
        return 0
    if n == 1:  # Caso base 2
        return 1
    return fibonacci(n - 1) + fibonacci(n - 2)  # Dos llamadas recursivas
```

---

### Ejemplo 3: Suma de una Lista

**Problema**: Calcular la suma de todos los números de una lista

#### Paso 1: Casos Base

La suma de una lista vacía es 0:

| Entrada | Salida |
|---------|--------|
| [] | 0 |

#### Paso 2: Valor Alejado

Tomamos `[1, 2, 3, 4, 5]`: suma = 15

| Entrada | Salida |
|---------|--------|
| [] | 0 |
| | |
| [1, 2, 3, 4, 5] | 15 |

#### Paso 3: Bajar un Orden

"¿Qué significa bajar un orden aquí?"
Reducir la lista: quitar el primer elemento.

`[2, 3, 4, 5]`: suma = 14

| Entrada | Salida |
|---------|--------|
| [] | 0 |
| | |
| [2, 3, 4, 5] | 14 |
| [1, 2, 3, 4, 5] | 15 |

#### Paso 4: La Magia

¿Cómo llego de `[1, 2, 3, 4, 5]` y `[2, 3, 4, 5]` del 14 al **15**?

```
15 = 1 + 14
```

El primer elemento (1) más la suma del resto (14).

**Fórmula recursiva**:
```
suma(lista) = primer_elemento + suma(resto_de_la_lista)
```

**Código (Python)**:
```python
def suma_lista(lista):
    if not lista:  # Caso base: lista vacía
        return 0
    return lista[0] + suma_lista(lista[1:])  # Primer elemento + suma del resto
```

---

### Ejemplo 4: Búsqueda en una Lista

**Problema**: Determinar si un elemento está presente en una lista (devuelve `True` o `False`)

#### Paso 1: Casos Base

Lista vacía: el elemento no está → `False`

| Entrada | Salida |
|---------|--------|
| [] | False |

#### Paso 2: Valor Alejado

Buscamos el `3` en `[1, 2, 3, 4, 5]` → `True`

| Entrada | Salida |
|---------|--------|
| [] | False |
| | |
| buscar([1,2,3,4,5], 3) | True |

#### Paso 3: Bajar un Orden

Reducimos la lista: `[2, 3, 4, 5]`

| Entrada | Salida |
|---------|--------|
| [] | False |
| | |
| buscar([2,3,4,5], 3) | True |
| buscar([1,2,3,4,5], 3) | True |

#### Paso 4: La Magia

¿Cómo conecto `buscar([1,2,3,4,5], 3)` con `buscar([2,3,4,5], 3)`?

Aquí aparece una **decisión condicional**:
- Si el primer elemento (1) es igual al buscado (3) → `True`
- Si no → depende de buscar en el resto

**Fórmula recursiva**:
```
buscar(lista, elemento) =
  si lista está vacía → False
  si primer_elemento == elemento → True
  si no → buscar(resto_de_la_lista, elemento)
```

**Código (Python)**:
```python
def buscar(lista, elemento):
    if not lista:  # Caso base: lista vacía
        return False
    if lista[0] == elemento:  # Caso base: encontrado
        return True
    return buscar(lista[1:], elemento)  # Buscar en el resto
```

**Nota**: Este ejemplo muestra que a veces hay **múltiples casos base o de decisión**, no solo uno.

---

## Patrones Comunes en Recursividad

A través de los ejemplos, identificamos varios patrones:

### 1. Recursión Simple (Un Solo Llamado)

Ejemplos: Factorial, Suma de lista

La fórmula recursiva tiene una sola llamada a sí misma:
```
f(n) = n × f(n-1)
f(lista) = primer_elemento + f(resto)
```

### 2. Recursión Múltiple (Múltiples Llamados)

Ejemplo: Fibonacci

La fórmula recursiva tiene múltiples llamadas:
```
f(n) = f(n-1) + f(n-2)
```

### 3. Recursión con Decisión Condicional

Ejemplo: Búsqueda en lista

La fórmula incluye condiciones que determinan el camino:
```
f(lista, elem) =
  si encontrado → True
  si no → f(resto, elem)
```

---

## Cuándo Necesitar Más Niveles

Como vimos en **Fibonacci**, a veces bajar un solo orden no es suficiente para ver el patrón.

**Señales de que necesitas más niveles**:
1. La operación no es obvia con un solo paso
2. El problema depende de más de un valor anterior
3. La relación no es lineal

**Solución**: Construye más filas en la tabla hasta que el patrón sea evidente.

---

## Resumen del Método

```
┌─────────────────────────────────────────────────────────┐
│           MÉTODO DE LA TABLA PARA RECURSIVIDAD          │
├─────────────────────────────────────────────────────────┤
│  1. IDENTIFICAR CASOS BASE                             │
│     → Colocar en la cima de la tabla                   │
│                                                          │
│  2. TOMAR UN VALOR ALEJADO                              │
│     → Ejemplo concreto no trivial                      │
│                                                          │
│  3. BAJAR UN ORDEN HACIA LOS CASOS BASE                 │
│     → Reducir el problema (n-1, lista[1:], etc.)       │
│     → Colocar entre casos base y valor alejado          │
│                                                          │
│  4. LA MAGIA                                            │
│     → ¿Cómo conecto entrada_actual + salida_anterior?  │
│     → La respuesta es la fórmula recursiva             │
└─────────────────────────────────────────────────────────┘
```

---

## Conclusión

Este método transforma el aprendizaje de la recursividad de "memorizar fórmulas" a "descubrir patrones". La tabla hace visible lo que antes era abstracto, y el proceso sistemático reduce la ansiedad de "no saber por dónde empezar".

La recursividad deja de ser magia negra y se convierte en un proceso deductivo accesible.

**Próximo paso**: Aplica este método a problemas nuevos. La práctica te ayudará a desarrollar intuición sobre qué tan lejos del caso base debes ir y cuántos niveles necesitas bajar para ver el patrón.

---

*Documento generado a partir del método desarrollado para enseñar recursividad de manera visual y sistemática.*
