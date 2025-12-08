#!/usr/bin/env node

/**
 * Adaptador CLI - pyProgresionesArmonicas
 * Disciplina de Diseño - RUP
 *
 * Punto de entrada de la aplicación CLI.
 */

const readline = require('readline');
const { NOTAS_CROMATICAS, MODOS, Escala } = require('../../01-analisis/model.js');
const { MapaArmonico } = require('../../01-analisis/harmonic-map.js');
const { ProgresionArmonica } = require('../../01-analisis/progression.js');
const { StateMachine } = require('./state-machine.js');
const { renderizarMapa, renderizarProgresion, renderizarEstado } = require('./renderer.js');

// ============================================================================
// ESTADO DE LA APLICACIÓN
// ============================================================================

const app = {
    tonica: 'C',
    modo: MODOS.MAYOR,
    mapa: null,
    progresion: null,
    stateMachine: new StateMachine()
};

// ============================================================================
// INTERFAZ READLINE
// ============================================================================

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    prompt: ''
});

function actualizarPrompt() {
    const estado = app.stateMachine.obtenerEstadoActual();
    const etiquetas = {
        SISTEMA_INICIAL: 'init',
        MAPA_DISPONIBLE: 'map',
        PROGRESION_EN_CONSTRUCCION: 'prog',
        PROGRESION_FINALIZADA: 'final'
    };
    rl.setPrompt(`cquintas[${etiquetas[estado]}]> `);
}

// ============================================================================
// COMANDOS
// ============================================================================

function ejecutarComando(linea) {
    const [comando, ...args] = linea.trim().split(/\s+/);

    try {
        switch (comando) {
            case 'set-tonica':
                comandoSetTonica(args[0]);
                break;
            case 'set-modo':
                comandoSetModo(args[0]);
                break;
            case 'map':
                comandoGenerarMapa();
                break;
            case 'goto':
                comandoGoto(args[0]);
                break;
            case 'undo':
                comandoUndo();
                break;
            case 'reset':
                comandoReset();
                break;
            case 'finish':
                comandoFinish();
                break;
            case 'status':
                comandoStatus();
                break;
            case 'help':
                comandoHelp();
                break;
            case 'exit':
            case 'quit':
                console.log('Hasta luego!');
                process.exit(0);
                break;
            case '':
                // Línea vacía, ignorar
                break;
            default:
                console.log(`Comando desconocido: ${comando}. Escriba 'help' para ver comandos disponibles.`);
        }
    } catch (error) {
        console.error(`Error: ${error.message}`);
    }

    actualizarPrompt();
    rl.prompt();
}

// ============================================================================
// IMPLEMENTACIÓN DE COMANDOS
// ============================================================================

function comandoSetTonica(nota) {
    if (!nota) {
        console.log(`Tónica actual: ${app.tonica}`);
        return;
    }

    if (!NOTAS_CROMATICAS.includes(nota)) {
        throw new Error(`Nota inválida: ${nota}. Notas válidas: ${NOTAS_CROMATICAS.join(', ')}`);
    }

    app.tonica = nota;
    console.log(`Contexto: ${app.tonica}, ${app.modo}`);

    // Si hay mapa disponible, regenerar
    if (app.stateMachine.obtenerEstadoActual() !== 'SISTEMA_INICIAL') {
        comandoGenerarMapa();
    }
}

function comandoSetModo(modo) {
    if (!modo) {
        console.log(`Modo actual: ${app.modo}`);
        return;
    }

    const modosValidos = Object.values(MODOS);
    if (!modosValidos.includes(modo)) {
        throw new Error(`Modo inválido: ${modo}. Modos válidos: ${modosValidos.join(', ')}`);
    }

    app.modo = modo;
    console.log(`Contexto: ${app.tonica}, ${app.modo}`);

    // Si hay mapa disponible, regenerar preservando progresión
    if (app.stateMachine.obtenerEstadoActual() !== 'SISTEMA_INICIAL') {
        comandoGenerarMapa();
    }
}

function comandoGenerarMapa() {
    app.stateMachine.transicion('generarMapaArmonico');

    const escala = new Escala(app.tonica, app.modo);
    app.mapa = new MapaArmonico(escala);

    // Si hay progresión activa, recrearla con el nuevo mapa
    if (app.progresion && app.progresion.obtenerEstado() !== 'VACIA') {
        const acordesAnteriores = app.progresion.obtenerProgresion();
        app.progresion = new ProgresionArmonica(app.mapa);

        // Intentar reconstruir (puede fallar si los acordes no existen en el nuevo modo)
        try {
            for (const acorde of acordesAnteriores) {
                if (app.progresion.obtenerEstado() === 'VACIA') {
                    app.progresion.iniciar(acorde);
                } else {
                    app.progresion.extender(acorde);
                }
            }
        } catch (error) {
            console.log(`Advertencia: No se pudo reconstruir la progresión completa en el nuevo modo.`);
            app.progresion.reiniciar();
        }
    }

    console.log(renderizarMapa(app.mapa, app.progresion));

    if (app.progresion && app.progresion.obtenerEstado() !== 'VACIA') {
        console.log(renderizarProgresion(app.progresion));
    }
}

