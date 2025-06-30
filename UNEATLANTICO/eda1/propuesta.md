# Sistema de exámenes masivos

## Propuesta de diseño general del sistema

### Entidades principales

```console
┌───────────────────┐    ┌──────────────────┐    ┌─────────────────────┐  
│ ListaPreguntas    │────│   ExamenAlumno   │────│ ListaEstudiantes    │  
│                   │    │                  │    │                     │  
│ - Lista<Pregunta> │    │ - Estudiante     │    │ - Lista<Estudiante> │  
│ - ArbolCategorias │    │ - Lista<Integer> │    │ - ArbolBusqueda     │  
└───────────────────┘    └──────────────────┘    └─────────────────────┘
```

## Estructura 1: gestión del banco de preguntas

### Pregunta individual

```java
class Pregunta {  
    int id;  
    String enunciado;  
    String[] opciones;     // Array simple de 4 opciones  
    int respuestaCorrecta; // 1-4  
    String categoria;      // "Listas", "Árboles", etc.  
    int dificultad;        // 1-5  
    String tipo;           // "correcta" o "incorrecta"  
}
```

### Banco de preguntas

**Estructura principal:** `Lista<Pregunta>` (lista enlazada simple)

```java
class BancoPregunta {  
    Lista<Pregunta> preguntas;          // Lista enlazada de todas las preguntas  
    ArbolBinario categoriasIndex;       // Árbol para organizar por categorías  
    int totalPreguntas;  
      
    // Buscar pregunta por ID - O(n)  
    Pregunta obtenerPregunta(int id) {  
        Nodo<Pregunta> actual = preguntas.getPrimero();  
        while (actual != null) {  
            if (actual.getDato().id == id) {  
                return actual.getDato();  
            }  
            actual = actual.getSiguiente();  
        }  
        return null;  
    }  
      
    // Obtener preguntas de una categoría - O(n)  
    Lista<Pregunta> obtenerPorCategoria(String categoria) {  
        Lista<Pregunta> resultado = new Lista<>();  
        Nodo<Pregunta> actual = preguntas.getPrimero();  
        while (actual != null) {  
            if (actual.getDato().categoria.equals(categoria)) {  
                resultado.insertarFinal(actual.getDato());  
            }  
            actual = actual.getSiguiente();  
        }  
        return resultado;  
    }  
}
```

### Organización por categorías

**Estructura:** Árbol binario de búsqueda para categorías

```java
class NodoCategoria {  
    String nombreCategoria;  
    Lista<Integer> idsPreguntas;    // Lista de IDs de preguntas de esta categoría  
    NodoCategoria izquierdo;  
    NodoCategoria derecho;  
}

class ArbolCategorias {  
    NodoCategoria raiz;  
      
    // Insertar categoría - O(log n) promedio  
    void insertarCategoria(String categoria, int idPregunta);  
      
    // Buscar preguntas de categoría - O(log n) + O(k)  
    Lista<Integer> buscarCategoria(String categoria);  
}
```

## Estructura 2: gestión de estudiantes

### Estudiante individual

```java
class Estudiante {  
    String id;  
    String nombre;  
    String seccion;  
}
```

### Lista de estudiantes - con búsqueda

**Estructura:** Lista enlazada + Árbol binario de búsqueda para índices

```java
class GestorEstudiantes {  
    Lista<Estudiante> estudiantes;         // Lista enlazada principal  
    ArbolBusqueda indiceIds;              // Árbol BST para búsqueda rápida por ID  
    Lista<Lista<Estudiante>> secciones;   // Lista de listas, una por sección  
      
    // Buscar estudiante - O(log n) usando árbol  
    Estudiante buscarPorId(String id) {  
        // Usar el árbol BST para encontrar el índice  
        int posicion = indiceIds.buscar(id);  
        if (posicion != -1) {  
            return obtenerEnPosicion(posicion);  
        }  
        return null;  
    }  
      
    // Obtener estudiante en posición específica - O(n)  
    Estudiante obtenerEnPosicion(int posicion) {  
        Nodo<Estudiante> actual = estudiantes.getPrimero();  
        for (int i = 0; i < posicion && actual != null; i++) {  
            actual = actual.getSiguiente();  
        }  
        return actual != null ? actual.getDato() : null;  
    }  
}
```

