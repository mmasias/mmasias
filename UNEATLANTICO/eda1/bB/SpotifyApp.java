import java.util.Scanner;

public class SpotifyApp {
    private static Scanner scanner = new Scanner(System.in);
    private static ListaCanciones biblioteca = new ListaCanciones();
    private static ListaCanciones favoritos = new ListaCanciones();
    private static ColaReproduccion colaReproduccion = new ColaReproduccion();
    private static PilaHistorial historial = new PilaHistorial();
    private static ListaPlaylists playlists = new ListaPlaylists();
    private static boolean modoAleatorio = false;
    private static boolean modoRepeticion = false;
    private static Cancion cancionActual = null;

    public static void main(String[] args) {
        inicializarBiblioteca();

        int opcionPrincipal;
        do {
            mostrarBibliotecaInicial();
            System.out.println("\n=== MENÚ PRINCIPAL ===");
            System.out.println("1. Reproducción");
            System.out.println("2. Biblioteca");
            System.out.println("3. Salir");
            System.out.print("Seleccione una opción: ");
            opcionPrincipal = scanner.nextInt();
            scanner.nextLine(); 

            switch (opcionPrincipal) {
                case 1:
                    menuReproduccion();
                    break;
                case 2:
                    menuBiblioteca();
                    break;
                case 3:
                    System.out.println("Saliendo...");
                    break;
                default:
                    System.out.println("Opción no válida.");
            }
        } while (opcionPrincipal != 3);
    }
    
    private static void mostrarBibliotecaInicial() {
        System.out.println("\n=== BIBLIOTECA INICIAL ===");
        biblioteca.mostrarCanciones();
    }
    

    private static void inicializarBiblioteca() {
        biblioteca.agregarCancion(new Cancion("Smell like teen spirit", "Nirvana", 290));
        biblioteca.agregarCancion(new Cancion("Vivo", "Gustavo Cerati", 283));
        biblioteca.agregarCancion(new Cancion("Disco Eterno", "Soda Stereo", 432));
        biblioteca.agregarCancion(new Cancion("Promesas sobre el bidet", "Charly García", 476));
        biblioteca.agregarCancion(new Cancion("Cuando Pase el Temblor", "Soda Stereo", 232));
        biblioteca.agregarCancion(new Cancion("Hombre Lobo en París", "La Unión", 278));
        biblioteca.agregarCancion(new Cancion("¿Qué ves?", "Divididos", 365));
        biblioteca.agregarCancion(new Cancion("Smooth Operator", "Sade", 543));
        biblioteca.agregarCancion(new Cancion("Camaleón", "Soda Stereo", 325));
        biblioteca.agregarCancion(new Cancion("Luna", "Smashing Pumpkins", 450));
    }

    private static void menuBiblioteca() {
        int opcionBiblioteca;
        do {
            System.out.println("\n=== MENÚ BIBLIOTECA ===");
            System.out.println("1. Añadir canción a favoritos");
            System.out.println("2. Eliminar canción de favoritos");
            System.out.println("3. Ver canciones favoritas");
            System.out.println("4. Crear nueva playlist");
            System.out.println("5. Añadir canción a playlist");
            System.out.println("6. Eliminar canción de playlist");
            System.out.println("7. Ver playlists");
            System.out.println("8. Ver canciones de una playlist");
            System.out.println("9. Volver al menú principal");
            System.out.print("Seleccione una opción: ");
            opcionBiblioteca = scanner.nextInt();
            scanner.nextLine(); // Limpiar buffer

            switch (opcionBiblioteca) {
                case 1:
                    añadirCancionAFavoritos();
                    break;
                case 2:
                    eliminarCancionDeFavoritos();
                    break;
                case 3:
                    verCancionesFavoritas();
                    break;
                case 4:
                    crearPlaylist();
                    break;
                case 5:
                    añadirCancionAPlaylist();
                    break;
                case 6:
                    eliminarCancionDePlaylist();
                    break;
                case 7:
                    verPlaylists();
                    break;
                case 8:
                    verCancionesDePlaylist();
                    break;
                case 9:
                    System.out.println("Volviendo al menú principal...");
                    break;
                default:
                    System.out.println("Opción no válida.");
            }
        } while (opcionBiblioteca != 9);
    }

    private static void añadirCancionAFavoritos() {
        System.out.println("Canciones en la biblioteca:");
        biblioteca.mostrarCanciones();
        System.out.print("Seleccione la canción para añadir a favoritos: ");
        int cancionIndex = scanner.nextInt() - 1;
        scanner.nextLine();
        NodoCancion nodo = biblioteca.getNodo(cancionIndex);
        if (nodo != null) {
            favoritos.agregarCancion(nodo.cancion);
            System.out.println("Canción añadida a favoritos.");
        } else {
            System.out.println("Selección inválida.");
        }
    }

