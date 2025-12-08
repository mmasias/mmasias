/**
 * Adaptador CLI - pyProgresionesArmonicas
 * Disciplina de Diseño - RUP
 *
 * Renderizadores: Generan salidas ASCII para consola.
 */

// ============================================================================
// RENDERIZADOR DE MAPA ARMÓNICO
// ============================================================================

/**
 * Renderiza el mapa armónico como tabla ASCII.
 * @param {MapaArmonico} mapa - El mapa armónico a renderizar
 * @param {ProgresionArmonica|null} progresion - Progresión actual (opcional)
 * @returns {string} Tabla ASCII del mapa
 */
function renderizarMapa(mapa, progresion) {
    if (!mapa) {
        return 'No hay mapa armónico generado. Use: map';
    }

    const acordeActual = progresion ? progresion.obtenerAcordeActual() : null;

    let output = `\n═══════════════════════════════════════════════════════════════════════════\n`;
    output += `  MAPA ARMÓNICO: ${mapa.escala.tonica} ${mapa.escala.modo}\n`;
    output += `═══════════════════════════════════════════════════════════════════════════\n\n`;

    output += `┌──────────────────────┬──────────┬─────────────────────┬──────────────────────┐\n`;
    output += `│ Entrantes (←)        │ Acorde   │ Función             │ Salientes (→)        │\n`;
    output += `├──────────────────────┼──────────┼─────────────────────┼──────────────────────┤\n`;

    let separadorCromaticos = false;

    for (let i = 0; i < mapa.acordes.length; i++) {
        const acorde = mapa.acordes[i];

        // Separador visual entre diatónicos y cromáticos
        if (i === 7 && !separadorCromaticos) {
            output += `├──────────────────────┼──────────┼─────────────────────┼──────────────────────┤\n`;
            separadorCromaticos = true;
        }

        const entrantes = mapa.obtenerEnlacesEntrantes(acorde.nombre)
            .map(e => e.acordeOrigen)
            .join(', ') || '-';

        const salientes = mapa.obtenerEnlacesSalientes(acorde.nombre)
            .map(e => e.acordeDestino)
            .join(', ') || '-';

        // Marcar acorde actual con asterisco
        const marcador = (acorde.nombre === acordeActual) ? '*' : ' ';
        const nombreAcorde = `${marcador}${acorde.nombre}${marcador}`;

        output += `│ ${pad(entrantes, 20)} │ ${pad(nombreAcorde, 8)} │ ${pad(acorde.grado, 19)} │ ${pad(salientes, 20)} │\n`;
    }

    output += `└──────────────────────┴──────────┴─────────────────────┴──────────────────────┘\n`;

    return output;
}

// ============================================================================
// RENDERIZADOR DE PROGRESIÓN
// ============================================================================

/**
 * Renderiza la progresión actual.
 * @param {ProgresionArmonica} progresion - La progresión a renderizar
 * @returns {string} Cadena de progresión formateada
 */
function renderizarProgresion(progresion) {
    if (!progresion || progresion.obtenerEstado() === 'VACIA') {
        return '\nProgresión: (vacía)';
    }

    const acordes = progresion.obtenerProgresion();
    const ultimo = acordes[acordes.length - 1];

    // Resaltar el acorde actual (último)
    const cadena = acordes.slice(0, -1).join(' → ') +
        (acordes.length > 1 ? ' → ' : '') +
        `[${ultimo}]`;

    const estado = progresion.obtenerEstado() === 'FINALIZADA' ? ' (FINALIZADA)' : '';

    return `\nProgresión: ${cadena}${estado}`;
}

// ============================================================================
// RENDERIZADOR DE ESTADO
// ============================================================================

/**
 * Renderiza el estado actual con opciones disponibles.
 * @param {ProgresionArmonica} progresion - La progresión actual
 * @param {MapaArmonico} mapa - El mapa armónico
 * @returns {string} Información de estado y opciones
 */
function renderizarEstado(progresion, mapa) {
    if (!progresion || progresion.obtenerEstado() === 'VACIA') {
        return '';
    }

    const acordeActual = progresion.obtenerAcordeActual();
    const acordesValidos = progresion.obtenerAcordesValidos();

    if (acordesValidos.length === 0) {
        return '\nNo hay progresiones válidas desde este acorde.';
    }

    let output = `\nDesde ${acordeActual}, puede ir a:\n`;

    acordesValidos.forEach((acorde, index) => {
        output += `  ${index + 1}. ${acorde}\n`;
    });

    output += `\nUso: goto <acorde>  o  goto <número>`;

    return output;
}

// ============================================================================
// UTILIDADES
// ============================================================================

/**
 * Rellena una cadena con espacios para alcanzar una longitud específica.
 * @param {string} str - Cadena a rellenar
 * @param {number} length - Longitud deseada
 * @returns {string} Cadena rellenada
 */
function pad(str, length) {
    const s = String(str);
    if (s.length >= length) {
        return s.substring(0, length);
    }
    return s + ' '.repeat(length - s.length);
}

// ============================================================================
// EXPORTS
// ============================================================================

if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        renderizarMapa,
        renderizarProgresion,
        renderizarEstado
    };
}
