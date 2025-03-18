# Flipping on the Beach: Una aproximación intuitiva al diseño descendente

## ¿Por qué?

La programación de sistemas complejos presenta diversos desafíos que dificultan su desarrollo:

- Se genera código difícil de leer y mantener cuando no existe una estructura clara de responsabilidades.
- Los desarrolladores tienden a mezclar detalles de implementación con la lógica principal del programa.
- La transición desde la programación estructurada hacia la orientada a objetos resulta confusa para muchos estudiantes.
- El main suele convertirse en un método extenso y complejo que asume demasiadas responsabilidades.
- La identificación de clases y sus responsabilidades se realiza frecuentemente de manera arbitraria.
- Existe una tendencia a que un único objeto "controlador" asuma la responsabilidad de todo el sistema.

Como señala L. Fernández: "*En programación tradicional, se definirían todas las estructuras de datos necesarias para que las manipulen todos los subprogramas. En programación orientada a objetos, se recurre a atributos que son objetos de otras clases responsables de los detalles del soporte y manipulación de esos datos*".

## ¿Qué?

"Flipping on the Beach" es una metodología de diseño que adapta los principios del Diseño Orientado a Objetos Jerárquico (HOOD) de manera simplificada e intuitiva.

### Visión estática y dinámica

Como señala Fernández: "*Un programa orientado a objetos en ejecución es una colección jerárquica de objetos contenidos en otros objetos sucesivas veces que colaboran todos entre sí. Paralelamente, un programa en edición/compilación es una colección de las clases de estos objetos relacionadas entre sí.*"

- **Visión estática**: Corresponde al código que escribimos. Un programa orientado a objetos es una colección de clases que permiten la abstracción, la encapsulación, la modularidad y la jerarquía. Esta visión muestra cómo las clases se "apoyan" en otras clases, utilizando objetos como atributos, parámetros o variables locales.
- **Visión dinámica**: Corresponde al programa en ejecución. Es un universo de objetos que colaboran entre sí gracias al desencadenamiento de objetos (instanciaciones) y mensajes. Esta visión muestra el flujo de ejecución y la interacción entre los objetos vivos.

Esta metodología propone diseñar el sistema de manera descendente (top-down), comenzando por la visión global del programa y refinando progresivamente cada componente. El término "flipping" (o "flipar") hace referencia al proceso creativo de imaginar o visualizar los componentes necesarios y sus responsabilidades.

Como define Budd: "*Cuando los programadores piensan en los problemas, en términos de comportamientos y responsabilidades de los objetos, traen con ellos un caudal de intuición, ideas y conocimientos provenientes de su experiencia diaria*". Esta es precisamente la esencia de "flipping on the beach": aprovechar nuestra intuición natural sobre las responsabilidades de los objetos.

## ¿Para qué?

La aplicación de "Flipping on the Beach" ofrece múltiples beneficios:

- **Claridad**: El código principal se mantiene limpio y legible, expresando claramente QUÉ hace sin mezclarlo con CÓMO lo hace.
- **Mantenibilidad**: Cada componente tiene una responsabilidad clara y bien definida, facilitando la localización y corrección de errores.
- **Escalabilidad**: Es más sencillo añadir nuevas funcionalidades sin afectar al código existente gracias a la separación de responsabilidades.
- **Transición natural a POO**: Prepara el terreno para la programación orientada a objetos, facilitando la comprensión del paradigma.
- **Colaboración natural**: Los objetos colaboran de manera similar a cómo entendemos el mundo real, mejorando la intuición sobre el diseño.
- **Encapsulación efectiva**: Cada clase encapsula sus datos y comportamientos, reduciendo el acoplamiento entre componentes.
- **Identificación temprana de relaciones**: Permite reconocer los distintos tipos de relaciones entre clases desde las primeras fases del diseño.

Como señala Booch: "*Un objeto en sí mismo no es interesante. Los objetos contribuyen al comportamiento de un sistema colaborando con otros objetos*".

## ¿Cómo?

|||
|-|-|
|**Tomar una clase**|Al inicio del desarrollo, será la clase que engloba todo el sistema. Posteriormente, serán las clases que se vayan identificando durante el desarrollo.|
|**Definir el comportamiento**|Se determinan las cabeceras de los métodos públicos, especialmente el método principal que dispara toda la funcionalidad (como `jugar()`, `ejecutar()`, etc.)|
|**Definir los atributos**|Se identifican los datos necesarios para que la clase cumpla sus responsabilidades, generalmente como atributos que son objetos de otras clases.|
|**Codificar los métodos**|Se implementa la lógica delegando tareas a los colaboradores. No debe ser impedimento incluir mensajes a métodos que aún no existen.|
|**Recapitular**|Se identifican las nuevas clases que han surgido y los mensajes enviados a objetos de estas clases.|

