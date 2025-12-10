
public class PilaHistorial {
    private NodoCancion tope;

    public PilaHistorial() {
        tope = null;
    }

    public void apilar(Cancion cancion) {
        NodoCancion nuevoNodo = new NodoCancion(cancion);
        nuevoNodo.siguiente = tope;
        tope = nuevoNodo;
    }

    public Cancion desapilar() {
        if (tope == null) return null;

        Cancion cancion = tope.cancion;
        tope = tope.siguiente;
        return cancion;
    }

    public void mostrarHistorial() {
        NodoCancion actual = tope;
        int index = 1;
        while (actual != null) {
            System.out.println(index + ". " + actual.cancion);
            actual = actual.siguiente;
            index++;
        }
    }

}