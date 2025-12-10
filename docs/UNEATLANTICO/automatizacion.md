# Automatización de evaluación de trabajos - con GitHub

## ¿Por qué?

La evaluación manual de trabajos de programación presenta varios problemas que afectan tanto la eficiencia como la calidad del proceso educativo:

- **Tiempo excesivo en validaciones básicas**: Con 60 estudiantes por asignatura, se requieren aproximadamente 5 horas solo para verificar aspectos estructurales básicos (nomenclatura de archivos, estructura de carpetas, rama correcta), tiempo que podría destinarse a retroalimentación pedagógica más valiosa.
- **Feedback tardío y poco específico**: Los estudiantes reciben comentarios días después de la entrega, y frecuentemente los errores básicos no se explican con suficiente detalle, lo que dificulta el aprendizaje y genera confusión.
- **Inconsistencia en criterios**: La evaluación manual puede variar según el cansancio del evaluador o el orden de revisión, generando percepciones de injusticia entre los estudiantes.
- **Sobrecarga administrativa**: El proceso actual mezcla validaciones técnicas rutinarias con evaluación pedagógica real, reduciendo el tiempo disponible para aspectos que requieren criterio profesional docente.
- **Falta de escalabilidad**: A medida que aumenta el número de estudiantes o la complejidad de los trabajos, el proceso se vuelve insostenible sin comprometer la calidad de la evaluación.

## ¿Qué?

Se propone un sistema de automatización progresiva basado en GitHub Actions que establece múltiples niveles de validación automática antes de la revisión docente.

Este enfoque implementa un pipeline de evaluación que separa claramente las validaciones técnicas automáticas de la evaluación pedagógica humana. El sistema actúa como un filtro inteligente que rechaza automáticamente trabajos con errores estructurales básicos, proporcionando feedback inmediato y específico a los estudiantes.

La solución se estructura en capas de complejidad creciente, comenzando con validaciones básicas de estructura y nomenclatura, y progresando hacia evaluaciones más sofisticadas como compilación automática, ejecución de tests unitarios y análisis de calidad de código.

## ¿Para qué?

- **Reducción drástica del tiempo de evaluación**: Las validaciones automáticas eliminan la necesidad de revisar manualmente trabajos con errores básicos, liberando hasta 4 horas por ciclo de evaluación que pueden destinarse a retroalimentación pedagógica de mayor valor.
- **Feedback inmediato y educativo**: Los estudiantes reciben comentarios específicos en el momento exacto del pull request, permitiendo correcciones inmediatas y aprendizaje en tiempo real sobre buenas prácticas de entrega.
- **Consistencia absoluta en criterios básicos**: Todos los trabajos se evalúan con exactamente los mismos criterios técnicos, eliminando la variabilidad humana en aspectos objetivos y garantizando equidad.
- **Mejora en la calidad de las entregas**: Al rechazar automáticamente trabajos mal estructurados, se incentiva a los estudiantes a seguir las convenciones establecidas, mejorando gradualmente sus hábitos de desarrollo.
- **Escalabilidad ilimitada**: El sistema puede manejar cualquier número de estudiantes sin incremento proporcional en tiempo de evaluación, y se adapta fácilmente a diferentes tipos de asignaturas.
- **Trazabilidad completa**: Cada validación queda registrada automáticamente, proporcionando métricas sobre errores comunes y permitiendo mejoras continuas en el proceso educativo.

## ¿Cómo?

### Implementación por fases

#### Fase 1: Validaciones estructurales básicas

Se configura un GitHub Action que se ejecuta automáticamente cuando se crea un pull request hacia las ramas de entrega. Este action implementa las siguientes validaciones:

```java
// Ejemplo de estructura esperada para validación
src/
├── main/
│   └── java/
│       └── com/
│           └── universidad/
│               └── [asignatura]/
│                   └── [nombre-trabajo]/
│                       └── Main.java
modelosUML/
├── diagrama-clases.puml
└── diagrama-secuencia.puml
images/
├── diagrama-clases.svg
└── diagrama-secuencia.svg
documents/
└── [documentos-adicionales].md
README.md
```

El sistema verifica automáticamente:

- Nombre correcto de la rama de origen del PR
- Estructura de carpetas según el template establecido
- Nomenclatura de archivos siguiendo convenciones
- Presencia de archivos obligatorios según el tipo de trabajo
- Formato correcto de archivos (extensiones permitidas)

#### Fase 2: Validaciones de compilación

Se añade compilación automática del código Java para verificar:

```java
// El sistema ejecuta automáticamente:
javac -cp "src/main/java" src/main/java/**/*.java

// Y valida:
// - Ausencia de errores de compilación
// - Warnings críticos de compilación
// - Dependencias correctamente resueltas
```

