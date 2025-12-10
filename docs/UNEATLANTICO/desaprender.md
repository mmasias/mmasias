# AcercaDe desaprender...

## ¿Por qué?

El aprendizaje de buenas prácticas de programación no siempre se produce de manera lineal, especialmente en estudiantes que ya poseen conocimientos previos. La acumulación de experiencias en desarrollo de software, a menudo adquiridas de manera autodidacta o en entornos que priorizan resultados inmediatos sobre la calidad del código, suele crear hábitos y patrones mentales que obstaculizan la adopción de principios más sólidos de ingeniería. 

Se hace necesario pues un proceso ***consciente*** de "desaprendizaje" como paso previo a la incorporación de nuevos conceptos y metodologías que promuevan un desarrollo más robusto, mantenible y escalable. Este proceso de desaprendizaje no debe entenderse como un descarte total del conocimiento anterior, sino como una reevaluación crítica que permite identificar qué elementos deben ser refinados, reformulados o reemplazados.

## ¿Qué?

El desaprendizaje en programación se define como el proceso mediante el cual los estudiantes reconocen, cuestionan y abandonan prácticas subóptimas previamente adquiridas, para dar paso a aproximaciones al diseño y desarrollo más estructurados. Este fenómeno se manifiesta particularmente entre programadores con experiencia previa que se enfrentan a metodologías formales por primera vez.

Entre los conceptos que frecuentemente deben ser "desaprendidos" se incluyen:

- La programación monolítica sin adecuada modularización.
- La duplicación excesiva de código.
- La dependencia de variables globales.
- El acoplamiento excesivo entre componentes.
- La ausencia de encapsulamiento adecuado.
- El diseño impulsado por la implementación en lugar de por la interfaz.
- La falta de planificación en la estructura del código.
- La resolución rápida pero subóptima de problemas.

|Concepto||
|-|-|
|La programación monolítica sin adecuada modularización|Un método de 200 líneas que realiza múltiples tareas (lectura de archivos, procesamiento, validación y generación de informes) en lugar de dividirlo en métodos especializados|
|La duplicación excesiva de código|Copiar y pegar el mismo bloque de validación de datos en múltiples métodos en lugar de crear un método auxiliar `validarEntrada()`|
|La dependencia de variables globales|Usar `static double resultado;` accesible desde cualquier parte del programa en lugar de pasar valores como parámetros o retornos|
|El acoplamiento excesivo entre componentes|Una clase `Calculadora` que conoce detalles internos de implementación de `BaseDatos` y debe modificarse si la base de datos cambia|
|La ausencia de encapsulamiento adecuado|Definir todos los atributos como públicos (`public double[] numeros;`) en lugar de privados con métodos de acceso controlado|
|El diseño impulsado por la implementación en lugar de por la interfaz|Imprimir siempre resultados en consola (`System.out.println(resultado)`) en lugar de devolver valores que puedan ser utilizados de diferentes formas|
|La falta de planificación en la estructura del código|Agregar métodos y funcionalidades sin considerar la organización lógica, resultando en clases como `Utilidades` que contienen métodos no relacionados|
|La resolución rápida pero subóptima de problemas|Resolver un problema complejo con un único método extenso que mezcla múltiples niveles de abstracción, sin separar responsabilidades ni identificar operaciones atómicas reutilizables|

La clave del desaprendizaje efectivo no radica en descartar completamente la experiencia acumulada, sino en desarrollar la capacidad crítica para evaluar qué prácticas deben evolucionar hacia estándares más profesionales.

## ¿Para qué?

El proceso de desaprendizaje en programación ofrece beneficios significativos:

- Se facilita la transición hacia metodologías más formales y estructuradas, preparando a los estudiantes para entornos profesionales exigentes
- Se reduce la resistencia a la adopción de nuevos paradigmas y buenas prácticas, superando la barrera del "siempre lo he hecho así"
- Se aprovecha la experiencia previa como marco de referencia comparativo, reforzando el valor de los nuevos conocimientos
- Se desarrolla un pensamiento crítico sobre las propias prácticas, fomentando la mejora continua
- Se establecen bases sólidas para el aprendizaje avanzado de patrones de diseño, arquitecturas complejas y desarrollo colaborativo
- Se prepara a los estudiantes para adaptarse a los cambios tecnológicos constantes en el campo de la programación

