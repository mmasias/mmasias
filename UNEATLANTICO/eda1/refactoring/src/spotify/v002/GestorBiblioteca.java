import java.util.Scanner;

public class GestorBiblioteca {
    private BibliotecaMusical biblioteca;

    public GestorBiblioteca(BibliotecaMusical biblioteca) {
        this.biblioteca = biblioteca;
    }

    public void gestionarMenuBiblioteca(Scanner sc) {
        boolean enBiblioteca = true;
        while (enBiblioteca) {
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
            System.out.println("\nSeleccione una opción:");
            int eleccionMenuBiblioteca = sc.nextInt();
            switch (eleccionMenuBiblioteca) {
                case 1:
                    gestionarAñadirFavoritos(sc);
                    break;
                case 2:
                    gestionarEliminarFavoritos(sc);
                    break;
                case 3:
                    mostrarFavoritos();
                    break;
                case 4:
                    gestionarCrearPlaylist(sc);
                    break;
                case 5:
                    gestionarAñadirCancionAPlaylist(sc);
                    break;
                case 6:
                    gestionarEliminarCancionDePlaylist(sc);
                    break;
                case 7:
                    mostrarPlaylists();
                    break;
                case 8:
                    mostrarCancionesPlaylist(sc);
                    break;
                case 9:
                    enBiblioteca = false;
                    break;
                default:
                    System.out.println("Elección inválida, intente de nuevo");
            }
        }
    }

    private void gestionarAñadirFavoritos(Scanner sc) {
        System.out.println("\nSeleccione la cancion que desea añadir a favoritos (1-10):");
        int idCancion = sc.nextInt();
        Cancion cancion = biblioteca.getCancionPorId(idCancion);
        if (cancion != null) {
            if (cancion.esFavorita()) {
                System.out.println("Ya tienes esta cancion en favoritos.");
            } else {
                cancion.setFavorita();
            }
        }
    }

    private void gestionarEliminarFavoritos(Scanner sc) {
        System.out.println("\nSeleccione la cancion que desea eliminar de favoritos (1-10):");
        int idCancion = sc.nextInt();
        Cancion cancion = biblioteca.getCancionPorId(idCancion);
        if (cancion != null) {
            if (!cancion.esFavorita()) {
                System.out.println("Esta cancion no la tienes en favoritos.");
            } else {
                cancion.unsetFavorita();
            }
        }
    }

    private void mostrarFavoritos() {
        for (Cancion cancion : biblioteca.getCancionesDisponibles()) {
            if (cancion.esFavorita()) {
                System.out.println(cancion.toString());
            }
        }
    }

    private void gestionarCrearPlaylist(Scanner sc) {
        System.out.println("Nombre de la nueva playlist: ");
        sc.nextLine();
        String nombreNuevaPlaylist = sc.nextLine();
        biblioteca.crearPlaylist(nombreNuevaPlaylist);
        System.out.println("Playlist creada con exito.");
    }

    private void gestionarAñadirCancionAPlaylist(Scanner sc) {
        mostrarPlaylists();
        if (biblioteca.tienePlaylist()) {
            System.out.println("\nSeleccione una playlist");
            int playlistID = sc.nextInt();
            System.out.println("Canciones disponibles: \n");
            for (Cancion cancion : biblioteca.getCancionesDisponibles()) {
                System.out.println(cancion.toString());
            }
            System.out.println("\nSeleccione canción a añadir: ");
            int idCancion = sc.nextInt();
            Cancion cancion = biblioteca.getCancionPorId(idCancion);
            if (cancion != null) {
                biblioteca.añadirCancionAPlaylist(playlistID, cancion);
            }
        }
    }

    private void gestionarEliminarCancionDePlaylist(Scanner sc) {
        mostrarPlaylists();
        if (biblioteca.tienePlaylist()) {
            System.out.println("\nSeleccione una playlist");
            int playlistID = sc.nextInt();
            NodoPlaylist playlist = biblioteca.getPlaylist(playlistID);
            if (playlist != null) {
                System.out.println("Canciones en la playlist:\n");
                System.out.println(playlist.mostrar());
                System.out.println("\nSeleccione canción para eliminar: ");
                int idCancion = sc.nextInt();
                Cancion cancion = biblioteca.getCancionPorId(idCancion);
                if (cancion != null) {
                    biblioteca.eliminarCancionDePlaylist(playlistID, cancion);
                }
            }
        }
    }

    private void mostrarPlaylists() {
        biblioteca.getPlaylists().mostrar();
    }

    private void mostrarCancionesPlaylist(Scanner sc) {
        mostrarPlaylists();
        if (biblioteca.tienePlaylist()) {
            System.out.println("\nSeleccione una playlist");
            int playlistID = sc.nextInt();
            NodoPlaylist playlist = biblioteca.getPlaylist(playlistID);
            if (playlist != null) {
                System.out.println("Canciones en la playlist " + playlist.getNombre() + ":");
                System.out.println(playlist.mostrar());
            } else {
                System.out.println("No se encontró la playlist con ID: " + playlistID);
            }
        } else {
            System.out.println("No hay playlists existentes");
        }
    }
}