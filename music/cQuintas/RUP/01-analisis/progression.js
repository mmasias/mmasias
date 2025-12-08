class ProgresionArmonica {
    constructor(mapaArmonico) {
        this.mapaArmonico = mapaArmonico;
        this.acordes = [];
        this.finalizada = false;
    }

    iniciar(acordeInicial) {
        const acordeExiste = this.mapaArmonico.acordes.some(
            grado => grado.nombre === acordeInicial
        );

        if (!acordeExiste) {
            throw new Error(`El acorde ${acordeInicial} no existe en el mapa armónico actual.`);
        }

        this.acordes.push(acordeInicial);
    }

    extender(nuevoAcorde) {
        const acordeActual = this.acordes[this.acordes.length - 1];

        if (!this.mapaArmonico.existeEnlace(acordeActual, nuevoAcorde)) {
            const enlacesPosibles = this.mapaArmonico.obtenerEnlacesSalientes(acordeActual);
            const acordesPosibles = enlacesPosibles.map(e => e.acordeDestino).join(', ');
            throw new Error(
                `Enlace no válido: ${acordeActual} → ${nuevoAcorde}. ` +
                `Progresiones válidas desde ${acordeActual}: ${acordesPosibles}`
            );
        }

        this.acordes.push(nuevoAcorde);
    }

    retroceder() {
        this.acordes.pop();
    }

    finalizar() {
        this.finalizada = true;
    }

    reiniciar() {
        this.acordes = [];
        this.finalizada = false;
    }

    obtenerAcordeActual() {
        return this.acordes.length > 0 ? this.acordes[this.acordes.length - 1] : null;
    }

    obtenerProgresion() {
        return [...this.acordes];
    }

    toString(separador = " → ") {
        if (this.acordes.length === 0) {
            return "(Progresión vacía)";
        }
        return this.acordes.join(separador);
    }

    obtenerEstado() {
        if (this.acordes.length === 0) {
            return "VACIA";
        }
        return this.finalizada ? "FINALIZADA" : "EN_CONSTRUCCION";
    }

    puedeExtender(acorde) {
        if (this.finalizada || this.acordes.length === 0) {
            return false;
        }

        const acordeActual = this.acordes[this.acordes.length - 1];
        return this.mapaArmonico.existeEnlace(acordeActual, acorde);
    }

    obtenerAcordesValidos() {
        if (this.finalizada || this.acordes.length === 0) {
            return [];
        }

        const acordeActual = this.acordes[this.acordes.length - 1];
        const enlaces = this.mapaArmonico.obtenerEnlacesSalientes(acordeActual);
        return enlaces.map(enlace => enlace.acordeDestino);
    }
}

if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        ProgresionArmonica
    };
}
