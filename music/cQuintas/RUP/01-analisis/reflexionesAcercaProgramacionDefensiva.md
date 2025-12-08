# Reflexiones acerca de la programación defensiva

|||
|-|-|
Proyecto|pyProgresionesArmonicas
Disciplina|Análisis
Tema|Design by Contract vs. Programación defensiva
Fecha|2025-12-08
Autor|Manuel Masías

## Contexto

Durante el desarrollo de las clases de análisis, surgió la pregunta: **¿Dónde validar las entradas?**

### Caso concreto

```javascript
const NOTAS_CROMATICAS = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];

function calcularNota(tonica, semitonos) {
    const indiceTonica = NOTAS_CROMATICAS.indexOf(tonica);
    if (indiceTonica === -1) {
        throw new Error(`Nota inválida: ${tonica}`);  // ← ¿Es necesario?
    }
    const indiceResultado = (indiceTonica + semitonos) % NOTAS_CROMATICAS.length;
    return NOTAS_CROMATICAS[indiceResultado];
}
```

**Pregunta**: ¿Debe `calcularNota()` validar que `tonica` sea válida?

## Tres opciones arquitecturales

### Opción A: validación en el modelo (el modelo se protege)

**Filosofía**: "*El modelo del dominio se protege contra entradas inválidas*"

<div align=center>

|Ventajas|Desventajas|
|-|-|
|Todos los clientes (CLI, Web, futuros) quedan protegidos automáticamente|El modelo contiene código defensivo
|Un solo punto de validación|El error aparece "tarde" (cuando se usa, no cuando se establece)

</div>

```javascript
// 01-analisis/model.js
function calcularNota(tonica, semitonos) {
    const indiceTonica = NOTAS_CROMATICAS.indexOf(tonica);
    if (indiceTonica === -1) {
        throw new Error(`Nota inválida: ${tonica}`);
    }
    // ...
}

// 02-diseno/cli/cli.js
function comandoSetTonica(nota) {
    app.tonica = nota;  // No valida - confía en que el modelo lo hará
    // ...
}
```

### Opción B: validación en diseño (controlador valida entrada del usuario)

**Filosofía**: "El controlador valida la entrada del usuario, el modelo confía"

<div align=center>

|Ventajas|Desventajas|
|-|-|
|Modelo limpio - solo lógica de dominio|Cada controlador debe recordar validar (duplicación CLI/Web)
|Error aparece "temprano" (cuando el usuario introduce el dato)|Si un controlador olvida validar, el error es silencioso

</div>

```javascript
// 01-analisis/model.js
function calcularNota(tonica, semitonos) {
    const indiceTonica = NOTAS_CROMATICAS.indexOf(tonica);
    // Si indiceTonica === -1, comportamiento indefinido
    const indiceResultado = (indiceTonica + semitonos) % NOTAS_CROMATICAS.length;
    return NOTAS_CROMATICAS[indiceResultado];
}

// 02-diseno/cli/cli.js
function comandoSetTonica(nota) {
    if (!NOTAS_CROMATICAS.includes(nota)) {
        throw new Error(`Nota inválida: ${nota}. Notas válidas: ${NOTAS_CROMATICAS.join(', ')}`);
    }
    app.tonica = nota;
    // ...
}

// 02-diseno/web/ui.js (futuro)
document.getElementById('btnGenerar').addEventListener('click', () => {
    const tonica = document.getElementById('selectTonica').value;
    if (!NOTAS_CROMATICAS.includes(tonica)) {  // ← Duplicación de validación
        alert(`Nota inválida: ${tonica}`);
        return;
    }
    // ...
});
```

### Opción C: híbrida (validación solo en entrada del usuario)

**Filosofía**: "El controlador valida entrada del usuario, el código interno confía"

<div align=center>

|Ventajas|Desventajas|
|-|-|
|Modelo limpio|Cada controlador debe validar entradas del usuario
|Error informativo en el punto de entrada del usuario|Requiere disciplina: "validar en la entrada del usuario, confiar internamente"
|Si hay bug interno, el comportamiento incorrecto señala el problema

</div>

