public class ListaPlaylists {
    private NodoPlaylist inicio;
    private int tamaño;

    public ListaPlaylists() {
        this.inicio = null;
        this.tamaño = 0;
    }

    public void agregarPlaylist(Playlist playlist) {
        NodoPlaylist nuevoNodo = new NodoPlaylist(playlist);
        if (inicio == null) {
            inicio = nuevoNodo;
        } else {
            NodoPlaylist temp = inicio;
            while (temp.siguiente != null) {
                temp = temp.siguiente;
            }
            temp.siguiente = nuevoNodo;
        }
        tamaño++;
    }

    public Playlist obtenerPlaylist(int index) {
        if (index < 0 || index >= tamaño) return null;
        NodoPlaylist actual = inicio;
        for (int i = 0; i < index; i++) {
            actual = actual.siguiente;
        }
        return actual.playlist;
    }

    public void mostrarPlaylists() {
        NodoPlaylist actual = inicio;
        int index = 1;
        while (actual != null) {
            System.out.println(index + ". " + actual.playlist.getNombre());
            actual = actual.siguiente;
            index++;
        }
    }

    public int getTamaño() {
        return tamaño;
    }
}