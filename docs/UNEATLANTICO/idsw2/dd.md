# El Doble Despacho en Java: Planteamiento del Problema y Solución

El **Doble Despacho (Double Dispatch)** es una técnica de programación que permite a un sistema seleccionar el método a ejecutar basándose en el **tipo de dos objetos** involucrados en una interacción (el receptor y el argumento), en lugar de depender únicamente del receptor.

Esta técnica constituye la base del **Patrón Visitor** y resulta especialmente útil en situaciones donde diferentes tipos de objetos deben interactuar entre sí de formas distintas, como en la gestión de colisiones dentro de un videojuego. Para comprender su verdadera utilidad, es fundamental contrastar la aproximación tradicional con la implementación mediante Doble Despacho.

---

## Parte 1: El Problema (El enfoque tradicional)

Supóngase que se está desarrollando un videojuego con una jerarquía de personajes: `Mario`, `Goomba` y `Bowser`. La lógica de interacción dictate que el resultado de una colisión varía según la combinación de tipos:
*   Mario vs Goomba → El Goomba es eliminado.
*   Mario vs Bowser → Mario recibe daño.
*   Goomba vs Bowser → Bowser se enoja con su subordinado.

Sin emplear el Doble Despacho, la solución habitual consiste en verificar explícitamente los tipos de los objetos utilizando el operador `instanceof`.

### El código tradicional

```java
// Clases básicas
abstract class Personaje {
    String nombre;
    public Personaje(String nombre) { this.nombre = nombre; }
}

class Mario extends Personaje { public Mario() { super("Mario"); } }
class Goomba extends Personaje { public Goomba() { super("Goomba"); } }
class Bowser extends Personaje { public Bowser() { super("Bowser"); } }

// --- ENFOQUE TRADICIONAL CON PROBLEMAS ---
class GestorColisiones {

    public void procesarColision(Personaje a, Personaje b) {
        System.out.print("Colisión entre " + a.nombre + " y " + b.nombre + ": ");

        // Se identifica al primer personaje
        if (a instanceof Mario) {
            // Se identifica al segundo personaje (Anidamiento)
            if (b instanceof Mario) {
                System.out.println("¡Hola hermano!");
            } else if (b instanceof Goomba) {
                System.out.println("¡Mario aplasta al Goomba!");
            } else if (b instanceof Bowser) {
                System.out.println("¡Bowser lanza fuego a Mario!");
            }

        } else if (a instanceof Goomba) {
            if (b instanceof Mario) {
                System.out.println("El Goomba muere.");
            } else if (b instanceof Goomba) {
                System.out.println("Se miran y se cruzan.");
            } else if (b instanceof Bowser) {
                System.out.println("Bowser se enoja con su súbdito.");
            }

        } else if (a instanceof Bowser) {
            // ... y así sucesivamente para cada combinación posible
        }
    }
}
```

### Limitaciones de este enfoque

1.  **Complejidad estructural:** Se generan estructuras de control anidadas (`if` dentro de `if`). Si el sistema cuenta con 10 personajes, podría haber hasta 100 combinaciones manuales, resultando en un código difícil de leer (código espagueti).
2.  **Bajo mantenibilidad:** Si se requiere añadir un nuevo personaje (por ejemplo, `Yoshi`), es necesario modificar esta clase central e insertar un bloque `else if` dentro de **cada** bloque condicional existente.
3.  **Acoplamiento:** La lógica de comportamiento de todos los personajes reside en una única clase, lo que viola el principio de encapsulamiento y responsabilidad única.

---

## Parte 2: La Solución (Doble Despacho)

El Doble Despacho resuelve estas limitaciones sustituyendo las comprobaciones manuales de tipo por dos llamadas virtuales (polimórficas).

### El mecanismo

En lugar de que una clase externa pregunte "¿Quién eres tú?", se delega la responsabilidad a los propios objetos mediante un proceso de doble llamada:
1.  El objeto `A` invoca un método en el objeto `B`.
2.  Dentro de ese método, el objeto `B` invoca de vuelta a un método específico de `A`, pasándose a sí mismo como argumento.

De esta forma, el entorno de ejecución resuelve el tipo real tanto de `A` como de `B` automáticamente.

### Implementación con Doble Despacho

