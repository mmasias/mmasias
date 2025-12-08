# Ideas para el Generador de Mapas Armónicos

## Brainstorming - Ideas a implementar

### 1. Navegación Interactiva entre Acordes
- Hacer clickeables los acordes en las columnas de progresiones (entrantes y salientes)
- Al hacer clic en un acorde, la tabla se actualiza mostrando los vectores armónicos de ese acorde
- Permite construir progresiones paso a paso de forma visual e interactiva

### 2. Historial de Progresión
- Mostrar la secuencia de acordes por los que se ha navegado
- El historial se actualiza SOLO cuando cambias a otro acorde
  - Ejemplo: Empiezas en G → Clic en C → Historial: [G]
  - Desde C → Clic en F → Historial: [G, C]
  - Desde F → Clic en G → Historial: [G, C, F]
- Display visual tipo: `Progresión actual: G → C → F → G`

### 3. Funcionalidad de Volver Atrás
- Botón para deshacer el último paso
- Quita el último acorde del historial
- Vuelve a mostrar la tabla del acorde anterior

### 4. Soporte para Escalas Mayor y Menor
- Agregar selector para elegir entre escala Mayor o Menor Natural
- Acordes diatónicos de Menor Natural son diferentes:
  - i (menor), ii° (disminuido), III (Mayor), iv (menor), v (menor), VI (Mayor), VII (Mayor)
- Las progresiones típicas de menor son distintas (i→iv→v, i→VI→III→VII, etc.)
- Acordes cromáticos/secundarios también cambiarán según la escala

### 5. Pendiente de definir
- ¿Cómo manejar el selector inicial de tónica?
  - Opción A: Mantenerlo y que sirva para empezar nuevas progresiones
  - Opción B: Convertirlo en "Acorde actual" con opción de reset

---

## Notas
- Usuario conoce algo de música pero no es experto
- El objetivo es tener una herramienta para desarrollar progresiones coherentes que suenen bien
- La tabla actual ya muestra de dónde vienes y a dónde puedes ir

---

## Estado de Implementación

### ✅ Completado

1. **Navegación Interactiva entre Acordes**
   - Acordes clickeables en columnas de progresión
   - Actualización dinámica de tabla al hacer clic
   - Construcción paso a paso de progresiones

2. **Selector Mayor/Menor**
   - Selector para elegir entre Mayor y Menor Natural
   - Se puede cambiar en caliente durante la navegación
   - Acordes diatónicos y progresiones adaptados a cada modo

3. **Control de Interfaz**
   - Selector de tónica se actualiza al navegar
   - Botón cambia dinámicamente: "Generar" ↔ "Reiniciar"
   - Función de reinicio/nueva progresión

4. **Historial de Progresión**
   - Display visual de la secuencia de acordes navegados
   - Se actualiza solo al cambiar de acorde
   - Formato: `G → C → F → G` (acorde actual en negrita)
   - Se limpia al reiniciar

5. **Botón Volver Atrás**
   - Permite deshacer el último paso de navegación
   - Vuelve al acorde anterior
   - Se deshabilita cuando no hay historial
   - Actualiza automáticamente el display del historial

### 🔜 Posibles mejoras futuras

- Exportar/guardar progresiones
- Reproducir progresiones con audio
- Más escalas (menor armónica, menor melódica, modos)
- Análisis de función armónica en contexto
- Sugerencias inteligentes basadas en estilos musicales

---

## 📚 Documentación RUP (En Proceso)

### Contexto

- Este proyecto se está usando como ejemplo didáctico para enseñar RUP
- Seguimos la estructura y estilo del proyecto pySigHor como referencia
- Metodología: Trabajar con calma, "con mimo, con cariño", revisando cada artefacto cuidadosamente

### ✅ Artefactos Completados

#### 1. README Principal (`/RUP/README.md`)

- Nombre del proyecto: **pyProgresionesArmonicas**
- Escrito desde la perspectiva del músico/usuario (no del sistema)
- Describe problemas del usuario que motivan la herramienta
- Estado: **Aprobado**

#### 2. Modelo del Dominio (`/RUP/00-casos-uso/00-modelo-del-dominio/`)

- **README.md**: Documentación completa del modelo
  - Glosario ordenado por dependencias conceptuales
  - Entidades: Nota → Calidad → Escala → Acorde → FunciónArmónica → GradoArmónico → EnlaceArmónico → MapaArmónico → ProgresiónArmónica
  - Relaciones: Composición, Agregación, Dependencia
  - Vocabulario del dominio (conceptos fundamentales, tipos de acordes, movimientos armónicos)
  - Ajustes y decisiones de diseño justificadas
  - Estado: **Aprobado**

