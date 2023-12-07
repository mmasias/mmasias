import java.util.Scanner;

class EscalasAcordes {
    
    static final String[] NOTAS = {"Do", "Do#", "Re", "Re#", "Mi", "Fa", "Fa#", "Sol", "Sol#", "La", "La#", "Si"};

    public static void main(String[] args) {

        System.out.println(obtenerIndice("Do"));
        System.out.println(obtenerNota(0));

    }

    private static int obtenerIndice(String nota) {
        for (int i = 0; i < NOTAS.length; i++) {
            if (NOTAS[i].equalsIgnoreCase(nota)) {
                return i;
            }
        }
        return -1;
    }

    private static String obtenerNota(int indice) {
        return NOTAS[indice];
    }
}
