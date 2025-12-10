# AcercaDe los ejemplos de árboles

## Valoración `ejemplo000`

*   **Objetivo principal**: Introducir la estructura de datos más fundamental: el `Node` y el `Tree`.
*   **Implementación**: Se presenta un árbol genérico (no binario) con un número máximo de hijos fijo (`MAX_CHILDREN = 3`). La inserción se realiza de forma iterativa utilizando una pila explícita (`stack`) para encontrar el primer nodo con espacio disponible, en un recorrido que se asemeja a una búsqueda en anchura (BFS) pero procesada con una pila (LIFO), lo que resulta en un recorrido en profundidad (DFS).
*   **2Think:**:
    *   **Simplicidad Extrema**: El código es fácil de seguir para un principiante. No hay conceptos avanzados que distraigan del Objetivo principal: entender que un árbol es un conjunto de nodos enlazados.
    *   **Manipulación directa de la estructura**: Al evitar la recursividad, el estudiante se ve forzado a pensar en el mecanismo de recorrido explícito (la pila), lo que desmitifica la "magia" de los algoritmos de árboles.
    *   **Concepto de "Espacio"**: La idea de `hasSpace()` es una simplificación muy tangible que ayuda a entender las restricciones y condiciones de inserción.

## Valoración `ejemplo001`

*   **Evolución desde `ejemplo000`**: Añade el método `printTree()`.
*   **Objetivo principal**: Visualizar la estructura jerárquica del árbol que se ha creado en memoria.
*   **Implementación**: El método `printTree()` utiliza de nuevo una pila explícita para un recorrido en preorden. De forma muy inteligente, se apoya en una segunda pila (`levelStack`) para registrar la profundidad de cada nodo y así poder imprimir la jerarquía con indentación.
*   **2Think:**:
    *   **Conexión lógica**: Responde a la pregunta natural del estudiante: "¿Y cómo veo el árbol que he creado?".
    *   **Refuerzo del recorrido iterativo**: No solo vuelve a usar una pila, sino que introduce la necesidad de manejar un estado adicional (el nivel), un concepto crucial en algoritmos más complejos.
    *   **Enseñanza implícita del preorden**: Sin llamarlo explícitamente "preorden", el código implementa este recorrido. El estudiante aprende el patrón (procesar nodo, luego apilar hijos) de una forma práctica y orientada a un objetivo (imprimir).
    *   **Atención al detalle**: La inversión del orden al apilar los hijos (`for (int i = childCount - 1; i >= 0; i--)`) es un detalle técnico fundamental para que la impresión salga en el orden natural, obligando al estudiante a pensar cuidadosamente en el comportamiento de la pila (LIFO).

## Valoración `ejemplo002`

*   **Evolución desde `ejemplo001`**: Se modifica `TreeSample.java` para evitar que el valor centinela (`-1`) se inserte en el árbol.
*   **Objetivo principal**: Refinar el uso de la estructura de datos, distinguiendo entre los datos a procesar y la lógica de control del programa.
*   **Implementación**: Se añade una simple condición `if (value != -1)` en el bucle de entrada de datos.
*   **2Think:**:
    *   **Manejo de casos límite**: Enseña al estudiante a pensar en los valores especiales o "centinelas" que se usan para controlar bucles y a tratarlos de forma adecuada.
    *   **Separación de responsabilidades**: Refuerza la idea de que la clase `Tree` no debería tener que saber nada sobre valores de control como `-1`. La responsabilidad de filtrar esos valores recae en el código "cliente" que utiliza el árbol.
    *   **Robustez y corrección**: Es un paso crucial para pasar de un programa que simplemente "funciona" a uno que es "correcto". El árbol ya no contiene datos espurios, lo que sería fundamental para futuras operaciones (búsquedas, borrados, etc.). Es una primera lecha sobre programación defensiva y validación de entradas.

## Valoración `ejemplo003`