## Estructura 3: algoritmo de distribución

### Distribuidor circular con cola

**Estructura:** Cola circular para distribución sistemática

```java
class DistribuidorSistematico {  
    Cola<Integer> colaPreguntas;    // Cola circular de IDs de preguntas  
    int preguntasPorExamen;  
    int totalPreguntas;  
      
    // Inicializar la cola con todas las preguntas  
    void inicializar(int totalPreguntas) {  
        colaPreguntas = new Cola<>();  
        for (int i = 1; i <= totalPreguntas; i++) {  
            colaPreguntas.encolar(i);  
        }  
    }  
      
    // Generar examen para un estudiante  
    Lista<Integer> generarExamen() {  
        Lista<Integer> preguntasExamen = new Lista<>();  
          
        for (int i = 0; i < preguntasPorExamen; i++) {  
            // Sacar pregunta de la cola  
            int preguntaId = colaPreguntas.desencolar();  
            preguntasExamen.insertarFinal(preguntaId);  
              
            // Volver a encolar para mantener la distribución circular  
            colaPreguntas.encolar(preguntaId);  
        }  
        return preguntasExamen;  
    }  
}
```

### Distribuidor con balance temático

**Estructura:** Pilas

```java
class DistribuidorBalanceado {  
    Pila<Integer> pilaListas;  
    Pila<Integer> pilaArboles;  
    Pila<Integer> pilaGrafos;  
      
    Lista<Integer> generarExamenBalanceado(int preguntasListas, int preguntasArboles, int preguntasGrafos) {  
        Lista<Integer> examen = new Lista<>();  
          
        // Tomar preguntas de cada pila según la distribución deseada  
        for (int i = 0; i < preguntasListas; i++) {  
            if (!pilaListas.estaVacia()) {  
                examen.insertarFinal(pilaListas.pop());  
            }  
        }  
          
        // Similar para árboles y grafos...  
          
        return examen;  
    }  
}
```

## Estructura 4: Trazabilidad con grafo

**Estructura:** grafo

**Nodos:** Estudiantes y Preguntas  
	**Aristas:** "Estudiante X recibió Pregunta Y"

```java
class NodoGrafo {  
    String id;                    // ID del estudiante o pregunta  
    String tipo;                  // "ESTUDIANTE" o "PREGUNTA"  
    Lista<NodoGrafo> conexiones;  // Lista de nodos conectados  
}

class GrafoTrazabilidad {  
    Lista<NodoGrafo> nodos;       // Todos los nodos del grafo  
      
    // Registrar que un estudiante recibió una pregunta  
    void registrarAsignacion(String estudianteId, int preguntaId) {  
        NodoGrafo nodoEstudiante = buscarNodo(estudianteId, "ESTUDIANTE");  
        NodoGrafo nodoPregunta = buscarNodo(String.valueOf(preguntaId), "PREGUNTA");  
          
        // Crear conexión bidireccional  
        nodoEstudiante.conexiones.insertarFinal(nodoPregunta);  
        nodoPregunta.conexiones.insertarFinal(nodoEstudiante);  
    }  
      
    // Encontrar qué estudiantes tuvieron una pregunta específica  
    Lista<String> quienTuvoPregunta(int preguntaId) {  
        NodoGrafo nodoPregunta = buscarNodo(String.valueOf(preguntaId), "PREGUNTA");  
        Lista<String> estudiantes = new Lista<>();  
          
        if (nodoPregunta != null) {  
            Nodo<NodoGrafo> actual = nodoPregunta.conexiones.getPrimero();  
            while (actual != null) {  
                if (actual.getDato().tipo.equals("ESTUDIANTE")) {  
                    estudiantes.insertarFinal(actual.getDato().id);  
                }  
                actual = actual.getSiguiente();  
            }  
        }  
        return estudiantes;  
    }  
      
    // Encontrar qué preguntas tuvo un estudiante  
    Lista<Integer> preguntasDeEstudiante(String estudianteId) {  
        NodoGrafo nodoEstudiante = buscarNodo(estudianteId, "ESTUDIANTE");  
        Lista<Integer> preguntas = new Lista<>();  
          
        if (nodoEstudiante != null) {  
            Nodo<NodoGrafo> actual = nodoEstudiante.conexiones.getPrimero();  
            while (actual != null) {  
                if (actual.getDato().tipo.equals("PREGUNTA")) {  
                    preguntas.insertarFinal(Integer.parseInt(actual.getDato().id));  
                }  
                actual = actual.getSiguiente();  
            }  
        }  
        return preguntas;  
    }  
}
```