### 1. El Main limpio

Se comienza con un main que expresa claramente QUÉ hace el programa, sin entrar en CÓMO lo hace:

```java
public static void main(String[] args) {
    Aplicacion app = new Aplicacion();
    app.ejecutar();
}
```

### 2. Primera "flipada": Las responsabilidades principales

Para la clase principal, se define su comportamiento general:

```java
public class Aplicacion {
    public void ejecutar() {
        cargarDatos();
        procesarInformacion();
        mostrarResultados();
    }
    
    private void cargarDatos() {
        // Necesitaré:
        //  - Leer de algún origen (archivo, teclado...)
        //  - Validar el formato
        //  - Almacenar temporalmente
    }
    
    // Otros métodos...
}
```

### 3. Segunda "flipada": Los colaboradores

Se identifican las clases colaboradoras y sus responsabilidades:

```java
public class Aplicacion {
    private LectorDatos lector;
    private Procesador procesador;
    private Visualizador visualizador;
    
    public Aplicacion() {
        lector = new LectorDatos();
        procesador = new Procesador();
        visualizador = new Visualizador();
    }
    
    public void ejecutar() {
        Datos datos = lector.cargar();
        Resultados resultados = procesador.procesar(datos);
        visualizador.mostrar(resultados);
    }
}
```

### 4. Identificación de relaciones entre clases

Durante el proceso se identifican tres tipos principales de relaciones:

#### a) Relación de Composición ("tiene un")

Es la relación entre el todo y la parte. Se implementa típicamente como atributos con instanciación:

```java
public class Libro {
    private Pagina[] paginas = new Pagina[100];
    
    public Libro() {
        for (int i = 0; i < paginas.length; i++) {
            paginas[i] = new Pagina();
        }
    }
}
```

#### b) Relación de Uso ("usa un")

Se establece momentáneamente, generalmente como parámetros o variables locales:

```java
public class Estudiante {
    public void hacerExamen(Problema problema) {
        Calculadora calc = new Calculadora();
        double resultado = calc.resolver(problema);
        // La calculadora se usa sólo dentro de este método
    }
}
```

#### c) Relación de Asociación ("conoce un")

Perdura en el tiempo pero no implica pertenencia. Se implementa como atributos que reciben referencias:

```java
public class Empleado {
    private Departamento departamento;
    
    public Empleado(Departamento depto) {
        this.departamento = depto;
    }
    
    public void cambiarDepartamento(Departamento nuevoDepartamento) {
        this.departamento = nuevoDepartamento;
    }
}
```

### 5. Aplicación sistemática del método

Para cada nueva clase identificada, se repite el proceso cíclicamente:

1. **Tomar la clase**: Seleccionar una de las clases identificadas previamente
2. **Definir comportamiento**: Establecer la interface pública
3. **Definir atributos**: Identificar datos y colaboradores necesarios
4. **Codificar métodos**: Implementar delegando tareas a colaboradores
5. **Recapitular**: Identificar nuevas clases y métodos necesarios

### Visiones

La aplicación de "Flipping on the Beach" supone trabajar simultáneamente con las visiones estática y dinámica del programa:

#### Visión estática: Las clases y sus relaciones

En la visión estática, se construye una jerarquía de clases relacionadas entre sí. Por ejemplo:

```
Aplicacion
  |
  |-- GestorDatos
  |     |-- Validador
  |
  |-- Procesador
  |
  |-- Visualizador
```

Cada clase ofrece un nombre y una interfaz pública de métodos que permite la abstracción de un concepto: esencialmente qué es y qué puede hacer. La vista privada encapsula los detalles: cómo se soportan los datos y cómo se manipulan.

#### Visión dinámica: Los objetos y su colaboración

En la visión dinámica, se crea un universo jerarquizado de objetos construido "automáticamente" mediante instanciaciones, que colaboran entre sí mediante mensajes:

```
main:
  crea una aplicacion que:
    crea un gestor que:
      crea un validador
    crea un procesador
    crea un visualizador
  lanza el mensaje ejecutar() a aplicacion que:
    lanza el mensaje cargarDatos() a gestor que:
      lanza validar() a validador
    ...
```

## ¿Y ahora qué?

Una vez comprendido el método, se recomienda:

1. Tomar un problema que se haya resuelto anteriormente con programación estructurada y reescribir el main siguiendo este enfoque.
2. Identificar las responsabilidades principales y pensar en posibles clases colaboradoras.
3. Definir las relaciones entre las clases: ¿cuáles son de composición, uso o asociación?
4. Implementar las clases principales definiendo primero sus interfaces públicas.
5. Comparar el código resultante con la versión original para apreciar las diferencias en legibilidad y mantenibilidad.

> El objetivo no es lograr la perfección desde el principio, sino mejorar incrementalmente mientras se mantiene el código principal limpio y comprensible.