```javascript
// 01-analisis/model.js
function calcularNota(tonica, semitonos) {
    const indiceTonica = NOTAS_CROMATICAS.indexOf(tonica);
    // NO valida - confía en que el caller ya validó
    const indiceResultado = (indiceTonica + semitonos) % NOTAS_CROMATICAS.length;
    return NOTAS_CROMATICAS[indiceResultado];
}

// 02-diseno/cli/cli.js
function comandoSetTonica(nota) {
    // VALIDA porque recibe input del usuario
    if (!NOTAS_CROMATICAS.includes(nota)) {
        throw new Error(`Nota inválida: ${nota}. Notas válidas: ${NOTAS_CROMATICAS.join(', ')}`);
    }
    app.tonica = nota;
}

// Internamente, el código confía
const escala = new Escala(app.tonica, app.modo);  // No revalida
```

## Principio guía: facilitar el cumplimiento del contrato

Si exiges: *"Dame una tónica válida"*
Debes ofrecer: *"Aquí están las tónicas válidas"*

```javascript
// Exportamos el conocimiento para que el cliente pueda cumplir el contrato
module.exports = {
    NOTAS_CROMATICAS,  // ← Cliente puede consultar antes de usar
    calcularNota,
    // ...
};
```

El cliente **puede** cumplir el contrato:

```javascript
const { NOTAS_CROMATICAS, calcularNota } = require('./model.js');

// Cliente responsable
if (NOTAS_CROMATICAS.includes(notaUsuario)) {
    calcularNota(notaUsuario, 5);
}
```

## Distinción clave: validación de entrada vs. validación de estado

### Validaciones de estado (precondiciones) - NO IMPLEMENTADAS

Por Design by Contract, **no se validan precondiciones** del tipo:

```javascript
// NO implementado - sería programación defensiva innecesaria
extender(nuevoAcorde) {
    if (this.finalizada) {
        throw new Error("La progresión está finalizada...");
    }
    if (this.acordes.length === 0) {
        throw new Error("La progresión no está iniciada...");
    }
    // ...
}
```

En su lugar, la implementación **confía en que el cliente respeta el contrato**:

```javascript
// Implementación actual - Design by Contract
extender(nuevoAcorde) {
    const acordeActual = this.acordes[this.acordes.length - 1];  // Confía en precondición

    // Solo valida regla de negocio del dominio
    if (!this.mapaArmonico.existeEnlace(acordeActual, nuevoAcorde)) {
        throw new Error(`Enlace no válido: ${acordeActual} → ${nuevoAcorde}...`);
    }

    this.acordes.push(nuevoAcorde);
}
```

**Razón**: `this.finalizada` y `this.acordes.length` son **estado interno controlable por el cliente**. El cliente debe conocer el estado antes de operar.

### Validaciones de entrada del usuario - MANTENIDAS EN DISEÑO

```javascript
// 02-diseno/cli/cli.js
function comandoSetTonica(nota) {
    // VALIDA porque es entrada del usuario (frontera del sistema)
    if (!NOTAS_CROMATICAS.includes(nota)) {
        throw new Error(`Nota inválida: ${nota}. Notas válidas: ${NOTAS_CROMATICAS.join(', ')}`);
    }
    app.tonica = nota;
}
```

**Razón**: `nota` es **entrada externa del usuario**. No es estado interno - es dato que cruza la frontera del sistema.

## Decisión adoptada: opción C (híbrida)

### Compromiso

**En el modelo (`01-analisis/`):**

- Sin validaciones de estado (precondiciones)
- Sin validaciones de entrada
- Solo validaciones de reglas de negocio del dominio musical

**En el controlador (`02-diseno/`):**

- El controlador valida entrada del usuario (CLI, Web)
- No revalidar internamente
- Confiar en que el código interno respeta el contrato

### Implementación

#### Modelo limpio

```javascript
// 01-analisis/model.js
function calcularNota(tonica, semitonos) {
    const indiceTonica = NOTAS_CROMATICAS.indexOf(tonica);
    const indiceResultado = (indiceTonica + semitonos) % NOTAS_CROMATICAS.length;
    return NOTAS_CROMATICAS[indiceResultado];
}
```

