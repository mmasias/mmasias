# Proyecto de auditoría de repositorios GitHub en entornos educativos

## ¿Por qué?

El uso de GitHub como infraestructura pedagógica en Ingeniería Informática está consolidado: en la Universidad Europea del Atlántico se utiliza en 9 asignaturas del grado, cubriendo desde Programación I hasta Dirección de Sistemas de la Información. La adopción no es experimental: es estructural.

Sin embargo, cuanto mayor es esa adopción, mayor es el coste de evaluación rigurosa y el riesgo de comprometer la objetividad. La razón es que la evaluación individualizada dentro de proyectos grupales permanece sin resolver. Las causas son concretas:

|Las métricas nativas son insuficientes|La revisión manual no escala|La visualización existente es plana|
|-|-|-|
El número de commits y las líneas de código son manipulables y no capturan calidad, impacto ni evolución real del conocimiento del estudiante.|Los docentes dependen de inspección directa del historial de commits, un proceso laborioso, subjetivo y proporcional al número de estudiantes, no al valor de la información obtenida.|GitHub no ofrece representaciones temporales, relacionales ni comparativas que permitan identificar patrones de trabajo, distribución de carga real o evolución de las contribuciones a lo largo del proyecto.

> *commit* es un término que equivale a *anotación firmada en un cuaderno de laboratorio*
>
> *repositorio* es el espacio de trabajo compartido donde cada equipo desarrolla (y por tanto registra) su avance.

## ¿Qué?

Un sistema de auditoría especializado para repositorios GitHub, diseñado específicamente para entornos educativos, que transforma el historial de un repositorio en información evaluable de forma objetiva y eficiente.

El sistema opera sobre cuatro ejes funcionales:

- **Reproductor de commits:** reconstrucción cronológica de la evolución del código, permitiendo observar el proceso de desarrollo, no solo el producto final.
- **Mapas de calor de autoría:** identificación visual de qué autor modificó qué partes del código y con qué densidad temporal.
- **Diagramas de burbujas de actividad:** representación comparativa del volumen y distribución de contribuciones por miembro del equipo.
- **Visualizador de ramas:** relaciones temporales entre líneas de trabajo paralelas y los momentos en que se integran, revelando cómo se organizó realmente la colaboración.

La unidad de análisis no es el commit aislado, sino el patrón de comportamiento del desarrollador a lo largo del tiempo.

## ¿Para qué?

|||
|-|-|
**Para el docente**|Reduce el coste de evaluación individualizada en proyectos grupales sin reducir su rigor. Sustituye la revisión manual y subjetiva por evidencia visual estructurada. Escala con el número de estudiantes sin degradar la calidad del análisis.
**Para el estudiante**|La trazabilidad continua del proceso convierte el repositorio en un registro de aprendizaje verificable. Promueve la adopción de buenas prácticas de desarrollo (commits significativos, gestión de ramas, distribución equitativa de trabajo) no como requisito formal sino como consecuencia directa de que el proceso es evaluado.
**Para la institución**|Proporciona una metodología de evaluación de trabajos en equipo que es objetiva, reproducible y auditable. Reduce la dependencia de criterios subjetivos en situaciones de disputa o reclamación. Genera datos estructurados sobre patrones de aprendizaje que pueden informar decisiones curriculares.
**Para el campo**|Cubre una necesidad documentada en la literatura: la ausencia de herramientas de visualización adaptadas al contexto educativo en plataformas de control de versiones. El sistema es generalizable a cualquier institución con adopción similar de GitHub.

## ¿Cómo?

|||
|-|-|
|**Desarrollo**| Metodología con ciclos iterativos, validando funcionalidades con docentes reales en cada fase del desarrollo. El sistema ha sido implementado y probado en asignaturas activas del Grado en Ingeniería Informática de la Universidad Europea del Atlántico.
|**Validación**|Aplicación directa en contexto real, no en condiciones de laboratorio. Los repositorios analizados corresponden a proyectos de estudiantes en asignaturas del grado, con evaluaciones paralelas (manual vs. sistema) para contrastar resultados.
|**Integración**|La herramienta opera directamente sobre GitHub, sin requerir modificaciones en los flujos de trabajo existentes. La adopción por parte del docente no impone cambios en la dinámica del curso.
|**Escalabilidad**|El análisis automatizado elimina la dependencia del tiempo del docente como factor limitante. Un curso con 80 estudiantes es analizable con el mismo esfuerzo que uno con 20.
