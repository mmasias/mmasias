// Array de las 12 notas para el cálculo de intervalos
const notasBase = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];

// Estado global para navegación
let acordeActual = null;
let enModoNavegacion = false;
let historialProgresion = []; // Array de acordes visitados

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
 * Función que envuelve un acorde en un elemento clickeable.
 * @param {string} nombreAcorde - El nombre del acorde (ej: "C", "Dm", "G7").
 * @returns {string} El HTML del acorde clickeable.
 */
function hacerAcordeClickeable(nombreAcorde) {
    return `<a href="#" class="acorde-link" onclick="navegarAcorde('${nombreAcorde}'); return false;">${nombreAcorde}</a>`;
}

/**
 * Función que convierte todos los acordes en un texto a enlaces clickeables.
 * @param {string} texto - Texto que puede contener nombres de acordes.
 * @returns {string} El texto con acordes convertidos en enlaces.
 */
function hacerAcordesClickeablesEnTexto(texto) {
    // Regex para detectar acordes: Nota + (#)? + (m|°|7)?
    // Usa lookahead/lookbehind para manejar correctamente el #
    const regexAcorde = /([A-G](#)?(m|°|7)?)/g;

    return texto.replace(regexAcorde, (match) => {
        // Verificar que realmente es un acorde válido y no parte de otra palabra
        if (match.match(/^[A-G](#)?(m|°|7)?$/)) {
            return hacerAcordeClickeable(match);
        }
        return match;
    });
}

/**
 * Función que navega a un acorde específico.
 * @param {string} nombreAcorde - El nombre del acorde al que navegar.
 */
function navegarAcorde(nombreAcorde) {
    // Agregar el acorde actual al historial ANTES de cambiar
    if (acordeActual && acordeActual !== nombreAcorde) {
        historialProgresion.push(acordeActual);
    }

    acordeActual = nombreAcorde;
    enModoNavegacion = true;
    actualizarInterfaz();
    actualizarHistorialDisplay();
    generarMapaArmonico();
}

/**
 * Función que inicia la navegación o resetea el estado.
 */
function iniciarOResetear() {
    if (enModoNavegacion) {
        // Resetear
        acordeActual = null;
        enModoNavegacion = false;
        historialProgresion = [];
        actualizarInterfaz();
        actualizarHistorialDisplay();
    } else {
        // Iniciar navegación - establecer acordeActual al valor del selector
        const tonica = document.getElementById('tonica').value;
        const modo = document.getElementById('modo').value;

        // Generar el acorde inicial según el modo
        if (modo === "Mayor") {
            acordeActual = tonica; // Acorde mayor (sin sufijo)
        } else {
            acordeActual = tonica + "m"; // Acorde menor
        }

        enModoNavegacion = true;
        actualizarInterfaz();
        actualizarHistorialDisplay();
    }
    generarMapaArmonico();
}

/**
 * Función que vuelve al acorde anterior en el historial.
 */
function volverAtras() {
    if (historialProgresion.length > 0) {
        // Quitar el último acorde del historial y usarlo como nuevo acorde actual
        acordeActual = historialProgresion.pop();
        actualizarInterfaz();
        actualizarHistorialDisplay();
        generarMapaArmonico();
    }
}

/**
 * Actualiza el display visual del historial de progresión.
 */
function actualizarHistorialDisplay() {
    const historialDiv = document.getElementById('historial');
    const btnVolverAtras = document.getElementById('btnVolverAtras');

    if (historialProgresion.length > 0 || acordeActual) {
        // Crear la cadena de progresión
        let progresion = '';
        if (historialProgresion.length > 0) {
            progresion = historialProgresion.join(' → ');
        }
        if (acordeActual) {
            if (progresion) {
                progresion += ' → <strong>' + acordeActual + '</strong>';
            } else {
                progresion = '<strong>' + acordeActual + '</strong>';
            }
        }

        historialDiv.innerHTML = '<p style="margin-top: 15px; font-size: 18px;">Progresión actual: ' + progresion + '</p>';

        // Habilitar/deshabilitar botón volver atrás
        if (btnVolverAtras) {
            btnVolverAtras.disabled = historialProgresion.length === 0;
        }
    } else {
        historialDiv.innerHTML = '';
        if (btnVolverAtras) {
            btnVolverAtras.disabled = true;
        }
    }
}

/**
 * Actualiza la interfaz según el estado de navegación.
 */
function actualizarInterfaz() {
    const btnGenerar = document.getElementById('btnGenerar');
    const selectorTonica = document.getElementById('tonica');

    if (enModoNavegacion) {
        btnGenerar.textContent = 'Nueva Progresión / Reiniciar';
        // Actualizar selector si hay acorde actual
        if (acordeActual) {
            const notaRaiz = extraerNotaRaiz(acordeActual);
            selectorTonica.value = notaRaiz;
        }
    } else {
        btnGenerar.textContent = 'Generar Mapa Armónico';
    }
}

/**
 * Extrae la nota raíz de un nombre de acorde.
 * @param {string} nombreAcorde - El nombre completo del acorde (ej: "Dm", "G7", "F#").
 * @returns {string} La nota raíz (ej: "D", "G", "F#").
 */
function extraerNotaRaiz(nombreAcorde) {
    // Regex para capturar la nota raíz (letra + sostenido opcional)
    const match = nombreAcorde.match(/^([A-G](#)?)/);
    return match ? match[1] : nombreAcorde;
}

/**
 * Función principal para generar el mapa armónico.
 */
function generarMapaArmonico() {
    // Usar acordeActual si existe, sino usar el selector
    let tonica;
    if (acordeActual) {
        tonica = extraerNotaRaiz(acordeActual);
    } else {
        tonica = document.getElementById('tonica').value;
    }

    const resultadoDiv = document.getElementById('resultado');
    const modo = document.getElementById('modo').value;

    // Grados Diatónicos según el modo
    let gradosDiatonicos, dominantesSecundarios, acordesAlterados;

    if (modo === "Mayor") {
        // Grados Diatónicos Mayor (I, II, III, IV, V, VI, VII)
        gradosDiatonicos = [
            [0, "Mayor", "Tónica (I)", false, "I"],
            [2, "Menor", "Supertónica (II)", false, "II"],
            [4, "Menor", "Mediante (III)", false, "III"],
            [5, "Mayor", "Subdominante (IV)", false, "IV"],
            [7, "Dominante7", "Dominante (V)", false, "V"],
            [9, "Menor", "Superdominante (VI)", false, "VI"],
            [11, "Disminuido", "Sensible (VII)", false, "VII"]
        ];

        // Dominantes Secundarios (V/X): Desplazamiento absoluto desde la Tónica (I).
        dominantesSecundarios = [
            [9, "Dominante7", "Dominante Secundario (V/II)", true, "V/II"],
            [0, "Dominante7", "Dominante Secundario (V/IV)", true, "V/IV"],
            [4, "Dominante7", "Dominante Secundario (V/VI)", true, "V/VI"]
        ];

        // Acordes Alterados (IVm y SubV7)
        acordesAlterados = [
            [5, "Menor", "Subdominante Menor (IVm)", true, "IVm"],
            [1, "Dominante7", "Sustituto Dominante (SubV7)", true, "SubV7"]
        ];
    } else {
        // Grados Diatónicos Menor Natural (i, ii°, III, iv, v, VI, VII)
        gradosDiatonicos = [
            [0, "Menor", "Tónica (i)", false, "i"],
            [2, "Disminuido", "Supertónica (ii°)", false, "ii°"],
            [3, "Mayor", "Mediante (III)", false, "III"],
            [5, "Menor", "Subdominante (iv)", false, "iv"],
            [7, "Menor", "Dominante (v)", false, "v"],
            [8, "Mayor", "Superdominante (VI)", false, "VI"],
            [10, "Mayor", "Subtónica (VII)", false, "VII"]
        ];

        // Dominantes Secundarios en menor
        dominantesSecundarios = [
            [3, "Dominante7", "Dominante Secundario (V/III)", true, "V/III"],
            [8, "Dominante7", "Dominante Secundario (V/VI)", true, "V/VI"],
            [10, "Dominante7", "Dominante Secundario (V/VII)", true, "V/VII"]
        ];

        // Acordes Alterados en menor (V7 mayor, iv Mayor)
        acordesAlterados = [
            [7, "Dominante7", "Dominante Mayor (V7)", true, "V7"],
            [5, "Mayor", "Subdominante Mayor (IV)", true, "IV"]
        ];
    }

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
    const nombreModo = modo === "Mayor" ? "Mayor" : "Menor Natural";
    let tablaHTML = `<h3>Mapa Armónico de ${tonica} ${nombreModo}</h3>`;
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

        // Asignar colores según tipo de acorde
        if (modo === "Mayor") {
            if (acorde.gradoFormal === "IVm") {
                claseFila += (claseFila ? ' ' : '') + 'modal-row';
            } else if (acorde.gradoFormal === "SubV7") {
                claseFila += (claseFila ? ' ' : '') + 'tritone-row';
            } else if (acorde.gradoFormal.startsWith("V/")) {
                claseFila += (claseFila ? ' ' : '') + 'secundario-row';
            }
        } else {
            // Menor
            if (acorde.gradoFormal === "IV") {
                claseFila += (claseFila ? ' ' : '') + 'modal-row';
            } else if (acorde.gradoFormal === "V7") {
                claseFila += (claseFila ? ' ' : '') + 'tritone-row';
            } else if (acorde.gradoFormal.startsWith("V/")) {
                claseFila += (claseFila ? ' ' : '') + 'secundario-row';
            }
        }

        // Obtención de grados para el flujo según el modo
        let grados = {};

        if (modo === "Mayor") {
            grados = {
                I: generarAcorde(calcularNota(tonica, 0), "Mayor"),
                II: generarAcorde(calcularNota(tonica, 2), "Menor"),
                III: generarAcorde(calcularNota(tonica, 4), "Menor"),
                IV: generarAcorde(calcularNota(tonica, 5), "Mayor"),
                V: generarAcorde(calcularNota(tonica, 7), "Dominante7"),
                VI: generarAcorde(calcularNota(tonica, 9), "Menor"),
                VII: generarAcorde(calcularNota(tonica, 11), "Disminuido"),
                V_II: generarAcorde(calcularNota(tonica, 9), "Dominante7"),
                V_IV: generarAcorde(calcularNota(tonica, 0), "Dominante7"),
                V_VI: generarAcorde(calcularNota(tonica, 4), "Dominante7"),
                IVm: generarAcorde(calcularNota(tonica, 5), "Menor"),
                SubV7: generarAcorde(calcularNota(tonica, 1), "Dominante7")
            };
        } else {
            // Menor Natural
            grados = {
                i: generarAcorde(calcularNota(tonica, 0), "Menor"),
                ii: generarAcorde(calcularNota(tonica, 2), "Disminuido"),
                III: generarAcorde(calcularNota(tonica, 3), "Mayor"),
                iv: generarAcorde(calcularNota(tonica, 5), "Menor"),
                v: generarAcorde(calcularNota(tonica, 7), "Menor"),
                VI: generarAcorde(calcularNota(tonica, 8), "Mayor"),
                VII: generarAcorde(calcularNota(tonica, 10), "Mayor"),
                V_III: generarAcorde(calcularNota(tonica, 3), "Dominante7"),
                V_VI: generarAcorde(calcularNota(tonica, 8), "Dominante7"),
                V_VII: generarAcorde(calcularNota(tonica, 10), "Dominante7"),
                V7: generarAcorde(calcularNota(tonica, 7), "Dominante7"),
                IV: generarAcorde(calcularNota(tonica, 5), "Mayor")
            };
        } 

        // Lógica de Progresión según el modo
        if (modo === "Mayor") {
            // Progresiones para Mayor
            if (acorde.gradoFormal === "SubV7") {
                progresionSaliente = acorde.nombre + " -> " + grados.I + " (Res. Cromática) / " + grados.IV;
                progresionEntrante = grados.II + ", " + grados.IV + ", " + grados.V;
            } else if (acorde.gradoFormal === "IVm") {
                progresionSaliente = acorde.nombre + " -> " + grados.V + " / " + grados.I;
                progresionEntrante = grados.I + ", " + grados.VI;
            } else if (acorde.gradoFormal === "V/II") {
                progresionSaliente = acorde.nombre + " -> " + grados.II + " (Res. a II)";
                progresionEntrante = grados.IV + ", " + grados.V;
            } else if (acorde.gradoFormal === "V/IV") {
                progresionSaliente = acorde.nombre + " -> " + grados.IV + " (Res. a IV)";
                progresionEntrante = grados.I + ", " + grados.V;
            } else if (acorde.gradoFormal === "V/VI") {
                progresionSaliente = acorde.nombre + " -> " + grados.VI + " (Res. a VI)";
                progresionEntrante = grados.V + ", " + grados.I;
            } else if (acorde.gradoFormal === "I") {
                progresionSaliente = acorde.nombre + " -> " + grados.IV + " / " + grados.VI + " / " + grados.IVm;
                progresionEntrante = grados.V + ", " + grados.VII + ", " + grados.SubV7;
            } else if (acorde.gradoFormal === "II") {
                progresionSaliente = acorde.nombre + " -> " + grados.V + " / " + grados.SubV7;
                progresionEntrante = grados.VI + ", " + grados.I + ", " + grados.V_II;
            } else if (acorde.gradoFormal === "IV") {
                progresionSaliente = acorde.nombre + " -> " + grados.V + " / " + grados.SubV7;
                progresionEntrante = grados.I + ", " + grados.II + ", " + grados.V_IV + ", " + grados.SubV7;
            } else if (acorde.gradoFormal === "V") {
                progresionSaliente = acorde.nombre + " -> " + grados.I + " (Res. Principal)";
                progresionEntrante = grados.II + ", " + grados.IV + ", " + grados.VII + ", " + grados.IVm;
            } else if (acorde.gradoFormal === "VI") {
                progresionSaliente = acorde.nombre + " -> " + grados.II + " / " + grados.IVm;
                progresionEntrante = grados.I + ", " + grados.V_VI;
            } else if (acorde.gradoFormal === "VII") {
                progresionSaliente = acorde.nombre + " -> " + grados.I + " (Tensión)";
                progresionEntrante = grados.V + ", " + grados.I;
            } else if (acorde.gradoFormal === "III") {
                progresionSaliente = acorde.nombre + " -> " + grados.VI + " / " + grados.IV;
                progresionEntrante = grados.I + ", " + grados.V;
            }
        } else {
            // Progresiones para Menor Natural
            if (acorde.gradoFormal === "V7") {
                progresionSaliente = acorde.nombre + " -> " + grados.i + " (Res. Principal)";
                progresionEntrante = grados.iv + ", " + grados.VII;
            } else if (acorde.gradoFormal === "IV") {
                progresionSaliente = acorde.nombre + " -> " + grados.V7 + " / " + grados.i;
                progresionEntrante = grados.i + ", " + grados.VI;
            } else if (acorde.gradoFormal === "V/III") {
                progresionSaliente = acorde.nombre + " -> " + grados.III + " (Res. a III)";
                progresionEntrante = grados.VI + ", " + grados.VII;
            } else if (acorde.gradoFormal === "V/VI") {
                progresionSaliente = acorde.nombre + " -> " + grados.VI + " (Res. a VI)";
                progresionEntrante = grados.i + ", " + grados.III;
            } else if (acorde.gradoFormal === "V/VII") {
                progresionSaliente = acorde.nombre + " -> " + grados.VII + " (Res. a VII)";
                progresionEntrante = grados.III + ", " + grados.iv;
            } else if (acorde.gradoFormal === "i") {
                progresionSaliente = acorde.nombre + " -> " + grados.iv + " / " + grados.VI + " / " + grados.III;
                progresionEntrante = grados.V7 + ", " + grados.v + ", " + grados.VII;
            } else if (acorde.gradoFormal === "ii°") {
                progresionSaliente = acorde.nombre + " -> " + grados.V7 + " / " + grados.i;
                progresionEntrante = grados.iv + ", " + grados.VI;
            } else if (acorde.gradoFormal === "III") {
                progresionSaliente = acorde.nombre + " -> " + grados.VI + " / " + grados.iv;
                progresionEntrante = grados.i + ", " + grados.VII + ", " + grados.V_III;
            } else if (acorde.gradoFormal === "iv") {
                progresionSaliente = acorde.nombre + " -> " + grados.V7 + " / " + grados.i;
                progresionEntrante = grados.i + ", " + grados.VI;
            } else if (acorde.gradoFormal === "v") {
                progresionSaliente = acorde.nombre + " -> " + grados.i + " (Res. Menor)";
                progresionEntrante = grados.iv + ", " + grados.i;
            } else if (acorde.gradoFormal === "VI") {
                progresionSaliente = acorde.nombre + " -> " + grados.III + " / " + grados.VII + " / " + grados.iv;
                progresionEntrante = grados.i + ", " + grados.iv + ", " + grados.V_VI;
            } else if (acorde.gradoFormal === "VII") {
                progresionSaliente = acorde.nombre + " -> " + grados.III + " / " + grados.i;
                progresionEntrante = grados.VI + ", " + grados.iv + ", " + grados.V_VII;
            }
        }

        // 4. Inserción de la fila: Negrita SOLO en el Acorde (Nodo) central
        tablaHTML += `
            <tr class="${claseFila}">
                <td>${hacerAcordesClickeablesEnTexto(progresionEntrante)}</td>
                <td><strong>${acorde.nombre}</strong></td>
                <td>${acorde.funcion}</td>
                <td>${hacerAcordesClickeablesEnTexto(progresionSaliente)}</td>
            </tr>
        `;
    }
    
    tablaHTML += `
        </tbody>
        </table>
    `;

    resultadoDiv.innerHTML = tablaHTML;
}