#### Diseño con validación en controlador

```javascript
// 02-diseno/cli/cli.js
const { NOTAS_CROMATICAS } = require('../../01-analisis/model.js');

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
}
```

### Justificación

1. **Análisis limpio**: El modelo del dominio no contiene código defensivo
2. **Error temprano**: La validación ocurre cuando el usuario introduce el dato
3. **Error informativo**: El mensaje muestra las opciones válidas
4. **Confianza interna**: El código interno no revalida constantemente
5. **Facilita el contrato**: `NOTAS_CROMATICAS` está exportado para consulta

### Contraste con lenguajes con `assert`

En Java, la distinción sería:

```java
// Análisis
public Nota calcularNota(String tonica, int semitonos) {
    // Sin validación - confía en el cliente
    int indiceTonica = Arrays.asList(NOTAS_CROMATICAS).indexOf(tonica);
    int indiceResultado = (indiceTonica + semitonos) % NOTAS_CROMATICAS.length;
    return NOTAS_CROMATICAS[indiceResultado];
}

// Diseño
public void comandoSetTonica(String nota) {
    if (!Arrays.asList(NOTAS_CROMATICAS).contains(nota)) {
        throw new IllegalArgumentException("Nota inválida: " + nota);
    }
    app.tonica = nota;
}
```

En Python con `-O` (optimización), los `assert` desaparecerían:

```python
# Análisis
def calcular_nota(tonica, semitonos):
    # Sin assert - confía en el cliente
    indice_tonica = NOTAS_CROMATICAS.index(tonica)
    indice_resultado = (indice_tonica + semitonos) % len(NOTAS_CROMATICAS)
    return NOTAS_CROMATICAS[indice_resultado]

# Diseño
def comando_set_tonica(nota):
    if nota not in NOTAS_CROMATICAS:
        raise ValueError(f"Nota inválida: {nota}")
    app.tonica = nota
```

## Beneficios de la decisión

1. **Separación de responsabilidades clara**:
   - Modelo: Lógica de dominio pura
   - Controlador: Validación de entrada del usuario

2. **Trazabilidad RUP**:
   - La validación está en la capa que corresponde según disciplina
   - El modelo es independiente de la interfaz

3. **Facilita testing**:
   - Tests del modelo: Asumen entradas válidas, prueban lógica
   - Tests del controlador: Prueban validación de entrada del usuario

4. **Código más legible**:
   - Sin `if` defensivos que oscurecen la lógica de negocio
   - La intención del código es clara

## Nota sobre terminología

En este documento, usamos el término **"modelo"** o **"modelos"** para referirnos a las clases implementadas en la disciplina de Análisis (`01-analisis/`).

Formalmente, en RUP:

- **Clases de análisis**: Descripciones conceptuales sin código (diagramas UML, especificaciones textuales)
- **Clases de diseño**: Especificaciones técnicas con decisiones de implementación
- **Clases de implementación**: Código ejecutable

Sin embargo, en lenguajes dinámicos como JavaScript, la separación entre análisis/diseño/implementación es menos rígida. Las clases en `01-analisis/` son simultáneamente:

- **Modelo conceptual del dominio** (propósito de análisis)
- **Código JavaScript ejecutable** (artefacto de implementación)

Esta flexibilidad es intencional y demuestra la adaptabilidad de RUP a contextos modernos donde el código puede ser auto-documentado y la especificación puede ser ejecutable.

Por tanto, cuando el documento habla de "el modelo", nos referimos a:

- En contexto RUP: Las clases que representan el modelo del dominio (disciplina de Análisis)
- En contexto arquitectural: La capa de lógica de negocio (patrón MVC)

Ambas interpretaciones son correctas y están alineadas en este proyecto.

## Referencias

- [README de Análisis - Sección Design by Contract](README.md#design-by-contract)
- [progression.js](progression.js) - Ejemplo de implementación sin programación defensiva
- [CLI - comandos de validación](../02-diseno/cli/cli.js)

---

**Versión**: 1.0
**Estado**: Aprobado
**Última actualización**: 2025-12-08
