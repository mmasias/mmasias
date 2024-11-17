package v0;

class ArbolMusical {
    public static void main(String[] args) {
        Arbol arbol = new Arbol("Música Popular");

        Nodo raiz = arbol.getRaiz();
        
        Nodo country = new Nodo("Country", 5);
        Nodo gospel = new Nodo("Gospel", 5);
        Nodo blues = new Nodo("Blues", 5);
        Nodo jazz = new Nodo("Jazz", 5);

        raiz.addHijo(country);
        raiz.addHijo(gospel);
        raiz.addHijo(blues);
        raiz.addHijo(jazz);

        Nodo folkRock = new Nodo("Folk Rock", 5);
        country.addHijo(folkRock);

        Nodo soul = new Nodo("Soul", 5);
        gospel.addHijo(soul);

        arbol.imprimir();
    }
}