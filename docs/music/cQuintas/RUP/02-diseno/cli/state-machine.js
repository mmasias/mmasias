/**
 * CLI (Vista + Controlador) - pyProgresionesArmonicas
 * Disciplina de Diseño - RUP
 *
 * Máquina de estados: Implementación directa del diagrama de contexto.
 */

// ============================================================================
// MÁQUINA DE ESTADOS
// ============================================================================

/**
 * Clase StateMachine: Implementa el diagrama de contexto como máquina de estados finita.
 * Valida transiciones permitidas y mantiene el estado actual del sistema.
 */
class StateMachine {
    constructor() {
        this.estado = 'SISTEMA_INICIAL';

        // Tabla de transiciones: Mapa del diagrama de contexto
        this.transiciones = {
            SISTEMA_INICIAL: {
                seleccionarTonica: 'SISTEMA_INICIAL',
                seleccionarModo: 'SISTEMA_INICIAL',
                generarMapaArmonico: 'MAPA_DISPONIBLE'
            },
            MAPA_DISPONIBLE: {
                seleccionarTonica: 'MAPA_DISPONIBLE',
                seleccionarModo: 'MAPA_DISPONIBLE',
                iniciarProgresion: 'PROGRESION_EN_CONSTRUCCION',
                reiniciarProgresion: 'MAPA_DISPONIBLE'
            },
            PROGRESION_EN_CONSTRUCCION: {
                extenderProgresion: 'PROGRESION_EN_CONSTRUCCION',
                retrocederEnProgresion: 'PROGRESION_EN_CONSTRUCCION',
                seleccionarModo: 'PROGRESION_EN_CONSTRUCCION',
                finalizarProgresion: 'PROGRESION_FINALIZADA',
                reiniciarProgresion: 'MAPA_DISPONIBLE'
            },
            PROGRESION_FINALIZADA: {
                iniciarProgresion: 'PROGRESION_EN_CONSTRUCCION',
                reiniciarProgresion: 'MAPA_DISPONIBLE'
            }
        };
    }

    /**
     * Intenta ejecutar una transición.
     * @param {string} accion - Nombre del caso de uso a ejecutar
     * @throws {Error} Si la transición no es válida desde el estado actual
     */
    transicion(accion) {
        const transicionesPermitidas = this.transiciones[this.estado];

        if (!transicionesPermitidas || !transicionesPermitidas[accion]) {
            const accionesPermitidas = transicionesPermitidas
                ? Object.keys(transicionesPermitidas).join(', ')
                : 'ninguna';

            throw new Error(
                `Transición no permitida: ${accion} desde estado ${this.estado}. ` +
                `Acciones permitidas: ${accionesPermitidas}`
            );
        }

        const nuevoEstado = transicionesPermitidas[accion];
        this.estado = nuevoEstado;
    }

    /**
     * Obtiene el estado actual de la máquina.
     * @returns {string} Estado actual
     */
    obtenerEstadoActual() {
        return this.estado;
    }

    /**
     * Verifica si una acción está permitida desde el estado actual.
     * @param {string} accion - Nombre del caso de uso
     * @returns {boolean} true si la acción está permitida
     */
    estaPermitida(accion) {
        const transicionesPermitidas = this.transiciones[this.estado];
        return transicionesPermitidas && transicionesPermitidas.hasOwnProperty(accion);
    }
}

// ============================================================================
// EXPORTS
// ============================================================================

if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        StateMachine
    };
}
