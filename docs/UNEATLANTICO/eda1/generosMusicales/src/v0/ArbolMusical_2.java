package v0;

class ArbolMusical_2 {
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

        Nodo bluesRock = new Nodo("Blues Rock", 5);
        Nodo hardRock = new Nodo("Hard Rock", 5);
        Nodo heavyMetal = new Nodo("Heavy Metal", 5);
        
        blues.addHijo(bluesRock);
        bluesRock.addHijo(hardRock);
        hardRock.addHijo(heavyMetal);
        
        Nodo trashMetal = new Nodo("Trash Metal", 5);
        Nodo nuMetal = new Nodo("Nu Metal", 5);
        Nodo grooveMetal = new Nodo("Groove Metal", 5);
        
        heavyMetal.addHijo(trashMetal);
        heavyMetal.addHijo(nuMetal);
        heavyMetal.addHijo(grooveMetal);
        
        Nodo rhythmAndBlues = new Nodo("Rhythm & Blues", 5);
        Nodo rockabilly = new Nodo("Rockabilly", 5);
        
        blues.addHijo(rhythmAndBlues);
        rhythmAndBlues.addHijo(rockabilly);
        rhythmAndBlues.addHijo(new Nodo("Boogie Woogie", 5));
        
        Nodo surfMusic = new Nodo("Surf Music", 5);
        Nodo garageRock = new Nodo("Garage Rock", 5);
        
        rockabilly.addHijo(surfMusic);
        rockabilly.addHijo(garageRock);

        System.out.println("Árbol genealógico del Rock (rama del Blues):");
        arbol.imprimir();
    }
}