function comandoGoto(acorde) {
    if (!acorde) {
        throw new Error('Debe especificar un acorde. Uso: goto <acorde>');
    }

    const estadoActual = app.stateMachine.obtenerEstadoActual();

    if (estadoActual === 'SISTEMA_INICIAL') {
        throw new Error('Debe generar el mapa armónico primero. Use: map');
    }

    if (estadoActual === 'PROGRESION_FINALIZADA') {
        throw new Error('La progresión está finalizada. Use reset para iniciar una nueva.');
    }

    // Iniciar o extender progresión
    if (!app.progresion || app.progresion.obtenerEstado() === 'VACIA') {
        app.stateMachine.transicion('iniciarProgresion');
        app.progresion = new ProgresionArmonica(app.mapa);
        app.progresion.iniciar(acorde);
        console.log(`Progresión iniciada: ${acorde}`);
    } else {
        app.stateMachine.transicion('extenderProgresion');
        app.progresion.extender(acorde);
    }

    console.log(renderizarProgresion(app.progresion));
    console.log(renderizarEstado(app.progresion, app.mapa));
}

function comandoUndo() {
    app.stateMachine.transicion('retrocederEnProgresion');

    if (!app.progresion || app.progresion.obtenerEstado() === 'VACIA') {
        throw new Error('No hay progresión activa.');
    }

    app.progresion.retroceder();

    if (app.progresion.obtenerEstado() === 'VACIA') {
        app.stateMachine.estado = 'MAPA_DISPONIBLE';
        console.log('Progresión vacía. Use goto <acorde> para iniciar una nueva.');
    } else {
        console.log(renderizarProgresion(app.progresion));
        console.log(renderizarEstado(app.progresion, app.mapa));
    }
}

function comandoReset() {
    app.stateMachine.transicion('reiniciarProgresion');

    if (app.progresion) {
        app.progresion.reiniciar();
    }

    console.log('Progresión reiniciada.');
    console.log(renderizarMapa(app.mapa, null));
}

function comandoFinish() {
    app.stateMachine.transicion('finalizarProgresion');

    if (!app.progresion || app.progresion.obtenerEstado() === 'VACIA') {
        throw new Error('No hay progresión activa para finalizar.');
    }

    app.progresion.finalizar();
    console.log('Progresión finalizada.');
    console.log(renderizarProgresion(app.progresion));
    console.log('\nUse reset para iniciar una nueva progresión.');
}

function comandoStatus() {
    console.log(`\nContexto: ${app.tonica} ${app.modo}`);
    console.log(`Estado: ${app.stateMachine.obtenerEstadoActual()}`);

    if (app.progresion && app.progresion.obtenerEstado() !== 'VACIA') {
        console.log(renderizarProgresion(app.progresion));
        console.log(renderizarEstado(app.progresion, app.mapa));
    } else {
        console.log('Progresión: (vacía)');
    }
    console.log();
}

function comandoHelp() {
    console.log(`
Generador de Mapas Armónicos - CLI
===================================

CONFIGURACIÓN:
  set-tonica <nota>    Define la tónica (C, D, E, F, G, A, B, C#, etc.)
  set-modo <modo>      Define el modo (Mayor, Menor)
  map                  Genera el mapa armónico para la tónica/modo actuales

NAVEGACIÓN:
  goto <acorde>        Añade un acorde a la progresión (inicia si es el primero)
  undo                 Elimina el último acorde de la progresión
  reset                Reinicia la progresión (vuelve al mapa)
  finish               Finaliza la progresión (bloquea edición)

CONSULTA:
  status               Muestra el estado actual del sistema
  help                 Muestra esta ayuda

SISTEMA:
  exit, quit           Salir de la aplicación

EJEMPLOS:
  cquintas[init]> set-tonica C
  cquintas[init]> set-modo Mayor
  cquintas[init]> map
  cquintas[map]> goto C
  cquintas[prog]> goto Am
  cquintas[prog]> goto F
  cquintas[prog]> undo
  cquintas[prog]> finish
  cquintas[final]> reset
    `);
}

// ============================================================================
// INICIALIZACIÓN
// ============================================================================

console.log('Generador de Mapas Armónicos - CLI');
console.log('Escriba "help" para ver comandos disponibles\n');

actualizarPrompt();
rl.prompt();

rl.on('line', ejecutarComando);

rl.on('close', () => {
    console.log('\nHasta luego!');
    process.exit(0);
});
