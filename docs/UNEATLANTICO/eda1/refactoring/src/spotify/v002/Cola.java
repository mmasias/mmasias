public class Cola {

    private NodoCancion primero;
    private NodoCancion ultimo;

    public Cola() {
        primero = null;
        ultimo = null;
    }

    public void enqueue(Cancion cancion) {
        NodoCancion nuevoNodo = new NodoCancion(null, cancion, null);
        if (isEmpty()) {
            primero = nuevoNodo;
            ultimo = nuevoNodo;
        } else {
            ultimo.setSiguiente(nuevoNodo);
            nuevoNodo.setAnterior(ultimo);
            ultimo = nuevoNodo;
        }
    }

    public void desenqueue() {
        if (isEmpty()) {
            System.out.println("La cola está vacía. No se puede eliminar ningún elemento.");
        } else {
            primero = primero.getSiguiente();
            if (primero != null) {
                primero.setAnterior(null);
            } else {
                ultimo = null;
            }
        }
    }

    public void mostrar() {
        if (isEmpty()) {
            System.out.println("La cola está vacía.");
        } else {
            NodoCancion actual = primero;
            while (actual != null) {
                System.out.println(actual.toString());
                actual = actual.getSiguiente();
            }
        }
    }

    public boolean isEmpty() {
        return this.primero == null;
    }

    public NodoCancion getPrimero() {
        return this.primero;
    }
}
