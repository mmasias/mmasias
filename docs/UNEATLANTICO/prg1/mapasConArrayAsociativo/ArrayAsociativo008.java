import java.util.*;

public class ArrayAsociativo008 {

    static final int FILA = 0;
    static final int COLUMNA = 1;

    static final int ARRIBA = 0;
    static final int ABAJO = 1;
    static final int IZQUIERDA = 2;
    static final int DERECHA = 3;
    static final int SALIR = 4;
    static final int NADA = 999;

    static final int[][] MOVIMIENTO = {
            { -1, 0 },
            { 1, 0 },
            { 0, -1 },
            { 0, 1 }
    };

    static double hora = 12.0;
    static int alcanceVision;
    static int viewPort;

    static int minFila, minColumna, maxFila, maxColumna;

    static boolean jugando = true;

    public static void main(String[] args) {

        String[] castilloLB = {
                "..............................................................................",
                "..............................................................................",
                "..............................................................................",
                "..............................................................................",
                "..............................................................................",
                "..............................................................................",
                "..............................................................................",
                "..............................................................................",
                "..............................................................................",
                "..............                                                   .............",
                "............                                                       ...........",
                "...........                                                         ..........",
                "..........      ..................................                   .........",
                "..........    .....................................          ....    .........",
                ".........    .......................................        ......    ........",
                ".........    ..|-----|..........|-------------|.....    .|-----|..    ........",
                ".........   ...|::+::|..........O+++++++++++++|....    ..|::+::|...   ........",
                ".........   ...|:+++:|..........|+++++++++++++|...    ...|:+++:|...   ........",
                ".........   ...|+++++------------++|-------|++------------+++++|...   ........",
                ".........   ...|:++++++++++++++++++|#######|++++++++++++++++++:|...   ........",
                ".........   ...|::+++++++++++++++++|::###::|+++++++++++++++++::|...   ........",
                ".........   ...---|++|-------|-+++-|:*#*#*:|-----|---|---|++|---...   ........",
                ".........   ......|++|---O---|+++++|*******|#####|+++-$$$|++|......   ........",
                ".........   ......|++|*#***#*|+++++|*******|#####-+++O*$$|++|......   ........",
                ".........    .....|++|*#***#*|+++++|*******|+++++X+++|**$|++|......   ........",
                ".........    .....|++|*#####*|+++++O*******|+++++X+++|---|++|......   ........",
                ".........     ....|++|*******|--+--|--***--|+++++X+++-**$|++|......   ........",
                ".........      ...|++|--***--|+++++|::+++::|+++++|+++O*$$|++|......   ........",
                ".........       ..|++|+++++++|+++++|:+++++:|+++++|+++|$$$|++|......   ........",
                "..........      ..|++|+##+##+|------+++++++--+++|---|----|++|......   ........",
                "...........      .|++|+++++++|++++++++++++++++++|***|**#*|++|......   ........",
                "...........       |++|+##+##+|++++++++++++++++++|---|**##|++|......   ........",
                "............      |++|+++++++|++++++++++++++++++|********|++|......   ........",
                "............      |++|+##+##+--++|----+++----|++|***|****|++|......   ........",
                "...........      .|++|+++++++++++|:::+++++:::|++-------**|++|......   ........",
                "...........     ..|++|++++++++++:|::+++++++::|+++++++++++|++|......   ........",
                "..........      ..|++|-------|+::|:+++++++++:|+++++++++++|++|......   ........",
                "..........     ...|++|*******|----++++   ++++-------|----|++|......   ........",
                ".........      ...|++|**|---*|+++++++     ++++++++++|++++|++|......   ........",
                ".........     ....|++|**|*#**|+++++++     ++++++++++O++++|++|......   ........",
                ".........     ....|++|**|*#**|+++++++     ++++++++++|++++|++|......   ........",
                ".........    .....|++|**--|**|++++++++   ++++|-------++++|++|......   ........",
                ".........    .....|++|****|**|++++++++++++++:|+++++++++++|++|......   ........",
                ".........   ......|++|--**----+++++++++++++::|+-+++++++++|++|......   ........",
                ".........   ......|++|++++++++++++++++++++:::|+++++++++++|++|......   ........",
                ".........   ......|++|-------------|--+++--|----|+++|----|++|......   ........",
                ".........   ......|++|XXXXXXXXXXXXX|::+++::|#***|+++|***#|++|......   ........",
                ".........   ......|++|X+++++++++++X| :+++: |****|+++|****|++|......   ........",
                ".........   ......|++|X++XXXXXXXX+X|  +++  |--O--+++--O--|++|......   ........",
                ".........   ......|++|X++|-----|X+X|  +++  |+++++++++++++|++|......   ........",
                ".........   ......|++|X++|%%%%%|X+X| :+++: |--O-|+++|-O--|++|......   ........",
                ".........   ......|++|X++|*****|X+X|::+++::|****|+++|****|++|......   ........",
                ".........   ......|++|X++|#####|X+X| :+++: |#***|+++|***#|++|......   ........",
                ".........   ......|++|X++|*****|X+X|  +++  |-----+++-----|++|......   ........",
                ".........   ......|++|X++----**|X+X|  +++  |X+++++++++++%|++|......   ........",
                ".........   ......|++|X++++++++|X+X|  +++  |XX+++++++++%%|++|......   ........",
                ".........   ......|++|XXXXXXXXX|X+X| :+++: |XXX+++++++%%%|++|......   ........",
                ".........   ...|---++-----------X+X|::+++::|XXXX+++++%%%%|XX---|...   ........",
                ".........   ...|::++++++++++++++++X| :+++: |XXXXX+++%%%%%|***$$|...   ........",
                ".........   ...|:+++++++++++++++++X|  +++  |#############|****$|...   ........",
                ".........   ...|+++++|-------------|  +++  |-------------|*****|...   ........",
                ".........   ...|:+++:|.............| :+++: |.............|$***$|...   ........",
                ".........   ...|::+::|.............|::+++::|.............|$$*$$|...   ........",
                ".........    ..-------.............---+++---.............-------..    ........",
                ".........    .....................................................    ........",
                "..........    ...................................................    .........",
                "..........      ......................+++......................      .........",
                "...........                           +++                           ..........",
                "............                          +++                          ...........",
                "..............                        +++                        .............",
                "......................................+++.....................................",
                "..............................................................................",
                "..............................................................................",
                "..............................................................................",
                "..............................................................................",
                "..............................................................................",
                "..............................................................................",
                ".............................................................................."
        };
        String[] castilloEX = {
                "                                                                              ",
                "                                                                              ",
                "                                                                              ",
                "                                                                              ",
                "                                                                              ",
                "                                                                              ",
                "                                                                              ",
                "                                                                              ",
                "                                                 %%%%%%%%%%%%%%%%%%%%%%       ",
                "                                                 %%%%%%%%%%%%%%%%%%%%%%       ",
                "                                                 %%%%%%%%%%%%%%%%%%%%%%       ",
                "                                                 %%%%%%%%%%%%%%%%%%%%%%       ",
                "                              |----------------|%%%%%%%%%%%%%%%%%%%%%%%       ",
                "                              |   ###%%%%###   |%%%%%%%%%%%%%%%%%%%%%%%       ",
                "                              |   ##      ##   |%%%%%%%%%%%%%%%%%%%%%%%       ",
                "                    |------|  |   #  ****  #   |%%%%%%%%%%%%%%%%%%%%%%%       ",
                "                    |******|  |     #****#     |%%%%%%%%%%%%%%%%%%%%%%%       ",
                "       |--------|----******---|     #****#     |---------###%%%%%%%%%%%       ",
                "       |===*****|******||*****|     #****#     |%%%*****O**#%%%%%%%%%%%       ",
                "       |+===****|XX****||*****|    ###**###    |%%******|**#%%%%%%%%%%%       ",
                "       |++|------XX|-----O-|**|    #%%**%%#    |%**|-----###%%%%%%%%%%%       ",
                "       |++|******XX|*******|**|    #%%**%%#    |%****|%%%%%%%%%%%%%%%%%       ",
                "       |++|********|*******|**|    #%%**%%#    |*****|%%%%%%%%%%%%%%%%%       ",
                "       |++|-**------**-|---|**|    ###**###    |*****|%%%%%%%%%%%%%%%%%       ",
                "       |++|#**#%%%%#**#|%%%|**-------****-------**|**|%%%%%%%%%%%%%%%%%       ",
                "       |++|%**%%%%%%***|%%%|**********************|**|%%%%%%%%%%%%%%%%%       ",
                "       |++|%**%|-|%%***|%%%|**********************|XX|%%%%%%%%%%%%%%%%%       ",
                "       |++|**%%|-|%%#**|%%=|-------------|--|-----|XX---|%%%%%%%%%%%%%%       ",
                "       |++|***%---%%***|%==|    *****    |**|=%%%%|XX***|%%%%%%%%%%%%%%       ",
                "       |++|*#*%***%***%|===|             |**|==%%%|*****-----------|--|       ",
                "       |++|%*********#%|===|     ***     |**|===|---||***%#%#%#%-**|%%|       ",
                "       |++|%%*|***|*%%%|+==|    *+++*    |**|===||++||**********O**O*%|       ",
                "       |++|%%%|***|%%%%|++=|    **+***   --O|=+=||++|-***%#%#%#%-**|%%|       ",
                "       |++-----***------+++|    |#+#|*    **|+++||++|***|----------|%%|       ",
                "       |++++++++++++++XX+++|    |+++|*******|+++--++|***-******%%%%|%%|       ",
                "       |++++++++++++++XX+++------#+#---------+++XX++|***********%%%|%%|       ",
                "       --------|-------|+++++++#=+++=#++++++++++XX++|***********%%%|%%|       ",
                "               |%%%%%%||++++++++++++++++++++++++|--------**%%***%%%|%%|       ",
                "          |-----%%%%%%||++++++++++++++++++++++++|++++++++%%%%%***%%|%%|       ",
                "          |*%%%%%%||%%|------------------***----|+++++++%%%%%%***%*|%%|       ",
                "          |**%%*%%||%%|                ##***#   |++--|-|%%%%%%%*****%%|       ",
                "          |%*|-O------|               #*****#   |++++|||%%%%%%***%***%|       ",
                "          |**|%*%%%%%%|               #****#    |++++|||+%%%%%**%%%|---       ",
                "          |**|%%%%%%%%|              #***##     |-|++|||++|---++|---          ",
                "          |*%------|%%|------|    |---***---|   |--++|--++|+++++|             ",
                "          |%%%***%%|%%|******|    |**%******|   |++++|++++|+++++|             ",
                "          |%%%%***%|%%-******|    |*%%%**%**|   |++++|++++|++|---             ",
                "          ------|**|%%%%*||**-####-%%%|-|%%*-###-++|-|++---++|                ",
                "                |*%|%%***||********%%%|-|%%%*****++|||+++++++|                ",
                "                |%%---|---|*******%%%%---%%******++|||+++++++|                ",
                "                |%%%**|----**|####|%%%%*%%%%|###|++----|++|---                ",
                "                |%%%%*|******|    |%%%***%%%|   |+++++||++|                   ",
                "                ---|**|%*****|    |%%*****%%|   |+++++||++|                   ",
                "                   |*%|%%|----    ---|***|---   ---|++--++|                   ",
                "                   |%%|%%|           |***|         |++++++|                   ",
                "                   |%%-%%|           |***|         |++++++|                   ",
                "                   |%%%%%|          #|***|#        --------                   ",
                "                   |%%%%%|          #|***|#                                   ",
                "                   -------            +++                                     ",
                "                                      +++                                     ",
                "                                      +++                                     ",
                "                                      +++                                     ",
                "                                      +++                                     ",
                "                                      +++                                     ",
                "                                      +++                                     ",
                "                                      +++                                     ",
                "                                      +++                                     ",
                "                                      +++                                     ",
                "                                      +++                                     ",
                "                                      +++                                     ",
                "                                      +++                                     ",
                "                                      +++                                     ",
                "                                      +++                                     ",
                "                                      +++                                     ",
                "                                      +++                                     "
        };

        int[] elPersonaje = { 31, 33 };

        inicializarMundo(castilloLB);
        do {
            actualizarTiempo();
            imprimirMundo(castilloLB, elPersonaje);
            verAccion(elPersonaje);
        } while (jugando);
    }

    private static void inicializarMundo(String[] mundo) {

        viewPort = 7;
        alcanceVision = viewPort / 2;

        minFila = 0 + viewPort;
        minColumna = 0 + viewPort;
        maxFila = mundo.length - (viewPort + 1);
        maxColumna = mundo[0].length() - (viewPort + 1);
    }

    static void actualizarTiempo() {

        hora = hora + 0.2;
        if (hora >= 24) {
            hora = 0;
        }
        calculaAlcanceVision();
    }

    static void calculaAlcanceVision() {

        alcanceVision = viewPort * 2;

        if (hora < 1 || hora > 23) {
            alcanceVision = 1;
        } else if (hora < 3 || hora > 21) {
            alcanceVision = alcanceVision / 5;
        } else if (hora < 4 || hora > 20) {
            alcanceVision = alcanceVision / 5 * 2;
        } else if (hora < 5 || hora > 19) {
            alcanceVision = alcanceVision / 5 * 3;
        } else if (hora < 6 || hora > 18) {
            alcanceVision = alcanceVision / 5 * 4;
        }
    }

    static void imprimirMundo(String[] castillo, int[] personaje) {

        String elemento;
        limpiarPantalla();
        imprimirLinea();
        imprimirElCielo();
        imprimirLinea();
        for (int fila = personaje[FILA] - viewPort; fila <= personaje[FILA] + viewPort; fila++) {
            for (int columna = personaje[COLUMNA] - viewPort; columna <= personaje[COLUMNA] + viewPort; columna++) {

                elemento = mapear('P');
                if (!(fila == personaje[FILA] && columna == personaje[COLUMNA])) {
                    elemento = mapear(castillo[fila].charAt(columna));
                }

                if (!(Math.pow((fila - personaje[FILA]), 2) + Math.pow((columna - personaje[COLUMNA]), 2) <= Math.pow(alcanceVision, 2))) {
                    elemento = mapear('D');
                }

                System.out.print(elemento);
            }
            System.out.println();
        }
        imprimirLinea();
        imprimirStatus(personaje);
        imprimirLinea();
    }

    private static void imprimirStatus(int[] personaje) {

        System.out.print("HORA: [" + (int) hora + "] / ");
        System.out.println("POSICION: (" + personaje[FILA] + "," + personaje[COLUMNA] + ")");
    }

    static void imprimirLinea() {

        System.out.println(mapear('B').repeat(viewPort * 2 + 1));
    }

    static String mapear(char elemento) {

        HashMap<String, String> tiles = new HashMap<>();

        tiles.put(" ", BLUE_BOLD_BRIGHT + BLUE_BACKGROUND_BRIGHT + " ~~ " + RESET);
        tiles.put(".", YELLOW_BRIGHT + GREEN_BACKGROUND + " . ." + RESET);
        tiles.put("-", WHITE + WHITE_BACKGROUND + "[##]" + RESET);
        tiles.put("=", BLACK_BACKGROUND_BRIGHT + "||||" + RESET);
        tiles.put("|", WHITE + WHITE_BACKGROUND + "[##]" + RESET);
        tiles.put(":", YELLOW_BRIGHT + GREEN_BACKGROUND + "oO*o" + RESET);
        tiles.put("+", GREEN_BOLD + YELLOW_BACKGROUND + "..:." + RESET);
        tiles.put("O", WHITE_BACKGROUND_BRIGHT + "[  ]" + RESET);
        tiles.put("#", BLACK + RED_BACKGROUND + "::::" + RESET);
        tiles.put("*", YELLOW + YELLOW_BACKGROUND + "    " + RESET);
        tiles.put("$", RED_BRIGHT + YELLOW_BACKGROUND + "$$$$" + RESET);
        tiles.put("X", RED_UNDERLINED + YELLOW_BACKGROUND + "||||" + RESET);
        tiles.put("%", GREEN_BOLD + YELLOW_BACKGROUND + "%%%%" + RESET);
        tiles.put("_", BLACK + "____" + RESET);
        tiles.put("~", BLUE_BACKGROUND_BRIGHT + " ~ ~" + RESET);
        tiles.put("B", BLUE + BLUE_BACKGROUND + "====" + RESET);
        tiles.put("P", RED + "_()_" + RESET);
        tiles.put("D", BLACK_BACKGROUND_BRIGHT + "    " + RESET);
        tiles.put("S", YELLOW_BOLD_BRIGHT + BLUE_BACKGROUND + " () " + RESET);
        tiles.put("C", BLUE_BACKGROUND + "    " + RESET);

        return tiles.get("" + elemento);
    }

    static void mover(int[] unPersonaje, int direccion) {

        unPersonaje[FILA] += MOVIMIENTO[direccion][FILA];
        unPersonaje[COLUMNA] += MOVIMIENTO[direccion][COLUMNA];

        if (unPersonaje[FILA] < minFila) {
            unPersonaje[FILA] = unPersonaje[FILA] + 1;
        }
        if (unPersonaje[FILA] > maxFila) {
            unPersonaje[FILA] = unPersonaje[FILA] - 1;
        }
        if (unPersonaje[COLUMNA] < minColumna) {
            unPersonaje[COLUMNA] = unPersonaje[COLUMNA] + 1;
        }
        if (unPersonaje[COLUMNA] > maxColumna) {
            unPersonaje[COLUMNA] = unPersonaje[COLUMNA] - 1;
        }
    }

    static void verAccion(int[] elPersonaje) {

        switch (capturarMovimiento()) {
            case ARRIBA:
                mover(elPersonaje, ARRIBA);
                break;
            case ABAJO:
                mover(elPersonaje, ABAJO);
                break;
            case IZQUIERDA:
                mover(elPersonaje, IZQUIERDA);
                break;
            case DERECHA:
                mover(elPersonaje, DERECHA);
                break;
            case SALIR:
                jugando = !jugando;
                break;
            case NADA:
                break;
        }
    }

    static int capturarMovimiento() {

        switch (pedirChar()) {
            case 's', 'S', '8':
                return ABAJO;
            case 'w', 'W', '2':
                return ARRIBA;
            case 'a', 'A', '4':
                return IZQUIERDA;
            case 'd', 'D', '6':
                return DERECHA;
            case 'f', 'F':
                return SALIR;
        }
        return NADA;
    }

    static char pedirChar() {

        Scanner entrada = new Scanner(System.in);
        String inputUsuario = entrada.nextLine() + "x"; // Este es un caso que justifica un comentario!
        return inputUsuario.charAt(0); // Lo comentamos en clase ;)
    }

    static void limpiarPantalla() {

        System.out.print("\033[H\033[2J");
        System.out.flush();
    }

    static void imprimirElCielo() {

        int posicionDelSolEnElCielo = (int) (((viewPort * 2)) - ((hora - 7) * (viewPort * 2) / 12));
        for (int i = 0; i < viewPort * 2 + 1; i = i + 1) {
            if ((hora > 6) && (hora <= 18) && (i == posicionDelSolEnElCielo)) {
                System.out.print(mapear('S'));
            } else {
                System.out.print(mapear('C'));
            }
        }
        System.out.println();
    }

    public static final String RESET = "\033[0m";

    public static final String BLACK = "\033[0;30m";
    public static final String RED = "\033[0;31m";
    public static final String GREEN = "\033[0;32m";
    public static final String YELLOW = "\033[0;33m";
    public static final String BLUE = "\033[0;34m";
    public static final String PURPLE = "\033[0;35m";
    public static final String CYAN = "\033[0;36m";
    public static final String WHITE = "\033[0;37m";

    public static final String BLACK_BOLD = "\033[1;30m";
    public static final String RED_BOLD = "\033[1;31m";
    public static final String GREEN_BOLD = "\033[1;32m";
    public static final String YELLOW_BOLD = "\033[1;33m";
    public static final String BLUE_BOLD = "\033[1;34m";
    public static final String PURPLE_BOLD = "\033[1;35m";
    public static final String CYAN_BOLD = "\033[1;36m";
    public static final String WHITE_BOLD = "\033[1;37m";

    public static final String BLACK_UNDERLINED = "\033[4;30m";
    public static final String RED_UNDERLINED = "\033[4;31m";
    public static final String GREEN_UNDERLINED = "\033[4;32m";
    public static final String YELLOW_UNDERLINED = "\033[4;33m";
    public static final String BLUE_UNDERLINED = "\033[4;34m";
    public static final String PURPLE_UNDERLINED = "\033[4;35m";
    public static final String CYAN_UNDERLINED = "\033[4;36m";
    public static final String WHITE_UNDERLINED = "\033[4;37m";

    public static final String BLACK_BACKGROUND = "\033[40m";
    public static final String RED_BACKGROUND = "\033[41m";
    public static final String GREEN_BACKGROUND = "\033[42m";
    public static final String YELLOW_BACKGROUND = "\033[43m";
    public static final String BLUE_BACKGROUND = "\033[44m";
    public static final String PURPLE_BACKGROUND = "\033[45m";
    public static final String CYAN_BACKGROUND = "\033[46m";
    public static final String WHITE_BACKGROUND = "\033[47m";

    public static final String BLACK_BRIGHT = "\033[0;90m";
    public static final String RED_BRIGHT = "\033[0;91m";
    public static final String GREEN_BRIGHT = "\033[0;92m";
    public static final String YELLOW_BRIGHT = "\033[0;93m";
    public static final String BLUE_BRIGHT = "\033[0;94m";
    public static final String PURPLE_BRIGHT = "\033[0;95m";
    public static final String CYAN_BRIGHT = "\033[0;96m";
    public static final String WHITE_BRIGHT = "\033[0;97m";

    public static final String BLACK_BOLD_BRIGHT = "\033[1;90m";
    public static final String RED_BOLD_BRIGHT = "\033[1;91m";
    public static final String GREEN_BOLD_BRIGHT = "\033[1;92m";
    public static final String YELLOW_BOLD_BRIGHT = "\033[1;93m";
    public static final String BLUE_BOLD_BRIGHT = "\033[1;94m";
    public static final String PURPLE_BOLD_BRIGHT = "\033[1;95m";
    public static final String CYAN_BOLD_BRIGHT = "\033[1;96m";
    public static final String WHITE_BOLD_BRIGHT = "\033[1;97m";

    public static final String BLACK_BACKGROUND_BRIGHT = "\033[0;100m";
    public static final String RED_BACKGROUND_BRIGHT = "\033[0;101m";
    public static final String GREEN_BACKGROUND_BRIGHT = "\033[0;102m";
    public static final String YELLOW_BACKGROUND_BRIGHT = "\033[0;103m";
    public static final String BLUE_BACKGROUND_BRIGHT = "\033[0;104m";
    public static final String PURPLE_BACKGROUND_BRIGHT = "\033[0;105m";
    public static final String CYAN_BACKGROUND_BRIGHT = "\033[0;106m";
    public static final String WHITE_BACKGROUND_BRIGHT = "\033[0;107m";
}