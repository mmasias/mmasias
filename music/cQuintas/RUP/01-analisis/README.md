<div align=right>

|[![](https://img.shields.io/badge/-Inicio-FFF?style=flat&logo=Emlakjet&logoColor=black)](../../README.md) [![](https://img.shields.io/badge/-RUP-FFF?style=flat&logo=Elsevier&logoColor=black)](../README.md) [![](https://img.shields.io/badge/-Requisitos-FFF?style=flat&logo=crewunited&logoColor=black)](../00-requisitos/README.md) ![](https://img.shields.io/badge/-Análisis-CCC?style=flat&logo=multisim&logoColor=black) ![](https://img.shields.io/badge/-Diseño-FFF?style=flat&logo=diagramsdotnet&logoColor=black)
|-:|

</div>

# pyProgresionesArmonicas > Análisis

|||
|-|-|
Proyecto|pyProgresionesArmonicas
Fase|Elaboración
Disciplina|Análisis
Iteración|1.0
Fecha|2025-12-08
Autor|Manuel Masías

## Modelo del dominio (Clases de análisis)

<div align=center>

|Conocimiento del dominio|Datos derivados|Datos del usuario|
|-|-|-|
[model.js](model.js)|[harmonic-map.js](harmonic-map.js)|[progression.js](progression.js)
Nota, Calidad, Escala, GradoArmónico|MapaArmónico, EnlaceArmónico|ProgresiónArmónica

</div>

## Clasificación de entidades

Las entidades del modelo del dominio se clasifican en tres categorías según su naturaleza:

### Conocimiento del dominio

Conceptos musicales universales y fijos que no cambian:

- **Nota**: Las 12 notas cromáticas del sistema temperado occidental
- **Calidad**: Mayor, Menor, Disminuido, Dominante7
- **Escala**: Mayor y Menor Natural con sus grados
- **GradoArmónico**: Acordes dentro del contexto de una escala

### Datos derivados/calculados

Entidades que se generan automáticamente a partir de la tónica y modo seleccionados:

- **MapaArmónico**: Grafo completo de acordes y enlaces posibles para una tonalidad
- **EnlaceArmónico**: Relaciones direccionales entre acordes según teoría funcional

### Datos del usuario

La única entidad que representa trabajo creativo del músico:

- **ProgresiónArmónica**: Secuencia de acordes construida por el usuario (admite CRUD completo)

## Decisiones de diseño

### Design by Contract

Las clases de análisis implementan **Design by Contract** sin programación defensiva:

**Precondiciones (responsabilidad del cliente):**

- `ProgresionArmonica.extender()` asume que la progresión está iniciada y no finalizada
- `ProgresionArmonica.retroceder()` asume que hay acordes en la progresión
- El cliente **debe** consultar el estado mediante `obtenerEstado()` o `puedeExtender()` antes de operar

**Validaciones presentes (reglas de negocio):**

- `iniciar()`: Valida que el acorde inicial exista en el mapa armónico
- `extender()`: Valida que el enlace armónico sea válido según teoría funcional

**Razón:** JavaScript no tiene `assert` nativo. Validar precondiciones con `throw Error` contamina el código con checks que son **responsabilidad del cliente**. Si el cliente viola el contrato, el stack trace nativo es suficientemente informativo.

En entornos con `assert` (Java, Python con `-O`), las precondiciones se validarían con assertions que desaparecen en producción.

## Trazabilidad a requisitos

Cada clase de análisis implementa entidades identificadas en el [Modelo del dominio](../00-requisitos/00-modelo-del-dominio/README.md) de la disciplina de Requisitos.

## Referencias

- [Modelo del dominio (Requisitos)](../00-requisitos/00-modelo-del-dominio/README.md)
- [Casos de uso](../00-requisitos/01-casos-de-uso/README.md)
- [Reflexiones acerca de Programación Defensiva](reflexionesAcercaProgramacionDefensiva.md)

---

**Versión**: 1.0
**Estado**: En desarrollo
**Última actualización**: 2025-12-08
