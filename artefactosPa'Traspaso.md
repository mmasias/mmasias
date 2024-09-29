# Un traspaso

## ¿Por qué?

Porque si no tengo una metodología, al momento que tenga que abordar el traspaso de un proyecto tendré cienmil ideas en la cabeza y no sabré por dónde empezar. O, lo que es peor, no tendré ninguna idea y tampoco sabré por dónde empezar.

## ¿Qué?

El traspaso de un proyecto es el proceso mediante el cual se transfiere la responsabilidad, el conocimiento y los recursos de un proyecto de un equipo a otro. Esto incluye:

- Documentación completa del estado actual del proyecto
- Transferencia de conocimiento técnico y de negocio
- Entrega de todos los artefactos relevantes
- Explicación de decisiones tomadas y razones detrás de ellas
- Identificación de riesgos y problemas conocidos
- Traspaso de relaciones con stakeholders y proveedores

## ¿Para qué?

Para hacerlo bien, de modo que pueda:

- Asegurar la continuidad del proyecto sin interrupciones significativas
- Minimizar la pérdida de conocimiento y experiencia
- Facilitar una transición suave para el nuevo equipo
- Reducir riesgos asociados con el cambio de equipo
- Mantener la calidad y el ritmo de desarrollo del proyecto
- Preservar la integridad de la visión y los objetivos del proyecto
- Proporcionar una base sólida para que el nuevo equipo pueda continuar y mejorar el proyecto

## ¿Cómo?

|Preparación|Recopilación|Transferencia|Verificación|Seguimiento|
|-|-|-|-|-|
|Identificar todos los stakeholders involucrados en el traspaso|Reunir toda la documentación existente|Organizar sesiones de traspaso entre equipos|Revisar la completitud de la información transferida|Establecer un período de soporte post-traspaso|
|Establecer un cronograma para el proceso de traspaso|Identificar los artefactos clave del proyecto|Documentar procesos y flujos de trabajo críticos|Realizar pruebas de acceso a todos los sistemas y herramientas|Programar revisiones periódicas para abordar dudas o problemas|
|Definir los roles y responsabilidades en el proceso|Listar todas las herramientas y tecnologías utilizadas|Realizar demostraciones de funcionalidades clave|Validar la comprensión del nuevo equipo mediante preguntas y escenarios|Recopilar feedback para mejorar el proceso de traspaso en futuras ocasiones|
|Crear un plan de comunicación para el traspaso|Recopilar métricas y KPIs del proyecto|Proporcionar documentación de procesos internos y mejores prácticas|Ejecutar un proyecto piloto o simulación de traspaso|Realizar una evaluación post-traspaso|
|Establecer los criterios de éxito para el traspaso||Facilitar la transferencia de relaciones con stakeholders clave||Ajustar procesos basados en las lecciones aprendidas|

Si además tengo una metodología, entonces puedo organizar una lista de elementos aterrizados a artefactos a pedir en el traspaso.

### Artefactos

