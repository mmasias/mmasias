import java.util.Scanner;

class RumoresMinimalista {

    public static void main(String[] args) {
        System.out.println("Cuántas personas?");
        final int NUMERO_PERSONAS = new Scanner(System.in).nextInt();
        int personas[] = new int[NUMERO_PERSONAS];
        int quienCreaRumor = (int) (Math.random() * personas.length);
        int deQuienSeHabla = seHablaDe(quienCreaRumor, personas.length);

        int quienCuenta = quienCreaRumor;
        personas[quienCuenta]++;
        System.out.println("Todo empieza cuando [" + quienCuenta + "] habla de [" + deQuienSeHabla + "]");
        do {
            quienCuenta = propagarRumor(quienCuenta, deQuienSeHabla, personas);
        } while (!repetido(personas));
    }

    private static int propagarRumor(int quienCuenta, int deQuienSeHabla, int[] personas) {
        int aQuienLoCuenta;
        do {
            aQuienLoCuenta = (int) (Math.random() * personas.length);
        } while (aQuienLoCuenta == quienCuenta || aQuienLoCuenta == deQuienSeHabla);
        personas[aQuienLoCuenta]++;
        System.out.println("> " + quienCuenta + " lo cuenta a " + aQuienLoCuenta);
        return aQuienLoCuenta;
    }

    private static boolean repetido(int[] personas) {
        for (int i = 0; i < personas.length; i++) {
            if (personas[i] > 1) {
                return true;
            }
        }
        return false;
    }

    private static int seHablaDe(int quienCreaRumor, int numeroPersonas) {
        int sehablaDe;
        do {
            sehablaDe = (int) (Math.random() * numeroPersonas);
        } while (quienCreaRumor == sehablaDe);
        return sehablaDe;
    }
}
