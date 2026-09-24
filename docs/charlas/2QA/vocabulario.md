# Vocabulario

## Actores de pruebas, según el SUT

| Tipo | Autor | SUT | Objetivo |
|---|---|---|---|
| Aceptación | Usuario | El sistema completo, desde la interfaz de usuario hasta la persistencia (*application under test*, AUT). Una rodaja funcional de arriba a abajo del sistema de acuerdo a los documentos de especificación de requisitos. | Validar los requerimientos iniciales, casos de uso, historias de usuario, manuales de usuario, ... |
| Sistema | Probador con Usuario | El sistema completo, desde la interfaz de usuario hasta la persistencia (*application under test*, AUT). Una rodaja funcional de arriba a abajo del sistema de acuerdo a los documentos de especificación de requisitos. | Verificar los requerimientos iniciales, casos de uso, historias de usuario, manuales de usuario, ..., independiente de las decisiones de diseño de la arquitectura de software |
| Integración | Probador | Varios componentes/subsistemas que proporcionan colectivamente un cierto servicio | Verificar las colaboraciones entre los componentes de un mismo sistema, comunicación entre subsistemas (por ejemplo: DLL, jar, servicio web, ...) o entre hardware y software |
| Componente | Probador | Varias clases de un componente que proporcionan colectivamente un cierto servicio | Verificar el funcionamiento correcto, independientemente de otros componentes |
| Unitaria | Desarrollador | Una sola clase (*class unit test*, CUT). Un solo objeto (*object unit test*, OUT). Un solo método (*method unit test*, MUT). | Verificar el funcionamiento correcto |

## Tipos de prueba, según la característica

| Pruebas Funcionales | Pruebas No Funcionales |
|---|---|
| Verifican aspectos funcionales del comportamiento del SUT. | Verifican aspectos no funcionales del comportamiento del SUT: escalabilidad, portabilidad, seguridad, ... |

### Pruebas No Funcionales

| Tipo | Verifica |
|---|---|
| Pruebas de Rendimiento | Niveles de rendimiento acordados en los requisitos, en las situaciones previstas de interacción (entradas, transacciones, ...). Los criterios de éxito son la comparación de dichos valores establecidos para el volumen de transacciones (*throughput*), el tiempo y/o velocidad de respuesta, ... Informan al equipo de producción de las tareas de optimización a acometer. |
| Prueba de carga, de esfuerzo o de escalabilidad | Las condiciones de uso del sistema bajo una pesada carga de datos, la repetición de ciertas acciones de los datos de entrada, los grandes valores numéricos, consultas grandes a una base de datos, o para comprobar el nivel de usuarios concurrentes que soporta la escalabilidad, generando situaciones en un máximo nivel. El criterio de éxito es la resistencia a que el tiempo de respuesta no se degrade. |
| Pruebas de estrés o volumen | Los límites del sistema escalando la cantidad de carga con el tiempo, con el objetivo de examinar cómo falla y vuelve a su funcionamiento normal. Puede incluir cargas de trabajo extremas, limitaciones de memoria, hardware y servicios disponibles, o recursos compartidos limitados. Informan de las tareas de recuperabilidad a acometer: que la aplicación siga funcionando después de que el servidor se haya reiniciado o se haya agotado su espacio en disco. |
| Prueba de estabilidad | Anomalías como pérdidas de memoria u otras degradaciones por la continuidad de la ejecución durante más de 24 horas. |
| Pruebas de Usabilidad | Aptitud para el uso, mediante la confirmación de que los usuarios reales pueden usar la aplicación de software para lograr los objetivos fijados, informando de si se presentan interfaces engorrosas que no siguen los flujos de trabajo normales o esperados. |
| Pruebas de Seguridad | La presencia de virus y gusanos, delincuentes que entran en el sistema, vándalos que causan ataques de denegación de servicio y mucho más. |
| Pruebas de Manejo y Recuperación de Errores y Desastres | Comportamientos con entradas no válidas, fallos en conexiones o del sistema operativo, archivos dañados, etc. |
| Pruebas de Instalación y Desinstalación | Cosas que pueden ir mal cuando se instala/desinstala una aplicación: la instalación causa daños en el sistema o no se instala, en especial con configuraciones mínima, máxima o inusuales; la desinstalación no elimina completamente los archivos y deshace los cambios, elimina demasiados archivos, o "deshace" cosas que la instalación no hizo. |
| Pruebas de Configuración, Compatibilidad o Portabilidad | Capacidad de ejecutarse en diferentes versiones o configuraciones de los entornos, hardware y software, como con diversos navegadores o versiones de los mismos. |
| Pruebas de Internacionalización y Localización | Soportar configuraciones locales, idiomas o leyes -- por ejemplo, si el sistema no soporta los conjuntos de caracteres del lenguaje local, o si no contempla los efectos locales de distintos calendarios de distintos usuarios. |
| Pruebas de Manejo de Fecha y Hora | Tratamientos de expiración de fechas, zonas horarias o eventos basados en fechas u horas. |
| Pruebas de Mantenibilidad | La fluidez, flexibilidad, reusabilidad y robustez del código de producción. |

