public class Cancion {
    private String titulo;
    private String artista;
    private int duracion;
    private boolean favorita;

    public Cancion(String titulo, String artista, int duracion) {
        this.titulo = titulo;
        this.artista = artista;
        this.duracion = duracion;
        this.favorita = false;
    }

    public String getTitulo() {
        return titulo;
    }

    public void marcarComoFavorita() {
        this.favorita = true;
    }

    public void desmarcarComoFavorita() {
        this.favorita = false;
    }

    public boolean isFavorita() {
        return favorita;
    }

    @Override
    public String toString() {
        return titulo + " - " + artista + " (" + duracion + "s)";
    }
}

