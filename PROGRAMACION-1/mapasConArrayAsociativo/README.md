
Versión del laberinto implementado con arrays asociativos, para contrastarlo con la solución que se implementa con arrays.

Se utilizan los mapas de Ultima III: [Castillo de Lord British](https://userpages.monmouth.com/~colonel/videogames/ultimaexodus/british.html), [Castillo de Timelord](https://userpages.monmouth.com/~colonel/videogames/ultimaexodus/time.html)

## Restricciones autoimpuestas

- Intentar KISS
- CNC / ANC

## Versiones

### Versión 1

> [Versión de partida](ArrayAsociativo001.java)

* Impresión completa del mapa mediante imprimeMapa()
* Traducción (parseo) de los tiles mediante mapea()

<div align=center>
    <img src="../../imagenes/ArrayAsociativoV1.png" width="50%" />
</div>

### Versión 2

> [Versión 2](ArrayAsociativo002.java)

Ajuste en la implementación de la impresión del mapa, mediante la inclusión de un viewport, que muestra una parte del mundo centrada alrededor de un punto. En los juegos, habitualmente este punto es el personaje principal, por lo que:

* Se crea una estructura de datos que almacene la posición del personaje, en la forma de un array posicionPersonaje que almacenará como primer elemento la fila y como segundo elemento la columna.
* Se crean las constantes *FILA* y *COLUMNA* para poder referirnos de manera clara a la posición: *posicionPersonaje[FILA]* y *posicionPersonaje[COLUMNA]*. 
* Se modifica *imprimeMapa*:
    * Cambio de nombre a *imprimeMundo*, más adecuado a su función dado que ya no imprime únicamente el mapa, sino que además ubica al personaje.
    * Se le pasan parámetros adicionales: *posicionPersonaje* y tamaño del *viewport*.
    * Se le da la responsabilidad adicional de imprimir al personaje en la posición especificada. ```_O_```
* Se agrega la funcion *imprimeLinea* que imprime una línea horizontal del tamaño del viewport.  

<div align=center>
    <img src="../../imagenes/ArrayAsociativoV2.png" width="50%" />
</div>

### Versión 3

[Versión 3](ArrayAsociativo003.java)

### Versión 4

[Versión 4](ArrayAsociativo004.java)

### Versión 5

[Hora y sol](ArrayAsociativo005.java)


### Versión 6

[Versión 6](ArrayAsociativo006.java): alcance de visión en función a la hora y el sol / Corrección del "error" del método estático pedirChar() y justificación de por qué aquí sí es pertinente un comentario. 

### Versión 7

[Versión 7](ArrayAsociativo007.java): un poco de color y ajustes menores de código

### Versión 8

[Versión 8](ArrayAsociativo008.java): protección en los límites del mapa

### Versión 9

[Versión 9](ArrayAsociativo009.java): Opción de skins (se activa con la letra **v**), como ayuda para el desarrollo de la detección de por dónde puede y no puede caminar. 

De una forma básica (o sea, *hardcoded*) verifica si puede ir al sitio que le piden: no permite traspasar paredes ni agua. En la siguiente versión debería generalizarlo a un "medio de transporte"

|Skin 0|Skin 1|Skin 2|Skin 3
|-|-|-|-
|![](/imagenes/ArrayAsociativoV9SKIN0.png)|![](/imagenes/ArrayAsociativoV9SKIN1.png)|![](/imagenes/ArrayAsociativoV9SKIN2.png)|![](/imagenes/ArrayAsociativoV9SKIN3.png)
|Full color|Sin color|Tiles puros|Matriz colisiones