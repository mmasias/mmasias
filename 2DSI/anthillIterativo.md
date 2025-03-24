# Zachman@Hormiguero.si *ITERATIVO*

## Situación inicial: sistema de información propuesto originalmente

|Hardware|Software|Datos|Procesos|Usuarios|
|-|-|-|-|-|
|Hormiguero|Feromonas|Humedad y temperatura|Alimentación|Reina|
|Túneles|Jerarquía|Cantidad hormigas|Mantenimiento|Obreras|
|Alimento|Distribución|Estado colonia|Defensa|Larvas|
|Cámara de cría|||||
|Hormiga|||||

## 1ra iteración: Matriz de Zachman

Trasladamos elementos del SI original a la columna que consideremos más apropiada, por ejemplo, "Feromonas" se ha movido del Software a una implementación física de "Cómo".

Algunos elementos como "Hormiga" necesitan ser redefinidos ya que las hormigas en general serían usuarios, pero específicas adaptaciones físicas de la hormiga podrían ser parte del "Quién" físico.

|**Perspectiva**|**Por qué** <br> (Motivación)|**Cómo** <br> (Función)|**Qué** <br> (Datos)|**Quién** <br> (Personas)|**Dónde** <br> (Redes)|**Cuándo** <br> (Tiempo)|
|-|-|-|-|-|-|-|
|||Alimentación <br> Mantenimiento <br> Defensa<br>Jerarquía <br> Distribución<br>Feromonas|Humedad y temperatura <br> Cantidad hormigas <br> Estado colonia|Reina <br> Obreras <br> Larvas<br>Hormiga|Hormiguero <br> Túneles <br> Cámara de cría<br>Alimento||

## 2da iteración: Matriz de Zachman

Los elementos identificados inicialmente se han distribuido en la matriz considerando no solo su categoría (dimensión) sino también su nivel de abstracción (perspectiva).

Esta redistribución revela áreas vacías en la matriz.

|**Perspectiva**|**Por qué** <br> (Motivación)|**Cómo** <br> (Función)|**Qué** <br> (Datos)|**Quién** <br> (Personas)|**Dónde** <br> (Redes)|**Cuándo** <br> (Tiempo)|
|-|-|-|-|-|-|-|
|**Contextual** <br> (Vista del planificador)||Alimentación <br> Mantenimiento <br> Defensa|Humedad y temperatura <br> Cantidad hormigas <br> Estado colonia|Reina <br> Obreras <br> Larvas|Hormiguero <br> Túneles <br> Cámara de cría||
|**Conceptual** <br> (Modelo del negocio)||Jerarquía <br> Distribución|||||
|**Lógico** <br> (Modelo del sistema)|||||||
|**Físico** <br> (Modelo tecnológico)||Feromonas||Hormiga|Alimento||
|**Detallado** <br> (Componentes)|||||||

## 3ra iteración: Análisis & ampliación de Matriz de Zachman

En esta iteración se completa la matriz analizando cada perspectiva desde lo más abstracto (Contextual) hasta lo más detallado (Componentes), identificando elementos específicos para cada nivel de abstracción.

|**Perspectiva**|**Por qué** <br> (Motivación)|**Cómo** <br> (Función)|**Qué** <br> (Datos)|**Quién** <br> (Personas)|**Dónde** <br> (Redes)|**Cuándo** <br> (Tiempo)|
|-|-|-|-|-|-|-|
|**Contextual** <br> (Vista del planificador)|Supervivencia <br> Reproducción <br> Expansión|Alimentación <br> Mantenimiento <br> Defensa|Humedad y temperatura <br> Cantidad hormigas <br> Estado colonia|Reina <br> Obreras <br> Larvas|Hormiguero <br> Túneles <br> Cámara de cría|Ciclos estacionales <br> Ciclos día/noche|
|**Conceptual** <br> (Modelo del negocio)|Eficiencia colectiva <br> Especialización|Jerarquía <br> Distribución <br> Recolección|Mapa de recursos <br> Estado nutricional <br> Amenazas|Soldados <br> Nodrizas <br> Exploradoras|Áreas de forrajeo <br> Zona de cría <br> Depósitos|Ciclo de desarrollo <br> Períodos de actividad|
|**Lógico** <br> (Modelo del sistema)|Reglas de priorización <br> Umbrales de acción|Algoritmos de búsqueda <br> Procedimientos defensivos|Intensidad de feromonas <br> Gradientes químicos|División de tareas <br> Comunicación entre castas|Rutas de forrajeo <br> Estructura de túneles|Secuencia de tareas <br> Tiempos de respuesta|
|**Físico** <br> (Modelo tecnológico)|Estímulos químicos <br> Comportamientos innatos|Feromonas <br> Intercambio alimentos|Composición química <br> Vibraciones <br> Contacto táctil|Hormiga (morfología) <br> Adaptaciones físicas|Alimento <br> Materiales construcción <br> Microclimas|Duración de feromonas <br> Ciclos de actividad|
|**Detallado** <br> (Componentes)|Genes específicos <br> Umbrales neuronales|Movimientos mandibulares <br> Patrones de antenas|Moléculas específicas <br> Receptores sensoriales|Glándulas específicas <br> Órganos sensoriales|Estructura molecular <br> Propiedades físicas|Ritmos circadianos <br> Tiempos de reacción|

## 4ta iteración: SI ampliado tras aplicar Zachman

Se trasladan los elementos identificados mediante el análisis de Zachman de vuelta al modelo original de componentes del SI

|Hardware|Software|Datos|Procesos|Usuarios|
|-|-|-|-|-|
|Hormiguero|Feromonas|Humedad y temperatura|Alimentación|Reina|
|Túneles y cámaras|Jerarquía|Cantidad hormigas|Mantenimiento|Obreras|
|Cámara de cría|Distribución|Estado colonia|Defensa|Larvas|
|Antenas|Algoritmos de búsqueda|Mapa de recursos|Recolección|Soldados|
|Mandíbulas|Umbrales de respuesta|Gradientes químicos|Construcción|Exploradoras|
|Glándulas especializadas|Patrones de comunicación|Intensidad de señales|Cuidado de cría|Nodrizas|
|Receptores químicos|Reglas de priorización|Vibraciones y sonidos|Gestión de residuos|Hormigas especializadas|
|Materiales de construcción|Memoria espacial colectiva|Ciclos temporales|Exploración|Hormigas jóvenes/mayores|
|Exoesqueleto|Comportamientos emergentes|Contacto táctil|Comunicación||

## 5ta iteración: (aparentes) inconsistencias y cuestionamiento

- Los "Ciclos temporales" aparecen en la categoría de Datos, pero podría argumentarse que también tienen componentes de Software.
- La dimensión completa de "Por qué" (Supervivencia, Reproducción, Eficiencia colectiva, etc.) no aparece claramente reflejada en el modelo SI final. No hay una categoría natural para estos elementos motivacionales.
- ¿Alguna(s) más?.
