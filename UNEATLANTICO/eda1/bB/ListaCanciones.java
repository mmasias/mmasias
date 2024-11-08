public class ListaCanciones {
    private NodoCancion inicio;
    private int tamaño;

    public ListaCanciones() {
        this.inicio = null;
        this.tamaño = 0;
    }

    public void agregarCancion(Cancion cancion) {
        NodoCancion nuevoNodo = new NodoCancion(cancion);
        if (inicio == null) {
            inicio = nuevoNodo;
        } else {
            NodoCancion temp = inicio;
            while (temp.siguiente != null) {
                temp = temp.siguiente;
            }
            temp.siguiente = nuevoNodo;
        }
        tamaño++;
    }

    public void eliminarCancion(String titulo) {
        if (inicio == null) return;

        if (inicio.cancion.getTitulo().equals(titulo)) {
            inicio = inicio.siguiente;
            tamaño--;
            return;
        }

        NodoCancion actual = inicio;
        while (actual.siguiente != null && !actual.siguiente.cancion.getTitulo().equals(titulo)) {
            actual = actual.siguiente;
        }

        if (actual.siguiente != null) {
            actual.siguiente = actual.siguiente.siguiente;
            tamaño--;
        }
    }

    public void mostrarCanciones() {
        NodoCancion actual = inicio;
        int index = 1;
        while (actual != null) {
            System.out.println(index + ". " + actual.cancion);
            actual = actual.siguiente;
            index++;
        }
    }

    public NodoCancion getNodo(int index) {
        if (index < 0 || index >= tamaño) {
            return null; // Índice fuera de rango
        }

        NodoCancion actual = inicio;
        for (int i = 0; i < index; i++) {
            actual = actual.siguiente;
        }
        return actual;
    }

    public int getTamaño() {
        return tamaño;
    }

}