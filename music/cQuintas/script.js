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
 * Función que genera el acorde con su calidad (mayor, menor, disminuido, dominante).
 * NOTA: Esta función ahora solo devuelve el texto sin negritas.
 * @param {string} nota - La nota raíz.
 * @param {string} calidad - La calidad.
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
        [0, "Mayor", "Tónica (I)", false, "I"],
        [2, "Menor", "Subdominante (II)", false, "II"],
        [4, "Menor", "Mediante (III)", false, "III"],
        [5, "Mayor", "Subdominante (IV)", false, "IV"],
        [7, "Mayor", "Dominante (V)", false, "V"],
        [9, "Menor", "Tónica Menor (VI)", false, "VI"],
        [11, "Disminuido", "Dominante Auxiliar (VII)", false, "VII"]
    ];

    // Dominantes Secundarios (V/X): Desplazamiento absoluto desde la Tónica (I).
    const dominantesSecundarios = [
        [9, "Dominante7", "Dominante Secundario (V/II)", true, "V/II"], 
        [0, "Dominante7", "Dominante Secundario (V/IV)", true, "V/IV"], 
        [4, "Dominante7", "Dominante Secundario (V/VI)", true, "V/VI"]
    ];
    
    // Acordes Alterados (IVm y SubV7)
    const acordesAlterados = [
        [5, "Menor", "Subdominante Alterado (IVm)", true, "IVm"],
        [1, "Dominante7", "Sustituto Dominante (SubV7)", true, "SubV7"] 
    ];

    // 1. Calcular todos los acordes necesarios
    const todosLosAcordes = gradosDiatonicos.concat(dominantesSecundarios).concat(acordesAlterados);
    const acordesCalculados = [];

    for (let i = 0; i < todosLosAcordes.length; i++) {
        const [desplazamiento, calidad, funcion, esSecundario, gradoFormal] = todosLosAcordes[i];
        
        const notaRaiz = calcularNota(tonica, desplazamiento); 

        // Generamos el nombre del acorde SIN negrita aquí
        const nombreAcorde = generarAcorde(notaRaiz, calidad);

        acordesCalculados.push({
            notaRaiz,
            nombre: nombreAcorde,
            funcion: funcion,
            esSecundario: esSecundario,
            gradoFormal: gradoFormal 
        });
    }

    // 2. Generar la estructura HTML de la tabla
    let tablaHTML = `<h3>Tonalidad de ${tonica} Mayor: Vectores Armónicos</h3>`;
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
        
        // Asignación de clases CSS para diferenciar visualmente los tipos de acordes
        let claseFila = '';

        // Separador entre acordes diatónicos (I-VII) y cromáticos
        if (i === 7) {
            claseFila = 'separador-cromaticos';
        }

        if (acorde.gradoFormal === "IVm") {
            claseFila += (claseFila ? ' ' : '') + 'modal-row';
        } else if (acorde.gradoFormal === "SubV7") {
            claseFila += (claseFila ? ' ' : '') + 'tritone-row';
        } else if (acorde.gradoFormal.startsWith("V/")) {
            claseFila += (claseFila ? ' ' : '') + 'secundario-row';
        }

        // Obtención de grados para el flujo. Se usa generarAcorde() para obtener el nombre SIN negrita.
        const acorde_I = generarAcorde(calcularNota(tonica, 0), "Mayor"); 
        const acorde_II = generarAcorde(calcularNota(tonica, 2), "Menor"); 
        const acorde_IV = generarAcorde(calcularNota(tonica, 5), "Mayor"); 
        const acorde_V = generarAcorde(calcularNota(tonica, 7), "Dominante7"); 
        const acorde_VI = generarAcorde(calcularNota(tonica, 9), "Menor"); 
        const acorde_VII = generarAcorde(calcularNota(tonica, 11), "Disminuido");
        
        // Acordes Alterados
        const acorde_V_II = generarAcorde(calcularNota(tonica, 9), "Dominante7"); 
        const acorde_V_IV = generarAcorde(calcularNota(tonica, 0), "Dominante7"); 
        const acorde_V_VI = generarAcorde(calcularNota(tonica, 4), "Dominante7"); 
        const acorde_IVm = generarAcorde(calcularNota(tonica, 5), "Menor"); 
        const acorde_SubV7 = generarAcorde(calcularNota(tonica, 1), "Dominante7"); 

        // Lógica de Progresión
        if (acorde.gradoFormal === "SubV7") {
            progresionSaliente = acorde.nombre + " -> " + acorde_I + " (Res. Cromática) / " + acorde_IV;
            progresionEntrante = acorde_II + ", " + acorde_IV + ", " + acorde_V; 
        } else if (acorde.gradoFormal === "IVm") {
            progresionSaliente = acorde.nombre + " -> " + acorde_V + " / " + acorde_I;
            progresionEntrante = acorde_I + ", " + acorde_VI;
            
        } else if (acorde.gradoFormal.startsWith("V/")) {
            if (acorde.gradoFormal === "V/II") {
                progresionSaliente = acorde.nombre + " -> " + acorde_II + " (Res. a II)";
                progresionEntrante = acorde_IV + ", " + acorde_V;
            } else if (acorde.gradoFormal === "V/IV") {
                progresionSaliente = acorde.nombre + " -> " + acorde_IV + " (Res. a IV)";
                progresionEntrante = acorde_I + ", " + acorde_V;
            } else if (acorde.gradoFormal === "V/VI") {
                progresionSaliente = acorde.nombre + " -> " + acorde_VI + " (Res. a VI)";
                progresionEntrante = acorde_V + ", " + acorde_I;
            }
            
        } else if (acorde.gradoFormal === "I") { 
            // CORRECCIÓN AQUÍ: Se elimina el ** del acorde_IV y acorde_VI.
            progresionSaliente = acorde.nombre + " -> " + acorde_IV + " / " + acorde_VI + " / " + acorde_IVm;
            progresionEntrante = acorde_V + ", " + acorde_VII + ", " + acorde_SubV7; 
        } else if (acorde.gradoFormal === "II") { 
            progresionSaliente = acorde.nombre + " -> " + acorde_V + " / " + acorde_SubV7;
            progresionEntrante = acorde_VI + ", " + acorde_I + ", " + acorde_V_II; 
        } else if (acorde.gradoFormal === "IV") { 
            progresionSaliente = acorde.nombre + " -> " + acorde_V + " / " + acorde_SubV7;
            progresionEntrante = acorde_I + ", " + acorde_II + ", " + acorde_V_IV + ", " + acorde_SubV7;
        } else if (acorde.gradoFormal === "V") { 
            // CORRECCIÓN AQUÍ: Se elimina el ** del acorde_I.
            progresionSaliente = acorde.nombre + " -> " + acorde_I + " (Res. Principal)";
            progresionEntrante = acorde_II + ", " + acorde_IV + ", " + acorde_VII + ", " + acorde_IVm;
        } else if (acorde.gradoFormal === "VI") { 
            progresionSaliente = acorde.nombre + " -> " + acorde_II + " / " + acorde_IVm;
            progresionEntrante = acorde_I + ", " + acorde_V_VI;
        } else if (acorde.gradoFormal === "VII") { 
            progresionSaliente = acorde.nombre + " -> " + acorde_I + " (Tensión)";
            progresionEntrante = acorde_V + ", " + acorde_I;
        } else {
             // III (Mediante)
            progresionSaliente = "Varias (Movimiento Débil a VIm o IV)";
            progresionEntrante = acorde_I + ", " + acorde_V;
        }

        // 4. Inserción de la fila: Negrita SOLO en el Acorde (Nodo) central
        tablaHTML += `
            <tr class="${claseFila}">
                <td>${progresionEntrante}</td>
                <td><strong>${acorde.nombre}</strong></td>
                <td>${acorde.funcion}</td>
                <td>${progresionSaliente}</td>
            </tr>
        `;
    }
    
    tablaHTML += `
        </tbody>
        </table>
        <p style="margin-top: 15px;">Las filas en rojo pálido son Dominantes Secundarios. Las filas en verde pálido son Acordes de Intercambio Modal (IVm). Las filas en azul claro son Sustitutos Dominantes (SubV7).</p>
    `;

    resultadoDiv.innerHTML = tablaHTML;
}