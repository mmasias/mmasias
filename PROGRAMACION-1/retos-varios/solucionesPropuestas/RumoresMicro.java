import java.util.Scanner;

class RumoresMicro {

    public static void main(String[] args) {
        System.out.println("¿Cuántas personas?");
        final int NUMERO_PERSONAS = new Scanner(System.in).nextInt();
        int[] personas = new int[NUMERO_PERSONAS];
        int quienCrea = (int) (Math.random() * NUMERO_PERSONAS);
        int deQuien = (int) (Math.random() * NUMERO_PERSONAS);
        while (deQuien == quienCrea)
            deQuien = (int) (Math.random() * NUMERO_PERSONAS);

        int quienCuenta = quienCrea;
        personas[quienCuenta]++;
        System.out.println("Todo empieza cuando [" + quienCuenta + "] habla de [" + deQuien + "]");

        boolean sePropaga = true;
        while (sePropaga) {
            quienCrea = quienCuenta;
            do {
                quienCuenta = (int) (Math.random() * NUMERO_PERSONAS);
            } while (quienCuenta == deQuien||quienCrea==quienCuenta);
            personas[quienCuenta]++;
            sePropaga=(personas[quienCuenta] <= 1);
            System.out.println("> " + quienCrea + " lo cuenta a " + quienCuenta);
        }
    }
}