public class Cancion {

    private String titulo;
    private int id;
    private String artista;
    private int duracion;    
    private boolean favorita;
    
    public Cancion(int id, String titulo, String artista, int duracion) {
        this.titulo = titulo;
        this.id = id;
        this.artista = artista;
        this.duracion = duracion;
        this.favorita = false;
    }    

    public Cancion(Cancion cancion) {
        this.id = cancion.getId();
        this.titulo = cancion.titulo;
        this.artista = cancion.artista;
        this.duracion = cancion.duracion;
        this.favorita = cancion.favorita;
    }

    public String toString(){

        return this.id + ". " + this.titulo + " - " + this.artista + " (" + this.duracion + "s)";

    }

    public void setFavorita(){
        this.favorita = true;
    }

    public void unsetFavorita(){
        this.favorita = false;
    }

    public boolean esFavorita(){
        return this.favorita;
    }

    public int getId(){
        return this.id;
    }
}
