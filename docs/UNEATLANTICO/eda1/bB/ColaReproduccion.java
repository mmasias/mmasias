public class ColaReproduccion {
    private NodoCancion inicio, fin;

    public ColaReproduccion() {
        inicio = fin = null;
    }

    public void encolar(Cancion cancion) {
        NodoCancion nuevoNodo = new NodoCancion(cancion);
        if (fin == null) {
            inicio = fin = nuevoNodo;
        } else {
            fin.siguiente = nuevoNodo;
            fin = nuevoNodo;
        }
    }

    public Cancion desencolar() {
        if (inicio == null) return null;

        Cancion cancion = inicio.cancion;
        inicio = inicio.siguiente;
        if (inicio == null) fin = null;
        return cancion;
    }

    public void mostrarCola(Cancion cancionActual) {
        NodoCancion actual = inicio;
        int index = 1;
        while (actual != null) {
            if (actual.cancion.equals(cancionActual)) {
                System.out.println(index + ". ▶ " + actual.cancion + " (ACTUAL)");
            } else {
                System.out.println(index + ". " + actual.cancion);
            }
            actual = actual.siguiente;
            index++;
        }
    }


}