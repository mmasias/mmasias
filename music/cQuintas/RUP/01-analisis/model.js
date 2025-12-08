const NOTAS_CROMATICAS = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];

function calcularNota(tonica, semitonos) {
    const indiceTonica = NOTAS_CROMATICAS.indexOf(tonica);
    const indiceResultado = (indiceTonica + semitonos) % NOTAS_CROMATICAS.length;
    return NOTAS_CROMATICAS[indiceResultado];
}

const CALIDADES = {
    MAYOR: "Mayor",
    MENOR: "Menor",
    DISMINUIDO: "Disminuido",
    DOMINANTE7: "Dominante7"
};

function generarNombreAcorde(notaRaiz, calidad) {
    switch (calidad) {
        case CALIDADES.MENOR:
            return notaRaiz + "m";
        case CALIDADES.DISMINUIDO:
            return notaRaiz + "°";
        case CALIDADES.DOMINANTE7:
            return notaRaiz + "7";
        case CALIDADES.MAYOR:
        default:
            return notaRaiz;
    }
}

function extraerNotaRaiz(nombreAcorde) {
    const match = nombreAcorde.match(/^([A-G](#)?)/);
    return match[1];
}

const MODOS = {
    MAYOR: "Mayor",
    MENOR: "Menor"
};

class Escala {
    constructor(tonica, modo) {
        this.tonica = tonica;
        this.modo = modo;
        this.grados = this._calcularGrados();
    }

    _calcularGrados() {
        if (this.modo === MODOS.MAYOR) {
            return {
                diatonicos: [
                    { semitonos: 0, calidad: CALIDADES.MAYOR, funcion: "Tónica (I)", grado: "I" },
                    { semitonos: 2, calidad: CALIDADES.MENOR, funcion: "Supertónica (II)", grado: "II" },
                    { semitonos: 4, calidad: CALIDADES.MENOR, funcion: "Mediante (III)", grado: "III" },
                    { semitonos: 5, calidad: CALIDADES.MAYOR, funcion: "Subdominante (IV)", grado: "IV" },
                    { semitonos: 7, calidad: CALIDADES.DOMINANTE7, funcion: "Dominante (V)", grado: "V" },
                    { semitonos: 9, calidad: CALIDADES.MENOR, funcion: "Superdominante (VI)", grado: "VI" },
                    { semitonos: 11, calidad: CALIDADES.DISMINUIDO, funcion: "Sensible (VII)", grado: "VII" }
                ],
                secundarios: [
                    { semitonos: 9, calidad: CALIDADES.DOMINANTE7, funcion: "Dominante Secundario (V/II)", grado: "V/II" },
                    { semitonos: 0, calidad: CALIDADES.DOMINANTE7, funcion: "Dominante Secundario (V/IV)", grado: "V/IV" },
                    { semitonos: 4, calidad: CALIDADES.DOMINANTE7, funcion: "Dominante Secundario (V/VI)", grado: "V/VI" }
                ],
                alterados: [
                    { semitonos: 5, calidad: CALIDADES.MENOR, funcion: "Subdominante Menor (IVm)", grado: "IVm" },
                    { semitonos: 1, calidad: CALIDADES.DOMINANTE7, funcion: "Sustituto Dominante (SubV7)", grado: "SubV7" }
                ]
            };
        } else {
            return {
                diatonicos: [
                    { semitonos: 0, calidad: CALIDADES.MENOR, funcion: "Tónica (i)", grado: "i" },
                    { semitonos: 2, calidad: CALIDADES.DISMINUIDO, funcion: "Supertónica (ii°)", grado: "ii°" },
                    { semitonos: 3, calidad: CALIDADES.MAYOR, funcion: "Mediante (III)", grado: "III" },
                    { semitonos: 5, calidad: CALIDADES.MENOR, funcion: "Subdominante (iv)", grado: "iv" },
                    { semitonos: 7, calidad: CALIDADES.MENOR, funcion: "Dominante (v)", grado: "v" },
                    { semitonos: 8, calidad: CALIDADES.MAYOR, funcion: "Superdominante (VI)", grado: "VI" },
                    { semitonos: 10, calidad: CALIDADES.MAYOR, funcion: "Subtónica (VII)", grado: "VII" }
                ],
                secundarios: [
                    { semitonos: 3, calidad: CALIDADES.DOMINANTE7, funcion: "Dominante Secundario (V/III)", grado: "V/III" },
                    { semitonos: 8, calidad: CALIDADES.DOMINANTE7, funcion: "Dominante Secundario (V/VI)", grado: "V/VI" },
                    { semitonos: 10, calidad: CALIDADES.DOMINANTE7, funcion: "Dominante Secundario (V/VII)", grado: "V/VII" }
                ],
                alterados: [
                    { semitonos: 7, calidad: CALIDADES.DOMINANTE7, funcion: "Dominante Mayor (V7)", grado: "V7" },
                    { semitonos: 5, calidad: CALIDADES.MAYOR, funcion: "Subdominante Mayor (IV)", grado: "IV" }
                ]
            };
        }
    }

    generarAcordes() {
        const todosLosGrados = [
            ...this.grados.diatonicos,
            ...this.grados.secundarios,
            ...this.grados.alterados
        ];

        return todosLosGrados.map(grado => new GradoArmonico(
            this.tonica,
            grado.semitonos,
            grado.calidad,
            grado.funcion,
            grado.grado
        ));
    }
}

class GradoArmonico {
    constructor(tonicaEscala, semitonos, calidad, funcion, grado) {
        this.notaRaiz = calcularNota(tonicaEscala, semitonos);
        this.calidad = calidad;
        this.nombre = generarNombreAcorde(this.notaRaiz, calidad);
        this.funcion = funcion;
        this.grado = grado;
        this.esCromatico = grado.includes('/') || grado.includes('m') || grado.includes('SubV7') ||
                           (grado === 'V7' || grado === 'IV');
    }

    toString() {
        return `${this.nombre} (${this.grado})`;
    }
}

if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        NOTAS_CROMATICAS,
        calcularNota,
        CALIDADES,
        generarNombreAcorde,
        extraerNotaRaiz,
        MODOS,
        Escala,
        GradoArmonico
    };
}
