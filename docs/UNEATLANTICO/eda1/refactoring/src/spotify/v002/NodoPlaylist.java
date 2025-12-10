public class NodoPlaylist extends Playlist {
    private NodoPlaylist siguiente;
    private NodoPlaylist anterior;

    public NodoPlaylist(NodoPlaylist anterior, String nombrePlaylist, NodoPlaylist siguiente, int id) {
        super(nombrePlaylist, id);
        this.siguiente = siguiente;
        this.anterior = anterior;
    }

    public NodoPlaylist getSiguiente() {
        return this.siguiente;
    }

    public NodoPlaylist getAnterior() {
        return this.anterior;
    }

    public void setSiguiente(NodoPlaylist siguiente) {
        this.siguiente = siguiente;
    }

    public void setAnterior(NodoPlaylist anterior) {
        this.anterior = anterior;
    }
}
