import java.util.Scanner;

class EscalasAcordes {

    public static void main(String[] args) {

        System.out.println(obtenerIndice("Do"));
        System.out.println(obtenerNota(0));

    }

    private static int obtenerIndice(String nota) {
        String[] notas = {"Do", "Do#", "Re", "Re#", "Mi", "Fa", "Fa#", "Sol", "Sol#", "La", "La#", "Si"};
        for (int i = 0; i < notas.length; i++) {
            if (notas[i].equalsIgnoreCase(nota)) {
                return i;
            }
        }
        return -1;
    }

    private static String obtenerNota(int indice) {
        String[] notas = { "Do", "Do#", "Re", "Re#", "Mi", "Fa", "Fa#", "Sol", "Sol#", "La", "La#", "Si" };
        return notas[indice];
    }

}