    private static void eliminarCancionDeFavoritos() {
        System.out.println("Canciones favoritas:");
        favoritos.mostrarCanciones();
        System.out.print("Seleccione la canción para eliminar de favoritos: ");
        int cancionIndex = scanner.nextInt() - 1;
        scanner.nextLine();
        NodoCancion nodo = favoritos.getNodo(cancionIndex);
        if (nodo != null) {
            favoritos.eliminarCancion(nodo.cancion.getTitulo());
            System.out.println("Canción eliminada de favoritos.");
        } else {
            System.out.println("Selección inválida.");
        }
    }

    private static void verCancionesFavoritas() {
        System.out.println("Canciones favoritas:");
        favoritos.mostrarCanciones();
    }

    private static void crearPlaylist() {
        System.out.print("Nombre de la nueva playlist: ");
        String nombrePlaylist = scanner.nextLine();
        Playlist nuevaPlaylist = new Playlist(nombrePlaylist);
        playlists.agregarPlaylist(nuevaPlaylist);
        System.out.println("Playlist \"" + nombrePlaylist + "\" creada con éxito.");
    }

    private static void añadirCancionAPlaylist() {
        if (playlists.getTamaño() == 0) {
            System.out.println("No hay playlists disponibles. Cree una playlist primero.");
            return;
        }

        System.out.println("Playlists disponibles:");
        playlists.mostrarPlaylists();

        System.out.print("Seleccione playlist: ");
        int playlistIndex = scanner.nextInt() - 1;
        scanner.nextLine();

        Playlist selectedPlaylist = playlists.obtenerPlaylist(playlistIndex);
        if (selectedPlaylist == null) {
            System.out.println("Playlist no válida.");
            return;
        }

        System.out.println("Canciones disponibles:");
        biblioteca.mostrarCanciones();
        System.out.print("Seleccione canción a añadir: ");
        int cancionIndex = scanner.nextInt() - 1;
        scanner.nextLine();

        NodoCancion nodo = biblioteca.getNodo(cancionIndex);
        if (nodo != null) {
            selectedPlaylist.agregarCancion(nodo.cancion);
        } else {
            System.out.println("Canción no válida.");
        }
    }

    private static void eliminarCancionDePlaylist() {
        if (playlists.getTamaño() == 0) {
            System.out.println("No hay playlists disponibles.");
            return;
        }

        System.out.println("Playlists disponibles:");
        playlists.mostrarPlaylists();

        System.out.print("Seleccione playlist: ");
        int playlistIndex = scanner.nextInt() - 1;
        scanner.nextLine();

        Playlist selectedPlaylist = playlists.obtenerPlaylist(playlistIndex);
        if (selectedPlaylist == null) {
            System.out.println("Playlist no válida.");
            return;
        }

        selectedPlaylist.mostrarCanciones();
        System.out.print("Seleccione canción a eliminar: ");
        int cancionIndex = scanner.nextInt() - 1;
        scanner.nextLine();

        NodoCancion nodo = biblioteca.getNodo(cancionIndex);
        if (nodo != null) {
            selectedPlaylist.eliminarCancion(nodo.cancion.getTitulo());
        } else {
            System.out.println("Canción no válida.");
        }
    }

    private static void verPlaylists() {
        playlists.mostrarPlaylists();
    }

    private static void verCancionesDePlaylist() {
        if (playlists.getTamaño() == 0) {
            System.out.println("No hay playlists disponibles.");
            return;
        }

        System.out.println("Playlists disponibles:");
        playlists.mostrarPlaylists();

        System.out.print("Seleccione playlist: ");
        int playlistIndex = scanner.nextInt() - 1;
        scanner.nextLine();

        Playlist selectedPlaylist = playlists.obtenerPlaylist(playlistIndex);
        if (selectedPlaylist != null) {
            selectedPlaylist.mostrarCanciones();
        } else {
            System.out.println("Playlist no válida.");
        }
    }

