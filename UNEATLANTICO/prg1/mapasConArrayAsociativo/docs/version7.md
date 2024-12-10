# Versión 7: Color mediante códigos ANSI

> [Color](../ArrayAsociativo007.java): un poco de color y ajustes menores de código.

<div align=center>
    <img src="/imagenes/ArrayAsociativoV7.png" width="50%" />
</div>

## Cómo agregamos color

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

## Ajustes menores de código

* [Reducción de la velocidad de paso del tiempo](https://github.com/mmasias/misApuntes/blob/36983d6b1b5fa8d5ce8cede0c8fc4ba6b4707eeb/PROGRAMACION-1/mapasConArrayAsociativo/ArrayAsociativo007.java#L174) (igual lo puedo cambiar a una constante luego)
* *elemento* [asume un valor por defecto](https://github.com/mmasias/misApuntes/blob/36983d6b1b5fa8d5ce8cede0c8fc4ba6b4707eeb/PROGRAMACION-1/mapasConArrayAsociativo/ArrayAsociativo007.java#L207) y solo cambia si es necesario.
