public class NodoCancion extends Cancion {
    private NodoCancion siguiente;
    private NodoCancion anterior;

    public NodoCancion(NodoCancion anterior, Cancion cancion, NodoCancion siguiente) {
        super(cancion);
        this.anterior = anterior;
        this.siguiente = siguiente;
    }

    public NodoCancion getSiguiente() {
        return this.siguiente;
    }

    public NodoCancion getAnterior() {
        return this.anterior;
    }

    public void setSiguiente(NodoCancion siguiente) {
        this.siguiente = siguiente;
    }

    public void setAnterior(NodoCancion anterior) {
        this.anterior = anterior;
    }

    public Cancion getCancion() {
        return this;
    }
}
