import java.util.Scanner;

public class Edlin {
    public static void main(String[] args){

        int lineaActiva[] = {1};
        String documento[] = {
            "Bienvenidos al editor EDLIN", 
            "Utilice el menu inferior para editar el texto", 
            "------", 
            "[L] permite definir la linea activa", 
            "[E] permite editar la linea activa", 
            "[I] permite intercambiar dos lineas", 
            "[B] borra el contenido de la linea activa", 
            "[S] sale del programa", 
            "", 
            "", 
        };

        do {
            imprime(documento, lineaActiva);
        } while(procesaAcciones(documento, lineaActiva));
    }

    private static boolean procesaAcciones(String[] documento, int[] lineaActiva) {

        System.out.println("Comandos: [L]inea activa | [E]ditar | [I]ntercambiar | [B]orrar | [S]alir");

        switch (pideChar()) {
            case 'S':   case 's':
                return false;
            case 'L':   case 'l':
                defineLineaActiva(documento, lineaActiva);
                break;
            case 'E':   case 'e':
                editar(documento, lineaActiva);
                break;
            case 'I':   case 'i':
                intercambiarLineas(documento);
                break;
            case 'B':   case 'b':
                borrar(documento, lineaActiva);
                break;
        }
        return true;
    }

    private static void intercambiarLineas(String[] documento) {

        int lineaOrigen, lineaDestino;
        String lineaTemporal;
        do {
            System.out.print("Introduzca primera linea por cambiar: ");
            lineaOrigen=pideInt();            
        } while (lineaOrigen<0 || lineaOrigen>documento.length);

        do {
            System.out.print("Introduzca segunda linea por cambiar: ");
            lineaDestino=pideInt();    
        } while (lineaDestino<0 || lineaDestino>documento.length);
        
        lineaTemporal = documento[lineaDestino];
        documento[lineaDestino]=documento[lineaOrigen];
        documento[lineaOrigen]=lineaTemporal;
        System.out.println("Lineas intercambiadas!");
    }

    private static void borrar(String[] documento, int[] lineaActiva) {
        System.out.println("Seguro que desea borrar ["+documento[lineaActiva[0]]+"] ('S': Si)");
        if (pideChar()=='S') {
            documento[lineaActiva[0]]="";
        }
    }

    private static void editar(String[] documento, int[] lineaActiva) {
        System.out.println(documento[lineaActiva[0]]);
        documento[lineaActiva[0]]=pideString();
    }

    private static void defineLineaActiva(String[] documento, int[] lineaActiva) {
        do {
            System.out.print("Indique la nueva linea activa: ");
            lineaActiva[0]=pideInt();
        } while (lineaActiva[0]<0 || lineaActiva[0]>=documento.length);

    }

    private static void imprime(String[] documento, int[] lineaActiva) {
        limpiaPantalla();
        imprimeLineaHorizontal();
        for (int linea=0; linea<documento.length; linea++){
            System.out.println(linea + separador(linea, lineaActiva[0]) + documento[linea]);
        }
        imprimeLineaHorizontal();
    }

    private static String separador(int linea, int lineaActiva) {
        if (linea==lineaActiva) {return ":*| ";}
        return ": | ";
    }

    private static void imprimeLineaHorizontal() {
        System.out.println("-------------------------------------------------------------------------");
    }

	private static void limpiaPantalla() {

		System.out.print("\033[H\033[2J");
		System.out.flush();

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