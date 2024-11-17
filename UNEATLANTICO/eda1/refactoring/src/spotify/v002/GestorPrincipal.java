import java.util.Scanner;

public class GestorPrincipal {
    private BibliotecaMusical biblioteca;
    private GestorReproduccion gestorReproduccion;
    private GestorBiblioteca gestorBiblioteca;

    public GestorPrincipal(BibliotecaMusical biblioteca, GestorReproduccion gestorReproduccion,
            GestorBiblioteca gestorBiblioteca) {
        this.biblioteca = biblioteca;
        this.gestorReproduccion = gestorReproduccion;
        this.gestorBiblioteca = gestorBiblioteca;
    }

    public void iniciar() {
        Scanner sc = new Scanner(System.in);
        while (true) {
            mostrarBibliotecaInicial();
            mostrarMenuPrincipal();
            int eleccionMenuPrincipal = sc.nextInt();
            if (!gestionarOpcionMenu(eleccionMenuPrincipal, sc)) {
                return;
            }
        }
    }

    private void mostrarBibliotecaInicial() {
        System.out.println("\n=== SPOTIFY === \n");
        System.out.println("BIBLIOTECA INICIAL \n");
        System.out.println("Canciones disponibles: \n");
        for (Cancion cancion : biblioteca.getCancionesDisponibles()) {
            System.out.println(cancion.toString());
        }
    }

    private void mostrarMenuPrincipal() {
        System.out.println("\n=== MENÚ PRINCIPAL ===");
        System.out.println("1. Reproducción");
        System.out.println("2. Biblioteca");
        System.out.println("3. Salir \n");
        System.out.println("Seleccione una opción:");
    }

    private boolean gestionarOpcionMenu(int opcion, Scanner sc) {
        switch (opcion) {
            case 1:
                gestorReproduccion.gestionarMenuReproduccion(sc);
                return true;
            case 2:
                gestorBiblioteca.gestionarMenuBiblioteca(sc);
                return true;
            case 3:
                return false;
            default:
                System.out.println("Elección inválida, intente de nuevo");
                return true;
        }
    }
}