# Propuesta de versión CLI para Generador de Mapas Armónicos

|||
|-|-|
Proyecto|pyProgresionesArmonicas
Ámbito|Disciplina de Requisitos → Extensión CLI
Autor|Manuel Masías
Fecha|2025-12-8

## Objetivo

Demostrar que los requisitos modelados (actores, casos de uso, máquina de estados y modelo de dominio) son **independientes de plataforma**, diseñando una versión de línea de comandos (CLI) que preserve el mismo comportamiento funcional y de navegación que la versión web.

## Apoyo en los artefactos de requisitos

- **Actor único (Músico)**: Se mantiene sin cambios; la interfaz pasa de web a CLI.
- **Casos de uso**: Cada CU mapea 1:1 a comandos. No se reescriben requisitos, solo se reinterpretan entradas/salidas.
- **Máquina de estados (diagrama de contexto)**: Los estados `SISTEMA_INICIAL`, `MAPA_DISPONIBLE`, `PROGRESION_EN_CONSTRUCCION`, `PROGRESION_FINALIZADA` conservan significado; solo cambia la forma de mostrarlos.
- **Modelo de dominio**: Entidades (Escala, Acorde, GradoArmónico, Enlace, Progresión) permanecen idénticas; la lógica de enlaces se reutiliza.

## Comandos propuestos (mapeo de CU)

|Caso de uso|Comando CLI|Descripción|
|-|-|-|
|seleccionarTónica()|`set-tonica <nota>`|Define tónica (default C).|
|seleccionarModo()|`set-modo {Mayor|Menor}`|Define modo (default Mayor).|
|generarMapaArmónico()|`map`|Genera/imprime mapa armónico textual para la tónica/modo actuales.|
|iniciarProgresión() / extenderProgresión()|`goto <acorde>`|Añade acorde al historial validando que sea alcanzable desde el actual.|
|retrocederEnProgresión()|`undo`|Elimina el último acorde de la progresión.|
|reiniciarProgresión()|`reset`|Vuelve a estado inicial, limpia historial.|
|finalizarProgresión()|`finish`|Bloquea edición; solo lectura/consulta.|
|consultarProgresión()|`status`|Muestra estado, tónica/modo y progresión actual.|

## UX de consola

- **Render del mapa**: tabla ASCII o lista por filas, con “Entrantes”, “Nodo”, “Función”, “Salientes”. Los acordes “clicables” se ofrecen como comandos `goto <acorde>`; opcionalmente, numerar salientes para selección rápida (`goto 2` desde el contexto actual).
- **Historial siempre visible**: cada salida muestra `Progresión: C → Am → F → G`.
- **Errores guiados**: si un `goto` no es válido, se lista qué salidas son fuertes/permitidas desde el acorde actual.
- **Cambio de modo en caliente**: `set-modo` regenera el mapa sin perder historial, respetando el estado `PROGRESION_EN_CONSTRUCCION`.
- **Estado finalizado**: `finish` congela la progresión; `goto/undo` responden “progresión finalizada (use reset/iniciar nueva)”.

### Propuesta de interfaz

- **Prompt corto**: `cquintas> ` indicando estado (`[init]`, `[map]`, `[prog]`, `[final]`).
- **Comandos discoverables**: `help` muestra descripción breve y ejemplos de uso de cada CU/estado.
- **Salida del mapa**: tabla ASCII con anchos fijos y color opcional (si terminal lo permite) para diferenciar diatónicos/secundarios/alterados.
- **Selección rápida**: al listar salientes desde el acorde actual, numerar opciones para `goto 1`, `goto 2`, manteniendo `goto G7` como alternativa explícita.
- **Mensajes de validación**: frases cortas, ejemplo: `G7 no es saliente válido desde Em (usa: Am, C, D7)`.

#### Ejemplo de uso (borrador)

```console
$ mapas-armonicos
cquintas[init]> set-tonica C
Contexto: C
cquintas[init]> set-modo Menor
Contexto: C, Menor
cquintas[map]> map
... (se imprime tabla ASCII del mapa de C menor) ...
cquintas[map]> goto G
Progresión: G
cquintas[prog]> goto Cm
Progresión: G → Cm
cquintas[prog]> undo
Progresión: G
cquintas[prog]> finish
Progresión finalizada. Use reset para iniciar otra.
```

## Trazabilidad explícita

- Cada comando corresponde a un CU ya aprobado; no se agregan requisitos nuevos.
- La máquina de estados se implementa directamente: cada comando valida transición permitida. Ej.: desde `SISTEMA_INICIAL`, `map` está permitido; `goto` no.
- El modelo de dominio nutre validaciones: los enlaces armónicos definen qué `goto` son válidos según tónica/modo.

## Beneficios de la preparación de requisitos

- **Independencia de plataforma comprobable**: sin cambiar requisitos, se puede producir UI web o CLI.
- **Validación formal**: la FSM (diagrama de contexto) sirve como oráculo para permitir/denegar comandos (alcanzabilidad y bloqueos).
- **Consistencia funcional**: el conocimiento armónico (grados, secundarios, alterados) se reutiliza tal cual; solo cambia la vista.
- **Cobertura completa**: el único gap identificado en la implementación web (`finalizarProgresión`) queda ya previsto en CU/estado, listo para implementar igual en CLI.

## Siguientes pasos propuestos

1. Definir contrato de entrada/salida (texto plano) y formato de tabla ASCII.
2. Reusar la lógica de generación de mapa y navegación; empaquetarla en un módulo común para web/CLI.
3. Implementar intérprete de comandos simple (Node.js o Python) con tests unitarios que ejerzan la máquina de estados y validen `goto` según mapa.