## Resumen de tipos de pruebas

### Requisitos

| Característica | SUT | Táctica | Ejecución | Herramienta | Objetivo | Cuándo | Rol |
|---|---|---|---|---|---|---|---|
| Func. y No Func. | Sistema | Estática | Manual | Inspección | Validación de Requisitos | Inicio Iteración | Analista de Sistemas |

### Diseño

| Característica | SUT | Táctica | Ejecución | Herramienta | Objetivo | Cuándo | Rol |
|---|---|---|---|---|---|---|---|
| Func. y No Func. | Sistema, Integración, Componente y Unidad | Estática | Manual | Inspección | Verificación de Diseño (subjetiva) | Final Iteración | Arquitecto, Desarrollador Senior |
| Func. y No Func. | Sistema, Integración, Componente y Unidad | Estática | Automática/Manual | CASE + Inspección | Verificación de Métricas de Diseño (subjetiva) | Final Iteración | Arquitecto, Desarrollador Senior |
| Func. y No Func. | Sistema, Integración, Componente y Unidad | Estática | Automática | CASE | Verificación de Métricas de Diseño (objetiva) | Final Iteración | Arquitecto, Desarrollador Senior |

### Implementación

| Característica | SUT | Táctica | Ejecución | Herramienta | Objetivo | Cuándo | Rol |
|---|---|---|---|---|---|---|---|
| <sub>Func. y No Func.</sub> | <sub>Sistema, Integración, Componente y Unidad</sub> | <sub>Estática</sub> | <sub>Manual</sub> | <sub>Inspección</sub> | <sub>Verificación de Diseño (subjetiva)</sub> | <sub>Final Iteración</sub> | <sub>Arquitecto, Desarrollador Senior</sub> |
| <sub>Func. y No Func.</sub> | <sub>Sistema, Integración, Componente y Unidad</sub> | <sub>Estática</sub> | <sub>Automática/Manual</sub> | <sub>SonarQube + Inspección</sub> | <sub>Verificación de Métricas de Diseño (subjetiva)</sub> | <sub>Final Iteración</sub> | <sub>Arquitecto, Desarrollador Senior</sub> |
| <sub>Func. y No Func.</sub> | <sub>Sistema, Integración, Componente y Unidad</sub> | <sub>Estática</sub> | <sub>Automática</sub> | <sub>SonarQube</sub> | <sub>Verificación de Métricas de Diseño (objetiva)</sub> | <sub>Final Iteración</sub> | <sub>Arquitecto, Desarrollador Senior</sub> |
| <sub>Funcionales</sub> | <sub>Unidad</sub> | <sub>Caja Blanca y Caja Negra</sub> | <sub>Automática</sub> | <sub>xUnit, xUnit Reproducción</sub> | <sub>Verificación de la Funcionalidad de la Implementación</sub> | <sub>Continuamente</sub> | <sub>Desarrollador</sub> |
| <sub>Funcionales</sub> | <sub>Integración y Componente</sub> | <sub>Caja Blanca y Caja Negra</sub> | <sub>Automática</sub> | <sub>xUnit, xUnit Reproducción</sub> | <sub>Verificación de la Funcionalidad de la Implementación</sub> | <sub>Final Iteración</sub> | <sub>Probador</sub> |
| <sub>Funcionales</sub> | <sub>Sistema</sub> | <sub>Caja Negra</sub> | <sub>Automática</sub> | <sub>Robot, xUnit Moderno, xUnit*</sub> | <sub>Verificación de la Funcionalidad de la Implementación</sub> | <sub>Final Iteración</sub> | <sub>Probador</sub> |
| <sub>No Funcionales</sub> | <sub>Sistema, Integración, Componente y Unidad</sub> | <sub>Caja Negra</sub> | <sub>Automática</sub> | <sub>Jmeter, xUnit</sub> | <sub>Verificación de Umbrales No Funcionales de la Implementación</sub> | <sub>Final Iteración</sub> | <sub>Probador</sub> |
| <sub>Func. y No Func.</sub> | <sub>Aceptación</sub> | <sub>Caja Negra</sub> | <sub>Manual</sub> | <sub>Inspección</sub> | <sub>Validación de Requisitos</sub> | <sub>Fin Iteración</sub> | <sub>Usuario</sub> |

