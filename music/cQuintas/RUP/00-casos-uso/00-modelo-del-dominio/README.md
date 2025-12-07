# Generador de vectores armónicos > Modelo del dominio

|||
|-|-|
Proyecto|pyVectoresArmonicos
Fase|Inicio
Disciplina|Requisitos
Iteración|1.0
Fecha|2025-12-06
Autor|Manuel Masías

<div align=center>

|![Modelo de Dominio](/images/music/cQuintas/RUP/00-casos-uso/00-modelo-del-dominio/modelo-dominio.svg)
|:-:
|**Código fuente:** [modelo-dominio.puml](modelo-dominio.puml)

</div>

## Glosario

<div align=center>

|Entidad|Descripción|Características|
|-|-|-|
|**Nota**|Unidad básica del sistema musical occidental|Representa las 12 notas cromáticas (C, C#, D, D#, E, F, F#, G, G#, A, A#, B)|
|**Calidad**|Característica tonal de un acorde|Puede ser: Mayor, Menor, Disminuido, Dominante7|
|**Acorde**|Combinación de una nota raíz con una calidad|Unidad fundamental de navegación en el sistema (ej: C, Dm, G7, F#°)|
|**Escala**|Conjunto organizado de notas que define un contexto tonal|Actualmente soporta: Mayor y Menor Natural|
|**GradoArmónico**|Posición funcional de un acorde dentro de una escala|Identificado por numeración romana (I, II, iii, IV, V, vi, vii°) según el modo|
|**FunciónArmónica**|Rol que cumple un acorde en el contexto tonal|Puede ser: Tónica, Dominante, Subdominante, Mediante, Superdominante, Sensible|
|**VectorArmónico**|Relación direccional válida entre dos acordes|Define las progresiones permitidas con su fuerza y tipo (diatónica, cromática, modal)|
|**MapaArmónico**|Conjunto completo de vectores para una tonalidad específica|Contiene todos los acordes diatónicos, dominantes secundarios y acordes alterados para una tónica y modo dados|
|**ProgresiónArmónica**|Secuencia histórica de acordes navegados por el usuario|Representa el camino tomado durante la exploración, permitiendo análisis y deshacer acciones|

</div>

## Relaciones entre entidades

<div align=center>

|Composición|Agregación|Dependencia|
|-|-|-|
|**Escala** ◆─ **Nota**: Una escala se compone de un conjunto específico de notas. Las notas no tienen sentido aisladas en este contexto.|**Acorde** ○─ **Nota**: Un acorde tiene una nota raíz, pero la nota existe independientemente del acorde.|**ProgresiónArmónica** ⋯> **MapaArmónico**: La progresión usa el mapa para validar movimientos válidos durante la navegación.
|**MapaArmónico** ◆─ **VectorArmónico**: El mapa armónico está compuesto por todos sus vectores. Los vectores existen solo en el contexto de un mapa.|**Acorde** ○─ **Calidad**: Un acorde tiene una calidad (mayor, menor, etc.), que es un concepto independiente.
||**GradoArmónico** ○─ **Acorde**: Cada grado representa un acorde específico, pero el acorde puede existir fuera del contexto de grado.
||**GradoArmónico** ○─ **FunciónArmónica**: Cada grado cumple una función, pero la función es un concepto abstracto reutilizable.
||**VectorArmónico** ○─ **Acorde** (origen): El vector parte de un acorde.
||**VectorArmónico** ○─ **Acorde** (destino): El vector apunta a un acorde.
||**MapaArmónico** ○─ **Escala**: El mapa está basado en una escala, pero la escala existe conceptualmente de forma independiente.
||**ProgresiónArmónica** ○─ **Acorde**: La progresión contiene una secuencia de acordes visitados.

</div>

## Ajustes

<div align=center>

|Ajuste|Decisión|Justificación|
|-|-|-|
|**Refinamiento de "Escala"**|Modelar Escala como entidad separada en lugar de como atributo del MapaArmónico.|Permite futuras extensiones a otros modos (menor armónica, menor melódica, modos griegos) sin modificar la estructura del mapa.
|**Separación de "VectorArmónico" y "Acorde"**|Los vectores son entidades independientes que conectan acordes, no propiedades de los acordes.|Un mismo acorde puede tener diferentes vectores salientes dependiendo del contexto tonal (mayor vs menor), por lo que la relación debe ser explícita.
|**Inclusión de "ProgresiónArmónica"**|**Decisión:** Modelar el historial de navegación como entidad del dominio.|**Justificación:** No es solo un artefacto técnico de UI, sino un concepto del dominio musical (análisis de progresiones, patrones comunes, etc.).

</div>

## Vocabulario del dominio

<div align=center>

||||
|-|-|-|
|Conceptos fundamentales|**Tónica**|Acorde central o "casa" de una tonalidad
||**Resolución**|Movimiento armónico que reduce tensión, típicamente hacia la tónica
||**Tensión**|Calidad de un acorde que busca resolver a otro más estable
||**Cadencia**|Secuencia específica de acordes que cierra una frase musical
||**Cromatismo**|Uso de notas fuera de la escala diatónica
|Tipos de acordes por origen|**Diatónicos**|Formados exclusivamente con notas de la escala
||**Dominantes secundarios**|Acordes de séptima dominante que resuelven a grados diatónicos (ej: V/II, V/IV)
||**Intercambio modal**|Acordes prestados del modo paralelo (ej: IVm en mayor, IV en menor)
||**Sustitutos**|Acordes que pueden reemplazar funcionalmente a otros (ej: SubV7 por V7)
|Conceptos de navegación|**Vectores entrantes**|Acordes válidos que pueden preceder al acorde actual
||**Vectores salientes**|Acordes válidos que pueden seguir al acorde actual
||**Navegación en caliente**|Capacidad de cambiar de modo (mayor/menor) durante la exploración sin reiniciar

</div>

## Referencias

- [Casos de uso](../01-actores-casos-uso/actores-casos-uso.md)
- [Ejemplos de uso](../../../ejemplos.md)
- [Código fuente](../../../script.js)

---

**Versión:** 1.0
**Estado:** Aprobado
**Última actualización:** 2025-12-06
