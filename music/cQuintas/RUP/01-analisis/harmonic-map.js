const { generarNombreAcorde, calcularNota, CALIDADES, MODOS } = require('./model.js');

class EnlaceArmonico {
    constructor(acordeOrigen, acordeDestino, tipo, descripcion = "") {
        this.acordeOrigen = acordeOrigen;
        this.acordeDestino = acordeDestino;
        this.tipo = tipo;
        this.descripcion = descripcion;
    }

    toString() {
        return `${this.acordeOrigen} → ${this.acordeDestino} (${this.descripcion || this.tipo})`;
    }
}

class MapaArmonico {
    constructor(escala) {
        this.escala = escala;
        this.acordes = escala.generarAcordes();
        this.enlaces = this._calcularEnlaces();
    }

    _calcularEnlaces() {
        const enlaces = [];
        const modo = this.escala.modo;
        const grados = this._generarMapaGrados();
        const reglas = (modo === MODOS.MAYOR)
            ? this._reglasProgresionesMayor(grados)
            : this._reglasProgresionesmenor(grados);

        for (const regla of reglas) {
            for (const destino of regla.salientes) {
                enlaces.push(new EnlaceArmonico(
                    regla.origen,
                    destino.acorde,
                    "fuerte",
                    destino.descripcion || ""
                ));
            }
        }

        return enlaces;
    }

    _generarMapaGrados() {
        const tonica = this.escala.tonica;
        const modo = this.escala.modo;

        if (modo === MODOS.MAYOR) {
            return {
                I: generarNombreAcorde(calcularNota(tonica, 0), CALIDADES.MAYOR),
                II: generarNombreAcorde(calcularNota(tonica, 2), CALIDADES.MENOR),
                III: generarNombreAcorde(calcularNota(tonica, 4), CALIDADES.MENOR),
                IV: generarNombreAcorde(calcularNota(tonica, 5), CALIDADES.MAYOR),
                V: generarNombreAcorde(calcularNota(tonica, 7), CALIDADES.DOMINANTE7),
                VI: generarNombreAcorde(calcularNota(tonica, 9), CALIDADES.MENOR),
                VII: generarNombreAcorde(calcularNota(tonica, 11), CALIDADES.DISMINUIDO),
                V_II: generarNombreAcorde(calcularNota(tonica, 9), CALIDADES.DOMINANTE7),
                V_IV: generarNombreAcorde(calcularNota(tonica, 0), CALIDADES.DOMINANTE7),
                V_VI: generarNombreAcorde(calcularNota(tonica, 4), CALIDADES.DOMINANTE7),
                IVm: generarNombreAcorde(calcularNota(tonica, 5), CALIDADES.MENOR),
                SubV7: generarNombreAcorde(calcularNota(tonica, 1), CALIDADES.DOMINANTE7)
            };
        } else {
            return {
                i: generarNombreAcorde(calcularNota(tonica, 0), CALIDADES.MENOR),
                ii: generarNombreAcorde(calcularNota(tonica, 2), CALIDADES.DISMINUIDO),
                III: generarNombreAcorde(calcularNota(tonica, 3), CALIDADES.MAYOR),
                iv: generarNombreAcorde(calcularNota(tonica, 5), CALIDADES.MENOR),
                v: generarNombreAcorde(calcularNota(tonica, 7), CALIDADES.MENOR),
                VI: generarNombreAcorde(calcularNota(tonica, 8), CALIDADES.MAYOR),
                VII: generarNombreAcorde(calcularNota(tonica, 10), CALIDADES.MAYOR),
                V_III: generarNombreAcorde(calcularNota(tonica, 3), CALIDADES.DOMINANTE7),
                V_VI: generarNombreAcorde(calcularNota(tonica, 8), CALIDADES.DOMINANTE7),
                V_VII: generarNombreAcorde(calcularNota(tonica, 10), CALIDADES.DOMINANTE7),
                V7: generarNombreAcorde(calcularNota(tonica, 7), CALIDADES.DOMINANTE7),
                IV: generarNombreAcorde(calcularNota(tonica, 5), CALIDADES.MAYOR)
            };
        }
    }

