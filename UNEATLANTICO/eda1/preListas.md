# Reto 002

Aisha tiene a los niños organizados en fila, donde cada niño sabe quién está detrás de él. 

Se han de implementar las diferentes actividades que Aisha necesita realizar con sus niños durante la jornada en la ludoteca.

## Mapa del Reto

<div align=center>

|Ejercicio || Descripción |
|-|-|-|
|presentarATodos() | 😊 | Todos los niños se presentan en orden |
|presentar(6) | 😐 | Solo se presentan niños mayores de 6 años |
|presentarPrimeros(5) | 😐 | Presentan únicamente los primeros 5 niños |
|presentarUltimos(5) | 😱 | Presentan únicamente los últimos 5 niños |
|contarNiños() | 😐 | Devuelve cuántos niños hay en total |
|contarMayoresDe(6) | 😰 | Devuelve cuántos niños son mayores de 6 años |
|edadPromedio() | 😰 | Calcula y devuelve la edad promedio de todos |
|sacarMenoresDe(5) | 💀 | Elimina de la cola a los niños menores de 5 años |

</div>

### La presentación general

Aisha quiere que todos los niños se presenten. Le dice al primer niño "¡preséntate!", y este debe presentarse y decirle al siguiente que haga lo mismo, y así sucesivamente hasta que todos se hayan presentado.

> **Implementar:** `presentarATodos()`

### Presentación selectiva por edad

Para una actividad especial, solo deben presentarse los niños mayores de una edad determinada. Por ejemplo, "que se presenten los mayores de 6 años", respetando el orden de la fila.

> **Implementar:** `presentar(int edadMinima)`

### Los primeros voluntarios

Aisha necesita 5 voluntarios para una actividad. Solo los primeros 5 niños de la cola deben presentarse. El resto permanece en silencio.

> **Implementar:** `presentarPrimeros(int n)`

### Los últimos en llegar

Para otra actividad, solo deben presentarse los últimos 5 niños de la cola. El problema es que ningún niño sabe si es uno de los últimos.

> **Implementar:** `presentarUltimos(int n)`

### Contar asistencia

Aisha debe saber cuántos niños tiene en su cola para el registro de asistencia.

> **Implementar:** `contarNiños()`

### Estadísticas por edad

La dirección pide estadísticas. Aisha debe saber cuántos de sus niños son mayores de cierta edad.

> **Implementar:** `contarMayoresDe(int edadMinima)`

### Edad promedio del grupo

Para planificar las actividades, Aisha debe calcular la edad promedio de todos los niños en su cola.

> **Implementar:** `edadPromedio()`

### El juego de la rana

El juego de la rana es solo para niños mayores de 5 años. Los niños menores de 5 años deben salir de la cola antes de empezar.

Aisha debe reorganizar su fila eliminando a los niños pequeños y manteniendo el orden de los que quedan. Si tenía: Ana(4) → Luis(7) → Pedro(3) → María(8), debe quedar: Luis(7) → María(8).

> **Implementar:** `sacarMenoresDe(int edadMaxima)`
