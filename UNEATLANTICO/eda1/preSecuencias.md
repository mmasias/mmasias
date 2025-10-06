# Interfaz del Programa: Ludoteca

## Menú principal

El programa debe presentar un menú con las siguientes opciones:

```
========================================
        LUDOTECA - SIMULACIÓN
========================================

1.  Simular llegada de niño
2.  Simular intento de inicio de juego
3.  Aisha se presenta y pide a los niños que se presenten
4.  Aisha pide que se presenten los niños mayores de 5 años
5.  Aisha pide que se presenten los niños cuyo nombre empieza por letra
6.  Aisha pide que se presenten los cinco primeros niños
7.  Aisha pide que se presenten los cinco últimos niños
8.  Aisha y Lydia dicen cuántos niños hay en cola
9.  Aisha dice la edad promedio de los niños en cola
10. Simular intento de inicio del juego de la rana
11. Paso de niños menores de 5 años a monitora Dalsy
12. Alarma contra incendios y protocolo de emergencia
13. Mostrar monitoras y niños

0.  Salir

Seleccione una opción:
```

## Comportamiento de cada opción

### Opción 1: Simular llegada de niño

**Input:** Solicita nombre y edad del niño

**Output:** 
```
Llega [nombre] ([edad] años)
[nombre] pasa a la cola de Lydia
```

### Opción 2: Simular intento de inicio de juego

**Output si hay suficientes niños:**
```
Lydia transfiere sus niños a Aisha
[Lista de niños transferidos]
```

**Output si NO hay suficientes:**
```
No hay suficientes niños para iniciar el juego
Se necesitan al menos 5 niños
```

### Opción 3: Presentaciones generales

**Output:**
```
Aisha: Hola, soy Aisha, monitora de esta ludoteca

[Niño1]: Hola, soy [nombre] y tengo [edad] años
[Niño2]: Hola, soy [nombre] y tengo [edad] años
...
```

### Opción 4: Presentaciones por edad mínima

**Input:** Solicita edad mínima

**Output:**
```
Aisha pide que se presenten los mayores de [X] años:

[Niño que cumple]: Hola, soy [nombre] y tengo [edad] años
[Niño que cumple]: Hola, soy [nombre] y tengo [edad] años
...
```

### Opción 5: Presentaciones por inicial

**Input:** Solicita letra inicial

**Output:**
```
Aisha pide que se presenten los niños cuyo nombre empieza con '[letra]':

[Niño que cumple]: Hola, soy [nombre]
[Niño que cumple]: Hola, soy [nombre]
...
```

### Opción 6: Primeros cinco

**Output:**
```
Aisha pide que se presenten los primeros 5 niños:

[Niño1]: Hola, soy [nombre]
[Niño2]: Hola, soy [nombre]
...
[Niño5]: Hola, soy [nombre]
```

### Opción 7: Últimos cinco

**Output:**
```
Aisha pide que se presenten los últimos 5 niños:

[Niño-4]: Hola, soy [nombre]
[Niño-3]: Hola, soy [nombre]
...
[ÚltimoNiño]: Hola, soy [nombre]
```

### Opción 8: Conteo de asistencia

**Output:**
```
CONTEO DE ASISTENCIA:
Lydia tiene [X] niños en cola
Aisha tiene [Y] niños en cola
Dalsy tiene [Z] niños en cola
Total: [X+Y+Z] niños
```

### Opción 9: Edad promedio

**Output:**
```
Edad promedio de los niños en la cola de Aisha: [XX.X] años
```

**Output si no hay niños:**
```
No hay niños en la cola de Aisha
```

### Opción 10: Intento del juego de la rana

**Output si pueden jugar:**
```
Verificando condiciones para el juego de la rana...
Total de niños: [X]
Niños de 5 años o más: [Y]
¡Más de la mitad cumplen la condición!
¡Pueden jugar al juego de la rana!
```

**Output si NO pueden:**
```
Verificando condiciones para el juego de la rana...
Total de niños: [X]
Niños de 5 años o más: [Y]
No hay suficientes niños mayores de 5 años
No pueden jugar todavía
```

### Opción 11: Separación para el juego

**Output:**
```
Separando niños para el juego de la rana...
Niños menores de 5 años pasan a Dalsy:
- [Niño1] ([edad] años)
- [Niño2] ([edad] años)

Niños que se quedan con Aisha para jugar:
- [Niño3] ([edad] años)
- [Niño4] ([edad] años)
...

NOTA: Al terminar el juego, los niños volverán a su posición original
```

### Opción 12: Alarma contra incendios

**Output:**
```
¡ALARMA CONTRA INCENDIOS!

PROTOCOLO DE EMERGENCIA ACTIVADO

Dalsy transfiere TODOS sus niños a Lydia INMEDIATAMENTE
Aisha transfiere TODOS sus niños a Lydia INMEDIATAMENTE
[X] niños transferidos

Lydia ahora tiene [Y] niños listos para evacuar en orden
```

### Opción 13: Mostrar monitoras y niños

**Output:**
```
========================================
        ESTADO ACTUAL
========================================

LYDIA:
[Si tiene niños]
  Niños en cola: [X]
  - [Niño1] ([edad] años)
  - [Niño2] ([edad] años)
  ...
[Si está vacía]
  Cola vacía

AISHA:
[Si tiene niños]
  Niños en cola: [Y]
  - [Niño1] ([edad] años)
  - [Niño2] ([edad] años)
  ...
[Si está vacía]
  Cola vacía

DALSY:
[Si tiene niños]
  Niños en cola: [Z]
  - [Niño1] ([edad] años)
  - [Niño2] ([edad] años)
  ...
[Si está vacía]
  Cola vacía

========================================
```

## Notas de implementación

### Flujo recomendado de prueba

1. Agregar varios niños (opción 1) - repetir 8-10 veces
2. Mostrar estado (opción 13)
3. Intentar inicio de juego (opción 2)
4. Mostrar estado (opción 13)
5. Probar presentaciones (opciones 3-7)
6. Verificar conteos (opción 8)
7. Calcular promedio (opción 9)
8. Intentar juego de la rana (opción 10)
9. Separar niños (opción 11)
10. Mostrar estado (opción 13)
11. Activar emergencia (opción 12)
12. Mostrar estado final (opción 13)

### Validaciones necesarias

- Opción 2: Verificar mínimo de niños antes de transferir
- Opciones 4-9: Verificar que Aisha tenga niños antes de operar
- Opción 10: Calcular correctamente "más de la mitad"
- Opción 11: Mantener referencia al orden original
- Opción 12: #2Think (y mucho!!!)

### Clase principal sugerida

```java
class Mundo {
    private Ludoteca ludoteca;
    private Console console;
    
    public void ejecutarSimulacion() {
        int opcion;
        do {
            mostrarMenu();
            opcion = console.readInt("Seleccione opción: ");
            procesarOpcion(opcion);
            console.readString("Presione ENTER para continuar...");
        } while (opcion != 0);
    }
}
```
