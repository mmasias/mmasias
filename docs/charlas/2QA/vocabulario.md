# Vocabulario

## Actores de pruebas, según el SUT

| Tipo | Autor | SUT | Objetivo |
|---|---|---|---|
| Aceptación | Usuario | El sistema completo, desde la interfaz de usuario hasta la persistencia (*application under test*, AUT). Una rodaja funcional de arriba a abajo del sistema de acuerdo a los documentos de especificación de requisitos. | Validar los requerimientos iniciales, casos de uso, historias de usuario, manuales de usuario, ... |
| Sistema | Probador con Usuario | El sistema completo, desde la interfaz de usuario hasta la persistencia (*application under test*, AUT). Una rodaja funcional de arriba a abajo del sistema de acuerdo a los documentos de especificación de requisitos. | Verificar los requerimientos iniciales, casos de uso, historias de usuario, manuales de usuario, ..., independiente de las decisiones de diseño de la arquitectura de software |
| Integración | Probador | Varios componentes/subsistemas que proporcionan colectivamente un cierto servicio | Verificar las colaboraciones entre los componentes de un mismo sistema, comunicación entre subsistemas (por ejemplo: DLL, jar, servicio web, ...) o entre hardware y software |
| Componente | Probador | Varias clases de un componente que proporcionan colectivamente un cierto servicio | Verificar el funcionamiento correcto, independientemente de otros componentes |
| Unitaria | Desarrollador | Una sola clase (*class unit test*, CUT). Un solo objeto (*object unit test*, OUT). Un solo método (*method unit test*, MUT). | Verificar el funcionamiento correcto |

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

