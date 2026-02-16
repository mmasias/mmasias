# El método de la tabla para descubrir recursividad

## 1) Idea central

Cuando queremos programar una solución recursiva, el problema no suele ser escribir código: el problema es **descubrir la regla recursiva correcta**.

Este método propone una forma concreta de encontrarla:

1. Armar una tabla de dos columnas: `Entrada` y `Salida`.
2. Ubicar primero el/los casos base.
3. Tomar un caso no base y acercarlo "un orden" hacia el caso base.
4. Observar cómo se relacionan los resultados "en aspa" para extraer la recurrencia.

La "magia" es pasar de ejemplos concretos a una ley general.

## 2) Protocolo sistemático

### Paso 1: Definir la función

Especificar con precisión:

- Qué recibe (`Entrada`)
- Qué devuelve (`Salida`)

Sin esto, la recursividad suele quedar ambigua.

### Paso 2: Identificar caso(s) base

Buscar los casos más simples definidos por el problema (matemática, lógica o dominio).

Regla práctica:

- El caso base no debe llamar a la función recursiva.
- Debe cortar la recursión de forma natural.

### Paso 3: Elegir un caso no base

Tomar una entrada más grande o más compleja, y anotar su salida correcta.

### Paso 4: Reducir un orden hacia la base

Construir una entrada "más simple" (por ejemplo `n-1`, `n-2`, `resto de lista`, etc.) y anotar su salida.

### Paso 5: Encontrar la relación "en aspa"

Usar el caso grande y el reducido para responder:

- ¿Cómo obtengo la salida grande a partir de la pequeña y de la entrada actual?

Esa respuesta es la recurrencia.

### Paso 6: Generalizar y validar

Escribir la forma general:

- Caso base
- Regla recursiva

Probar con 1 o 2 entradas para verificar consistencia.

## 3) Plantilla universal (pseudocódigo)

```text
f(entrada):
  si entrada cumple caso_base:
    retornar salida_base

  entrada_reducida = reducir(entrada)
  resultado_reducido = f(entrada_reducida)
  retornar combinar(entrada, resultado_reducido)
```

Donde:

- `reducir` acerca al caso base.
- `combinar` expresa la relación en aspa.

## 4) Ejemplo 1: Factorial

Queremos `fact(n)` con `n >= 0`.

Tabla:

- `0 -> 1` (caso base)
- `5 -> 120`
- `4 -> 24` (un orden más cerca de la base)

Relación:

- `120 = 5 * 24`
- Entonces: `fact(5) = 5 * fact(4)`

Generalización:

- Base: `fact(0) = 1`
- Recurrencia: `fact(n) = n * fact(n-1)` para `n > 0`

```text
fact(n):
  si n == 0: retornar 1
  retornar n * fact(n-1)
```

## 5) Ejemplo 2: Potencia

Queremos `pow(a, n)` con `n >= 0`.

Fijando `a = 2`:

- `0 -> 1` (caso base)
- `5 -> 32`
- `4 -> 16`

Relación:

- `32 = 2 * 16`
- Entonces: `pow(2,5) = 2 * pow(2,4)`

Generalización:

- Base: `pow(a, 0) = 1`
- Recurrencia: `pow(a, n) = a * pow(a, n-1)` para `n > 0`

```text
pow(a, n):
  si n == 0: retornar 1
  retornar a * pow(a, n-1)
```

## 6) Ejemplo 3: Suma de una lista

Queremos `suma(lista)`.

Lista ejemplo: `[3, 5, 2, 4]`.

Tabla:

- `[] -> 0` (caso base)
- `[3,5,2,4] -> 14`
- `[5,2,4] -> 11`

Relación:

- `14 = 3 + 11`
- Entonces: `suma([3,5,2,4]) = 3 + suma([5,2,4])`

Generalización:

- Base: `suma([]) = 0`
- Recurrencia: `suma([x | resto]) = x + suma(resto)`

```text
suma(lista):
  si lista está vacía: retornar 0
  retornar lista[0] + suma(lista[1:])
```

## 7) Ejemplo 4: Buscar elemento en lista

Queremos `buscar(lista, x)` que devuelve booleano.

Ejemplo: buscar `7` en `[4,7,1]`.

Tabla:

- `([], 7) -> false` (caso base)
- `([4,7,1], 7) -> true`
- `([7,1], 7) -> true`

Relación:

- Si la cabeza coincide, devolver `true`.
- Si no coincide, delegar al resto.

Generalización:

- Base: `buscar([], x) = false`
- Recurrencia:
  - Si `lista[0] == x`, retornar `true`.
  - Si no, `buscar(lista[1:], x)`.

```text
buscar(lista, x):
  si lista está vacía: retornar false
  si lista[0] == x: retornar true
  retornar buscar(lista[1:], x)
```

## 8) Qué aporta este método

- Hace visible el caso base desde el inicio.
- Obliga a definir una reducción válida hacia la base.
- Permite descubrir la recurrencia desde ejemplos concretos.
- Se enseña y se recuerda con facilidad.

## 9) Límites y cómo complementarlo

El método es excelente cuando la reducción es evidente (`n-1`, `resto`, etc.).  
En problemas más complejos (múltiples parámetros, poda, memoización, divide y vencerás), conviene complementarlo con:

- Definición explícita del estado.
- Árbol de llamadas.
- Análisis de complejidad.

## 10) Checklist rápido

Antes de programar, verifica:

- ¿Definí entrada y salida de la función?
- ¿Tengo caso(s) base correctos y suficientes?
- ¿Cada llamada recursiva acerca realmente a la base?
- ¿Ya identifiqué la regla de combinación (aspa)?
- ¿Probé mentalmente con 1-2 casos?

Si todas son "sí", la implementación suele salir directa.
