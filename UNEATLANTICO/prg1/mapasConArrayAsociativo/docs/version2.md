# Versión 2: viewport de 7x7 centrado en el personaje

> [Versión 2](../ArrayAsociativo002.java)

Ajuste en la implementación de la impresión del mapa, mediante la inclusión de un viewport, que muestra una parte del mundo centrada alrededor de un punto. En los juegos, habitualmente este punto es el personaje principal, por lo que:

* [Se crea una estructura de datos que almacene la posición del personaje](https://github.com/mmasias/misApuntes/blob/a0493da8552d566407f4f1b6329ea58f16982676/PROGRAMACION-1/mapasConArrayAsociativo/ArrayAsociativo002.java#L141), en la forma de un array posicionPersonaje que almacenará como primer elemento la fila y como segundo elemento la columna.
* [Se crean las constantes](https://github.com/mmasias/misApuntes/blob/a0493da8552d566407f4f1b6329ea58f16982676/PROGRAMACION-1/mapasConArrayAsociativo/ArrayAsociativo002.java#L5-L6) *FILA* y *COLUMNA* para poder referirnos de manera clara a la posición: *posicionPersonaje[FILA]* y *posicionPersonaje[COLUMNA]*. 
* Se modifica *imprimeMapa*:
    * [Cambio de nombre a *imprimeMundo*](https://github.com/mmasias/misApuntes/blob/a0493da8552d566407f4f1b6329ea58f16982676/PROGRAMACION-1/mapasConArrayAsociativo/ArrayAsociativo002.java#L147), más adecuado a su función dado que ya no imprime únicamente el mapa, sino que además ubica al personaje.
    * Se le pasan parámetros adicionales: *posicionPersonaje* y tamaño del *viewport*.
    * Se le da la responsabilidad adicional de imprimir al personaje en la posición especificada. ```_O_```
* [Se agrega la funcion *imprimeLinea*](https://github.com/mmasias/misApuntes/blob/a0493da8552d566407f4f1b6329ea58f16982676/PROGRAMACION-1/mapasConArrayAsociativo/ArrayAsociativo002.java#L165) que imprime una línea horizontal del tamaño del viewport.  

<div align=center>
    <img src="/imagenes/ArrayAsociativoV2.png" width="50%" />
</div>