    private static void menuReproduccion() {
        int opcionReproduccion;
        do {
            System.out.println("\n=== MENÚ REPRODUCCIÓN ===");
            System.out.println("1. Ver canción actual");
            System.out.println("2. Reproducir siguiente");
            System.out.println("3. Reproducir anterior");
            System.out.println("4. Ver cola de reproducción");
            System.out.println("5. Ver historial");
            System.out.println("6. Activar/desactivar aleatorio");
            System.out.println("7. Activar/desactivar repetición");
            System.out.println("8. Añadir canciones a la cola de reproducción");
            System.out.println("9. Volver al menú principal");
            System.out.print("Seleccione una opción: ");
            opcionReproduccion = scanner.nextInt();
            scanner.nextLine(); // Limpiar buffer
    
            switch (opcionReproduccion) {
                case 1:
                    verCancionActual();
                    break;
                case 2:
                    reproducirSiguiente();
                    break;
                case 3:
                    reproducirAnterior();
                    break;
                case 4:
                    verColaReproduccion();
                    break;
                case 5:
                    verHistorial();
                    break;
                case 6:
                    activarDesactivarAleatorio();
                    break;
                case 7:
                    activarDesactivarRepeticion();
                    break;
                case 8:
                    añadirCancionesACola();
                    break;
                case 9:
                    System.out.println("Volviendo al menú principal...");
                    break;
                default:
                    System.out.println("Opción no válida.");
            }
        } while (opcionReproduccion != 9);
    }

    private static void verCancionActual() {
        if (cancionActual == null) {
            System.out.println("No hay canción en reproducción.");
            System.out.print("¿Desea comenzar a reproducir? (S/N): ");
            String respuesta = scanner.nextLine().trim().toUpperCase();
            if (respuesta.equals("S")) {
                iniciarReproduccion();
            }
        } else {
            System.out.println("▶ Reproduciendo: " + cancionActual);
        }
    }
    
    private static void iniciarReproduccion() {
        System.out.println("Seleccione una canción para reproducir:");
        biblioteca.mostrarCanciones();
        System.out.print("Seleccione canción (1-" + biblioteca.getTamaño() + "): ");
        int index = scanner.nextInt() - 1;
        scanner.nextLine();
        NodoCancion nodo = biblioteca.getNodo(index);
        if (nodo != null) {
            cancionActual = nodo.cancion;
            colaReproduccion.encolar(cancionActual);
            System.out.println("▶ Reproduciendo: " + cancionActual);
        } else {
            System.out.println("Selección inválida.");
        }
    }

    private static void reproducirSiguiente() {
        if (modoRepeticion && cancionActual != null) {
            System.out.println("▶ Reproduciendo de nuevo: " + cancionActual);
        } else {
            cancionActual = colaReproduccion.desencolar();
            if (cancionActual != null) {
                historial.apilar(cancionActual);
                System.out.println("▶ Reproduciendo: " + cancionActual);
            } else {
                System.out.println("No hay más canciones en la cola.");
            }
        }
    }
    
    private static void reproducirAnterior() {
        Cancion anterior = historial.desapilar();
        if (anterior != null) {
            cancionActual = anterior;
            colaReproduccion.encolar(cancionActual);
            System.out.println("▶ Reproduciendo: " + cancionActual);
        } else {
            System.out.println("No hay canciones anteriores en el historial.");
        }
    }
    
    private static void verColaReproduccion() {
        System.out.println("COLA DE REPRODUCCIÓN:");
        colaReproduccion.mostrarCola(cancionActual);  // Pasar cancionActual como parámetro
        System.out.println("Estado: Reproducción normal | Repetición: " + (modoRepeticion ? "ON" : "OFF") + " | Aleatorio: " + (modoAleatorio ? "ON" : "OFF"));
    }
    
    private static void verHistorial() {
        System.out.println("HISTORIAL DE REPRODUCCIÓN:");
        historial.mostrarHistorial();
    }
    
    private static void activarDesactivarAleatorio() {
        modoAleatorio = !modoAleatorio;
        System.out.println("Modo aleatorio: " + (modoAleatorio ? "Activado" : "Desactivado"));
    }
                    
    private static void activarDesactivarRepeticion() {
        modoRepeticion = !modoRepeticion;
        System.out.println("Modo repetición: " + (modoRepeticion ? "Activado" : "Desactivado"));
    }
    
    private static void añadirCancionesACola() {
        System.out.println("Canciones en la biblioteca:");
        biblioteca.mostrarCanciones();
    
        while (true) {
            System.out.print("Seleccione una canción para añadir a la cola (1-" + biblioteca.getTamaño() + ", o 0 para finalizar): ");
            int index = scanner.nextInt() - 1;
            scanner.nextLine();
    
            if (index == -1) {
                // Salir del bucle si el usuario elige 0
                System.out.println("Finalizando adición a la cola de reproducción.");
                break;
            }
    
            NodoCancion nodo = biblioteca.getNodo(index);
            if (nodo != null) {
                colaReproduccion.encolar(nodo.cancion);
                System.out.println("Canción añadida a la cola: " + nodo.cancion);
            } else {
                System.out.println("Selección inválida.");
            }
        }
    }    
}