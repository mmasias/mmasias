# Console

Clase que encapsula la entrada/salida por consola.

## Creación

```java
Console console = new Console();
```

## Métodos de entrada y salida

<div align=center>

| Entrada | Salida |
|---|---|
| `String readString()` | `void write(String)` |
| `String readString(String title)` | `void writeln(String)` |
| `char readChar()` | `void writeln()` |
| `char readChar(String title)` | `void write(char)` |
| `int readInt()` | `void writeln(char)` |
| `int readInt(String title)` | `void write(int)` |
| `double readDouble()` | `void writeln(int)` |
| `double readDouble(String title)` | `void write(double)` |
| | `void writeln(double)` |
| | `void write(Object)` |
| | `void writeln(Object)` |

</div>

Las variantes con parámetro `title` muestran un mensaje antes de leer. Los métodos `read` de tipos primitivos validan el formato y repiten la lectura hasta obtener una entrada válida.

Los métodos `write` y `writeln` están sobrecargados para `String`, `char`, `int`, `double` y `Object`. La diferencia entre ambos: `writeln` añade un salto de línea.

## Ejemplo de uso

```java
class App {

    public static void main(String[] args) {
        Console console = new Console();

        console.writeln("Registro de alumno");
        String nombre = console.readString("Nombre: ");
        int edad = console.readInt("Edad: ");
        double nota = console.readDouble("Nota media: ");

        console.writeln("> Alumno: " + nombre);
        console.writeln("> Edad: " + edad);
        console.writeln("> Nota media: " + nota);
    }
}
```

### Salida esperada

```
Registro de alumno
Nombre: Ibuprofeno Fernández
Edad: 21
Nota media: 7.5
> Alumno: Ibuprofeno Fernández
> Edad: 21
> Nota media: 7.5
```
