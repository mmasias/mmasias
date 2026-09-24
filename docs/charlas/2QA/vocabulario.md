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
| Func. y No Func. | Sistema, Integración, Componente y Unidad | Estática | Manual | Inspección | Verificación de Diseño (subjetiva) | Final Iteración | <sub>Arquitecto, Desarrollador Senior |
| Func. y No Func. | Sistema, Integración, Componente y Unidad | Estática | Automática/Manual | SonarQube + Inspección | Verificación de Métricas de Diseño (subjetiva) | Final Iteración | <sub>Arquitecto, Desarrollador Senior |
| Func. y No Func. | Sistema, Integración, Componente y Unidad | Estática | Automática | SonarQube | Verificación de Métricas de Diseño (objetiva) | Final Iteración | <sub>Arquitecto, Desarrollador Senior |
| Funcionales | Unidad | Caja Blanca y Caja Negra | Automática | xUnit, xUnit Reproducción | Verificación de la Funcionalidad de la Implementación | Continuamente | <sub>Desarrollador |
| Funcionales | Integración y Componente | Caja Blanca y Caja Negra | Automática | xUnit, xUnit Reproducción | Verificación de la Funcionalidad de la Implementación | Final Iteración | <sub>Probador |
| Funcionales | Sistema | Caja Negra | Automática | Robot, xUnit Moderno, xUnit* | Verificación de la Funcionalidad de la Implementación | Final Iteración | <sub>Probador |
| No Funcionales | Sistema, Integración, Componente y Unidad | Caja Negra | Automática | Jmeter, xUnit | Verificación de Umbrales No Funcionales de la Implementación | Final Iteración | <sub>Probador |
| Func. y No Func. | Aceptación | Caja Negra | Manual | Inspección | Validación de Requisitos | Fin Iteración | Usuario |

