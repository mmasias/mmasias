# Versión 8: límites en los bordes del mapa

> [Límites en los bordes](../ArrayAsociativo008.java)

## Definir límites al mapa

Al utilizar una matriz de 2x2, evitar caer en los límites sería tan "simple" como verificar (luego de moverme) si la coordenada en la que aterrizo es válida, es decir, está dentro de los límites. Los límites de una matriz los determinan los elementos de sus dimensiones: el límite inferior de una dimensión es cero y el límite superior es el número de elementos de esa dimensión:

    min = 0 / max = longitud de matriz

Dado que la matriz que estamos trabajando es una matriz de Strings, la primera dimensión la da directamente el método length de la matriz, mientras que la segunda dimensión la da el método length() del elemento String seleccionado (de allí que los paréntesis al final). Con esto en mente, tendríamos:

    minFila = 0;
    minColumna = 0;
    maxFila = mundo.length;
    maxColumna = mundo[0].length();

Ahora bien, como la impresión la hacemos en un viewport, hay que evitar que el personaje se acerque a los límites precisamente el valor de dicho viewport. Por tanto, las fórmulas anteriores quedan tal que:

    minFila = 0 + viewPort;
    minColumna = 0 + viewPort;
    maxFila = mundo.length - (viewPort + 1);
    maxColumna = mundo[0].length() - (viewPort + 1);

Al igual que el tamaño del viewPort y el alcanceVision (y por las mismas razones), declaramos esas variables como estáticas, de modo que su ámbito es global en la clase.

Y, por un tema de orden, colocamos en el método estático *inicializarMundo* las tareas que inicializan el viewPort y el alcance de visión (que anteriormente estaban directo en el *main*), así como la definición de los límites anteriormente vista. Dado que los límites dependen del mapa que se esté utilizando, el método estático requiere que se le pase el mapa como parámetro, como puede verse en su definición.

## Ajustes menores

Por claridad creo la variable *posicionposicionDelSolEnElCielo* en *imprimirElCielo()*

Por claridad, intento mapear la mayor cantidad posible de elementos en lugar de poner 

|En lugar de esto|Ahora tengo esto
|-|-
|```System.out.print(BLUE_BACKGROUND_BRIGHT + "   " + RESET);```|```System.out.print(mapear('C'));```