# Detalle 

## Flujo Principal

1. El usuario solicita registrar una nueva actividad.
2. El sistema muestra las categorías de actividades disponibles.
3. El usuario ingresa la categoría de la actividad.
4. El sistema solicita el valor de la actividad.
5. El usuario ingresa el valor de la actividad.
6. El sistema solicita la fecha de la actividad.
7. El usuario ingresa la fecha de la actividad.
8. El usuario solicita el cálculo de la huella de carbono.
9. El sistema muestra el resultado del cálculo de huella de carbono.
10. El sistema muestra las estadísticas actualizadas del usuario.

## Flujos Alternativos

3a. Si la categoría ingresada no es válida:
   1. El sistema muestra un mensaje de error.
   2. El sistema solicita ingresar una categoría válida.
   3. El flujo continúa en el paso 3.

5a. Si el valor ingresado no es válido:
   1. El sistema muestra un mensaje de error.
   2. El sistema solicita ingresar un valor válido.
   3. El flujo continúa en el paso 5.

7a. Si la fecha ingresada no es válida:
   1. El sistema muestra un mensaje de error.
   2. El sistema solicita ingresar una fecha válida.
   3. El flujo continúa en el paso 7.

9a. Si ocurre un error en el cálculo:
   1. El sistema muestra un mensaje de error.
   2. El sistema solicita intentar el cálculo nuevamente.
   3. El flujo continúa en el paso 8.