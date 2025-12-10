import java.util.Scanner;
class EdlinOtraSolucion{
    public static void main(String[] args){
        String[] documento = {
            "Editor de lineas EDLIN",
            "---------------------------",
            "Utilice los comandos de la barra inferior para trabajar con el editor",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
        };
        int[] lineaActiva = {0};

        do {
            imprimeDocumento(documento, lineaActiva);
        } while (procesaEntrada(documento, lineaActiva));

    }

    private static boolean procesaEntrada(String[] documento, int[] lineaActiva) {
		Scanner entrada = new Scanner(System.in);
		String inputUsuario;
		inputUsuario = entrada.nextLine();
        
        if (inputUsuario.equalsIgnoreCase("S")) {return false;}
        if (inputUsuario.equalsIgnoreCase("I")) {intercambiarLineas(documento);}
        if (inputUsuario.equalsIgnoreCase("B")) {borrarLinea(documento, lineaActiva);}
        if (inputUsuario.equalsIgnoreCase("L")) {defineLineaActiva(lineaActiva, documento);}
        if (inputUsuario.equalsIgnoreCase("E")) {editarDocumento(documento, lineaActiva);}

        return true;
        
    }

    private static void editarDocumento(String[] documento, int[] lineaActiva) {
        Scanner entrada = new Scanner(System.in);
        System.out.println("Ingrese texto:");
        documento[lineaActiva[0]] = entrada.nextLine();
    }

    private static void defineLineaActiva(int[] lineaActiva, String[] documento) {
        
        Scanner entrada = new Scanner(System.in);
        do {
            System.out.print("Indique la nueva linea activa: ");
            lineaActiva[0] = entrada.nextInt();    
        } while (lineaActiva[0]<0 || lineaActiva[0]>documento.length);

    }

    private static void borrarLinea(String[] documento, int[] lineaActiva) {
        documento[lineaActiva[0]] = "";
    }

    private static void intercambiarLineas(String[] documento) {
		Scanner entrada = new Scanner(System.in);

        System.out.println("Dime la primera linea a cambiar: ");
        int linea1 = entrada.nextInt();
        System.out.println("Dime la segunda linea a cambiar: ");
        int linea2 = entrada.nextInt();

        String lineaTemporal = documento[linea2];
        documento[linea2] = documento[linea1];
        documento[linea1] = lineaTemporal;

    }

    private static void imprimeDocumento(String[] documento, int[] lineaActiva) {
        limpiaPantalla();
        imprimeLineaHorizontal();
        for (int linea=0; linea<documento.length; linea++){
            if (linea==lineaActiva[0]) {
                System.out.println(linea + "> |" + documento[linea]);
            } else {
                System.out.println(linea + "  |" + documento[linea]);
            }
            
        }
        imprimeLineaHorizontal();
        imprimeComandos();
    }

    private static void imprimeComandos() {
        System.out.println("Comandos: [L]:Linea activa / [B]:Borrar / [I]:Intercambiar / [S]:Salir");
    }

	private static void limpiaPantalla() {

		System.out.print("\033[H\033[2J");
		System.out.flush();

	}

    private static void imprimeLineaHorizontal() {
        System.out.println("--------------------------------------------------");
    }
}