*   **Evolución desde `ejemplo002`**: El método `insert()` en `Tree.java` cambia su estrategia de recorrido de una pila (DFS) a una cola (BFS).
*   **Objetivo principal**: Introducir el concepto de recorrido en anchura (BFS) y contrastarlo con el recorrido en profundidad (DFS) ya visto.
*   **Implementación**: La inserción ahora utiliza una cola implementada manualmente con un array y punteros `front` y `rear`. Esto asegura que los nodos se inserten en el primer espacio disponible por niveles, de izquierda a derecha.
*   **2Think:**:
    *   **Introducción fundamental a BFS**: Este ejemplo es la primera exposición directa a la búsqueda en anchura, un algoritmo crucial para árboles y grafos.
    *   **Implementación manual de cola**: Al igual que con la pila, el estudiante debe entender y codificar el comportamiento FIFO de una cola, reforzando los conceptos de estructuras de datos lineales.
    *   **Contraste algorítmico directo**: Permite comparar cómo un cambio en la estructura de datos auxiliar (pila vs. cola) cambia fundamentalmente el algoritmo de recorrido y, por ende, la forma en que se construye el árbol. Esto es vital para comprender la elección de algoritmos.
    *   **Base para grafos**: Establece una base sólida para la comprensión de algoritmos de recorrido en grafos, donde BFS y DFS son herramientas esenciales.
    *   **Impacto en la estructura del árbol**: El estudiante puede observar cómo la misma secuencia de inserciones produce árboles con formas muy diferentes dependiendo de si se usa DFS o BFS para encontrar el hueco.

## Valoración `ejemplo004`

*   **Evolución desde `ejemplo003`**: El cambio más significativo ocurre en `Node.java`, que se transforma de un nodo con `MAX_CHILDREN` a un nodo con solo dos referencias: `left` y `right`. Los métodos de `Tree.java` (`insert` y `printTree`) se adaptan a esta nueva estructura binaria.
*   **Objetivo principal**: Introducir el concepto fundamental de **Árbol binario** y cómo su estructura básica influye en la implementación de las operaciones.
*   **Implementación**:
    *   `Node.java` ahora define explícitamente `left` y `right` como hijos, eliminando el array genérico.
    *   `insert()` en `Tree.java` sigue utilizando un recorrido BFS (cola) para encontrar el primer hueco disponible, pero ahora inserta en el hijo izquierdo o derecho según estén disponibles. Esto tiende a construir un árbol binario lo más completo posible.
    *   `printTree()` se ajusta para recorrer la estructura binaria, manteniendo el orden de apilamiento de `right` antes que `left` para un recorrido preorden correcto.
*   **2Think:**:
    *   **Introducción al árbol binario**: Es el primer ejemplo que define explícitamente un árbol binario, una de las estructuras más importantes.
    *   **Impacto de la estructura del nodo**: Demuestra cómo una restricción en el número de hijos (`MAX_CHILDREN = 2` implícito) simplifica y especializa la lógica de inserción y recorrido.
    *   **Construcción de árbol binario completo**: La combinación de la estructura binaria y la inserción BFS resulta en un árbol que se llena por niveles, lo que es una característica clave de los árboles binarios completos.
    *   **Adaptación de algoritmos iterativos**: Muestra cómo los algoritmos de recorrido (BFS para inserción, DFS para impresión) se adaptan a la nueva estructura binaria, reforzando la comprensión de estos patrones.
    *   **Base para BSTs**: Este ejemplo es el precursor directo de los árboles binarios de Búsqueda (BST), ya que establece la estructura binaria sobre la cual se aplicarán las reglas de ordenación.

## Valoración `ejemplo005`

*   **Evolución desde `ejemplo004`**: El método `insert()` en `Tree.java` es completamente reescrito para implementar la lógica de inserción de un árbol binario de Búsqueda (BST). `Node.java` elimina el método `hasSpace()` ya que la disponibilidad de espacio se determina por la lógica de ordenación.
*   **Objetivo principal**: Introducir el concepto de **Árbol binario de Búsqueda (BST)**, donde la posición de un nodo depende de su valor, y cómo implementar su inserción de forma iterativa.
*   **Implementación**:
    *   La inserción ya no utiliza un recorrido BFS (cola), sino un recorrido iterativo que compara la clave a insertar con la clave del nodo actual para decidir si ir a la izquierda o a la derecha.
    *   Si se llega a un punto donde el hijo necesario (izquierdo o derecho) es `null`, se inserta el nuevo nodo allí.
    *   Los valores duplicados (`key == current.getKey()`) son ignorados en esta implementación.
