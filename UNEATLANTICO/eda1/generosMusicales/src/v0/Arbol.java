package v0;

class Arbol {
    private Nodo raiz;

    public Arbol(String generoRaiz) {
        raiz = new Nodo(generoRaiz, 10);
    }

    public Nodo getRaiz() {
        return raiz;
    }

    public void imprimir() {
        imprimir(raiz, 0);
    }

    private void imprimir(Nodo nodo, int nivel) {
        for (int i = 0; i < nivel; i++) {
            System.out.print("  ");
        }
        System.out.println(nodo.genero);

        for (int i = 0; i < nodo.numHijos; i++) {
            imprimir(nodo.hijos[i], nivel + 1);
        }
    }
}