```java
// 1. La interfaz base define las sobrecargas necesarias
abstract class Personaje {
    String nombre;
    public Personaje(String nombre) { this.nombre = nombre; }

    // PRIMER DESPACHO: Método de entrada genérico
    public abstract void colisionarCon(Personaje otro);

    // Métodos para el SEGUNDO DESPACHO (Sobrecargas para cada tipo)
    public abstract void colisionarConMario(Mario m);
    public abstract void colisionarConGoomba(Goomba g);
    public abstract void colisionarConBowser(Bowser b);
}

// 2. Implementaciones concretas

class Mario extends Personaje {
    public Mario() { super("Mario"); }

    @Override
    public void colisionarCon(Personaje otro) {
        // Mario delega la acción en el otro objeto, identificándose a sí mismo
        otro.colisionarConMario(this); 
    }

    // Definición de cómo reacciona Mario según el visitante
    @Override
    public void colisionarConMario(Mario m) { System.out.println("¡High five!"); }
    @Override
    public void colisionarConGoomba(Goomba g) { System.out.println("¡Mario aplasta al Goomba!"); }
    @Override
    public void colisionarConBowser(Bowser b) { System.out.println("¡Mario recibe daño de Bowser!"); }
}

class Goomba extends Personaje {
    public Goomba() { super("Goomba"); }

    @Override
    public void colisionarCon(Personaje otro) {
        otro.colisionarConGoomba(this);
    }

    @Override
    public void colisionarConMario(Mario m) { System.out.println("El Goomba es aplastado."); }
    @Override
    public void colisionarConGoomba(Goomba g) { System.out.println("Los Goombas se cruzan."); }
    @Override
    public void colisionarConBowser(Bowser b) { System.out.println("Bowser patea al Goomba."); }
}

class Bowser extends Personaje {
    public Bowser() { super("Bowser"); }

    @Override
    public void colisionarCon(Personaje otro) {
        otro.colisionarConBowser(this);
    }

    @Override
    public void colisionarConMario(Mario m) { System.out.println("Bowser intenta quemar a Mario."); }
    @Override
    public void colisionarConGoomba(Goomba g) { System.out.println("Bowser ignora al Goomba."); }
    @Override
    public void colisionarConBowser(Bowser b) { System.out.println("¡Bowser pelea consigo mismo!"); }
}

// 3. Código cliente
public class EjecucionJuego {
    public static void main(String[] args) {
        Personaje mario = new Mario();
        Personaje goomba = new Goomba();
        Personaje bowser = new Bowser();

        System.out.println("--- Registro de colisiones ---");
        
        // Se observa la limpieza del código: sin 'ifs', sin 'instanceof'.
        mario.colisionarCon(goomba);   // Salida: ¡Mario aplasta al Goomba!
        goomba.colisionarCon(mario);   // Salida: El Goomba es aplastado.
        bowser.colisionarCon(mario);   // Salida: Bowser intenta quemar a Mario.
        bowser.colisionarCon(bowser);  // Salida: ¡Bowser pelea consigo mismo!
    }
}
```

### Análisis de la ejecución

Para comprender el flujo interno, considérese la llamada `mario.colisionarCon(goomba)`:

1.  **Primer Despacho:** El entorno de ejecución identifica que `mario` es una instancia de `Mario` y ejecuta `Mario.colisionarCon(Personaje otro)`.
2.  **Delegación:** Dentro de este método, se ejecuta la línea `otro.colisionarConMario(this)`.
    *   `this` corresponde a `mario`.
    *   `otro` corresponde a `goomba`.
3.  **Segundo Despacho:** El sistema busca el método `colisionarConMario` dentro de la clase real de `otro`. Al ser `otro` un `Goomba`, se ejecuta `Goomba.colisionarConMario(Mario m)`.
4.  **Resultado:** Se ejecuta la lógica específica para la combinación `Goomba` (receptor) recibe a `Mario` (argumento).

## Conclusión

El empleo de la técnica del Doble Despacho transforma un código frágil y saturado de condicionales en una estructura robusta y orientada a objetos.

*   **Eliminación de comprobaciones de tipo:** Se suprime el uso de `instanceof` y conversiones explícitas (casting).
*   **Encapsulamiento:** La lógica de cada interacción reside dentro de las propias clases involucradas.
*   **Mantenibilidad:** Aunque añadir nuevas clases requiere implementar nuevos métodos, se reduce significativamente el riesgo de error humano en comparación con la modificación de bloques condicionales gigantescos.

La próxima vez que se encuentre ante la necesidad de escribir múltiples estructuras condicionales para manejar interacciones entre objetos, es recomendable considerar la implementación del Doble Despacho para mejorar la arquitectura del software.
