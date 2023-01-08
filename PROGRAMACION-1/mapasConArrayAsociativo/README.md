
Versión del laberinto implementado con arrays de string y parseo mediante arrays asociativos, para contrastarlo con la solución que habitualmente he implementado con arrays de enteros. Y vale: he usado switch/case...

Se utilizan como inspiracióin los mapas del [Castillo de Lord British](https://userpages.monmouth.com/~colonel/videogames/ultimaexodus/british.html) y el del [Castillo de Timelord](https://userpages.monmouth.com/~colonel/videogames/ultimaexodus/time.html), de [Ultima III: Exodus](https://es.wikipedia.org/wiki/Ultima_III:_Exodus)

## Restricciones autoimpuestas

- Intentar KISS
- CNC / ANC

## Versiones

|Versión|Detalle
|-|-
|[Versión 1](docs/version1.md)|Mapas en arrays de String y parseo de mosaicos (en ASCII) utilizando un array asociativo
|[Versión 2](docs/version2.md)|Un viewport de 7x7 centrado en el personaje
|[Versión 3](docs/version3.md)|Permitimos mover al personaje (w/a/s/d o 8/4/6/2)
|[Versión 4](docs/version4.md)|Códigos ANSI I: limpiar pantalla
|[Versión 5](docs/version5.md)|Tiempo, un reloj y el sol en el cielo (moviéndose en función al tiempo)
|[Versión 6](docs/version6.md)|Dia y noche, de acuerdo a la hora
|[Versión 7](docs/version7.md)|Códigos ANSI II: ¡colores!
|[Versión 8](docs/version8.md)|Protección en los límites del mapa y otros pequeños ajustes
|[Versión 9](docs/version9.md)|Definición de zonas infranqueables (paredes, agua, etc). Y temas ;)