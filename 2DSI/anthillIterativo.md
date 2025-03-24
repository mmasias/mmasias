# Zachman@Hormiguero.si *ITERATIVO*

## PASO 1: Sistema de información propuesto originalmente

|Hardware|Software|Datos|Procesos|Usuarios|
|-|-|-|-|-|
|Hormiguero|Feromonas|Humedad y temperatura|Alimentación|Reina|
|Túneles|Jerarquía|Cantidad hormigas|Mantenimiento|Obreras|
|Alimento|Distribución|Estado colonia|Defensa|Larvas|
|Cámara de cría|||||
|Hormiga|||||

## Iteración: Matriz de Zachman

|**Perspectiva**|**Por qué** <br> (Motivación)|**Cómo** <br> (Función)|**Qué** <br> (Datos)|**Quién** <br> (Personas)|**Dónde** <br> (Redes)|**Cuándo** <br> (Tiempo)|
|-|-|-|-|-|-|-|
|||Alimentación <br> Mantenimiento <br> Defensa<br>Jerarquía <br> Distribución<br>Feromonas|Humedad y temperatura <br> Cantidad hormigas <br> Estado colonia|Reina <br> Obreras <br> Larvas<br>Hormiga|Hormiguero <br> Túneles <br> Cámara de cría<br>Alimento||

## Iteración: Matriz de Zachman

> **Nota**: *Reubicamos algunos elementos del SI original a celdas más apropiadas, por ejemplo, "Feromonas" se ha movido del Software a una implementación física de "Cómo". Algunos elementos como "Hormiga" necesitan ser redefinidos ya que las hormigas en general serían usuarios, pero específicas adaptaciones físicas de la hormiga podrían ser parte del "Dónde" físico.*

|**Perspectiva**|**Por qué** <br> (Motivación)|**Cómo** <br> (Función)|**Qué** <br> (Datos)|**Quién** <br> (Personas)|**Dónde** <br> (Redes)|**Cuándo** <br> (Tiempo)|
|-|-|-|-|-|-|-|
|**Contextual** <br> (Vista del planificador)||Alimentación <br> Mantenimiento <br> Defensa|Humedad y temperatura <br> Cantidad hormigas <br> Estado colonia|Reina <br> Obreras <br> Larvas|Hormiguero <br> Túneles <br> Cámara de cría||
|**Conceptual** <br> (Modelo del negocio)||Jerarquía <br> Distribución|||||
|**Lógico** <br> (Modelo del sistema)|||||||
|**Físico** <br> (Modelo tecnológico)||Feromonas||Hormiga|Alimento||
|**Detallado** <br> (Componentes)|||||||

## Iteración: Análisis & ampliación de Matriz de Zachman

|**Perspectiva**|**Por qué** <br> (Motivación)|**Cómo** <br> (Función)|**Qué** <br> (Datos)|**Quién** <br> (Personas)|**Dónde** <br> (Redes)|**Cuándo** <br> (Tiempo)|
|-|-|-|-|-|-|-|
|**Contextual** <br> (Vista del planificador)|Supervivencia <br> Reproducción <br> Expansión|Alimentación <br> Mantenimiento <br> Defensa|Humedad y temperatura <br> Cantidad hormigas <br> Estado colonia|Reina <br> Obreras <br> Larvas|Hormiguero <br> Túneles <br> Cámara de cría|Ciclos estacionales <br> Ciclos día/noche|
|**Conceptual** <br> (Modelo del negocio)|Eficiencia colectiva <br> Especialización|Jerarquía <br> Distribución <br> Recolección|Mapa de recursos <br> Estado nutricional <br> Amenazas|Soldados <br> Nodrizas <br> Exploradoras|Áreas de forrajeo <br> Zona de cría <br> Depósitos|Ciclo de desarrollo <br> Períodos de actividad|
|**Lógico** <br> (Modelo del sistema)|Reglas de priorización <br> Umbrales de acción|Algoritmos de búsqueda <br> Procedimientos defensivos|Intensidad de feromonas <br> Gradientes químicos|División de tareas <br> Comunicación entre castas|Rutas de forrajeo <br> Estructura de túneles|Secuencia de tareas <br> Tiempos de respuesta|
|**Físico** <br> (Modelo tecnológico)|Estímulos químicos <br> Comportamientos innatos|Feromonas <br> Intercambio alimentos|Composición química <br> Vibraciones <br> Contacto táctil|Hormiga (morfología) <br> Adaptaciones físicas|Alimento <br> Materiales construcción <br> Microclimas|Duración de feromonas <br> Ciclos de actividad|
|**Detallado** <br> (Componentes)|Genes específicos <br> Umbrales neuronales|Movimientos mandibulares <br> Patrones de antenas|Moléculas específicas <br> Receptores sensoriales|Glándulas específicas <br> Órganos sensoriales|Estructura molecular <br> Propiedades físicas|Ritmos circadianos <br> Tiempos de reacción|

## Iteración: SI ampliado tras aplicar Zachman

> **Nota**: *Los elementos en cursiva son los nuevos, identificados tras aplicar el Framework de Zachman*

|Hardware|Software|Datos|Procesos|Usuarios|
|-|-|-|-|-|-|-|
|Hormiguero (estructura)|Feromonas (sistema de señalización)|Humedad y temperatura|Alimentación|Reina (administrador)|
|Túneles y cámaras|Jerarquía (organización)|Cantidad hormigas|Mantenimiento|Obreras (operarios)|
|Cámara de cría|Distribución (asignación)|Estado colonia|Defensa|Larvas (usuarios en formación)|
|Antenas (sensores)|Algoritmos de búsqueda|Mapa de recursos|Recolección|Soldados (seguridad)|
|Mandíbulas (herramientas)|Umbrales de respuesta|Gradientes químicos|Construcción|Exploradoras (analistas)|
|Glándulas especializadas|Patrones de comunicación|Intensidad de señales|Cuidado de cría|Nodrizas (soporte)|
|Receptores químicos|Reglas de priorización|Vibraciones y sonidos|Gestión de residuos|Zánganos (reproductores)|
|Materiales de construcción|Memoria espacial colectiva|Ciclos temporales|Exploración|Hormigas jóvenes/mayores (diferentes roles)|
|Exoesqueleto (protección)|Comportamientos emergentes|Contacto táctil|Comunicación|Hormigas especializadas (técnicos)|
