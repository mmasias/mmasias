
Versión del laberinto implementado con arrays asociativos, para contrastarlo con la solución que se implementa con arrays.

Se utilizan como inspiracióin los mapas del [Castillo de Lord British](https://userpages.monmouth.com/~colonel/videogames/ultimaexodus/british.html) y el del [Castillo de Timelord](https://userpages.monmouth.com/~colonel/videogames/ultimaexodus/time.html), de [Ultima III: Exodus](https://es.wikipedia.org/wiki/Ultima_III:_Exodus)

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

* [Se crea una estructura de datos que almacene la posición del personaje](https://github.com/mmasias/misApuntes/blob/a0493da8552d566407f4f1b6329ea58f16982676/PROGRAMACION-1/mapasConArrayAsociativo/ArrayAsociativo002.java#L141), en la forma de un array posicionPersonaje que almacenará como primer elemento la fila y como segundo elemento la columna.
* [Se crean las constantes](https://github.com/mmasias/misApuntes/blob/a0493da8552d566407f4f1b6329ea58f16982676/PROGRAMACION-1/mapasConArrayAsociativo/ArrayAsociativo002.java#L5-L6) *FILA* y *COLUMNA* para poder referirnos de manera clara a la posición: *posicionPersonaje[FILA]* y *posicionPersonaje[COLUMNA]*. 
* Se modifica *imprimeMapa*:
    * [Cambio de nombre a *imprimeMundo*](https://github.com/mmasias/misApuntes/blob/a0493da8552d566407f4f1b6329ea58f16982676/PROGRAMACION-1/mapasConArrayAsociativo/ArrayAsociativo002.java#L147), más adecuado a su función dado que ya no imprime únicamente el mapa, sino que además ubica al personaje.
    * Se le pasan parámetros adicionales: *posicionPersonaje* y tamaño del *viewport*.
    * Se le da la responsabilidad adicional de imprimir al personaje en la posición especificada. ```_O_```
* [Se agrega la funcion *imprimeLinea*](https://github.com/mmasias/misApuntes/blob/a0493da8552d566407f4f1b6329ea58f16982676/PROGRAMACION-1/mapasConArrayAsociativo/ArrayAsociativo002.java#L165) que imprime una línea horizontal del tamaño del viewport.  

<div align=center>
    <img src="../../imagenes/ArrayAsociativoV2.png" width="50%" />
</div>

### Versión 3

> [Versión 3](ArrayAsociativo003.java)

Partimos de la premisa que hemos abstraido a nuestro personaje y el dato que nos interesa de él, **la posición**, en el vector posicionPersonaje, de modo que *fila=5, columna=3* queda almacenada así:

```
    int[] posicionPersonaje = {5,3}
```

#### ¿Qué es moverse?

A partir de esta abstracción, moverse sería cambiar dichas coordenadas. Con esto en mente:

- Si queremos que el personaje suba, restamos 1 a la fila y nos queda: ```{4,3}```
- Si queremos que el personaje baje, sumamos 1 a la fila y nos queda: ```{6,3}```
- Si queremos que el personaje vaya a la izquierda, restamos 1 a la columna y nos queda: ```{5,2}```
- Si queremos que el personaje vaya a la derecha, sumamos 1 a la columna y nos queda: ```{5,4}```

Por tanto, moverse sería sumar una unidad a la dimensión adecuada del vector del personaje.

<div align="center">

|Dirección|Cambio
|-|-
|Arriba|```{-1,0}```
|Abajo|```{1,0}```
|Izquierda|```{0,1}```
|Derecha|```{0,-1}```

</div>

Es decir que moverse significaría elegir una dirección y sumar ese vector al vector de posición del personaje.

<div align="center">

**Moverse = Posición + Dirección**

|Posición inicial|Dirección|Moverse|Posición final
|:-:|-|-|:-:
|```{5,3}```|Arriba|```{5,3} + {-1,0}```|```{4,3}```
|```{5,3}```|Abajo|```{5,3} + {1,0}```|```{6,3}```
|```{5,3}```|Izquierda|```{5,3} + {0,1}```|```{5,4}```
|```{5,3}```|Derecha|```{5,3} + {0,-1}```|```{5,2}```

</div>

##### Abstracción del movimiento

Podemos hacer que la fórmula ***Moverse = Posición + Dirección*** quede abstraida tal que la nueva posición del personaje sea la posicion actual más la suma de la dirección a la que 

nuevaPosicion = posicionPersonaje + vectorMovimiento(unaDirección)

Si hacemos que el vector movimiento sea:

```
MOVIMIENTO = { 
	{ -1, 0 },
	{ 1, 0 },
	{ 0, -1 },
	{ 0, 1 }
};
```

Y si además definimos las siguientes constantes:

```
static final int ARRIBA = 0;
static final int ABAJO = 1;
static final int IZQUIERDA = 2;
static final int DERECHA = 3;
static final int SALIR = 4;
```

Entonces, el vector de movimiento hacia arriba ```{-1,0}``` quedaría referenciado de esta manera:

```
MOVIMIENTO[ARRIBA] 
```

Y como anteriormente hemos abstraido fila y columna en las constantes FILA y COLUMNA, el movimiento de la fila sería ```MOVIMIENTO[ARRIBA][FILA]``` y en la columna sería ```MOVIMIENTO[ARRIBA][COLUMNA]```

Con esto en mente podemos crear un método *mover* que se responsabilice por mover el personaje. Lo que le haría falta saber es la posición del personaje y dirección hacia la que se mueve.

```
static void mover(int[] unPersonaje, int direccion) {

    unPersonaje[FILA] = unPersonaje[FILA] + MOVIMIENTO[direccion][FILA];
    unPersonaje[COLUMNA] = unPersonaje[COLUMNA] + MOVIMIENTO[direccion][COLUMNA];
}
```

Definido esto, los métodos *verAccion*, *capturaMovimiento* y *pedirChar* colaboran entre ellos para permitir al usuario indicar adónde moverse usando los numeros direccionales (8/4/6/2) o las teclas habituales (w/a/s/d).

En el main del programa se agrega un bucle que se encarga de imprimir el mapa y pedirle al usuario que indique una dirección de movimiento (o de terminar, cuando el booleano ```jugando``` pasa a false, tarea de la que se encarga el método *verAccion*):

```
do {
    imprimirMundo(castilloLB, elPersonaje, viewPort);
    verAccion(elPersonaje);
} while (jugando);
``` 

Esta versión mueve al personaje pero ni verifica límites ni tampoco verifica el terreno sobre el cual se mueve el personaje, por lo que de momento el personaje podrá moverse libremente atravesando paredes y agua. Asimismo, si se acerca mucho a los límites de la pantalla, el programa lanzará un error: ambas situaciones serán abordadas en las siguientes versiones.

<div align=center>
    <img src="../../imagenes/ArrayAsociativoV3.png" width="50%" />
</div>

### Versión 4

> [Versión 4](ArrayAsociativo004.java)

Igual que la versión 3, salvo que esta en lugar de acumular la impresión del mapa, [implementa un método que limpia la pantalla](https://github.com/mmasias/misApuntes/blob/d516bcab5b1298f078d9a7868e8d8ee94aa09573/PROGRAMACION-1/mapasConArrayAsociativo/ArrayAsociativo004.java#L264) mediante códigos ANSI y hace más interesante el "efecto de movimiento".


### Versión 5

> [Hora y sol](ArrayAsociativo005.java)

Implementamos:

* [El tiempo](https://github.com/mmasias/misApuntes/blob/a0493da8552d566407f4f1b6329ea58f16982676/PROGRAMACION-1/mapasConArrayAsociativo/ArrayAsociativo005.java#L169), que avanza [en cada turno](https://github.com/mmasias/misApuntes/blob/a0493da8552d566407f4f1b6329ea58f16982676/PROGRAMACION-1/mapasConArrayAsociativo/ArrayAsociativo005.java#L162). 
* En la parte inferior, [agregamos una barra de estado](https://github.com/mmasias/misApuntes/blob/a0493da8552d566407f4f1b6329ea58f16982676/PROGRAMACION-1/mapasConArrayAsociativo/ArrayAsociativo005.java#L199) que muestre el reloj (que de momento muestra solo la hora) y la posición del personaje. 
* [El cielo en la parte superior](https://github.com/mmasias/misApuntes/blob/a0493da8552d566407f4f1b6329ea58f16982676/PROGRAMACION-1/mapasConArrayAsociativo/ArrayAsociativo005.java#L286), que muestra el sol en el día (sale a las 6:00h, a las 12:00h está en mitad del cielo y se oculta a las 18:00h).

<div align=center>
    <img src="../../imagenes/ArrayAsociativoV5.png" width="50%" />
</div>


### Versión 6

[Versión 6](ArrayAsociativo006.java): alcance de visión en función a la hora y el sol / Corrección del "error" del método estático pedirChar() y justificación de por qué aquí sí es pertinente un comentario. 

#### Alcance de visión (o, para qué sirven las matemáticas...)

Teniendo en el centro al personaje P y definiendo además un alcance de visión Av, los puntos que pueden verse son los que están dentro del alcance de visión (α); mientras que las que estén fuera de este alcance (β) no. El problema entonces consiste en determinar cuáles son los puntos que están dentro y cuales fuera, lo cual puede hacerse por trigonometría: el límite es Av² (hipotenusa de un triángulo rectángulo y a la vez radio del círculo) y las coordenadas de los puntos serían la posición del punto menos la posición del personaje (α-P), tal que:


<div align=center>
    <img src="../../imagenes/alcanceVision.jpg" width="50%" />
</div>

Aterrizándolo a código, con las variables que manejamos, la condición de visibilidad a comprobar sería:

```
Math.pow((fila - personaje[FILA]), 2)+ Math.pow((columna - personaje[COLUMNA]), 2) <= alcanceVision * alcanceVision
```

Condición que se ha incluido en la función *imprimirMundo* para "apagar" los puntos que no caen dentro de este rango.

#### Corrección de pedirChar()

El programa no avanzaba el tiempo si únicamente se pulsaba enter. Las deliberaciones técnicas (que incluyen un debate que abordaba la identificación de un salto de línea, retorno de carro, dependencia de la plataforma, etc.) pueden ser excesivas para este documento: si me da el tiempo las extiendo en otro readme. 

¡Pero! El tema se ha resuelto construyendo un string conformado por lo que ingresa el usuario y un carácter cualquiera ('x' en este caso) y capturando el primer caracter. 

```
static char pedirChar() {

    Scanner entrada = new Scanner(System.in);
    String inputUsuario = entrada.nextLine() + "x"; // Este es un caso sí que justifica un comentario!
    return inputUsuario.charAt(0); 
}
```

Si el usuario no ingresa nada, el primer caracter será 'x'. Si el usuario ingresa algo, el primer caracter será precisamente lo ingresado por el usuario. Esta breve explicación sí califica como algo que deba dejarse comentado en la función.

### Versión 7

[Versión 7](ArrayAsociativo007.java): un poco de color y ajustes menores de código.

<div align=center>
    <img src="../../imagenes/ArrayAsociativoV7.png" width="50%" />
</div>

#### Cómo agregamos color

Para agregar color, podemos utilizar los [códigos de escape ANSI](https://en.wikipedia.org/wiki/ANSI_escape_code) de modo que enviemos el mensaje adecuado a la consola, lo que nos permite especificar un color de fondo, un color del texto y adicionalmente un modo (negrita o subrayado), indicándolo antes de imprimir el texto y reseteando al final del mismo.

Por ejemplo, el código ANSI para el color rojo es ```\033[1;31m``` y el código para resetear es ```\033[0m```. Por tanto, si quiero imprimir el texto HOLA en color rojo, usaría el siguiente código:

```
System.out.println("\033[1;31mHOLA\033[0m");
```

Que puede ser expresado también como: 

```
System.out.println("\033[1;31m" + "HOLA" + "\033[0m");
```

y reexpresado con miras a reusabilidad de la siguiente manera: 

```
final String RED = "\033[0;31m";
final String RESET = "\033[0m";
System.out.println(RED + "HOLA" + RESET);
```

Dado que tenemos asignada la responsabilidad de la impresión de los mosaicos al método mapear(), bastará con realizar aquí los ajustes que hacen falta para el coloreado de los mismos. Resulta pertinente crear un grupo de constantes para cada color, de modo que se pueda especificar de modo simple los colores de cada elemento, como ha quedado especificado en la [nueva versión de mapear()](https://github.com/mmasias/misApuntes/blob/09b363a122ac73678410e1b433f1a6381327a138/PROGRAMACION-1/mapasConArrayAsociativo/ArrayAsociativo007.java#L234). 

#### Ajustes menores de código

* [Reducción de la velocidad de paso del tiempo](https://github.com/mmasias/misApuntes/blob/36983d6b1b5fa8d5ce8cede0c8fc4ba6b4707eeb/PROGRAMACION-1/mapasConArrayAsociativo/ArrayAsociativo007.java#L174) (igual lo puedo cambiar a una constante luego)
* *elemento* [asume un valor por defecto](https://github.com/mmasias/misApuntes/blob/36983d6b1b5fa8d5ce8cede0c8fc4ba6b4707eeb/PROGRAMACION-1/mapasConArrayAsociativo/ArrayAsociativo007.java#L207) y solo cambia si es necesario.



### Versión 8

[Versión 8](ArrayAsociativo008.java): protección en los límites del mapa

### Versión 9

[Versión 9](ArrayAsociativo009.java): Opción de skins (se activa con la letra **v**), como ayuda para el desarrollo de la detección de por dónde puede y no puede caminar. 



|Skin 0|Skin 1|Skin 2|Skin 3
|-|-|-|-
|![](/imagenes/ArrayAsociativoV9SKIN0.png)|![](/imagenes/ArrayAsociativoV9SKIN1.png)|![](/imagenes/ArrayAsociativoV9SKIN2.png)|![](/imagenes/ArrayAsociativoV9SKIN3.png)
|Full color|Sin color|Tiles puros|Matriz colisiones

* Las skin 1 y 2 son similares en el concepto de parsear el mapa almacenado, con la diferencia de la inclusión del color. 
* La skin 2 muestra el mapa con los tiles tal y como los tiene almacenados el programa. 
* La skin 3 muestra la "matriz de colisiones", es decir, los puntos por los que no debería permitirse el paso al personaje.

De una forma básica (o sea, *hardcoded*) verifica si puede ir al sitio que le piden: no permite traspasar paredes ni agua. 

    Ideas para las siguientes versiones: 
    - Generalizarlo a un "medio de transporte"
    - ¿Incluir altura y profundidad?
    - ¿Poder crear un puente?
