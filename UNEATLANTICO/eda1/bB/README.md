# Propuesta [@emmabry](https://github.com/enmabry/24-25-EDA1/tree/feature/reto-004)

|Clases|Clases vista pública|Clases extendido|
|-|-|-|
|![](/images/UNEATLANTICO/eda1/bB/DdCBase.svg)|![](/images/UNEATLANTICO/eda1/bB/DdCExtendidoVistaPublica.svg)|![](/images/UNEATLANTICO/eda1/bB/DdCExtendido.svg)

|Clases|Clases con estereotipo|
|-|-|
|![](/images/UNEATLANTICO/eda1/bB/DdCBase.svg)|![](/images/UNEATLANTICO/eda1/bB/DdCBaseEstereotipado.svg)|

## Estereotipo

Un estereotipo en UML es una forma de extender o clasificar elementos del diagrama para indicar que tienen características o comportamientos específicos que los diferencian del elemento base de UML.

Es como una "etiqueta" o "categoría" que le dice a quien lee el diagrama: "este elemento tiene un propósito o comportamiento especial". Se representa entre comillas francesas («»).

En nuestro diagrama anterior, usamos estereotipos para indicar:

- `<<entity>>`: Indica que la clase representa un objeto del dominio del negocio
- `<<node>>`: Indica que la clase es un contenedor que forma parte de una estructura de datos
- `<<list>>`: Indica que la clase implementa el comportamiento de una lista enlazada
- `<<queue>>`: Indica que la clase implementa el comportamiento de una cola FIFO
- `<<stack>>`: Indica que la clase implementa el comportamiento de una pila LIFO
- `<<main>>`: Indica que es la clase principal que controla la aplicación

Otros estereotipos comunes en UML son:

- `<<interface>>`: Para interfaces
- `<<abstract>>`: Para clases abstractas
- `<<service>>`: Para clases que proveen servicios
- `<<controller>>`: Para clases que controlan el flujo
- `<<repository>>`: Para clases que manejan persistencia
- `<<dto>>`: Para objetos de transferencia de datos
- `<<enum>>`: Para enumeraciones

1. Comunican la intención y el propósito de una clase.
1. Ayudan a categorizar elementos del diagrama.
1. Permiten identificar rápidamente el rol de cada elemento.
1. Evitan tener que usar prefijos o sufijos en los nombres de las clases.
1. Hacen el modelo más expresivo y fácil de entender.

|Clases con estereotipo sin notación húngara|
|-|
|![](/images/UNEATLANTICO/eda1/bB/DdCBaseEstereotipadoSinHungara.svg)|