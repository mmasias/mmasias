
public class Playlist {
    private String nombre;
    private ListaCanciones canciones;

    public Playlist(String nombre) {
        this.nombre = nombre;
        this.canciones = new ListaCanciones();
    }

    public String getNombre() {
        return nombre;
    }

    public void agregarCancion(Cancion cancion) {
        canciones.agregarCancion(cancion);
        System.out.println("\"" + cancion.getTitulo() + "\" añadida a la playlist " + nombre);
    }

    public void eliminarCancion(String titulo) {
        canciones.eliminarCancion(titulo);
        System.out.println("Canción \"" + titulo + "\" eliminada de la playlist " + nombre);
    }

    public void mostrarCanciones() {
        System.out.println("Canciones en la playlist \"" + nombre + "\":");
        canciones.mostrarCanciones();
    }
}