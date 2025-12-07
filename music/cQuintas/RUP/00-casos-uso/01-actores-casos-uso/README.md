<div align=right>

|[![](https://img.shields.io/badge/-Inicio-FFF?style=flat&logo=Emlakjet&logoColor=black)](../../../README.md) [![](https://img.shields.io/badge/-RUP-FFF?style=flat&logo=Elsevier&logoColor=black)](../../) [![](https://img.shields.io/badge/-Modelo_del_dominio-FFF?style=flat&logo=freedesktop.org&logoColor=black)](../00-modelo-del-dominio/README.md) [![](https://img.shields.io/badge/-Actores_&_Casos_de_Uso-FFF?style=flat&logo=crewunited&logoColor=black)](./README.md) [![](https://img.shields.io/badge/-Diagrama_de_contexto-FFF?style=flat&logo=diagramsdotnet&logoColor=black)](./diagrama-contexto-musico.md) [![](https://img.shields.io/badge/-Detalle_&_Prototipo-FFF?style=flat&logo=typeorm&logoColor=black)](./00-detalle/) ![](https://img.shields.io/badge/-Análisis-FFF?style=flat&logo=multisim&logoColor=black)|
|-:|

</div>

# pyProgresionesArmonicas > Actores y Casos de Uso

|||
|-|-|
Proyecto|pyProgresionesArmonicas
Fase|Inicio
Disciplina|Requisitos
Iteración|1.0
Fecha|2025-12-07
Autor|Manuel Masías

## Encontrar actores y casos de uso

### Actores

<div align=center>

|Actor|Descripción|Responsabilidades|
|-|-|-|
|**Músico**|Usuario que compone música explorando progresiones armónicas|Seleccionar contexto tonal (tónica y modo), construir progresiones armónicas navegando entre acordes, consultar el mapa armónico para tomar decisiones compositivas

</div>

### Casos de uso

<div align=center>

|Configuración del contexto tonal|Gestión de la progresión armónica|
|-|-|
![](/images/music/cQuintas/RUP/00-casos-uso/01-actores-casos-uso/actores-casos-uso-001.svg)|![](/images/music/cQuintas/RUP/00-casos-uso/01-actores-casos-uso/actores-casos-uso-002.svg)
**seleccionarTónica()**: Elegir la nota base (tónica) de la tonalidad a explorar|**iniciarProgresión()**: Crear una nueva progresión armónica desde la tónica en el modo seleccionado
**seleccionarModo()**: Elegir entre Escala Mayor o Menor Natural|**consultarProgresión()**: Visualizar la secuencia actual de acordes en la progresión
**generarMapaArmónico()**: Calcular y visualizar todos los acordes y enlaces armónicos válidos para la tonalidad seleccionada|**extenderProgresión()**: Añadir un nuevo acorde a la progresión navegando desde el acorde actual
||**retrocederEnProgresión()**: Eliminar el último acorde añadido (deshacer)
||**finalizarProgresión()**: Marcar la progresión como completada, bloqueando edición
||**reiniciarProgresión()**: Eliminar toda la progresión y comenzar una nueva exploración

|![](/images/music/cQuintas/RUP/00-casos-uso/01-actores-casos-uso/actores-casos-uso-003.svg)
|-

</div>

### Diagrama de contexto

<div align=center>

|![](/images/music/cQuintas/RUP/00-casos-uso/01-actores-casos-uso/diagrama-contexto-musico.svg)
|-
|Código fuente: [diagrama-contexto-musico.puml](diagrama-contexto-musico.puml)

</div>

## 2Think

### Trazabilidad al modelo del dominio

<div align=center>

|Caso de Uso|Entidades del Dominio Involucradas|
|-|-|
|seleccionarTónica()|Nota
|seleccionarModo()|Escala
|generarMapaArmónico()|Escala, Acorde, GradoArmónico, FunciónArmónica, EnlaceArmónico, MapaArmónico
|iniciarProgresión()|ProgresiónArmónica, Acorde
|consultarProgresión()|ProgresiónArmónica
|extenderProgresión()|ProgresiónArmónica, Acorde, EnlaceArmónico, MapaArmónico
|retrocederEnProgresión()|ProgresiónArmónica
|finalizarProgresión()|ProgresiónArmónica
|reiniciarProgresión()|ProgresiónArmónica

</div>

### Enfoque metodológico

Como punto de partida pedagógico, aplicamos la regla: **"Para cada entidad del dominio, considerar operaciones CRUD (Crear, Leer, Actualizar, Eliminar)"**.

Sin embargo, el análisis crítico del dominio musical revela que no todas las entidades requieren gestión por el usuario. Las entidades se clasifican en:

<div align=center>

|Clasificación|Entidades|Razón|
|-|-|-|
|**Conocimiento del dominio**|Nota, Calidad, Escala, FunciónArmónica, EnlaceArmónico|Son conceptos musicales universales y fijos. Las 12 notas cromáticas, las calidades de acordes (Mayor, Menor, Disminuido, Dominante7), las funciones armónicas y las reglas de enlace son conocimiento teórico que no cambia.
|**Datos derivados/calculados**|Acorde, GradoArmónico, MapaArmónico|Se generan automáticamente a partir de la selección de Tónica y Modo. El usuario no los "crea" directamente, sino que el sistema los calcula según las reglas del conocimiento del dominio.
|**Datos del usuario**|ProgresiónArmónica|Es la única entidad que el usuario construye, modifica y gestiona activamente. Representa su trabajo creativo: la secuencia de acordes que está componiendo.

</div>

### Conclusión del análisis

Solo **ProgresiónArmónica** admite un CRUD completo, ya que es la única entidad que representa datos creados y gestionados por el usuario. Las demás entidades son conocimiento fijo o se derivan automáticamente.

Por tanto:

1. **La regla CRUD es un punto de partida**, no una aplicación mecánica
2. **El contexto del dominio determina qué operaciones tienen sentido**: En un sistema de composición musical asistida, el usuario no "crea notas" ni "edita funciones armónicas"; esos son conocimientos fijos
3. **La distinción entre tipos de datos es fundamental**: Conocimiento vs. Datos derivados vs. Datos del usuario
4. **El modelo del dominio informa directamente el diseño**: Las entidades, sus relaciones y su naturaleza guían qué casos de uso son necesarios

---

**Versión:** 1.0
**Estado:** En revisión
**Última actualización:** 2025-12-07