#### Fase 3: Validaciones funcionales básicas

Para trabajos que requieren funcionalidad específica:

```java
// Ejemplo de test automático básico
public class ValidacionAutomatica {
    public static void main(String[] args) {
        // Ejecuta la clase principal del estudiante
        // Verifica salida esperada para casos de prueba básicos
        // Valida manejo de errores fundamentales
    }
}
```

#### Fase 4: Análisis de calidad (*Opcional*)

Integración con herramientas de análisis estático como [SpotBugs](https://spotbugs.github.io/) o [Checkstyle](https://checkstyle.sourceforge.io/) para evaluar:

- Cumplimiento de convenciones de codificación
- Detección de problemas potenciales de rendimiento
- Análisis de complejidad ciclomática

### Scripting

#### Configuración del GitHub Action

Se crea un archivo `.github/workflows/evaluacion-automatica.yml` en el repositorio principal:

```yaml
name: Evaluación Automática de Trabajos

on:
  pull_request:
    branches: [ 'entrega-*' ]

jobs:
  validacion-basica:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Validar Estructura
      run: |
        python scripts/validar-estructura.py
    
    - name: Configurar Java
      uses: actions/setup-java@v3
      with:
        java-version: '17'
        distribution: 'temurin'
    
    - name: Compilar Código
      run: |
        javac -cp "src/main/java" src/main/java/**/*.java
    
    - name: Ejecutar Tests Básicos
      run: |
        java -cp "src/main/java" ValidacionAutomatica
    
    - name: Comentar Resultado
      uses: actions/github-script@v6
      with:
        script: |
          // Genera comentario automático con resultados
          github.rest.issues.createComment({
            issue_number: context.issue.number,
            owner: context.repo.owner,
            repo: context.repo.repo,
            body: '✅ Validaciones automáticas completadas correctamente'
          })
```

#### Scripts de validación

Se desarrollan scripts específicos para cada tipo de validación:

```java
// ValidadorEstructura.java - Ejemplo de validación
import java.io.*;
import java.nio.file.*;

public class ValidadorEstructura {
    public static boolean validarEstructura(String rutaProyecto) {
        Path proyecto = Paths.get(rutaProyecto);
        
        // Verificar carpetas obligatorias
        if (!Files.exists(proyecto.resolve("src"))) {
            System.err.println("ERROR: Falta carpeta src/");
            return false;
        }
        
        if (!Files.exists(proyecto.resolve("README.md"))) {
            System.err.println("ERROR: Falta archivo README.md");
            return false;
        }
        
        // Validaciones adicionales según tipo de trabajo
        return true;
    }
}
```

#### Integración con Google Sheets existente

Se mantiene la integración actual con Google Sheets, enriqueciendo los datos:

```java
// Se pueden exportar automáticamente:
// - Estado de validaciones automáticas
// - Timestamp de última validación exitosa
// - Lista de errores encontrados por estudiante
// - Métricas de calidad de código
```

#### Configuración diferenciada por asignatura

El sistema se adapta automáticamente según el tipo de trabajo:

```yaml
# Para PRG1 - Validaciones básicas
- Estructura simple de clases
- Compilación básica
- Ejecución sin errores

# Para PRG2 - Orientación a objetos
- Validación de patrones OOP
- Tests de encapsulación
- Verificación de herencia

# Para EDA - Algoritmos y estructuras
- Tests de complejidad temporal
- Validación de estructuras de datos
- Benchmarks automáticos

# Para IDSW - Documentación
- Validación de Markdown
- Validación de PlantUML
- Verificación de enlaces
```

## ¿Y ahora qué?

Una vez implementado el sistema básico, se abren múltiples posibilidades de expansión:

- **Métricas avanzadas**: Implementación de dashboards que muestren tendencias de errores comunes, permitiendo ajustar la enseñanza según las dificultades detectadas automáticamente.
- **Feedback pedagógico personalizado**: Desarrollo de un sistema que genere sugerencias específicas basadas en los errores más frecuentes de cada estudiante.
- **Integración con sistemas de calificación**: Conexión automática con plataformas de gestión académica para actualizar calificaciones parciales automáticamente.
- **Análisis de plagio automático**: Implementación de herramientas que detecten similitudes sospechosas entre trabajos de diferentes estudiantes.
- **Gamificación del proceso**: Creación de un sistema de badges y logros que reconozca buenas prácticas de entrega y calidad de código.

La implementación puede comenzarse inmediatamente con la [Fase 1](automatizacion-fase1.md), obteniendo beneficios inmediatos en la reducción de tiempo de evaluación manual, y progresarse gradualmente según las necesidades específicas de cada asignatura.