public class Playlist {
    private String nombre;
    private int id;
    private ListaCanciones canciones;

    public Playlist(String nombre, int id) {
        this.nombre = nombre;
        this.id = id;
        this.canciones = new ListaCanciones();
    }

    public String getNombre() {
        return this.nombre;
    }

    public int getId(){
        return this.id;
    }

    public ListaCanciones getCanciones() {
        return this.canciones;
    }

    public void añadirCancion(Cancion cancion) {
        canciones.insertUltimo(cancion);
    }

    public void eliminarCancion(Cancion cancion) {
        canciones.eliminarCancion(cancion);
    }

    public String toString() {
        return this.id + ". " + this.nombre;
    }

    public String mostrar(){
        return "\n" + canciones.mostrar();
    }
}
