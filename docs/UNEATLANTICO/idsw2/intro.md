# De estructuras a arquitectura

## ¿Por qué?

**Retrospectiva conectora:** En EDA1 dijimos "el niño sabe quién le sigue" y funcionó. Pero esa solución antropomórfica oculta problemas fundamentales de diseño que aparecen cuando escalamos sistemas reales.

**Problemas de la antropomorfización:** Si el "niño" (elemento) debe saber todo sobre la fila, entonces debe manejar inserción, eliminación, búsqueda, ordenación... El diseño se sobrecarga y pierde escalabilidad.

## ¿Qué?

**Principio del orden como capa agregada:** Trabajamos siempre con conjuntos de datos (sin orden inherente). Nosotros agregamos capas de orden mediante:

- **Orden interno**: Estructuras donde cada elemento conoce su posición (listas, árboles)
- **Orden externo**: Índices separados que apuntan a los datos (bases de datos)

**Principio del reparto de responsabilidades:** Evolución hacia responsabilidades separadas:

- **Nodo**: Solo almacena datos + referencias (contenedor "tonto")
- **Estructura**: Maneja operaciones y reglas específicas (lógica inteligente)

## ¿Para qué?

Esta separación permite:

- **Escalabilidad**: Operaciones complejas sin contaminar elementos básicos
- **Reutilización**: El mismo Nodo sirve para múltiples estructuras
- **Mantenimiento**: Cambios en lógica no afectan almacenamiento
- **Testabilidad**: Componentes independientes y focalizados

Base para entender patrones de diseño, arquitecturas modulares y sistemas distribuidos.

## ¿Cómo?

Aplicaremos estos principios en:
- Diseño de APIs que separan datos de operaciones
- Arquitecturas por capas donde orden y almacenamiento son independientes
- Patrones que permiten múltiples vistas sobre los mismos datos
- Sistemas donde responsabilidades están claramente delimitadas
