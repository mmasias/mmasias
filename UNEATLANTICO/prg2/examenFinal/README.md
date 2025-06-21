# Cómo lo hubiera resuelto

## Primer paso

Empiezo por resolver el problema, usando HOOD, lo que me dará la vista pública de objetos.

Para esto, sigo el guión de la parte 2:

- Crear una universidad

    ```java
    Universidad uneatlantico = new Universidad("UNEATLANTICO");
    ```

- Desde la universidad (o sea, todo lo que sigue lo debe desencadenar la Universidad, desencadenarlo es responsabilidad de la universidad).

    ```java
    uneatlantico.configurar()
    ```

  - Crear una asignatura

    ```java
    Asignatura programacion2 = new Asignatura("Programación 2", "PRG2", 6)
    ```
  
  - Contratar (crear) un profesor

    ```java
    Profesor ibuprofeno = new Profesor("Ibuprofeno","XYZ666123");
    ```

  - Asignarle la asignatura al profesor

    ```java
    ibuprofeno.asignarAsignatura(programacion2);
    ```

  - Decirle al profesor que cree un examen

    ```java
    ibuprofeno.crearExamen();
    ```

    - El profesor, cuando le pidan crear el examen, debe crearlo conteniendo tres preguntas, por tanto primero crea las preguntas:

        ```java
        Pregunta pregunta1 = new Pregunta("Vista pública clases");`    
        Pregunta pregunta2 = new Pregunta("Vista pública objetos");`
        Pregunta pregunta3 = new Pregunta("Vista privada clases");`
        ```

    - Crea el examen
    
        ```java
        Examen examen = new Examen();
        examen.agregarPregunta(pregunta1);
        examen.agregarPregunta(pregunta2);
        examen.agregarPregunta(pregunta3);
        ```

  - Contratar (crear) un profesor para que cuide el examen

    ```java
    Profesor dalsy = new Profesor("Dalsy","ABC999999");
    ```

  - Decirle al profesor que imparte que le entregue el examen al profesor que vigila

    ```java
    ibuprofeno.entregarExamen(dalsy);
    ```

    - El profesor que imparte, cuando ejecute entregarExamen(), sabe qué profesor recibe el examen, y hará:

        ```java
        profesorVigilante.recibirExamen(asignatura);
        ```
    - Que, efectivamente, hace que profesorVigilante reciba la asignatura y obtenga el examen.

    - El profesor que vigila, cuando ejecute recibirExamen(), recibe la asignatura, y hará:

        ```java
        Examen examen = asignatura.obtenerExamen();
        ```

    - Momento en el cual tiene ya el examen.

- Cuando nos pidan mostrar todo, se lo piden a la universidad, la cual se lo pide a sus profesores, los cuales, dependiendo de su rol, se lo piden a asignatura o a examen. Por tanto, todos deben tener un método `mostrarEscenario()` y se invoca en cascada.

## Segundo paso

Recopilo las responsabilidades (métodos) para cada clase identificada, incluyendo sus parámetros.

|Universidad|Profesor|Asignatura|Examen|Pregunta|
|-|-|-|-|-|
|`public Universidad(String nombre)`|`public Profesor(String nombre, String dni)`|`public Asignatura(String nombre, String codigo, int creditos)`|`public Examen()`|`public Pregunta(String enunciado)`|
|`public void configurar()`|`public void asignarAsignatura(Asignatura asignatura)`|`public Examen obtenerExamen()`|`public void agregarPregunta(Pregunta pregunta)`||
||`public void crearExamen()`||||
||`public void entregarExamen(Profesor profesorVigilante)`||||
||`public void recibirExamen(Asignatura asignatura)`||||
|`public String mostrarEscenario()`|`public String mostrarEscenario()`|`public String mostrarEscenario()`|`public String mostrarEscenario()`|`public String mostrarEscenario()`|

### Tercer paso

A partir de las vistas públicas, codifico:

#### Universidad

```java
class Universidad {
    private String nombre;
    private Profesor profesorQueImparte;
    private Profesor profesorQueVigila;
    private Asignatura asignatura;

    public Universidad(String nombre) {
        this.nombre = nombre;
    }

