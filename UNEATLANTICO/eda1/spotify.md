# Spotify

## Introducción

Se requiere implementar un sistema de reproducción de música similar a Spotify, utilizando las estructuras de datos básicas estudiadas en clase (listas enlazadas, listas doblemente enlazadas, listas circulares, pilas y colas). 

El sistema debe gestionar tanto la reproducción de música como la organización de la biblioteca musical del usuario.

## Clases base

Se proporcionan *fragmentos significativos* de las siguientes clases base:

```java
class Cancion {
    private String titulo;
    private String artista;
    private int duracion;    
    private boolean favorita;
    
    public Cancion(String titulo, String artista, int duracion) {
        this.titulo = titulo;
        this.artista = artista;
        this.duracion = duracion;
        this.favorita = false;
    }    

    public String toString()
}

class Album {
    private String titulo;
    private String artista;
    private int año;
    
    public Album(String titulo, String artista, int año) {
        this.titulo = titulo;
        this.artista = artista;
        this.año = año;
    }

    public String toString()
}
```

## Requisitos

### Sistema de reproducción

El sistema debe implementar:

- Cola de reproducción actual.
- Historial de reproducción.
- Controles básicos:
  - Reproducir canción.
  - Siguiente canción.
  - Canción anterior.
- Modos especiales:
  - Reproducción aleatoria (shuffle).
  - Repetición (repeat).

### Biblioteca

El sistema debe permitir:

- Gestionar canciones favoritas (añadir/eliminar).
- Crear y gestionar playlists.
- Visualizar biblioteca personal.

### Operaciones

El programa debe implementar el siguiente menú de opciones:

1. Reproducción.
   - Ver canción actual.
   - Reproducir siguiente.
   - Reproducir anterior.
   - Ver cola de reproducción.
   - Ver historial de reproducción.
   - Activar/desactivar modo aleatorio.
   - Activar/desactivar repetición.
1. Biblioteca.
   - Añadir canción a favoritos.
   - Eliminar canción de favoritos.
   - Ver canciones favoritas.
   - Crear nueva playlist.
   - Añadir canción a playlist.
   - Eliminar canción de playlist.
   - Ver playlists.
   - Ver canciones de una playlist.

## Restricciones (o no...)

1. Se deben utilizar ÚNICAMENTE las estructuras de datos implementadas en clase:
   - Listas enlazadas, doblemente enlazadas y circulares.
   - Pilas.
   - Colas.
1. No está permitido el uso de:
   - Colecciones de Java (ArrayList, LinkedList, etc.).
   - Estructuras de datos de la biblioteca estándar.
1. La entrada/salida debe ser por consola.

## Opcional

Implementar funcionalidades sociales:

- Compartir playlists
- Seguir playlists de otros usuarios
- Ver playlists compartidas

### Propuesta de interfaz

```console
=== SPOTIFY  ===

BIBLIOTECA INICIAL

Canciones disponibles:

1. Demoliendo Hoteles - Charly García (258s)
2. Los Dinosaurios - Charly García (234s)
3. Rasguña Las Piedras - Sui Generis (285s)
4. Canción Para Mi Muerte - Sui Generis (342s)
5. No Soy Un Extraño - Charly García (295s)
6. Seminare - Serú Girán (238s)
7. Promesas Sobre El Bidet - Charly García (243s)
8. Rezo Por Vos - Charly García & Luis Alberto Spinetta (266s)
9. Película sordomuda - Charly García (235s)
10. ¿Qué se puede hacer salvo ver películas? - La máquina de hacer pájaros (325s)

=== MENÚ PRINCIPAL ===
1. Reproducción
2. Biblioteca
3. Salir

Seleccione una opción: 2

=== MENÚ BIBLIOTECA ===
1. Añadir canción a favoritos
2. Eliminar canción de favoritos
3. Ver canciones favoritas
4. Crear nueva playlist
5. Añadir canción a playlist
6. Eliminar canción de playlist
7. Ver playlists
8. Ver canciones de una playlist
9. Volver al menú principal

Seleccione una opción: 4

Nombre de la nueva playlist: Serú Greatest Hits
Playlist "Serú Greatest Hits" creada con éxito.

=== MENÚ BIBLIOTECA ===
[... menú se repite ...]

Seleccione una opción: 5

Playlists disponibles:
1. Serú Greatest Hits

Seleccione playlist: 1

Canciones disponibles:
1. Demoliendo Hoteles - Charly García (258s)
2. Los Dinosaurios - Charly García (234s)
3. Rasguña Las Piedras - Sui Generis (285s)
4. Canción Para Mi Muerte - Sui Generis (342s)
5. No Soy Un Extraño - Charly García (295s)
6. Seminare - Serú Girán (238s)
7. Promesas Sobre El Bidet - Charly García (243s)
8. Rezo Por Vos - Charly García & Luis Alberto Spinetta (266s)
9. Película sordomuda - Charly García (235s)
10. ¿Qué se puede hacer salvo ver películas? - La máquina de hacer pájaros (325s)

Seleccione canción a añadir: 6
"Seminare" añadida a Serú Greatest Hits

¿Desea añadir otra canción? (S/N): S

Seleccione canción a añadir: 6
"Película sordomuda" añadida a Serú Greatest Hits

¿Desea añadir otra canción? (S/N): N

=== MENÚ PRINCIPAL ===
1. Reproducción
2. Biblioteca
3. Salir

Seleccione una opción: 1

=== MENÚ REPRODUCCIÓN ===
1. Ver canción actual
2. Reproducir siguiente
3. Reproducir anterior
4. Ver cola de reproducción
5. Ver historial
6. Activar/desactivar aleatorio
7. Activar/desactivar repetición
8. Volver al menú principal

Seleccione una opción: 1

No hay canción en reproducción. 
¿Desea comenzar a reproducir? (S/N): S

Seleccione canción (1-8): 2

▶ Reproduciendo: Los Dinosaurios - Charly García [234s]
   "Los amigos del barrio pueden desaparecer..."

=== MENÚ REPRODUCCIÓN ===
[... menú se repite ...]

Seleccione una opción: 4

COLA DE REPRODUCCIÓN:
1. ▶ Los Dinosaurios - Charly García [234s] (ACTUAL)
2. Rasguña Las Piedras - Sui Generis [185s]
3. Canción Para Mi Muerte - Sui Generis [342s]

Estado: Reproducción normal | Repetición: OFF | Aleatorio: OFF

=== MENÚ REPRODUCCIÓN ===
[... menú se repite ...]
```
