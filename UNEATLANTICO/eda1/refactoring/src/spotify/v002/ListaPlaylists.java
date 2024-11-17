public class ListaPlaylists {
    private NodoPlaylist primero;
    private NodoPlaylist ultimo;
    private int contadorIds;

    public ListaPlaylists() {
        this.primero = null;
        this.ultimo = null;
        this.contadorIds = 1;
    }

    public boolean isEmpty() {
        return this.primero == null;
    }

    public void insertUltimo(String nombrePlaylist) {
        this.ultimo = new NodoPlaylist(this.ultimo, nombrePlaylist, null, contadorIds);
        if (this.primero == null) {
            this.primero = this.ultimo;
        } else {
            this.ultimo.getAnterior().setSiguiente(this.ultimo);
        }
        this.contadorIds++;
    }

    public void mostrar() {
        System.out.println("LISTA DE PLAYLISTS: \n");
        if (this.isEmpty()) {
            System.out.println("Lista vacía");
        } else {
            NodoPlaylist current = this.primero;
            while (current != null) {
                System.out.println(current.toString());
                current = current.getSiguiente();
            }
        }
    }

    public NodoPlaylist encontrar(int playlistID) {

        NodoPlaylist current = this.primero;
        while (current != null) {
            if (current.getId() == playlistID) {
                return current;
            }
            current = current.getSiguiente();
        }
        return null;

    }
}
