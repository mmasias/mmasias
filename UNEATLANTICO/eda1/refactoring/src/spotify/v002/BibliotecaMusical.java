public class BibliotecaMusical {
    private Cancion[] cancionesDisponibles;
    private ListaPlaylists playlists;

    public BibliotecaMusical() {
        this.cancionesDisponibles = new Cancion[] {
            new Cancion(1, "Bitcoin", "LEÏTI", 187),
            new Cancion(2, "La vida padre", "ToteKing", 147),
            new Cancion(3, "R.I.P", "Playboi Carti", 192),
            new Cancion(4, "redrum", "21 Savage", 271),
            new Cancion(5, "LENNY", "ABHIR", 129),
            new Cancion(6, "Mandaloriano", "JohnPo", 179),
            new Cancion(7, "Marlboro Nights", "Lonely God", 69),
            new Cancion(8, "20 Min", "Lil Uzi Vert", 221),
            new Cancion(9, "If we beeing rëal", "Yeat", 173),
            new Cancion(10, "Capo", "NLE Choppa", 192)
        };
        this.playlists = new ListaPlaylists();
    }

    public Cancion[] getCancionesDisponibles() {
        return cancionesDisponibles;
    }

    public Cancion getCancionPorId(int id) {
        if (id >= 1 && id <= cancionesDisponibles.length) {
            return cancionesDisponibles[id - 1];
        }
        return null;
    }

    public void crearPlaylist(String nombre) {
        playlists.insertUltimo(nombre);
    }

    public void añadirCancionAPlaylist(int playlistId, Cancion cancion) {
        NodoPlaylist playlist = playlists.encontrar(playlistId);
        if (playlist != null) {
            playlist.añadirCancion(cancion);
        }
    }

    public void eliminarCancionDePlaylist(int playlistId, Cancion cancion) {
        NodoPlaylist playlist = playlists.encontrar(playlistId);
        if (playlist != null) {
            playlist.eliminarCancion(cancion);
        }
    }

    public ListaPlaylists getPlaylists() {
        return playlists;
    }

    public NodoPlaylist getPlaylist(int id) {
        return playlists.encontrar(id);
    }

    public boolean tienePlaylist() {
        return !playlists.isEmpty();
    }
}