Este enfoque resulta particularmente valioso en estudiantes que han desarrollado proyectos por su cuenta y ahora deben adaptarse a estándares profesionales, pues les permite reconocer las limitaciones de sus enfoques anteriores y valorar las metodologías más estructuradas.

## ¿Cómo?

Para facilitar el proceso de desaprendizaje y posterior aprendizaje de mejores prácticas, se pueden implementar diversas estrategias pedagógicas:

### Uso de ejemplos concretos del trabajo de los propios estudiantes

El análisis de soluciones reales desarrolladas por los estudiantes proporciona material didáctico relevante y contextualizado. Por ejemplo, al revisar diferentes implementaciones de un método `invertir()` en una calculadora:

```java
// Solución original de un estudiante
public void invertir() {
    if (verificarOperandos(1)) {
        double[] operando = extraerOperandos(1);
        ingresarNumero(operando[0] - (operando[0] + operando[0]));
    }
}

// Solución directa del instructor
public void invertir() {
    if (verificarOperandos(1)) {
        double[] operadores = extraerOperandos(1);
        ingresarNumero(operadores[0] * -1);
    }
}

// Solución basada en operaciones primitivas existentes
public void invertir() {
    if (verificarOperandos(1)) {
        double[] operadores = extraerOperandos(1);
        ingresarNumero(operadores[0]);
        ingresarNumero(-1);
        multiplicar();
    }
}
```

Mediante el análisis comparativo de estas soluciones, se puede guiar a los estudiantes a reconocer principios como la cohesión, la reutilización y la composición de operaciones primitivas.

### Confrontación de problemas derivados de malas prácticas

Es necesario presentar escenarios donde las prácticas subóptimas conducen a problemas concretos:

- Demostrar cómo la falta de modularidad complica el mantenimiento cuando los requisitos cambian
- Ilustrar los errores difíciles de detectar causados por variables globales o estado mutable innecesario
- Evidenciar las limitaciones de prueba que surgen del alto acoplamiento entre componentes
- Presentar casos donde la duplicación de código llevó a inconsistencias al realizar modificaciones

### Refactorización guiada de código existente

La transformación progresiva de código mal estructurado hacia soluciones más elegantes debe realizarse paso a paso:

1. Identificar áreas problemáticas en el código existente
2. Aplicar refactorizaciones específicas manteniendo la funcionalidad
3. Comparar el estado inicial y final, evaluando mejoras en legibilidad, mantenibilidad y extensibilidad
4. Documentar las lecciones aprendidas durante el proceso

### Contraste entre diferentes niveles de abstracción

Es fundamental explorar cómo un mismo problema puede abordarse desde diferentes niveles de abstracción:

- Soluciones de bajo nivel con manipulación directa de datos
- Implementaciones que utilizan métodos auxiliares específicos
- Enfoques basados en la composición de operaciones existentes
- Diseños basados en principios como "Tell, Don't Ask" y responsabilidad única

### Espacios seguros para experimentación y error

Debe promoverse un entorno donde los errores se valoren como oportunidades de aprendizaje:

- Fomentar la presentación de múltiples soluciones a un mismo problema
- Realizar sesiones de revisión de código donde los estudiantes critiquen constructivamente el trabajo de sus compañeros
- Implementar ejercicios donde se premie el proceso de razonamiento sobre la solución final
- Celebrar los momentos de "desaprendizaje" como avances significativos en el desarrollo profesional

## ¿Y ahora qué?

El proceso de desaprendizaje en programación no debe verse como un evento aislado, sino como parte de un ciclo continuo de mejora. Para profundizar en este enfoque, se recomienda:

- Explorar literatura sobre patrones de diseño y anti-patrones, para identificar sistemáticamente prácticas que deben ser desaprendidas
- Investigar sobre psicología cognitiva aplicada al aprendizaje de programación, especialmente en lo referente a la superación de "fijaciones funcionales"
- Participar en comunidades de práctica donde se discutan y analicen diferentes aproximaciones a problemas comunes
- Documentar el propio proceso de desaprendizaje, identificando qué conceptos han sido más difíciles de modificar y por qué

El camino hacia la excelencia en programación necesariamente incluye tropiezos. Es precisamente en el reconocimiento y superación de estos tropiezos donde se forja el verdadero aprendizaje significativo. La capacidad de desaprender es, paradójicamente, uno de los aprendizajes más valiosos que un programador puede desarrollar.
