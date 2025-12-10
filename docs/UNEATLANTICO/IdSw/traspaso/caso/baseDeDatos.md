# Base de datos

## DER

![](/images/modelosUML/traspaso/caso/EcoTrack%20ER%20Diagram.svg)

## Diccionario de datos

### Tabla: USUARIO

Almacena la información de los usuarios registrados en la aplicación.

|Campo|Tipo|Descripción|
|-|-|-|
|id|string|Identificador único del usuario (UUID)|
|nombre|string|Nombre completo del usuario|
|email|string|Correo electrónico del usuario (usado para login)|
|fecha_registro|date|Fecha en que el usuario se registró en la aplicación|
|ubicacion|string|Ciudad o región del usuario (para cálculos localizados)|

### Tabla: ACTIVIDAD

Registra las actividades realizadas por los usuarios que contribuyen a su huella de carbono.

|Campo|Tipo|Descripción|
|-|-|-|
|id|string|Identificador único de la actividad (UUID)|
|usuario_id|string|ID del usuario que realizó la actividad (FK a USUARIO)|
|categoria_id|string|ID de la categoría a la que pertenece la actividad (FK a CATEGORIA)|
|valor|float|Valor numérico asociado a la actividad (ej. kilómetros recorridos)|
|fecha|date|Fecha en que se realizó la actividad|
|descripcion|string|Descripción opcional de la actividad|

### Tabla: CATEGORIA

Define las diferentes categorías de actividades que pueden generar huella de carbono.

|Campo|Tipo|Descripción|
|-|-|-|
|id|string|Identificador único de la categoría (UUID)|
|nombre|string|Nombre de la categoría (ej. "Transporte", "Consumo eléctrico")|
|factor_emision|float|Factor de emisión de CO2 asociado a esta categoría|

### Tabla: HUELLA_CARBONO

Almacena los cálculos de huella de carbono generados a partir de las actividades.

|Campo|Tipo|Descripción|
|-|-|-|
|id|string|Identificador único del cálculo de huella (UUID)|
|actividad_id|string|ID de la actividad que generó esta huella (FK a ACTIVIDAD)|
|valor|float|Valor calculado de la huella de carbono (en kg de CO2)|
|fecha_calculo|date|Fecha en que se realizó el cálculo|

### Tabla: OBJETIVO

Registra los objetivos de reducción de huella de carbono establecidos por los usuarios.

|Campo|Tipo|Descripción|
|-|-|-|
|id|string|Identificador único del objetivo (UUID)|
|usuario_id|string|ID del usuario que estableció el objetivo (FK a USUARIO)|
|valor_objetivo|float|Valor numérico del objetivo (ej. reducción del 20%)|
|fecha_inicio|date|Fecha de inicio del período del objetivo|
|fecha_fin|date|Fecha de fin del período del objetivo|
|estado|string|Estado actual del objetivo (ej. "En progreso", "Completado")|

### Tabla: LOGRO

Almacena los logros obtenidos por los usuarios en la aplicación.

|Campo|Tipo|Descripción|
|-|-|-|
|id|string|Identificador único del logro (UUID)|
|usuario_id|string|ID del usuario que obtuvo el logro (FK a USUARIO)|
|nombre|string|Nombre del logro obtenido|
|fecha_obtencion|date|Fecha en que se obtuvo el logro|
|descripcion|string|Descripción detallada del logro|

### Tabla: RECOMENDACION

Guarda las recomendaciones personalizadas generadas para cada usuario.

|Campo|Tipo|Descripción|
|-|-|-|
|id|string|Identificador único de la recomendación (UUID)|
|usuario_id|string|ID del usuario para quien se generó la recomendación (FK a USUARIO)|
|contenido|string|Texto de la recomendación|
|fecha_generacion|date|Fecha en que se generó la recomendación|
|estado|string|Estado de la recomendación (ej. "Nueva", "Leída", "Implementada")|
