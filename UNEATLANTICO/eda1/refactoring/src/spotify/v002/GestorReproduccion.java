import java.util.Scanner;

public class GestorReproduccion {
    private Reproductor reproductor;
    private BibliotecaMusical biblioteca;

    public GestorReproduccion(Reproductor reproductor, BibliotecaMusical biblioteca) {
        this.reproductor = reproductor;
        this.biblioteca = biblioteca;
    }

    public void gestionarMenuReproduccion(Scanner sc) {
        boolean enReproduccion = true;
        while(enReproduccion){
            mostrarMenuReproduccion();
            int eleccionMenuReproduccion = sc.nextInt();
            switch (eleccionMenuReproduccion){
                case 1:
                    gestionarCancionActual(sc);
                    break;
                case 2:
                    reproductor.siguienteCancion();
                    break;
                case 3:
                    reproductor.cancionAnterior();
                    break;
                case 4:
                    reproductor.verCola();
                    break;
                case 5:
                    reproductor.verHistorial();
                    break;
                case 6:
                    reproductor.activarDesactivarAleatorio();
                    break;
                case 7:
                    reproductor.activarDesactivarRepeticion();
                    break;
                    case 8:
                    gestionarAñadirCancionCola(sc);
                    break;
                case 9:
                    gestionarReproducirPlaylist(sc);
                    break;
                case 10:
                    enReproduccion = false;
                    break;
                default:
                    System.out.println("Elección inválida, intente de nuevo");
            }
        }
    }

    private void mostrarMenuReproduccion() {
        System.out.println("\n=== MENÚ REPRODUCCIÓN ===");
        System.out.println("1. Ver canción actual");
        System.out.println("2. Reproducir siguiente");
        System.out.println("3. Reproducir anterior");
        System.out.println("4. Ver cola de reproducción");
        System.out.println("5. Ver historial");
        System.out.println("6. Activar/desactivar aleatorio");
        System.out.println("7. Activar/desactivar repetición");
        System.out.println("8. Añadir canción a cola de reproducción");
        System.out.println("9. Reproducir playlist");
        System.out.println("10. Volver al menú principal");
        System.out.println("\nSeleccione una opción:");
    }

    private void gestionarCancionActual(Scanner sc) {
        Cancion actual = reproductor.getCancionActual();
        if (actual != null) {
            reproductor.reproducirCancion(actual);
        }else{
            System.out.println("No hay canción en reproducción.");
            System.out.println("¿Desea comenzar a reproducir? (S/N): ");
            String respuesta = sc.next();
            if(respuesta.equalsIgnoreCase("S")) {
                System.out.println("Seleccione canción (1-10):");
                int idCancion = sc.nextInt();
                reproductor.añadirCancionCola(idCancion);
                reproductor.siguienteCancion();
            }
        }
    }

    private void gestionarAñadirCancionCola(Scanner sc) {
        System.out.println("Seleccione canción (1-10):");
        int idCancion = sc.nextInt();
        reproductor.añadirCancionCola(idCancion);
    }

    private void gestionarReproducirPlaylist(Scanner sc) {
        if (biblioteca.tienePlaylist()) {
            biblioteca.getPlaylists().mostrar();
            System.out.println("\nSeleccione una playlist para reproducir:");
            int playlistID = sc.nextInt();
            NodoPlaylist playlist = biblioteca.getPlaylist(playlistID);
            if (playlist != null) {
                reproductor.cargarPlaylist(playlist);
            } else {
                System.out.println("Playlist no encontrada.");
            }
        } else {
            System.out.println("No hay playlists disponibles.");
        }
    }
}