# Estructuras de Datos

## ¿Por qué?

**El problema de la ludoteca:** En vPRG1 los niños estaban "en fila" sin usar arrays. El agrupamiento existía solo en nuestra interpretación, pero funcionaba.

En las aproximaciones de vPRG2 nos encontrábamos con la **limitación de los arrays:** para agrupar elementos necesitamos declarar `String[] niños = new String[¿?]` - pero no sabemos cuántos llegarán. Los arrays nos obligan a decidir el tamaño de antemano, y la realidad es dinámica.

## ¿Qué?

Los datos nunca se mueven. Solo cambiamos cómo los interpretamos. Cada elemento puede (¿debe?) "recordar" conexiones con otros elementos - no necesitamos contenedores externos. ¿O sí?

## ¿Para qué?

Esta comprensión unifica todo lo que veremos en el curso. Las estructuras que parecen completamente diferentes (listas, pilas, colas, árboles, grafos) son interpretaciones del mismo principio: elementos + reglas de conexión = cualquier organización posible.

Los datos son solo datos. El orden lo decidimos nosotros.

## ¿Cómo?

Implementaremos cada estructura aplicando diferentes reglas a los mismos principios base:

- **Listas**: Cada elemento conoce el siguiente
- **Pilas**: Último en entrar, primero en salir
- **Colas**: Primero en entrar, primero en salir  
- **Árboles**: Un elemento puede conectar con múltiples "hijos"
- **Grafos**: Conexiones libres entre cualquier elemento