## Estructura 5: generación de exámenes

### Examen individual

**Estructura:** Lista

```java
class ExamenAlumno {  
    Estudiante estudiante;  
    Lista<Integer> preguntasAsignadas;  // Lista de IDs de preguntas  
      
    // Generar clave de respuestas  
    Lista<Integer> generarClaveRespuestas(BancoPregunta banco) {  
        Lista<Integer> respuestas = new Lista<>();  
        Nodo<Integer> actual = preguntasAsignadas.getPrimero();  
          
        while (actual != null) {  
            Pregunta pregunta = banco.obtenerPregunta(actual.getDato());  
            if (pregunta != null) {  
                respuestas.insertarFinal(pregunta.respuestaCorrecta);  
            }  
            actual = actual.getSiguiente();  
        }  
        return respuestas;  
    }  
}
```

### Generador principal

```java
class GeneradorExamenes {  
    BancoPregunta banco;  
    GestorEstudiantes estudiantes;  
    DistribuidorSistematico distribuidor;  
    GrafoTrazabilidad trazabilidad;  
    Cola<ExamenAlumno> examenesGenerados;  // Cola de exámenes listos  
      
    void generarExamenesParaTodos() {  
        Nodo<Estudiante> actual = estudiantes.estudiantes.getPrimero();  
          
        while (actual != null) {  
            // Generar examen para este estudiante  
            Lista<Integer> preguntas = distribuidor.generarExamen();  
              
            ExamenAlumno examen = new ExamenAlumno();  
            examen.estudiante = actual.getDato();  
            examen.preguntasAsignadas = preguntas;  
              
            // Registrar en trazabilidad  
            Nodo<Integer> preguntaActual = preguntas.getPrimero();  
            while (preguntaActual != null) {  
                trazabilidad.registrarAsignacion(  
                    examen.estudiante.id,   
                    preguntaActual.getDato()  
                );  
                preguntaActual = preguntaActual.getSiguiente();  
            }  
              
            // Encolar examen generado  
            examenesGenerados.encolar(examen);  
            actual = actual.getSiguiente();  
        }  
    }  
}
```

## Análisis

### Ventajas vs desventajas

#### Ventajas

- **Comprensible:** Algoritmos claros y directos  
- **Flexible:** Fácil modificar y extender  
- **Educativo:** Muestra aplicación real de todas las estructuras

#### Desventajas

- **Menos eficiente:** Algunas operaciones son O(n) en lugar de O(1)  
- **Más memoria:** Estructuras auxiliares para acelerar búsquedas  
- **Complejidad:** Más código para la misma funcionalidad

## Arquitectura final EDA1

```console
┌─────────────────────────────────────────────────────────┐  
│                 SISTEMA DE EXÁMENES EDA1                │  
├─────────────────────────────────────────────────────────┤  
│  BancoPregunta  │  GestorEstudiantes  │  Distribuidor   │  
│  - Lista<>      │  - Lista<>          │  - Cola<>       │  
│  - ArbolBST     │  - ArbolBST         │  - Pila<>       │  
│  (categorías)   │  (búsqueda)         │  (balance)      │  
├─────────────────────────────────────────────────────────┤  
│              GrafoTrazabilidad                          │  
│              - Lista<NodoGrafo>                         │  
│              - Conexiones bidireccionales               │  
└─────────────────────────────────────────────────────────┘
```

### Uso de estructuras de EDA1:

- **Listas:** Almacenamiento principal y recorridos  
- **Pilas:** Balance temático y gestión de pools  
- **Colas:** Distribución circular sistemática  
- **Árboles:** Búsqueda e indexación por categorías/IDs  
- **Grafos:** Trazabilidad de relaciones estudiante-pregunta