    public void configurar() {
 
        asignatura = new Asignatura("Programacion 2", "PRG2", 6);      
        
        profesorQueImparte = new Profesor("Ibuprofeno del Jesús Fernández Gómez de la Piedra y Cansado", "244455555X");
        profesorQueImparte.asignarAsignatura(asignatura);        
        profesorQueImparte.crearExamen();        
        
        profesorQueVigila = new Profesor("Dalsy Piedad de los Remedios Albornoz del Campo", "666456665X");        
        
        profesorQueImparte.entregarExamen(profesorQueVigila);
    }

    public String mostrarEscenario() {
        String resultado = "Universidad: " + nombre + "\n";
        resultado = resultado + profesorQueImparte.mostrarEscenario();
        resultado = resultado + profesorQueVigila.mostrarEscenario();
        return resultado;
    }

    public static void main(String[] args) {
        Universidad uneatlantico = new Universidad("Universidad Europea del Atlántico");
        uneatlantico.configurar();
        System.out.println(uneatlantico.mostrarEscenario());
    }
}
```

#### Profesor

```java
class Profesor {
    private String nombre;
    private String dni;
    private Asignatura asignatura;
    private Examen examenVigilado;

    public Profesor(String nombre, String dni) {
        this.nombre = nombre;
        this.dni = dni;
    }

    public void asignarAsignatura(Asignatura asignatura) {
        this.asignatura = asignatura;
    }

    public void crearExamen() {
        assert asignatura != null;
        Pregunta pregunta1 = new Pregunta("Vista pública clases");
        Pregunta pregunta2 = new Pregunta("Vista pública de objetos");
        Pregunta pregunta3 = new Pregunta("Vista privada de clases");
        
        Examen examen = new Examen("Examen Final");
        examen.agregarPregunta(pregunta1);
        examen.agregarPregunta(pregunta2);
        examen.agregarPregunta(pregunta3);
        
        asignatura.asignarExamen(examen);
    }

    public void entregarExamen(Profesor profesorVigilante) {
        assert asignatura != null;
        profesorVigilante.recibirExamen(asignatura);
    }

    public void recibirExamen(Asignatura asignatura) {
        examenVigilado = asignatura.obtenerExamen();
    }

    public String mostrarEscenario() {
        String resultado = "";
        if (asignatura != null) {
            resultado = resultado + "Profesor : " + nombre + " / DNI " + dni + "\n";
            resultado = resultado + asignatura.mostrarEscenario();
        } else if (examenVigilado != null) {
            resultado = resultado + "Vigilado por : " + nombre + " / DNI " + dni + "\n";
            resultado = resultado + examenVigilado.mostrarEscenario();
        }
        return resultado;
    }
}
```

### Asignatura

```java
class Asignatura {
    private String nombre;
    private String codigo;
    private int creditos;
    private Examen examen;

    public Asignatura(String nombre, String codigo, int creditos) {
        this.nombre = nombre;
        this.codigo = codigo;
        this.creditos = creditos;
    }

    public void asignarExamen(Examen examen) {
        this.examen = examen;
    }

    public Examen obtenerExamen() {
        return examen;
    }

    public String mostrarEscenario() {
        String resultado = "Asignatura: " + nombre + " - " + codigo + " - " + creditos + " créditos\n";
        if (examen != null) {
            resultado = resultado + examen.mostrarEscenario();
        }
        return resultado;
    }
}
```

### Examen

```java
class Examen {
    private String nombre;
    private Pregunta[] preguntas;
    private int numPreguntas;

    public Examen(String nombre) {
        this.nombre = nombre;
        this.preguntas = new Pregunta[10];
        this.numPreguntas = 0;
    }

    public void agregarPregunta(Pregunta pregunta) {
        if (numPreguntas < preguntas.length) {
            preguntas[numPreguntas] = pregunta;
            numPreguntas++;
        }
    }

    public String mostrarEscenario() {
        String resultado = "Examen: " + nombre + "\n";
        for (int i = 0; i < numPreguntas; i++) {
            resultado = resultado + "Pregunta " + (i + 1) + ": " + preguntas[i].mostrarEscenario() + "\n";
        }
        return resultado;
    }
}
```

### Pregunta

```java
class Pregunta {
    private String enunciado;

    public Pregunta(String enunciado) {
        this.enunciado = enunciado;
    }

    public String mostrarEscenario() {
        return enunciado;
    }
}
```

