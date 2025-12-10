# Sentido común vs academicismo pomposo

> "Si necesitas un framework complejo para explicar por qué tu código es bueno, tu código probablemente no es bueno."
> 
> — De sentido común (disponible gratis, sin suscripción)

## Principios fundamentales

**Sentido común:**

- Si Aisha da pizarras en el enunciado → Aisha da pizarras en el código
- Si el último niño escribe en la pizarra → el último niño escribe en el código
- Si algo se llama ludoteca → que se comporte como una ludoteca

**No se necesita un framework para esto: Es lógica y orden.**

- **Piensa** (diseña, dibuja) antes de programar
- **Lee** el enunciado cuidadosamente
- **Modela** fielmente la realidad
- **Escribe** código que cuente la historia

## Lo que enseñamos vs "Lo que venden como"

|Lo visto desde PRG1|Lo venden como|
|-|-|
| El código debe contar la historia del problema que resuelve | *Implementa Aggregates con Bounded Contexts usando Ubiquitous Language en tu Domain Model siguiendo los patrones del Blue Book de Eric Evans...* |
| Cada clase hace lo que dice su nombre | *Aplicar el principio de Single Responsibility del paradigma SOLID con Separation of Concerns* |
| Los comentarios son caca - el código debe ser auto-explicativo | *Implementar Clean Code siguiendo las reglas de Robert C. Martin con Self-Documenting Code* |
| Si necesitas arrays que crezcan, usa listas | *Implementa Dynamic Data Structures con Abstract Data Types siguiendo el patrón Strategy para la gestión de capacidad* |
| Lydia recibe niños, Aisha los gestiona | *Establece un Pipeline Pattern con Command Handlers siguiendo Event-Driven Architecture* |
| El monitor no debe gestionar arrays y lógica de juego | *Separa responsabilidades aplicando Separation of Concerns con el patrón Facade* |
| Usa `Console` en lugar de `System.out.println` por todas partes | *Implementa el patrón Adapter con Dependency Injection para abstraer las operaciones de I/O* |
| Si repites código, extrae un método | *Aplica el principio DRY (Don't Repeat Yourself) con Refactoring hacia Extract Method* |
| `gestionarNiños()` en lugar de `gestionarColas()` | *Utiliza Ubiquitous Language del Domain Model para mantener coherencia semántica* |
| Cada niño tiene su pizarrín, no una variable compartida | *Encapsula el estado mediante Composition sobre Inheritance con Value Objects* |
| Si el enunciado dice que llegan 0-2 niños/min, implementa eso | *Modela los Requirements con fidelidad utilizando Specification Pattern* |
| Los arrays fijos son un problema, las listas dinámicas lo resuelven | *Migra de Static Allocation a Dynamic Memory Management usando el patrón Abstract Factory* |
| Experimenta el problema antes de aplicar la solución | *Aprende mediante Problem-Based Learning con Constructivist Pedagogy* |
| Código limpio es código que lees como un libro | *Implementa Readable Code siguiendo los principios de Cognitive Load Theory* |
| Si no sabes cuántos elementos necesitas, no uses array fijo | *Aplica el Open/Closed Principle para estructuras de datos escalables* |
| Cuando Aisha quiere saber cuántos niños tiene, pregúntale a la cola | *Implementa el patrón Query Object con Tell Don't Ask principle* |
| El método `llegaNiño()` debería decir exactamente cuándo llegan | *Encapsula la lógica de dominio mediante Business Rules Pattern* |

---

## El problema del academicismo

### Lo simple se vuelve complejo

**Pregunta simple:** ¿Cómo sé cuántos niños tengo?

**Respuesta simple:**

```java
int cantidad = monitor.numeroNiños();
```

**Respuesta académica:**
*"Implementamos un Query Pattern que retorna un Value Object representando el Cardinal de la Collection encapsulada, manteniendo el principio de Tell Don't Ask mientras preservamos la inmutabilidad del Aggregate Root..."*

### El código habla por sí mismo

**Código con sentido común:**

```java
if (aisha.puedeJugar()) {
    aisha.jugar();
}
```

**Todo claro. No necesita explicación.**

**Código académico:**

```java
if (gameCoordinator.validateMinimumParticipants(playerQueue)) {
    gameCoordinator.initializeGameSession(playerQueue);
}
```

*"Esto implementa el Strategy Pattern con Factory Method para el Game Session Management siguiendo Domain-Driven Design..."*

---

## La progresión natural (sin frameworks)

### PRG1: Programación Estructurada

- Arrays y métodos estáticos
- El código hace lo que dice
- Los nombres explican qué hace cada cosa

### PRG2: Orientación a Objetos

- Cada clase = un actor del dominio
- Cada método = una responsabilidad clara
- El código cuenta la historia del problema

### EDA: Estructuras de Datos

- Las listas resuelven el problema de los arrays fijos
- No porque "son mejores" abstractamente
- Sino porque **experimentaste las dificultades** de los arrays

### Ingeniería del Software

- Analiza decisiones de diseño
- Compara compromisos
- Evalúa cuándo aplicar qué solución
- **Sin dogmas, con criterio**

---

## La verdad incómoda

La mayoría de los "patrones" y "principios" que la industria vende como "mejores prácticas" son simplemente:

**Sentido común con nombre comercial.**

- **SOLID** = Haz que cada cosa haga una cosa
- **DRY** = No copies código
- **KISS** = No compliques lo simple
- **YAGNI** = No hagas cosas que no necesitas
- **Clean Code** = Escribe código legible

Todo esto es **obvio** si piensas antes de programar.

---

## Conclusión

### Lo que importa

- Pensar antes de programar  
- Leer el enunciado con cuidado  
- Modelar fielmente la realidad  
- Escribir código que cuente la historia  
- Aprender de los errores  
- Desarrollar criterio propio  

### Lo que NO necesitas por imposición

- Frameworks pomposos  
- Jerga académica innecesaria  
- Libros de 500 páginas  
- Certificaciones caras  
- Consultores que te digan lo obvio  
- Patrones para problemas que no tienes  