*   **2Think:**:
    *   **Introducción al ordenamiento en árboles**: Es el primer ejemplo que introduce una regla de ordenación fundamental (`izquierda < padre < derecha`), que es la característica definitoria de un BST.
    *   **Algoritmo de inserción iterativo para BST**: La implementación iterativa de la inserción es muy clara y didáctica. Guía al estudiante a través del proceso de búsqueda del lugar correcto para el nuevo nodo, reforzando la lógica de comparación y navegación.
    *   **Decisión sobre duplicados**: La forma en que se manejan los duplicados (ignorándolos) es una decisión de diseño simple que puede servir como punto de partida para discutir otras estrategias (permitirlos, contarlos, etc.).
    *   **Base para búsqueda y eliminación**: La lógica de recorrido establecida en este `insert()` es la misma que se utilizará para implementar las operaciones de búsqueda y eliminación en un BST, lo que proporciona una base sólida para los siguientes pasos.
    *   **Eficiencia conceptual**: Aunque no se cuantifica, el estudiante puede empezar a apreciar cómo la propiedad de ordenación puede hacer que la búsqueda de un elemento sea más eficiente que en un árbol binario genérico.

## Valoración `ejemplo006`

*   **Evolución desde `ejemplo005`**: Se eliminó el método `printTree()` y se introdujeron tres nuevos métodos en `Tree.java`: `printPreorder()`, `printInorder()`, y `printPostorder()`. `TreeSample.java` se actualiza para llamar a estos nuevos métodos.
*   **Objetivo principal**: Introducir los tres recorridos canónicos de un árbol binario (preorden, inorden, postorden) y demostrar sus implementaciones iterativas.
*   **Implementación**:
    *   `insert()` permanece sin cambios, manteniendo la lógica de inserción de BST.
    *   `printPreorder()`: Implementa el recorrido preorden (raíz, izquierda, derecha) de forma iterativa usando una pila.
    *   `printInorder()`: Implementa el recorrido inorden (izquierda, raíz, derecha) de forma iterativa usando una pila. Este recorrido es particularmente importante para BSTs, ya que produce las claves en orden ascendente.
    *   `printPostorder()`: Implementa el recorrido postorden (izquierda, derecha, raíz) de forma iterativa usando una pila y un nodo `lastVisited` para gestionar la lógica de visita. Este es el más complejo de los tres recorridos iterativos.
*   **2Think:**:
    *   **Conceptos fundamentales de recorrido**: Presenta los algoritmos esenciales para acceder a todos los nodos de un árbol.
    *   **Dominio de la pila para recorridos iterativos**: Cada método es un ejercicio avanzado en el uso de la pila para simular la recursividad, reforzando la comprensión del comportamiento LIFO y la gestión explícita del estado.
    *   **Significado de cada recorrido**: Permite al estudiante observar la salida de cada recorrido y comprender su propósito:
        *   Inorden: Ordenación de las claves en un BST.
        *   Preorden: Copia de la estructura del árbol.
        *   Postorden: Eliminación de nodos o evaluación de expresiones.
    *   **Desafío Gradualg*: La implementación iterativa del postorden es un desafío significativo que consolida la comprensión de los recorridos y el manejo de la pila.

## Valoración `ejemplo007`

*   **Evolución desde `ejemplo006`**: Se introduce el método `search(int key)` en `Tree.java` para buscar un valor en el BST. Los métodos de recorrido específicos (`printPreorder`, `printInorder`, `printPostorder`) de `ejemplo006` son reemplazados por el `printTree()` de `ejemplo005` (preorden con indentación). `TreeSample.java` se actualiza para incluir un bucle interactivo de búsqueda.
*   **Objetivo principal**: Demostrar la operación de búsqueda en un árbol binario de Búsqueda (BST) de forma iterativa.
*   **Implementación**:
    *   `search(int key)`: Implementa la búsqueda iterativa, navegando por el árbol (izquierda o derecha) en función de la comparación de la clave buscada con la clave del nodo actual.
    *   `TreeSample.java` incluye un `searchLoop` que permite al usuario introducir valores para buscar, mostrando el resultado.
