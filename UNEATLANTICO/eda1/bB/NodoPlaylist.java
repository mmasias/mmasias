public class NodoPlaylist {
    public Playlist playlist;
    public NodoPlaylist siguiente;

    public NodoPlaylist(Playlist playlist) {
        this.playlist = playlist;
        this.siguiente = null;
    }
}