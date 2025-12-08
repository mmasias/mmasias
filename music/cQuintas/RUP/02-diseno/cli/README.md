<div align=right>

|[![](https://img.shields.io/badge/-Inicio-FFF?style=flat&logo=Emlakjet&logoColor=black)](../../../README.md) [![](https://img.shields.io/badge/-RUP-FFF?style=flat&logo=Elsevier&logoColor=black)](../../README.md) [![](https://img.shields.io/badge/-Requisitos-FFF?style=flat&logo=crewunited&logoColor=black)](../../00-requisitos/README.md) [![](https://img.shields.io/badge/-Análisis-FFF?style=flat&logo=multisim&logoColor=black)](../../01-analisis/README.md) ![](https://img.shields.io/badge/-Diseño-DDD?style=flat&logo=diagramsdotnet&logoColor=black)
|-:|
|[![](https://img.shields.io/badge/-CLI-CCC?style=flat&logo=gnubash&logoColor=black)](README.md) ![](https://img.shields.io/badge/-Web-FFF?style=flat&logo=html5&logoColor=black)|

</div>

# pyProgresionesArmonicas > Diseño > Adaptador CLI

|||
|-|-|
Proyecto|pyProgresionesArmonicas
Fase|Construcción
Disciplina|Diseño
Iteración|1.0
Fecha|2025-12-08
Autor|Manuel Masías

## Arquitectura

```
cli.js              → Punto de entrada, intérprete de comandos
├── state-machine.js   → Implementación del diagrama de contexto
├── renderer.js        → Renderizadores ASCII (mapa, progresión, estado)
└── ../../01-analisis/ → Modelo del dominio (reutilizado sin cambios)
    ├── model.js
    ├── harmonic-map.js
    └── progression.js
```

## Instalación

```bash
cd /home/manuel/misRepos/mmasias/music/cQuintas/RUP/02-diseno/cli
chmod +x cli.js
node cli.js
```

## Comandos

### Configuración del contexto tonal

```
set-tonica <nota>    Selecciona la tónica (C, D, E, F, G, A, B, C#, etc.)
set-modo <modo>      Selecciona el modo (Mayor, Menor)
map                  Genera el mapa armónico
```

### Gestión de progresión armónica

```
goto <acorde>        Inicia/extiende progresión
undo                 Retrocede un acorde
reset                Reinicia progresión
finish               Finaliza progresión
```

### Consulta

```
status               Muestra estado actual
help                 Ayuda
```

## Ejemplo de uso

```console
$ node cli.js
Generador de Mapas Armónicos - CLI
Escriba "help" para ver comandos disponibles

cquintas[init]> set-tonica C
Contexto: C, Mayor
cquintas[init]> map
═══════════════════════════════════════════════════════════════════════════
  MAPA ARMÓNICO: C Mayor
═══════════════════════════════════════════════════════════════════════════
...

cquintas[map]> goto C
Progresión iniciada: C
Progresión: [C]

Desde C, puede ir a:
  1. F
  2. Am
  3. Fm

cquintas[prog]> goto Am
Progresión: C → [Am]

Desde Am, puede ir a:
  1. Dm
  2. Fm

cquintas[prog]> goto Dm
Progresión: C → Am → [Dm]

cquintas[prog]> finish
Progresión finalizada.
Progresión: C → Am → [Dm] (FINALIZADA)

Use reset para iniciar una nueva progresión.
cquintas[final]> reset
Progresión reiniciada.
```

## Trazabilidad

### Comandos → Casos de Uso

|Comando|Caso de Uso|Archivo|
|-|-|-|
`set-tonica`|seleccionarTónica()|[cli.js:103](cli.js)
`set-modo`|seleccionarModo()|[cli.js:119](cli.js)
`map`|generarMapaArmónico()|[cli.js:135](cli.js)
`goto`|iniciarProgresión() + extenderProgresión()|[cli.js:165](cli.js)
`undo`|retrocederEnProgresión()|[cli.js:197](cli.js)
`reset`|reiniciarProgresión()|[cli.js:215](cli.js)
`finish`|finalizarProgresión()|[cli.js:224](cli.js)
`status`|consultarProgresión()|[cli.js:236](cli.js)

### Estados del sistema

El archivo `state-machine.js` implementa directamente el [diagrama de contexto](../../00-requisitos/01-casos-de-uso/diagrama-contexto-musico.md):

- `SISTEMA_INICIAL` → `[init]`
- `MAPA_DISPONIBLE` → `[map]`
- `PROGRESION_EN_CONSTRUCCION` → `[prog]`
- `PROGRESION_FINALIZADA` → `[final]`

## Referencias

- [Casos de Uso](../../00-requisitos/01-casos-de-uso/README.md)
- [Diagrama de contexto](../../00-requisitos/01-casos-de-uso/diagrama-contexto-musico.md)
- [Modelo del dominio (Análisis)](../../01-analisis/README.md)
- [Propuesta CLI](../../00-requisitos/propuestaCLI.md)

---

**Versión**: 1.0
**Estado**: En desarrollo
**Última actualización**: 2025-12-08