- **modelo-dominio.puml**: Diagrama PlantUML
  - Cambio importante: "VectorArmónico" → "EnlaceArmónico" (terminología musical pura)
  - Paquetes: TeoriaMusical, SistemaArmonico
  - Estado: **Aprobado** (pendiente regenerar SVG con nuevos nombres)

#### 3. Actores y Casos de Uso (`/RUP/00-casos-uso/01-actores-casos-uso/`)

- **actores-casos-uso.md**: Documentación completa
  - Un único actor: Músico
  - Análisis pedagógico: Del modelo del dominio a casos de uso (aplicación crítica de regla CRUD)
  - Clasificación de entidades: Conocimiento del dominio, Datos derivados, Datos del usuario
  - Solo ProgresiónArmónica admite CRUD completo
  - Casos de uso organizados en dos grupos: Configuración del Contexto Tonal y Gestión de ProgresiónArmónica
  - Trazabilidad completa al modelo del dominio
  - Estado: **En revisión**

- **Diagramas PlantUML**:
  - `actores-casos-uso-001.puml`: Configuración del Contexto Tonal
  - `actores-casos-uso-002.puml`: Gestión de Progresión Armónica (CRUD)
  - `actores-casos-uso-003.puml`: Vista integrada completa del sistema
  - Estado: **En revisión**

#### 4. Diagrama de Contexto (`/RUP/00-casos-uso/01-actores-casos-uso/diagrama-contexto-musico.md`)

- **diagrama-contexto-musico.md**: Documentación completa del diagrama de contexto
  - Estados del sistema: SISTEMA_INICIAL, MAPA_DISPONIBLE, PROGRESION_EN_CONSTRUCCION, PROGRESION_FINALIZADA
  - Validación de completitud: todos los casos de uso tienen lugar en el flujo
  - Descubrimiento: `finalizarProgresión()` emergió del análisis de estados necesarios
  - Análisis de cambio de modo "en caliente" transversal a múltiples estados
  - Comparación con implementación actual (3 estados implementados, 1 pendiente)
  - Estado: **En revisión**

- **diagrama-contexto-musico.puml**: Diagrama PlantUML
  - Máquina de estados UML modelando navegación del músico
  - 4 estados, 13 transiciones
  - Estado: **En revisión**

### 🔜 Próximos Artefactos

#### 5. Implementación pendiente

- Estado PROGRESION_FINALIZADA
- Caso de uso `finalizarProgresión()`

### Lecciones Aprendidas

- ✨ **Pureza del dominio**: Solo terminología musical, sin conceptos de software/UI
- ✨ **Orden conceptual**: Glosario ordenado por dependencias (lo básico primero)
- ✨ **Definiciones previas**: Definir términos técnicos antes de usarlos (ej: "contexto tonal")
- ✨ **Paciencia**: No ser "cagaprisas", revisar cada paso cuidadosamente
- ✨ **Nombres precisos**: Usar terminología del dominio, no matemática ni técnica
- ✨ **Del modelo del dominio a casos de uso (ENFOQUE PEDAGÓGICO)**:
  - **Regla general**: Cada entidad del dominio → casos de uso CRUD
  - **Pensamiento crítico**: No todos los CRUD tienen sentido en cada contexto
  - **Clasificación de entidades en este proyecto**:
    - **Conocimiento del dominio** (hardcoded): Nota, Calidad, Escala, FunciónArmónica, EnlaceArmónico
    - **Datos derivados/calculados**: Acorde, GradoArmónico, MapaArmónico (se generan a partir de tónica + modo)
    - **Datos del usuario** (CRUD completo): ProgresiónArmónica (única entidad que el usuario crea, consulta, actualiza y elimina)
  - **Valor pedagógico**: Muestra que la estructura del dominio informa qué comportamientos tienen sentido
  - **Nota importante**: Explicitar esta clasificación como lección aprendida en el artefacto de casos de uso

### Contexto para Continuar

**Estado actual**: Artefactos de requisitos completados (Modelo del dominio, Actores y casos de uso, Diagrama de contexto)

**Siguiente paso**: Detalle de casos de uso (especificaciones textuales)
- Revisar `editarProfesor()` en pySigHor como referencia
- Especialmente el PlantUML que muestra el patrón de detalle
- Crear especificaciones para los 9 casos de uso identificados

**Descubrimiento importante**: `finalizarProgresión()` emergió del análisis del diagrama de contexto

**Estrategia pedagógica**:
- Mantener implementación ad-hoc actual (JavaScript procedural, funcional)
- Después de completar RUP completo, crear implementación guiada por diseño (JavaScript vanilla, sin frameworks)
- Comparar ambas para mostrar valor de la metodología
- JavaScript puro para no distraer con frameworks modernos

---

Funcionalidades implementadas - Documentación RUP en progreso
