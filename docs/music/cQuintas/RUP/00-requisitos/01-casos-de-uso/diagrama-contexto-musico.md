<div align=right>

|[![](https://img.shields.io/badge/-Inicio-FFF?style=flat&logo=Emlakjet&logoColor=black)](../../../README.md) [![](https://img.shields.io/badge/-RUP-FFF?style=flat&logo=Elsevier&logoColor=black)](../../README.md) [![](https://img.shields.io/badge/-Requisitos-DDD?style=flat&logo=crewunited&logoColor=black)](../README.md) [![](https://img.shields.io/badge/-Análisis-FFF?style=flat&logo=multisim&logoColor=black)](../../01-analisis/README.md) [![](https://img.shields.io/badge/-Diseño-FFF?style=flat&logo=diagramsdotnet&logoColor=black)](../../02-diseno/README.md)
|-:|
|[![](https://img.shields.io/badge/-Modelo_del_dominio-FFF?style=flat&logo=freedesktop.org&logoColor=black)](../00-modelo-del-dominio/README.md) [![](https://img.shields.io/badge/-Actores_&_Casos_de_Uso-FFF?style=flat&logo=crewunited&logoColor=black)](./README.md) ![](https://img.shields.io/badge/-Diagrama_de_contexto-CCC?style=flat&logo=diagramsdotnet&logoColor=black) [![](https://img.shields.io/badge/-Detalle_&_Prototipo-FFF?style=flat&logo=typeorm&logoColor=black)](./00-detalle/README.md)|

</div>

# pyProgresionesArmonicas > Diagrama de contexto > Músico

|||
|-|-|
Proyecto|pyProgresionesArmonicas
Fase|Inicio
Disciplina|Requisitos
Iteración|1.0
Fecha|2025-12-07
Autor|Manuel Masías

<div align=center>

|![](../../../../../images/music/cQuintas/RUP/00-requisitos/01-casos-de-uso/diagrama-contexto-musico.svg)
|-
|Código fuente: [diagrama-contexto-musico.puml](diagrama-contexto-musico.puml)

</div>

## Estados del sistema

|Estado|Descripción|Función principal|
|-|-|-|
|**SISTEMA_INICIAL**|Estado de entrada del sistema|Interfaz vacía con selectores de tónica y modo disponibles
|**MAPA_DISPONIBLE**|Mapa armónico generado y visible|Visualización de todos los acordes y enlaces posibles para la tonalidad seleccionada
|**PROGRESION_EN_CONSTRUCCION**|Usuario navegando activamente|Construcción iterativa de la progresión mediante navegación entre acordes
|**PROGRESION_FINALIZADA**|Progresión completada y bloqueada|Consulta de la progresión finalizada, sin posibilidad de edición accidental

## Transiciones principales

### Configuración inicial

|||
|-|-|
|`seleccionarTónica()`|SISTEMA_INICIAL → SISTEMA_INICIAL<br>Actualiza la nota base sin generar el mapa aún
|`seleccionarModo()`|SISTEMA_INICIAL → SISTEMA_INICIAL<br>Alterna entre Mayor y Menor Natural sin generar el mapa aún
|`generarMapaArmónico()`|SISTEMA_INICIAL → MAPA_DISPONIBLE<br>Primera generación del mapa armónico con tónica y modo seleccionados

### Exploración y ajuste del contexto tonal

|||
|-|-|
|`seleccionarTónica()`|MAPA_DISPONIBLE → MAPA_DISPONIBLE<br>Regenera el mapa armónico con nueva tónica, sin progresión activa
|`seleccionarModo()`|MAPA_DISPONIBLE → MAPA_DISPONIBLE<br>Regenera el mapa armónico con nuevo modo (**cambio "en caliente"**)
|`iniciarProgresión()`|MAPA_DISPONIBLE → PROGRESION_EN_CONSTRUCCION<br>Primer click en un acorde del mapa inicia la construcción de progresión

### Construcción de la progresión

|||
|-|-|
|`extenderProgresión()`|PROGRESION_EN_CONSTRUCCION → PROGRESION_EN_CONSTRUCCION<br>Click en siguiente acorde extiende la progresión
|`retrocederEnProgresión()`|PROGRESION_EN_CONSTRUCCION → PROGRESION_EN_CONSTRUCCION<br>Botón "Volver Atrás" elimina último acorde
|`seleccionarModo()`|PROGRESION_EN_CONSTRUCCION → PROGRESION_EN_CONSTRUCCION<br>Regenera mapa con nuevo modo, **mantiene** la progresión construida
|`finalizarProgresión()`|PROGRESION_EN_CONSTRUCCION → PROGRESION_FINALIZADA<br>Marca la progresión como completada, bloqueando edición
|`reiniciarProgresión()`|PROGRESION_EN_CONSTRUCCION → MAPA_DISPONIBLE<br>Botón "Nueva Progresión / Reiniciar" descarta progresión actual

### Desde progresión finalizada

|||
|-|-|
|`iniciarProgresión()`|PROGRESION_FINALIZADA → PROGRESION_EN_CONSTRUCCION<br>Comienza nueva progresión desde cero
|`reiniciarProgresión()`|PROGRESION_FINALIZADA → MAPA_DISPONIBLE<br>Vuelve al mapa armónico

## Precondiciones visuales

### Generación del mapa requerida

El diagrama hace explícito que para iniciar una progresión, el músico debe:

1. Seleccionar tónica (opcional, hay valor por defecto)
2. Seleccionar modo (opcional, hay valor por defecto)
3. Generar el mapa armónico (SISTEMA_INICIAL → MAPA_DISPONIBLE)

### Cambio de modo "en caliente"

Una característica importante del sistema: `seleccionarModo()` puede ejecutarse desde múltiples estados:

- **SISTEMA_INICIAL**: Configura modo antes de generar mapa
- **MAPA_DISPONIBLE**: Regenera mapa con nuevo modo, sin progresión activa
- **PROGRESION_EN_CONSTRUCCION**: Regenera mapa con nuevo modo, **preservando** la progresión construida

Esto permite al músico explorar cómo suena su progresión en contextos tonales diferentes sin perder su trabajo.

### Finalización como punto de decisión

El estado PROGRESION_FINALIZADA sirve como:

- **Bloqueo de edición**: Previene modificaciones accidentales
- **Punto de consulta**: Permite revisar la progresión completada
- **Punto de extensión futura**: Preparado para casos de uso adicionales (guardar, exportar, compartir)

## Validación de casos de uso

### Casos de uso incluidos

Todos los casos de uso identificados para el Músico aparecen en el diagrama:

|||
|-|-|
|**Configuración del contexto tonal**|`seleccionarTónica()`, `seleccionarModo()`, `generarMapaArmónico()`
|**Gestión de ProgresiónArmónica (CRUD)**|`iniciarProgresión()` (Create)<br>`consultarProgresión()` (Read - implícito en todos los estados)<br>`extenderProgresión()` + `retrocederEnProgresión()` (Update)<br>`reiniciarProgresión()` (Delete)
|**Nuevo caso de uso identificado**|`finalizarProgresión()` - Emergió del análisis de estados necesarios

### Caso de uso implícito: consultarProgresión()

La visualización del historial de progresión está disponible en todos los estados relevantes:

- **MAPA_DISPONIBLE**: No hay progresión, historial vacío
- **PROGRESION_EN_CONSTRUCCION**: Historial visible y actualizado en tiempo real
- **PROGRESION_FINALIZADA**: Historial visible, edición bloqueada

Por tanto, `consultarProgresión()` no es una transición explícita sino una **vista permanente** del sistema.

## Características del diseño

### Simplicidad del flujo

A diferencia de sistemas CRUD complejos con múltiples entidades, este sistema tiene:

- **Una única entidad gestionada por el usuario**: ProgresiónArmónica
- **Estados conceptuales claros**: Inicial → Mapa → Construcción → Finalizada
- **Flujo lineal predominante** con algunos ciclos de refinamiento

### Estados autorreflexivos estratégicos

|||
|-|-|
|**SISTEMA_INICIAL**|`seleccionarTónica()`, `seleccionarModo()` - Ajuste de configuración antes de generar
|**MAPA_DISPONIBLE**|`seleccionarTónica()`, `seleccionarModo()` - Exploración de contextos tonales alternativos
|**PROGRESION_EN_CONSTRUCCION**|`extenderProgresión()`, `retrocederEnProgresión()`, `seleccionarModo()` - Construcción iterativa

### Cambio de modo transversal

El caso de uso `seleccionarModo()` aparece en **tres estados diferentes**, cada uno con semántica distinta:

|||
|-|-|
|**Desde SISTEMA_INICIAL**|Configuración previa (no regenera nada)
|**Desde MAPA_DISPONIBLE**|Regeneración del mapa (sin progresión activa)
|**Desde PROGRESION_EN_CONSTRUCCION**|Regeneración del mapa **preservando** progresión activa

Esta transversalidad refleja la flexibilidad del sistema para experimentación musical.

### Punto de no retorno controlado

PROGRESION_FINALIZADA no tiene transición de retorno a PROGRESION_EN_CONSTRUCCION que **continúe** la progresión existente. Solo permite:

- Iniciar nueva progresión (descarta la finalizada)
- Volver al mapa (descarta la finalizada)

Esto refuerza la semántica de "finalización" como decisión deliberada del usuario.

## Consideraciones de análisis

### Nivel conceptual

|||
|-|-|
|**Enfoque**|Contextos del músico componiendo progresiones
|**Independencia tecnológica**|No asume interfaz específica (web, escritorio, móvil)
|**Abstracción apropiada**|Nivel RUP Inception

### Validación de completitud

|||
|-|-|
|**Completitud**|Todos los casos de uso identificados tienen lugar en el diagrama
|**Coherencia**|Transiciones reflejan flujo natural de composición musical
|**Descubrimiento**|`finalizarProgresión()` emergió del análisis de estados necesarios

### Extensibilidad futura

El estado PROGRESION_FINALIZADA es un punto natural para agregar:

- `guardarProgresión()` → Persistir en localStorage/servidor
- `exportarProgresión()` → Generar PDF, MIDI, MusicXML
- `compartirProgresión()` → Generar enlace, publicar en redes sociales
- `analizarProgresión()` → Mostrar análisis de funciones armónicas, cadencias

Estas extensiones **no requieren cambios estructurales** al diagrama actual, solo nuevas transiciones desde PROGRESION_FINALIZADA.

## Comparación con implementación actual

### Estados ya implementados

|||
|-|-|
|**SISTEMA_INICIAL**|Implementado - Selectores visibles, botón "Generar"
|**MAPA_DISPONIBLE**|Implementado - Tabla de mapa armónico generada
|**PROGRESION_EN_CONSTRUCCION**|Implementado - Navegación activa, historial visible, botón "Volver Atrás"

### Casos de uso ya implementados

|||
|-|-|
|`seleccionarTónica()`|Implementado - Selector dropdown
|`seleccionarModo()`|Implementado - Selector dropdown, funciona "en caliente"
|`generarMapaArmónico()`|Implementado - Botón "Generar Mapa Armónico"
|`iniciarProgresión()`|Implementado - Primer click en acorde clickeable
|`extenderProgresión()`|Implementado - Click en acordes subsiguientes
|`retrocederEnProgresión()`|Implementado - Botón "← Volver Atrás"
|`reiniciarProgresión()`|Implementado - Botón "Nueva Progresión / Reiniciar"

### Estado y caso de uso pendientes

|||
|-|-|
|**PROGRESION_FINALIZADA**|Pendiente de implementar
|`finalizarProgresión()`|Pendiente de implementar - Requiere botón/acción explícita
|`consultarProgresión()`|Ya existe (implícito) - El historial siempre es visible

## Referencias

- [Modelo del dominio](../00-modelo-del-dominio/README.md)
- [Actores y casos de uso](README.md)
- [Código fuente](../../../cQuintas.js)
- [Reflexiones sobre diagrama de contexto](../reflexionesSobreDiagramaContexto.md)

---

**Versión:** 1.0
**Estado:** En revisión
**Última actualización:** 2025-12-07
