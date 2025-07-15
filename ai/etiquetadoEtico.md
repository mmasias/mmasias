# Propuesta de un sistema de etiquetado ético

## ¿Por qué?

- La creación digital actual mezcla trabajo humano e IA sin distinción clara.
- No existe un estándar para medir y comunicar las contribuciones de cada parte.
- La transparencia es cada vez más importante en la era digital.
- Los sistemas actuales (como derechos de autor) no contemplan la colaboración humano-IA.
- Es necesario reconocer justamente el trabajo de todos los participantes.

## ¿Qué?

|||
|-|-|
|Se presenta una propuesta de un sistema de etiquetado ético que mida y permita visualizar las contribuciones en trabajos creativos y técnicos que involucran tanto participación humana como de Inteligencia Artificial (IA). |Basado en el sistema CRediT (Contributor Roles Taxonomy) y adaptado para el contexto de la creación híbrida humano-IA, este sistema proporciona una forma transparente y estandarizada de documentar y comunicar los aportes de diferentes agentes en un proyecto.|

El sistema combina:

- Los ejes *Humano*-*IA* e *Individual*-*Grupal*.
- La metodología de [roles del sistema CRediT](https://credit.niso.org/).
- Niveles de contribución cuantificables.
- Visualización clara mediante una etiqueta gráfica.
- Metadatos para trazabilidad.
- Documentación del [proceso creativo](https://github.com/mmasias/mmasias/blob/main/procesoDeCreacion.md).

## ¿Para qué?

- Fomentar la responsabilidad en el uso de IA.
- Ayudar en discusiones éticas y legales sobre propiedad intelectual.
- Permitir a usuarios y consumidores entender el origen del contenido.
- Proporcionar transparencia en procesos creativos.
- Facilitar el reconocimiento justo de contribuciones.

## ¿Cómo?

|Etiqueta|Proceso de documentación|Mecanismos de verificación|
|-|-|-|
|Gráfico circular para contribución global.|Registro de herramientas utilizadas.|Registro automatizado de interacciones.|
|Tabla de roles específicos (Conceptualización, Análisis, etc.).|Tiempo dedicado a cada fase.|Documentación del proceso.|
|Niveles de contribución (Principal, Igual, Apoyo, Ninguna).|Interacciones con sistemas de IA.|Sistema de validación.|
|Barra de progreso para dimensión colaborativa.|Validación por pares cuando sea aplicable.|Posible integración con blockchain.|

### Contexto de iniciativas existentes

La propuesta de etiquetado ético se desarrolla en un ecosistema creciente de iniciativas de transparencia en IA. A diferencia de sistemas como **C2PA** (Coalition for Content Provenance and Authenticity) que se centran en la autenticidad del contenido, o **OpenAI's Model Cards** que documentan capacidades de modelos de IA, esta propuesta aborda específicamente la **atribución granular de contribuciones** en trabajos híbridos humano-IA.

#### Iniciativas relacionadas:

**En autenticidad de contenido:**
- **C2PA**: Estándares técnicos para metadatos de contenido
- **Project Origin**: Firmas criptográficas para contenido creativo
- **SynthID**: Identificación de contenido generado por IA

**En marcos éticos:**
- **AI Ethics Framework (UE)**: Directrices regulatorias
- **Partnership on AI**: Mejores prácticas industriales
- **IEEE Standards**: Estándares técnicos para IA ética

**En atribución académica:**
- **CRediT**: Base conceptual del sistema propuesto
- **ORCID**: Identificación persistente de investigadores

#### Posicionamiento diferencial:

La propuesta llena un **vacío específico** en el panorama actual al:
- Medir contribuciones humanas e IA de manera granular
- Proporcionar visualización intuitiva de la colaboración
- Establecer métricas cuantificables para diferentes tipos de trabajo
- Crear un sistema adaptable a diversos contextos creativos y técnicos

> Para un análisis detallado de iniciativas existentes, consultar: [Investigación de Iniciativas Existentes en Transparencia de IA](investigacionIniciativasExistentes.md)

### Roles de contribución

Adaptando el [sistema CRediT](https://credit.niso.org/), se definen roles específicos para el contexto humano-IA:

<div align=center>

|||
|-|-|
|**Conceptualización**|Desarrollo de ideas iniciales.|
||Planificación estructural.|
||Definición de objetivos.|
|**Análisis**|Procesamiento de datos.|
||Evaluación de resultados.|
||Interpretación de outputs.|
|**Implementación**|Ejecución técnica.|
||Desarrollo de contenido.|
||Aplicación de herramientas.|
|**Validación**|Control de calidad.|
||Verificación de resultados.|
||Ajustes y correcciones.|

</div>

### Niveles de contribución

<div align=center>

|Principal|Igual|Apoyo|Ninguna|
|-|-|-|-|
|Responsabilidad y aporte mayoritario.|Contribución equilibrada.|Participación secundaria o auxiliar.|Sin participación en ese rol específico.|

</div>

### Borrador v0

<div align=center width=45%>

<img src="/imagenes/ethical-credit-label.svg" width=45%>

</div>

- Fácilmente legible.
- Adaptable a diferentes contextos.
- Compatible con sistemas digitales e impresos.
- Verificable y rastreable.

### Implementación

#### Proceso de creación

Se recomienda mantener registros de:

- Herramientas utilizadas.
- Tiempo dedicado a cada fase.
- Interacciones con sistemas de IA.
- Contribuciones específicas de cada participante.

#### Mecanismos de Verificación

Para asegurar la precisión y confiabilidad:

- Registro automatizado de interacciones con IA.
- Documentación del proceso creativo.
- Sistema de validación por pares (cuando sea aplicable).

### Análisis comparativo con iniciativas existentes

#### Sistemas de procedencia y autenticación de contenido

**Coalition for Content Provenance and Authenticity (C2PA)**
- *Organizaciones*: Adobe, Microsoft, BBC, Intel, Truepic
- *Enfoque*: Autenticación y procedencia de contenido digital
- *Relación con la propuesta*: Complementario en transparencia, pero enfocado en autenticidad más que en atribución de contribuciones

**Project Origin (Adobe)**
- *Enfoque*: Atribución y autenticidad de contenido digital mediante firmas criptográficas
- *Relación con la propuesta*: Sistema complementario para verificación de contenido

#### Marcos de ética y transparencia de IA

**AI Ethics Framework (Unión Europea)**
- *Enfoque*: Directrices éticas para desarrollo y despliegue de IA
- *Relación con la propuesta*: Marco regulatorio que podría incorporar sistemas de atribución

**Partnership on AI (PAI)**
- *Organizaciones*: Google, Facebook, Amazon, Apple, Microsoft, IBM
- *Enfoque*: Investigación en ética y transparencia de IA
- *Relación con la propuesta*: Colaboración industrial con objetivos similares de transparencia

#### Sistemas de atribución académica

**CRediT (Contributor Roles Taxonomy)**
- *Organización*: NISO (National Information Standards Organization)
- *Enfoque*: Atribución de contribuciones en investigación académica
- *Relación con la propuesta*: Base directa del sistema propuesto

**ORCID (Open Researcher and Contributor ID)**
- *Enfoque*: Identificación persistente de investigadores
- *Relación con la propuesta*: Sistema complementario para identificación de contribuyentes

#### Posicionamiento de la propuesta

##### Similitudes con sistemas existentes:
- **Objetivos de transparencia**: Comparte el objetivo de aumentar la transparencia
- **Estandarización**: Busca crear enfoques estandarizados
- **Verificación**: Enfoque común en verificación y autenticidad
- **Participación multiactor**: Enfoques colaborativos

##### Diferencias y valor añadido:
- **Atribución de contribuciones**: Enfoque específico en medir y atribuir contribuciones
- **Colaboración humano-IA**: Aborda explícitamente el trabajo híbrido humano-IA
- **Análisis basado en roles**: Desglose detallado de diferentes tipos de contribución
- **Métricas cuantificables**: Niveles específicos de medición de contribuciones
- **Representación visual**: Representación visual clara de patrones de contribución

##### Oportunidades de integración:
- **Estándares técnicos**: Integración con C2PA para implementación técnica
- **Marco académico**: Extensión natural del sistema CRediT
- **Cumplimiento regulatorio**: Alineación con requisitos de transparencia
- **Adopción por plataformas**: Potencial adopción por plataformas de contenido

### Retos

<div align=center>

|En la implementación|A futuro|
|-|-|
|Estandarización de mediciones.|Automatización del proceso de etiquetado.|
|Verificación de contribuciones.|Integración con blockchain para verificación.|
|Adopción por la comunidad.|Expansión a nuevos campos y contextos.|
|Integración con sistemas existentes.|Adaptación a tecnologías emergentes.|
|Interoperabilidad con C2PA y otros estándares.|Desarrollo de APIs para integración.|

</div>

---

<div align=right>

***Para este documento:***

|*H*|*IA*|
|-|-|
|*70*|*30*|

</div>
