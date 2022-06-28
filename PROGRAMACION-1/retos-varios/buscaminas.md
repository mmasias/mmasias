# Un buscaminas

Desarrolle el juego de buscaminas sobre un tablero de 5 filas x 7 columnas y asigne cinco minas (de modo aleatorio) sobre su superficie.

El jugador indica las posiciones X e Y y el programa determina si hay una mina en esa casilla. 

- Si no hay mina, el tablero muestra un punto. 
- En caso de haber una mina,  se muestra un asterisco y se suma una explosión.

El juego finaliza al liberar todas las casillas (en  cuyo caso gana) o bien cuando al jugador le explotan tres minas (donde lógicamente pierde).

## Sugerencia de presentación
```
================
  1 2 3 4 5 6 7
1 - - - - - - - 
2 - - - - - - -
3 - - - - - - -
4 - - - - - - -
5 - - - - - - -
================
Ingrese X: 2
Ingrese Y: 2
----------------
Libre!
================
  1 2 3 4 5 6 7
1 - - - - - - - 
2 - . - - - - -
3 - - - - - - -
4 - - - - - - -
5 - - - - - - -
================
Ingrese X: 1
Ingrese Y: 5
----------------
Mina!
================
  1 2 3 4 5 6 7
1 - - - - * - - 
2 - . - - - - -
3 - - - - - - -
4 - - - - - - -
5 - - - - - - -
================
Ingrese X: 

```