class ZzzPrueba {

    static int[] primerArray = {1,2,3,4};
    static int[] segundoArray = {5,6,7,8};
    static int[] tercerArray = {9,10,11,12,13,14,15};
    static int[] arrayModelo;

    static int[][] elementos = {primerArray, segundoArray, tercerArray};

    public static void main(String[] args){

        inicializa(2);  imprimeArray(arrayModelo);
        inicializa(1);  imprimeArray(arrayModelo);
        inicializa(0);  imprimeArray(arrayModelo);
    }

    static void imprimeArray(int[] unArray){
        for(int i=0; i<unArray.length; i++){
            System.out.print(unArray[i] + " - ");
        }
        System.out.println();
    }

    static void inicializa(int queMapaActivar){
        arrayModelo = elementos[queMapaActivar];
    }

}
