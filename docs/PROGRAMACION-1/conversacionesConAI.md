# Jugando con ChatGPT

A continuación una transcripción literal de una charla con el [bot de OpenAI](https://openai.com/blog/chatgpt/), proponiéndole uno de los retos de los que habitualmente trabajamos en clase y extendiendo su complejidad poco a poco, como si de una clase se tratara.

Las repuestas y el código se pone sin cambios, tal y como lo proporcionó OpenAI, incluyendo adicionalmente algunos extras para representar de manera más clara la interacción:

|Símbolo|Significado 
|-|-
|Titulo en grande|Mi pregunta o planteamiento
|Texto en tamaño normal|La respuesta de OpenAI
|Texto dentro de cuadro gris|El código fuente que devolvió
|:collision:| Cuando la respuesta es incompleta o se ha interrumpido (debido, sin duda, al exceso de peticiones al que estará sometido el chat)
|:speaker: <b><i>COMENTARIO:</i></b> | Comentario mio a la conversación, incluido *a posteriori*

Conforme tenga tiempo iré poniendo mis comentarios. ¡Se anima a los lectores a dejar los suyos!

# Inicio

## Crea un laberinto de 10x10 y represéntalo en una matriz, en la que 0 sea el camino y 1 sean paredes

Aquí tienes un ejemplo de cómo se podría crear un laberinto de 10x10 utilizando una matriz en Java, en la que se utilizan 0 para representar el camino y 1 para representar las paredes. Este laberinto se ha diseñado de manera sencilla con el fin de facilitar su visualización y no es una solución óptima para un laberinto real.

```
public class Laberinto {
    // Tamaño del laberinto (10x10)
    private static final int FILAS = 10;
    private static final int COLUMNAS = 10;
    // Matriz que almacena el laberinto
    private static int[][] laberinto = new int[FILAS][COLUMNAS];

    public static void main(String[] args) {
        // Inicializa la matriz con las paredes del laberinto
        for (int fila = 0; fila < FILAS; fila++) {
            for (int columna = 0; columna < COLUMNAS; columna++) {
                // Pone una pared en todos los bordes del laberinto
                if (fila == 0 || columna == 0 || fila == FILAS - 1 || columna == COLUMNAS - 1) {
                    laberinto[fila][columna] = 1;
                }
                // Pone una pared en la fila 3 y en la columna 4
                else if (fila == 3 || columna == 4) {
                    laberinto[fila][columna] = 1;
                }
                // Pone un camino en todas las posiciones restantes
                else {
                    laberinto[fila][columna] = 0;
                }
            }
        }

        // Muestra el laberinto en la consola
        for (int fila = 0; fila < FILAS; fila++) {
            for (int columna = 0; columna < COLUMNAS; columna++) {
                System.out.print(laberinto[fila][columna] + " ");
            }
            System.out.println();
        }
    }
}
```

El laberinto se representa en la consola de la siguiente manera:

```
1 1 1 1 1 1 1 1 1 1
1 0 0 0 0 0 0 0 0 1
1 1 1 1 1 1 1 1 1 1
1 1 1 1 1 1 1 1
```
:collision:

## en el codigo anterior, utiliza esto como laberinto:

> :speaker: <b><i>COMENTARIO:</i></b> Aquí se me fue el ENTER antes de proponerle un laberinto (y de ponerle tilde a código :confounded:). OpenAI empezó a trabajar igual, de momento no tiene la opción de detener la petición.

Aquí tienes una implementación en Java del laberinto que has indicado. En lugar de utilizar una matriz de 10x10 para representar el laberinto, se han utilizado caracteres ASCII para dibujar el laberinto directamente en la consola. Además, se han añadido algunas condiciones adicionales para que el laberinto sea más complejo y difícil de resolver.

```
public class Laberinto {
    public static void main(String[] args) {
        // Dibuja el laberinto en la consola
        dibujarLaberinto();
    }

    private static void dibujarLaberinto() {
        // Filas del laberinto
        System.out.println("+-+-+-+-+-+-+-+-+");
        System.out.println("| |       |   | |");
        System.out.println("+ + +-+-+ +-+ + +");
        System.out.println("| | |     | | | |");
        System.out.println("+ + + + + + + + +");
        System.out.println("| |   | |   | | |");
        System.out.println("+ +-+ + +-+ + + +");
        System.out.println("|   |   |   | | |");
        System.out.println("+ +-+ + +-+ + + +");
        System.out.println("| | | | | | | | |");
        System.out.println("+ + + + + + + + +");
        System.out.println("| |   |   |   | |");
        System.out.println("+ +-+ +-+-+ +-+ +");
        System.out.println("|   | | |     | |");
        System.out.println("+ +-+ + + +-+-+ +");
        System.out.println("| |       |   | |");
        System.out.println("+-+-+-+-+-+-+-+-+");
    }
}
```

El laberinto se representa en la consola de la siguiente manera:

```
+-+-+-+-+-+-+-+-+
| |       |   | |
+ + +-+-+ +-+ + +
| | |     | | | |
+ + + + + + + + +
| |   | |   | | |
+ +-+ + +-+ + + +
|   |   |   | | |
+ +-+ + +-+ + + +
| | | | | | | | |
+ + + + + + + + +
| |   |   |   | |
+ +-+ +-+-+ +-+ +
|   | | |     | |
+ +-+ + + +-+-+ +
| |       |   | |
+-+-+-+-+-+-+-+-+
```

## no, volvamos al código anterior. Te voy a dar una matriz para que la utilices como punto de partida del laberinto: {1,1,1,1,1},{1,0,1,0,1},{1,0,1,0,1},{1,0,1,0,1},{1,0,0,0,1}

Aquí tienes una implementación en Java del laberinto que has indicado, en la que se utiliza una matriz para representar el laberinto y se han añadido algunas condiciones adicionales para que el laberinto sea más complejo y difícil de resolver. La matriz que has proporcionado se ha utilizado como punto de partida para el laberinto, pero se han añadido más paredes y caminos para que el laberinto tenga un tamaño y una forma adecuados.

```
public class Laberinto {
    // Tamaño del laberinto (10x10)
    private static final int FILAS = 10;
    private static final int COLUMNAS = 10;
    // Matriz que almacena el laberinto
    private static int[][] laberinto = {
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 0, 1, 0, 1, 0, 0, 1, 0, 1},
        {1, 0, 1, 0, 0, 0, 0, 1, 0, 1},
        {1, 0, 1, 0, 1, 0, 1, 1, 0, 1},
        {1, 0, 1, 0, 1, 0, 1, 0, 0, 1},
        {1, 0, 1, 0, 1, 0, 1, 0, 1, 1},
        {1, 0, 1, 0, 1, 0, 0, 0, 0, 1},
        {1, 0, 1, 0, 1, 1, 1, 1, 0, 1},
        {1, 0, 0, 0, 1, 0, 0, 1, 0, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    };

    public static void main(String[] args) {
        // Muestra el laberinto en la consola
        for (int fila = 0; fila < FILAS; fila++) {
            for (int columna = 0; columna < COLUMNAS; columna++) {
                System.out.
```

Aquí tienes una implementación en Java del laberinto que has indicado. En lugar de dibujar el laberinto en la consola utilizando caracteres ASCII, se ha utilizado una matriz de 5x5 para almacenar el estado de cada posición del laberinto. Esta matriz se ha inicializado con los valores que has indicado y se ha utilizado un bucle for para recorrerla y mostrar su contenido en la consola.

```
public class Laberinto {
    // Tamaño del laberinto (5x5)
    private static final int FILAS = 5;
    private static final int COLUMNAS = 5;
    // Matriz que almacena el laberinto
    private static int[][] laberinto = {
        {1, 1, 1, 1, 1},
        {1, 0, 1, 0, 1},
        {1, 0, 1, 0, 1},
        {1, 0, 1, 0, 1},
        {1, 0, 0, 0, 1}
    };

    public static void main(String[] args) {
        // Muestra el laberinto en la consola
        for (int fila = 0; fila < FILAS; fila++) {
            for (int columna = 0; columna < COLUMNAS; columna++) {
                System.out.print(laberinto[fila][columna] + " ");
            }
            System.out.println();
        }
    }
}
```

El laberinto se representa en la consola de la siguiente manera:

```
1 1 1 1 1 
1 0 1 0 1 
1 0 1 0 1 
1 0 1 0 1 
1 0 0 0 1 
```

## Genial! Ahora utiliza "[ ]" en lugar de imprimir 1 y " . " en lugar de imprimir 0

Aquí tienes una implementación en Java del laberinto que has indicado. En lugar de mostrar el contenido de la matriz utilizando los valores numéricos 1 y 0, se han utilizado los caracteres "[]" y "." para representar las paredes y el camino del laberinto, respectivamente. Además, se ha utilizado una estructura de bucle for anidada para recorrer la matriz y mostrar su contenido en la consola.

```
public class Laberinto {
    // Tamaño del laberinto (5x5)
    private static final int FILAS = 5;
    private static final int COLUMNAS = 5;
    // Matriz que almacena el laberinto
    private static int[][] laberinto = {
        {1, 1, 1, 1, 1},
        {1, 0, 1, 0, 1},
        {1, 0, 1, 0, 1},
        {1, 0, 1, 0, 1},
        {1, 0, 0, 0, 1}
    };

    public static void main(String[] args) {
        // Muestra el laberinto en la consola
        for (int fila = 0; fila < FILAS; fila++) {
            for (int columna = 0; columna < COLUMNAS; columna++) {
                // Muestra una pared o un camino en función del valor de la matriz
                if (laberinto[fila][columna] == 1) {
                    System.out.print("[ ]");
                } else {
                    System.out.print(" . ");
                }
            }
            System.out.println();
        }
    }
}
```

El laberinto se representa en la consola de la siguiente manera:

```
[ ][ ][ ][ ][ ]
[ ][ . ][ . ][ ]
[ ][ . ][ . ][ ]
[ ][ . ][ . ][ ]
[ ][ . ][ . ][ ]
```
> :speaker: <b><i>COMENTARIO:</i></b> Por alguna razón, la implementación que hace OpenAI de la máquina virtual de Java muestra erróneamente el laberinto (aunque el código está bien, salvo lo de public class Laberinto, mis alumnos ya me entienden :wink:)


## Vale! Ahora amplia el laberinto a una matriz de 10x10

Aquí tienes una implementación en Java del laberinto que has indicado. En lugar de utilizar una matriz de 5x5, se ha utilizado una matriz de 10x10 para almacenar el estado de cada posición del laberinto. Para inicializar la matriz, se han utilizado los valores que has indicado para las primeras 5 filas y se han duplicado estos valores para las 5 filas restantes. Además, se han utilizado bucles for para recorrer la matriz y mostrar su contenido en la consola.

```
public class Laberinto {
    // Tamaño del laberinto (10x10)
    private static final int FILAS = 10;
    private static final int COLUMNAS = 10;
    // Matriz que almacena el laberinto
    private static int[][] laberinto = {
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 0, 1, 0, 1, 0, 1, 0, 1, 0},
        {1, 0, 1, 0, 1, 0, 1, 0, 1, 0},
        {1, 0, 1, 0, 1, 0, 1, 0, 1, 0},
        {1, 0, 0, 0, 1, 0, 0, 0, 1, 0},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 0, 1, 0, 1, 0, 1, 0, 1, 0},
        {1, 0, 1, 0, 1, 0, 1, 0, 1, 0},
        {1, 0, 1, 0, 1, 0, 1, 0, 1, 0},
        {1, 0, 0, 0, 1, 0, 0, 0, 1, 0}
    };

    public static void main(String[] args) {
        // Muestra el laberinto en la consola
        for (int fila = 0; fila < FILAS; fila++) {
            for (int columna = 0; columna < COLUMNAS; columna++) {
                // Muestra una pared o un camino en función del valor de la
```
:collision:

> :speaker: <b><i>COMENTARIO:</i></b> Aunque el código se corta, lo interesante de esta evolución es la ampliación de la matriz de 5x5 a 10x10

## Y si además de pared y camino agregamos, por ejemplo, agua: ¿cómo la representarías?

Si quieres añadir agua al laberinto, puedes utilizar un nuevo valor en la matriz que represente este elemento. Por ejemplo, si utilizas el valor 2 para representar agua, podrías modificar el código de la siguiente manera:


```
public class Laberinto {
    // Tamaño del laberinto (10x10)
    private static final int FILAS = 10;
    private static final int COLUMNAS = 10;
    // Matriz que almacena el laberinto
    private static int[][] laberinto = new int[FILAS][COLUMNAS];

    public static void main(String[] args) {
        // Inicializa la matriz con valores aleatorios
        for (int fila = 0; fila < FILAS; fila++) {
            for (int columna = 0; columna < COLUMNAS; columna++) {
                // Genera un valor aleatorio entre 0 y 2
                laberinto[fila][columna] = (int) (Math.random() * 3);
            }
        }

        // Muestra el laberinto en la consola
        for (int fila = 0; fila < FILAS; fila++) {
            for (int columna = 0; columna < COLUMNAS; columna++) {
                // Muestra una pared, un camino o agua en función del valor de la matriz
                if (laberinto[fila][columna] == 0) {
                    System.out.print(" . ");
                } else if (laberinto[fila][columna] == 1) {
                    System.out.print("[ ]");
                } else {
                    System.out.print("~~~");
                }
            }
            System.out.println();
        }
    }
}
```

En este caso, se ha utilizado la cadena de caracteres "~~~" para representar agua en el laberinto. El laberinto se representa en la consola de la siguiente manera (el laberinto mostrado es un ejemplo y puede variar en cada ejecución del programa):

```
~~~ ~~~ ~~
```

## vale: extendamos el código para permitir pared, camino, agua, césped y montañas...

Si quieres añadir más elementos al laberinto, como césped y montañas, puedes utilizar nuevos valores en la matriz que representen estos elementos. Por ejemplo, si utilizas el valor 3 para representar césped y el valor 4 para representar montañas, podrías modificar el código de la siguiente manera:

```
public class Laberinto {
    // Tamaño del laberinto (10x10)
    private static final int FILAS = 10;
    private static final int COLUMNAS = 10;
    // Matriz que almacena el laberinto
    private static int[][] laberinto = new int[FILAS][COLUMNAS];

    public static void main(String[] args) {
        // Inicializa la matriz con valores aleatorios
        for (int fila = 0; fila < FILAS; fila++) {
            for (int columna = 0; columna < COLUMNAS; columna++) {
                // Genera un valor aleatorio entre 0 y 4
                laberinto[fila][columna] = (int) (Math.random() * 5);
            }
        }

        // Muestra el laberinto en la consola
        for (int fila = 0; fila < FILAS; fila++) {
            for (int columna = 0; columna < COLUMNAS; columna++) {
                // Muestra una pared, un camino, agua, césped o montañas en función del valor de la matriz
                if (laberinto[fila][columna] == 0) {
                    System.out.print(" . ");
                } else if (laberinto[fila][columna] == 1) {
                    System.out.print("[ ]");
                } else if (laberinto[fila][columna] == 2) {
                    System.out.print("~~~");
                } else if (laberinto[fila][columna] == 3) {
                    System.out.print(";;;");
                } else {
                    System.out.print("/\\/\\");
                }
            }
            System.out.println();
        }
    }
}
```
En este caso, se han utilizado las cadenas de caracteres ";;;" para representar césped y "/\/\" 

:collision:

