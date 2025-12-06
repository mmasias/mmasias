// Array de las 12 notas para el cálculo de intervalos
const notasBase = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];

/**
 * Función que calcula la nota raíz del acorde en base al desplazamiento de semitonos.
 * @param {string} tonica - La nota tónica.
 * @param {number} desplazamiento - El número de semitonos desde la tónica.
 * @returns {string} La nota raíz del acorde.
 */
function calcularNota(tonica, desplazamiento) {
    let indiceTonica = -1;
    for (let i = 0; i < notasBase.length; i++) {
        if (notasBase[i] === tonica) {
            indiceTonica = i;
            break;
        }
    }
    
    const indiceAcorde = (indiceTonica + desplazamiento) % notasBase.length;
    return notasBase[indiceAcorde];
}

/**
 * Función que genera el acorde con su calidad (mayor, menor, disminuido).
 * @param {string} nota - La nota raíz.
 * @param {string} calidad - La calidad ("Mayor", "Menor", "Disminuido", "Dominante7").
 * @returns {string} El acorde formateado.
 */
function generarAcorde(nota, calidad) {
    if (calidad === "Menor") {
        return nota + "m";
    } else if (calidad === "Disminuido") {
        return nota + "°";
    } else if (calidad === "Dominante7") {
        return nota + "7";
    } else {
        return nota; // Mayor o Tónica
    }
}

/**
 * Función principal para generar la tabla de vectores armónicos.
 */
