import java.util.Scanner;
import java.util.Random;   

public class Rumores {
    
    public static void main(String[] args){

        String[] personas;
        int[] contador;
        int numeroPersonas=0;
		int vueltas=0, ultimo=0;
        final int INICIA_RUMOR=0;

        numeroPersonas = defineParticipantes(3);

        personas = new String[numeroPersonas];
        contador = new int[numeroPersonas];

        inicializa(numeroPersonas,personas);
        contador[INICIA_RUMOR]=1;
        
        do {
            ultimo = propagaRumor(ultimo, personas, contador);
            vueltas++;
        } while(!HayRepetidos(contador));
        System.out.println("Dimos " + vueltas + " vueltas");
    }

    private static int defineParticipantes(int numeroMinimo) {
        int numeroPersonas;
        do {
            System.out.println("Indique numero de participantes (mayor de 3)");
            numeroPersonas = pideInt();    
        } while (numeroPersonas<3);
        return numeroPersonas;        
    }

    private static int propagaRumor(int ultimo, String[] personas, int[] contador) {
        
        int penultimo = ultimo;
        Random random = new Random();   
        
        do {
            ultimo = random.nextInt(personas.length);
        } while (penultimo==ultimo);
          
        System.out.println("["+personas[penultimo]+"] se lo dice a ["+personas[ultimo]+"]");
        contador[ultimo]++;

        return ultimo;   
    }

    private static boolean HayRepetidos(int[] contador) {
        for(int i=0;i<contador.length;i++){
            if (contador[i]>1) {
                return true;
            }
        }
        return false;
    }

    private static void inicializa(int numeroPersonas, String[] personas) {
        Scanner entrada = new Scanner(System.in);
        for(int persona=0;persona<personas.length;persona++){
            System.out.print("Diga el nombre de la persona " + (persona+1) + ": ");
            personas[persona]=pideString();
        }
    }

    private static String pideString() {
        Scanner entrada = new Scanner(System.in);
        return entrada.nextLine();
    }

    private static int pideInt() {
        Scanner entrada = new Scanner(System.in);
        return entrada.nextInt();
    }
    
    private static char pideChar() {
        Scanner entrada = new Scanner(System.in);
        return entrada.next().charAt(0);
    }

}