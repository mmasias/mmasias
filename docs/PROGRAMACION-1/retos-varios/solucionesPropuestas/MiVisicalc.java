import java.util.Scanner;

class MiVisicalc {

	static final int FILA = 0;
	static final int COLUMNA = 1;

	static final int ARRIBA = 0;
	static final int ABAJO = 1;
	static final int IZQUIERDA = 2;
	static final int DERECHA = 3;
	static final int SALIR = 4;
	static final int INSERTAR_TEXTO = 5;
	static final int COMANDO_ERRONEO = -1;

	static final int[][] MOVIMIENTO = {
			{ -1, 0 },
			{ 1, 0 },
			{ 0, -1 },
			{ 0, 1 }
	};

	static String unaCelda = "";

	public static void main(String[] args){
		
		String unaCelda = "";
		String hojaDeCalculo[][] = {
			{"","","","","","","","","",""},
			{"","","","","","","","","",""},
			{"","","","","","","","","",""},
			{"","","","","","","","","",""},
			{"","","","","","","","","",""}
		};
		
		int[] elCursor = { 0, 0 };
		
		do {
			imprimir(hojaDeCalculo, elCursor);
		} while(interactuar(hojaDeCalculo, elCursor));
		
	}

	static boolean interactuar(String[][] hoja, int[] posicion){
		switch (capturarMovimiento()) {
			case ARRIBA:
				mover(posicion, ARRIBA);
				break;
			case ABAJO:
				mover(posicion, ABAJO);
				break;
			case IZQUIERDA:
				mover(posicion, IZQUIERDA);
				break;
			case DERECHA:
				mover(posicion, DERECHA);
				break;
			case INSERTAR_TEXTO:
				modificar(hoja, posicion);
				break;
			case SALIR:
				return false;
		}
		corrige(posicion, hoja);
		return true;
	}

	private static void corrige(int[] posicion, String[][] hoja) {

		if (posicion[0]<0) posicion[0]=0;
		if (posicion[0]>=hoja.length) posicion[0]=hoja.length-1;
		if (posicion[1]<0) posicion[1]=0;
		if (posicion[1]>=hoja[0].length) posicion[1]=hoja[0].length-1;

	}

	static void modificar(String[][] hoja, int[] posicion){
		hoja[posicion[0]][posicion[1]] = pedirString("Ingrese valor");
	}

	static void mover(int[] posicion, int direccion) {

		posicion[FILA] += MOVIMIENTO[direccion][FILA];
		posicion[COLUMNA] += MOVIMIENTO[direccion][COLUMNA];
	}

	static int capturarMovimiento() {

		switch (pedirChar("Ingrese comando> ")) {
			case 's', 'S', '8':
				return ABAJO;
			case 'w', 'W', '2':
				return ARRIBA;
			case 'a', 'A', '4':
				return IZQUIERDA;
			case 'd', 'D', '6':
				return DERECHA;
			case 'e', 'E', '5':
				return INSERTAR_TEXTO;				
			case 'f', 'F':
				return SALIR;
		}
		return COMANDO_ERRONEO;
	}

	static char pedirChar(String prompt) {
		System.out.print(prompt);
		Scanner entrada = new Scanner(System.in);
		return entrada.next().charAt(0);
	}

	static String pedirString(String prompt) {
		
		System.out.print(prompt);
		Scanner entrada = new Scanner(System.in);
		return entrada.nextLine();
	}

	static void imprimir(String[][] hoja, int[] posicion){
		final int ANCHO_DE_CELDA = 6;
		String celda;
        limpiarPantalla();
		for(int fila=0;fila<hoja.length;fila++){
			for(int columna=0;columna<hoja[fila].length;columna++){
				boolean borde=false;
				if (posicion[0]==fila && posicion[1]==columna){
					borde=true;
				} 
				celda=limpia(hoja[fila][columna], ANCHO_DE_CELDA,borde);
				System.out.print("|"+celda);
			}
			System.out.println("|");
		}
	}
	
	static String limpia(String texto, int largo, boolean borde){
		if(texto.length()<largo){
			texto=" ".repeat(largo-texto.length())+texto;
		} else {
			texto = texto.substring(texto.length() - largo);
		}
		if (borde) {
			texto="["+limpia(texto,4,!borde)+"]";
		}
		return texto;
	}

    static void limpiarPantalla() {

        System.out.print("\033[H\033[2J");
    }

}