function calcularAcordesAvanzados() {
    const tonica = document.getElementById('tonica').value;
    const resultadoDiv = document.getElementById('resultado');
    
    // Grados Diatónicos (I, II, III, IV, V, VI, VII)
    const gradosDiatonicos = [
        [0, "Mayor", "Tónica (I)", false],
        [2, "Menor", "Subdominante (II)", false],
        [4, "Menor", "Mediante (III)", false],
        [5, "Mayor", "Subdominante (IV)", false],
        [7, "Mayor", "Dominante (V)", false],
        [9, "Menor", "Tónica Menor (VI)", false],
        [11, "Disminuido", "Dominante Auxiliar (VII)", false]
    ];

    // Definición de los Dominantes Secundarios clave (V/X): Desplazamiento absoluto desde la Tónica (I).
    const dominantesSecundarios = [
        // V/II (A7 en C): Desplazamiento = 9
        [9, "Dominante7", "Dominante Secundario (V/II)", true, "II"], 
        // V/IV (C7 en C): Desplazamiento = 0
        [0, "Dominante7", "Dominante Secundario (V/IV)", true, "IV"], 
        // V/VI (E7 en C): Desplazamiento = 4
        [4, "Dominante7", "Dominante Secundario (V/VI)", true, "VI"]
    ];
    
    // 1. Calcular todos los acordes necesarios (diatónicos + secundarios)
    const todosLosAcordes = gradosDiatonicos.concat(dominantesSecundarios);
    const acordesCalculados = [];

    for (let i = 0; i < todosLosAcordes.length; i++) {
        const [desplazamiento, calidad, funcion, esSecundario, resuelveEnGrado] = todosLosAcordes[i];
        
        // Simplemente usa el desplazamiento directo (posición absoluta)
        const notaRaiz = calcularNota(tonica, desplazamiento); 

        const nombreAcorde = generarAcorde(notaRaiz, calidad);

        acordesCalculados.push({
            notaRaiz,
            nombre: nombreAcorde,
            funcion: funcion,
            esSecundario: esSecundario,
            resuelveEn: resuelveEnGrado || "" 
        });
    }

    // 2. Generar la estructura HTML de la tabla con el nuevo orden de columnas
    let tablaHTML = `<h3>Tonalidad de **${tonica}** Mayor: Vectores Armónicos</h3>`;
    tablaHTML += `<table cellspacing="0" cellpadding="8">`;
    tablaHTML += `
        <thead>
            <tr style="background-color: #007bff; color: white;">
                <th>De dónde se viene (Entrantes) <--</th>
                <th>Acorde (Nodo)</th>
                <th>Función Primaria</th>
                <th>A dónde progresa (Salientes Fuertes) --></th>
            </tr>
        </thead>
        <tbody>
    `;
    
    // 3. Rellenar las filas de la tabla con la lógica de progresión
    for (let i = 0; i < acordesCalculados.length; i++) {
        const acorde = acordesCalculados[i];
        let progresionSaliente = "";
        let progresionEntrante = "";
        const claseFila = acorde.esSecundario ? 'secundario-row' : '';

        // Obtenemos los acordes necesarios para la lógica V -> I
        const acorde_I = generarAcorde(calcularNota(tonica, 0), "Mayor"); 
        const acorde_II = generarAcorde(calcularNota(tonica, 2), "Menor"); 
        const acorde_IV = generarAcorde(calcularNota(tonica, 5), "Mayor"); 
        const acorde_V = generarAcorde(calcularNota(tonica, 7), "Dominante7"); 
        const acorde_VI = generarAcorde(calcularNota(tonica, 9), "Menor"); 
        const acorde_VII = generarAcorde(calcularNota(tonica, 11), "Disminuido");
        
        // Dominantes secundarios calculados
        const acorde_A7 = generarAcorde(calcularNota(tonica, 9), "Dominante7"); // V/II
        const acorde_C7 = generarAcorde(calcularNota(tonica, 0), "Dominante7"); // V/IV
        const acorde_E7 = generarAcorde(calcularNota(tonica, 4), "Dominante7"); // V/VI

        // Lógica de Progresión Saliente y Entrante
        if (acorde.esSecundario) {
            if (acorde.resuelveEn === "II") {
                progresionSaliente = acorde.nombre + " -> " + acorde_II + " (Res. a II)";
                progresionEntrante = acorde_IV + ", " + acorde_V;
            } else if (acorde.resuelveEn === "IV") {
                progresionSaliente = acorde.nombre + " -> " + acorde_IV + " (Res. a IV)";
                progresionEntrante = acorde_I + ", " + acorde_V;
            } else if (acorde.resuelveEn === "VI") {
                progresionSaliente = acorde.nombre + " -> " + acorde_VI + " (Res. a VI)";
                progresionEntrante = acorde_V + ", " + acorde_I;
            }
            
        } else if (acorde.funcion.includes("Tónica (I)")) { 
            progresionSaliente = acorde.nombre + " -> " + acorde_IV + " / " + acorde_VI;
            progresionEntrante = acorde_V + ", " + acorde_VII;
        } else if (acorde.funcion.includes("Subdominante (II)")) { 
            progresionSaliente = acorde.nombre + " -> " + acorde_V;
            progresionEntrante = acorde_VI + ", " + acorde_I + ", " + acorde_A7; 
        } else if (acorde.funcion.includes("Subdominante (IV)")) { 
            progresionSaliente = acorde.nombre + " -> " + acorde_V;
            progresionEntrante = acorde_I + ", " + acorde_II + ", " + acorde_C7;
        } else if (acorde.funcion.includes("Dominante (V)")) { 
            progresionSaliente = acorde.nombre + " -> **" + acorde_I + "** (Res. Principal)";
            progresionEntrante = acorde_II + ", " + acorde_IV + ", " + acorde_VII;
        } else if (acorde.funcion.includes("Tónica Menor (VI)")) { 
            progresionSaliente = acorde.nombre + " -> " + acorde_II;
            progresionEntrante = acorde_I + ", " + acorde_E7;
        } else if (acorde.funcion.includes("Dominante Auxiliar (VII)")) { 
            progresionSaliente = acorde.nombre + " -> " + acorde_I + " (Tensión)";
            progresionEntrante = acorde_V + ", " + acorde_I;
        } else {
            progresionSaliente = "Varias (Movimiento Débil)";
            progresionEntrante = acorde_I + ", " + acorde_V;
        }

        // Inserción de la fila con el nuevo orden y negrita en el nodo
        tablaHTML += `
            <tr class="${claseFila}">
                <td>${progresionEntrante}</td>
                <td>**${acorde.nombre}**</td>
                <td>${acorde.funcion}</td>
                <td>${progresionSaliente}</td>
            </tr>
        `;
    }
    
    tablaHTML += `
        </tbody>
        </table>
        <p style="margin-top: 15px;">Las filas en **rojo pálido** son Dominantes Secundarios, que actúan como "puentes" fuera de la tonalidad principal para crear modulación.</p>
    `;

    resultadoDiv.innerHTML = tablaHTML;
}