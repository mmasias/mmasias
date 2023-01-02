
Versión del laberinto implementado con arrays asociativos, para contrastarlo con la solución que se implementa con arrays.

## Restricciones autoimpuestas

- KISS
- CNC / ANC


## Versiones

### Versión 1

[Versión de partida](ArrayAsociativo001.java)

![](/imagenes/ArrayAsociativoV1.png)


### Versión 2

[Versión 2](ArrayAsociativo002.java)

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