*   **2Think:**:
    *   **Operación fundamental de BST**: La búsqueda es una de las operaciones más importantes y eficientes de un BST.
    *   **Algoritmo de búsqueda iterativo**: La implementación es directa y sigue la lógica de ordenación del BST, reforzando cómo esta propiedad se utiliza para la eficiencia.
    *   **Interacción práctica**: El bucle de búsqueda interactivo permite al estudiante experimentar directamente la funcionalidad y verificar la corrección del algoritmo.
    *   **Eficiencia implícita**: El estudiante puede observar que la búsqueda no recorre todo el árbol, sino que sigue un camino dirigido, lo que la hace más rápida.
    *   **Foco en la funcionalidad**: La simplificación de los métodos de impresión puede ser una decisión consciente para mantener el foco en la nueva funcionalidad de búsqueda.

## Valoración `ejemplo008`

*   **Evolución desde `ejemplo007`**: Se introduce el método `delete(int key)` en `Tree.java` para eliminar un valor del BST. `Node.java` añade métodos auxiliares (`setKey`, `detachLeftChild`, `detachRightChild`). `TreeSample.java` se transforma en un programa interactivo con un menú completo para probar todas las operaciones del BST.
*   **Objetivo principal**: Implementar la operación de eliminación en un árbol binario de Búsqueda (BST) de forma iterativa y proporcionar una interfaz interactiva para probar todas las funcionalidades.
*   **Implementación**:
    *   `Node.java` añade `setKey()` para actualizar el valor de un nodo (necesario en el caso de eliminación de nodos con dos hijos) y `detachLeftChild()`/`detachRightChild()` para desvincular hijos.
    *   `delete(int key)`: Es la parte más compleja. Implementa los tres casos de eliminación:
        1.  **Nodo hoja**: Se elimina directamente.
        2.  **Nodo con un hijo**: El nodo se reemplaza por su único hijo.
        3.  **Nodo con dos hijos**: Se busca el sucesor inorden (el nodo más pequeño en el subárbol derecho), se copia su clave al nodo a eliminar, y luego se elimina el sucesor (que siempre será un nodo hoja o con un solo hijo derecho). Toda la lógica se maneja de forma iterativa, rastreando el nodo `parent` y la relación `isLeftChild`.
    *   `TreeSample.java` proporciona un menú interactivo que permite al usuario insertar, buscar, eliminar y mostrar el árbol, ofreciendo una experiencia de aprendizaje práctica.
*   **2Think:**:
    *   **Eliminación iterativa en BST**: La implementación iterativa de la eliminación es un punto culminante. Es una operación intrínsecamente compleja, y su desglose en casos y su manejo iterativo es una demostración excelente de control de flujo explícito.
    *   **Manejo de casos complejos**: El algoritmo de eliminación cubre todos los escenarios posibles, incluyendo la búsqueda del sucesor inorden, lo que es fundamental para mantener la propiedad del BST.
    *   **Métodos auxiliares claros**: La adición de `setKey` y `detachChild` en la clase `Node` mejora la modularidad y claridad del código de `Tree`.
    *   **Experiencia de usuario completa**: El menú interactivo en `TreeSample` es una herramienta de aprendizaje invaluable. Permite al estudiante manipular el árbol y observar los resultados de cada operación en tiempo real, lo que solidifica la comprensión de los algoritmos.
    *   **Consolidación de conocimientos**: Este ejemplo integra y consolida todos los conceptos previos: la estructura del nodo, la inserción, la búsqueda y, finalmente, la eliminación, proporcionando una visión completa de las operaciones básicas de un BST.
    *   **Preparación para temas avanzados**: Una vez que se domina la eliminación, el estudiante está listo para entender los problemas de desequilibrio en los BSTs y la necesidad de estructuras más avanzadas como los árboles AVL o Rojo-Negro.
