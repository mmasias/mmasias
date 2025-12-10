<div align=right>

|[![](https://img.shields.io/badge/-Inicio-FFF?style=flat&logo=Emlakjet&logoColor=black)](../../README.md) [![](https://img.shields.io/badge/-RUP-FFF?style=flat&logo=Elsevier&logoColor=black)](../README.md) [![](https://img.shields.io/badge/-Requisitos-FFF?style=flat&logo=crewunited&logoColor=black)](../00-requisitos/README.md) [![](https://img.shields.io/badge/-Análisis-FFF?style=flat&logo=multisim&logoColor=black)](../01-analisis/README.md) ![](https://img.shields.io/badge/-Diseño-CCC?style=flat&logo=diagramsdotnet&logoColor=black)
|-:|
|[![](https://img.shields.io/badge/-CLI-FFF?style=flat&logo=gnometerminal&logoColor=black)](cli/README.md) ![](https://img.shields.io/badge/-Web-FFF?style=flat&logo=html5&logoColor=black)|

</div>

# pyProgresionesArmonicas > Diseño

|||
|-|-|
Proyecto|pyProgresionesArmonicas
Fase|Construcción
Disciplina|Diseño
Iteración|1.0
Fecha|2025-12-08
Autor|Manuel Masías

## Implementaciones (Vista + Controlador)

<div align=center>

|CLI|Web|
|-|-|
[cli/](cli/README.md)|web/ (pendiente)
Vista + Controlador combinados|Vista y Controlador separados
Línea de comandos (Node.js)|Navegador (HTML + JavaScript)

</div>

**Decisión arquitectural**:
- **CLI**: Por el tamaño del proyecto, no hace falta separar Vista y Controlador. `cli.js` combina ambas responsabilidades.
- **Web**: Se separarán por propósitos pedagógicos, mostrando la separación clásica MVC (además, en web es más orgánica la separación).

## Independencia de plataforma

Ambas implementaciones reutilizan el mismo [modelo del dominio](../01-analisis/README.md) sin modificaciones:

```
01-analisis/         → Modelo del dominio (JavaScript puro)
├── model.js         → Nota, Calidad, Escala, GradoArmónico
├── harmonic-map.js  → MapaArmónico, EnlaceArmónico
└── progression.js   → ProgresiónArmónica

02-diseno/
├── cli/             → Vista + Controlador combinados
│   ├── cli.js       → Entrada: process.stdin, Salida: console.log
│   ├── state-machine.js
│   └── renderer.js  → Renderizadores ASCII
└── web/             → Vista y Controlador separados (pendiente)
    ├── index.html   → Vista: HTML
    ├── controller.js → Controlador: manejo de eventos
    └── view.js      → Vista: renderizado dinámico
```

## Trazabilidad

Las implementaciones (CLI y Web) ejecutan los mismos [casos de uso](../00-requisitos/01-casos-de-uso/README.md), solo cambia la presentación:

|Caso de Uso|CLI|Web|
|-|-|-|
seleccionarTónica()|`set-tonica <nota>`|`<select id="tonica">`
seleccionarModo()|`set-modo <modo>`|`<select id="modo">`
generarMapaArmónico()|`map`|`<button>Generar Mapa</button>`
iniciarProgresión()|`goto <acorde>`|Click en acorde
extenderProgresión()|`goto <acorde>`|Click en acorde
retrocederEnProgresión()|`undo`|`<button>← Volver Atrás</button>`
finalizarProgresión()|`finish`|(pendiente)
reiniciarProgresión()|`reset`|`<button>Nueva Progresión / Reiniciar</button>`

## Referencias

- [Casos de Uso](../00-requisitos/01-casos-de-uso/README.md)
- [Modelo del dominio (Análisis)](../01-analisis/README.md)
- [Propuesta CLI](../00-requisitos/propuestaCLI.md)

---

**Versión**: 1.0
**Estado**: En desarrollo
**Última actualización**: 2025-12-08