    _reglasProgresionesMayor(grados) {
        return [
            {
                origen: grados.I,
                salientes: [
                    { acorde: grados.IV, descripcion: "" },
                    { acorde: grados.VI, descripcion: "" },
                    { acorde: grados.IVm, descripcion: "" }
                ]
            },
            {
                origen: grados.II,
                salientes: [
                    { acorde: grados.V, descripcion: "" },
                    { acorde: grados.SubV7, descripcion: "" }
                ]
            },
            {
                origen: grados.III,
                salientes: [
                    { acorde: grados.VI, descripcion: "" },
                    { acorde: grados.IV, descripcion: "" }
                ]
            },
            {
                origen: grados.IV,
                salientes: [
                    { acorde: grados.V, descripcion: "" },
                    { acorde: grados.SubV7, descripcion: "" }
                ]
            },
            {
                origen: grados.V,
                salientes: [
                    { acorde: grados.I, descripcion: "Res. Principal" }
                ]
            },
            {
                origen: grados.VI,
                salientes: [
                    { acorde: grados.II, descripcion: "" },
                    { acorde: grados.IVm, descripcion: "" }
                ]
            },
            {
                origen: grados.VII,
                salientes: [
                    { acorde: grados.I, descripcion: "Tensión" }
                ]
            },
            {
                origen: grados.V_II,
                salientes: [
                    { acorde: grados.II, descripcion: "Res. a II" }
                ]
            },
            {
                origen: grados.V_IV,
                salientes: [
                    { acorde: grados.IV, descripcion: "Res. a IV" }
                ]
            },
            {
                origen: grados.V_VI,
                salientes: [
                    { acorde: grados.VI, descripcion: "Res. a VI" }
                ]
            },
            {
                origen: grados.IVm,
                salientes: [
                    { acorde: grados.V, descripcion: "" },
                    { acorde: grados.I, descripcion: "" }
                ]
            },
            {
                origen: grados.SubV7,
                salientes: [
                    { acorde: grados.I, descripcion: "Res. Cromática" },
                    { acorde: grados.IV, descripcion: "" }
                ]
            }
        ];
    }

    _reglasProgresionesmenor(grados) {
        return [
            {
                origen: grados.i,
                salientes: [
                    { acorde: grados.iv, descripcion: "" },
                    { acorde: grados.VI, descripcion: "" },
                    { acorde: grados.III, descripcion: "" }
                ]
            },
            {
                origen: grados.ii,
                salientes: [
                    { acorde: grados.V7, descripcion: "" },
                    { acorde: grados.i, descripcion: "" }
                ]
            },
            {
                origen: grados.III,
                salientes: [
                    { acorde: grados.VI, descripcion: "" },
                    { acorde: grados.iv, descripcion: "" }
                ]
            },
            {
                origen: grados.iv,
                salientes: [
                    { acorde: grados.V7, descripcion: "" },
                    { acorde: grados.i, descripcion: "" }
                ]
            },
            {
                origen: grados.v,
                salientes: [
                    { acorde: grados.i, descripcion: "Res. Menor" }
                ]
            },
            {
                origen: grados.VI,
                salientes: [
                    { acorde: grados.III, descripcion: "" },
                    { acorde: grados.VII, descripcion: "" },
                    { acorde: grados.iv, descripcion: "" }
                ]
            },
            {
                origen: grados.VII,
                salientes: [
                    { acorde: grados.III, descripcion: "" },
                    { acorde: grados.i, descripcion: "" }
                ]
            },
            {
                origen: grados.V_III,
                salientes: [
                    { acorde: grados.III, descripcion: "Res. a III" }
                ]
            },
            {
                origen: grados.V_VI,
                salientes: [
                    { acorde: grados.VI, descripcion: "Res. a VI" }
                ]
            },
            {
                origen: grados.V_VII,
                salientes: [
                    { acorde: grados.VII, descripcion: "Res. a VII" }
                ]
            },
            {
                origen: grados.V7,
                salientes: [
                    { acorde: grados.i, descripcion: "Res. Principal" }
                ]
            },
            {
                origen: grados.IV,
                salientes: [
                    { acorde: grados.V7, descripcion: "" },
                    { acorde: grados.i, descripcion: "" }
                ]
            }
        ];
    }

    obtenerEnlacesSalientes(nombreAcorde) {
        return this.enlaces.filter(enlace => enlace.acordeOrigen === nombreAcorde);
    }

    obtenerEnlacesEntrantes(nombreAcorde) {
        return this.enlaces.filter(enlace => enlace.acordeDestino === nombreAcorde);
    }

    existeEnlace(acordeOrigen, acordeDestino) {
        return this.enlaces.some(
            enlace => enlace.acordeOrigen === acordeOrigen && enlace.acordeDestino === acordeDestino
        );
    }
}

if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        EnlaceArmonico,
        MapaArmonico
    };
}
