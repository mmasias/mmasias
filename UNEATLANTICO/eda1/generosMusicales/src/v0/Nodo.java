package v0;

public class Nodo {
    String genero;
    Nodo[] hijos;
    int numHijos;

    public Nodo(String genero, int numeroMaximoHijos) {
        this.genero = genero;
        this.hijos = new Nodo[numeroMaximoHijos];
        this.numHijos = 0;
    }

    public void addHijo(Nodo hijo) {
        if (numHijos < hijos.length) {
            hijos[numHijos] = hijo;
            numHijos++;
        }
    }
}
