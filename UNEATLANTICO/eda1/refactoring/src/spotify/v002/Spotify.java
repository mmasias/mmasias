public class Spotify {
    public static void main(String[] args) {
        
        BibliotecaMusical biblioteca = new BibliotecaMusical();
        Reproductor reproductor = new Reproductor(biblioteca);
        
        GestorBiblioteca gestorBiblioteca = new GestorBiblioteca(biblioteca);
        GestorReproduccion gestorReproduccion = new GestorReproduccion(reproductor, biblioteca); 
        
        GestorPrincipal gestorPrincipal = new GestorPrincipal(biblioteca, gestorReproduccion, gestorBiblioteca);
        
        gestorPrincipal.iniciar();
    }
}