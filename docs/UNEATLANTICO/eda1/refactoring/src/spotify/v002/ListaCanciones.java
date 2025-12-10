public class ListaCanciones {
    private NodoCancion primero;
    private NodoCancion ultimo;

    public ListaCanciones() {
        this.primero = null;
        this.ultimo = null;
    }

    public boolean isEmpty() {
        return this.primero == null;
    }

    public void insertPrimero(Cancion cancion) {
        NodoCancion nuevoNodo = new NodoCancion(null, cancion, this.primero);
        if (this.primero != null) {
            this.primero.setAnterior(nuevoNodo);
        }
        this.primero = nuevoNodo;
        if (this.ultimo == null) {
            this.ultimo = this.primero;
        }
    }

    public void insertUltimo(Cancion cancion) {
        NodoCancion nuevoNodo = new NodoCancion(this.ultimo, cancion, null);
        if (this.ultimo != null) {
            this.ultimo.setSiguiente(nuevoNodo);
        }
        this.ultimo = nuevoNodo;
        if (this.primero == null) {
            this.primero = this.ultimo;
        }
    }

    public void eliminarCancion(Cancion cancion) {
        if (!isEmpty()){
            NodoCancion current = this.primero;
            while (current != null) {
                if (current.getId() == cancion.getId()) {
                    if (current.getAnterior() != null) {
                        current.getAnterior().setSiguiente(current.getSiguiente());
                    } else {
                        this.primero = current.getSiguiente();
                    }
    
                    if (current.getSiguiente() != null) {
                        current.getSiguiente().setAnterior(current.getAnterior());
                    } else {
                        this.ultimo = current.getAnterior();
                    }
                    return;
                }
                current = current.getSiguiente();
            }
        } 
    }

    public String mostrar() {
        String mensaje = "";
        if (this.isEmpty()) {
            return "Lista vacía";
        }else{
            NodoCancion current = this.primero;
            while (current != null) {
                mensaje = mensaje + current.toString() + "\n";
                current = current.getSiguiente();
            }
            return mensaje;
        }
    }

    public NodoCancion getUltimoNodo() {
        return this.ultimo;
    }

    public NodoCancion getPrimerNodo() {
        return this.primero;
    }    
}