|Nivel|Artefacto|Descripción|Completado|Pendiente|
|-------|-----------|-------------|------------|-----------|
|1. Visión general|Backlog del proyecto|Lista de funcionalidades y tareas|Product backlog inicial|Nuevas funcionalidades identificadas|
||||Historias o casos de uso completados|Historias de usuario o casos de uso no completados|
||||Documento de alcance original|Actualización del documento de alcance|
|2. Arquitectura|Diagramas de arquitectura|Representaciones visuales de la estructura del sistema|Diagrama de arquitectura general|Actualización de diagramas con nuevos componentes|
||||Diagramas de secuencia para procesos implementados|Diagramas de secuencia para procesos pendientes|
|2. Arquitectura|Documentación técnica|Documentos que explican la arquitectura y funcionamiento|Documento de arquitectura inicial|Actualización de la documentación de arquitectura|
||||Diagramas de componentes existentes|Nuevos casos de uso o historias identificados|
||||Casos de uso o historias implementados||
|3. Datos|Base de datos|Estructura y datos de la base de datos|Esquema de BD actual|Diseño de nuevas tablas o campos|
||||Datos existentes|Scripts de migración pendientes|
||||Diccionario de datos actual||
|4. Implementación|Código fuente|Todo el código desarrollado|Módulos completados|Módulos incompletos|
||||Funcionalidades implementadas|Funcionalidades por implementar|
||||Tests unitarios existentes|Refactorizaciones pendientes|
|4. Implementación|Configuraciones de entorno|Archivos y guías de configuración|Configuraciones para entornos existentes|Configuraciones para nuevos entornos|
||||Guías de instalación actuales|Actualizaciones de guías de instalación|
|5. Pruebas y calidad|Pruebas|Conjunto de pruebas del proyecto|Pruebas unitarias existentes|Nuevas pruebas unitarias por escribir|
||||Pruebas de integración actuales|Pruebas de integración pendientes|
||||Casos de prueba manuales definidos|Automatización de pruebas manuales|
|5. Pruebas y calidad|Registro de problemas|Lista de bugs y problemas|Bugs resueltos|Bugs abiertos|
||||Problemas conocidos y documentados|Nuevos problemas identificados|
|6. Interfaces|Documentación de API|Especificaciones de las APIs|Documentación de endpoints existentes|Documentación de nuevos endpoints|
||||Ejemplos de requests/responses actuales|Actualización de ejemplos|
|7. Seguridad|Credenciales y accesos|Información de acceso a sistemas y servicios|Lista actual de usuarios y roles|Nuevos accesos requeridos|
||||Documentación de permisos existentes|Actualizaciones de permisos pendientes|

#### Glosario de artefactos

1. **Product backlog**: Lista priorizada de todas las funcionalidades, requisitos y mejoras planificadas para un producto o proyecto.
1. **Documento de alcance**: Descripción detallada de los objetivos, entregables, límites y restricciones del proyecto.
1. **Historia de usuario**: Breve descripción de una funcionalidad desde la perspectiva del usuario final, utilizada en metodologías ágiles.
1. **Caso de uso**: Descripción detallada de cómo un actor (usuario o sistema externo) interactúa con el sistema para lograr un objetivo específico.
1. **Criterios de aceptación**: Condiciones que un producto debe satisfacer para ser aceptado por un usuario, cliente o stakeholder.
1. **Diagrama de arquitectura**: Representación visual de alto nivel de la estructura y componentes principales del sistema.
1. **Diagrama de secuencia**: Ilustración de cómo los objetos en un sistema interactúan entre sí a lo largo del tiempo para completar un proceso.
1. **Documento de arquitectura**: Descripción completa de la estructura, componentes, interfaces y comportamientos del sistema.
1. **Diagrama de componentes**: Representación visual de cómo los componentes de software se organizan e interactúan en el sistema.
1. **Esquema de base de datos**: Estructura que define cómo se organiza y almacena la información en una base de datos.
1. **Diccionario de datos**: Colección centralizada de información sobre los datos almacenados en una base de datos.
1. **Script de migración**: Código utilizado para transformar datos de un formato o sistema a otro.
1. **Prueba unitaria**: Método para probar unidades individuales de código fuente para determinar si funcionan correctamente.
1. **Prueba de integración**: Fase de prueba donde módulos de software individuales se combinan y prueban como un grupo.
1. **Configuración de entorno**: Conjunto de parámetros y variables que definen el ambiente en el que se ejecuta una aplicación.
1. **Documentación de API**: Descripción técnica de cómo interactuar con una API, incluyendo endpoints, métodos, parámetros y respuestas.
1. **Registro de problemas**: Lista documentada de defectos, errores o problemas identificados en el software.
1. **Lista de control de acceso**: Especificación de los permisos adjuntos a un objeto del sistema.
