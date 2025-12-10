public class NodoCancion {
    Cancion cancion;
    NodoCancion siguiente;

    public NodoCancion(Cancion cancion) {
        this.cancion = cancion;
        this.siguiente = null;
    }
}
