# De Bundungún a LYCAEUM:<br>Evolución de un sistema multi-agente para análisis crítico

## ¿Por qué?

<div align=center>

||El problema de la perspectiva única||
|:-:|:-:|:-:|
|Un autor no puede leer su propia obra desde fuera.|Un arquitecto de software tiende a defender sus decisiones de diseño incluso cuando la evidencia sugiere revisarlas.|Un desarrollador no es buen tester de su propio código.|

</div>

El sesgo de confirmación no es un defecto de carácter: es una limitación estructural del análisis monoperspectiva.

Los LLMs heredan esta limitación: un único modelo, ante un objeto de análisis, produce una lectura coherente pero inevitablemente sesgada por su prompt, su temperatura y su tendencia estadística hacia el consenso consigo mismo. No hay tensión interna que fuerce la revisión de supuestos.

### El estado del arte: hub-and-spoke y sus limitaciones

La mayoría de los frameworks multi-agente existentes (AutoGen, CrewAI, LangGraph) implementan variaciones del patrón **hub-and-spoke**: un agente central orquesta, delega, sintetiza y redistribuye. El centro es simultáneamente cuello de botella computacional y cuello de botella interpretativo. Todo pasa por un único punto de síntesis que decide qué es relevante, qué se descarta y cómo se integran las perspectivas.

```
Hub-and-spoke                    LYCAEUM (blackboard)

    ┌───┐                         ┌─────────────────┐
    │ A │──┐                      │   BLACKBOARD    │
    └───┘  │   ┌─────────┐        │   (filesystem)  │
    ┌───┐  ├──►│ CENTRO  │        └──┬──┬──┬──┬──┬──┘
    │ B │──┤   │(filtra) │           │  │  │  │  │
    └───┘  │   │(decide) │        ┌──┘  │  │  │  └──┐
    ┌───┐  ├──►│(síntesis│        ▼     ▼  ▼  ▼     ▼
    │ C │──┘   └─────────┘        A     B  C  D    MOD
    └───┘                      (todos leen/escriben)
                               (MOD provoca, no decide)
```

La diferencia es estructural: en hub-and-spoke el centro **filtra** antes de que los agentes vean el trabajo de los demás. En LYCAEUM, el blackboard es un medio pasivo — un filesystem — y todos los agentes tienen acceso simétrico al estado completo del debate. El moderador no sintetiza: identifica desacuerdos y provoca.

## ¿Qué?

### bundungún: el origen

***bundungún*** nace como un script bash que lanza Terminator con geometría 2x2, ejecutando automáticamente cuatro CLIs de LLM (Claude, Gemini, Codex, Qwen) en el directorio de invocación:

```
┌──────────────┬──────────────┐
│   claude     │    codex     │
│              │              │
├──────────────┼──────────────┤
│   gemini     │    qwen      │
│              │              │
└──────────────┴──────────────┘
```

Su propósito: consulta paralela comparativa. El mismo prompt formulado manualmente a cuatro modelos, sin cambio de contexto. Útil para validación cruzada de soluciones técnicas y exploración de enfoques divergentes.

**Limitación fundamental:** los agentes coexisten visualmente pero no dialogan. El humano es el único integrador. Toda síntesis ocurre en su cabeza, ***con las limitaciones cognitivas que eso implica***.

### La transición: coordinación por filesystem

El primer intento de hacer que los agentes debatan entre sí introdujo coordinación por mutex atómico sobre el filesystem:

- **Semáforo**: archivo cuyo nombre codifica el estado (`LIBRE.txt`, `OCUPADO_HABLANDO_CLAUDE.txt`)
- **Conversación**: archivo compartido (`CONVERSACION.txt`) donde el agente con el lock lee el contexto, reflexiona y escribe
- **Protocolo**: adquisición del lock por `mv` atómico → lectura → reflexión → escritura → liberación del lock
- **Anti-monopolio**: espera post-turno para evitar que un agente rápido acapare la conversación

```bash
# Pseudocódigo del protocolo
while true; do
    if mv LIBRE.txt OCUPADO_HABLANDO_${AGENTE}.txt; then
        CONTEXTO=$(cat CONVERSACION.txt)
        RESPUESTA=$(echo "$PROMPT\n$CONTEXTO" | $CLI)
        echo "$RESPUESTA" >> CONVERSACION.txt
        mv OCUPADO_HABLANDO_${AGENTE}.txt LIBRE.txt
        sleep $((INTERVALO * 2))
    else
        sleep $INTERVALO
    fi
done
```

Este diseño resolvía la coordinación pero carecía de estructura argumentativa. Los agentes turnaban, pero no debatían: producían monólogos secuenciales sin tensión crítica real.

### LYCAEUM: debate estructurado con marcos críticos

LYCAEUM introduce tres cambios conceptuales respecto al prototipo:

1. **Marcos críticos asignados**: cada agente analiza desde un paradigma teórico específico (formalismo, fenomenología, deconstrucción — o cualquier conjunto de perspectivas relevantes al dominio). No son agentes genéricos que "opinan": son agentes con restricciones epistemológicas explícitas.

2. **Moderador adversarial**: un cuarto agente cuyo rol no es sintetizar sino identificar dónde los otros tres están en desacuerdo y forzar la confrontación. No opina sobre el objeto: opina sobre el debate.

3. **Blackboard pattern**: el filesystem no es solo un canal de comunicación sino un espacio de conocimiento compartido. Cada agente lee el estado completo del debate antes de intervenir. No hay mensajes punto a punto: hay un estado global visible para todos.

```
┌─────────────────────────────────────────────┐
│              BLACKBOARD (filesystem)        │
│                                             │
│  debate.md    ← estado completo del debate  │
│  ronda_N/     ← artefactos por ronda        │
│  config/      ← prompts y marcos críticos   │
│                                             │
└────┬─────────┬─────────┬─────────┬──────────┘
     │         │         │         │
  inotifywait  │         │         │
     │         │         │         │
     ▼         ▼         ▼         ▼
  ┌──────┐  ┌──────┐  ┌──────┐  ┌───────┐
  │Agent │  │Agent │  │Agent │  │ MOD   │
  │FORMAL│  │FENOM │  │DECON │  │       │
  │      │  │      │  │      │  │provoca│
  └──────┘  └──────┘  └──────┘  └───────┘
```

**Implementación**: CLIs en tmux con `inotifywait` monitorizando cambios en el blackboard. Cuando un agente escribe, los demás detectan el cambio y el turno avanza.

### Nombre

LYCAEUM: referencia al Liceo de Aristóteles, donde el método era precisamente el debate peripatético entre perspectivas divergentes. No la clase magistral unidireccional, sino el paseo donde las ideas se ponen a prueba por confrontación.

## ¿Para qué?

### Hallazgos que la perspectiva única no produce

La primera aplicación de LYCAEUM fue el análisis crítico de nueve poemas del álbum conceptual "Fábulas sin moraleja" — diez rondas de debate entre tres marcos filosóficos con moderador adversarial.

Los resultados confirmaron la hipótesis: la tensión entre marcos produjo lecturas que ningún agente individual habría generado. Donde el formalista veía estructura métrica, el fenomenólogo veía experiencia vivida, y el deconstruccionista cuestionaba los supuestos de ambos. El moderador identificaba los puntos de fricción y forzaba a cada agente a responder a las objeciones de los otros.

No es que las lecturas individuales fueran incorrectas. Es que eran incompletas de formas que solo se revelan por contraste.

### Generalización: el debate como método de análisis

La tesis central de LYCAEUM no es sobre poesía. Es sobre la estructura del análisis:

> Cuando se ponen marcos interpretativos en tensión sobre un objeto concreto, emergen lecturas que ninguno habría producido por separado.

Esto es directamente aplicable a:

|||
|---|---|
|**Análisis de requisitos**|Tres agentes simulando stakeholders con prioridades distintas (usuario final, departamento técnico, dirección) debatiendo sobre una especificación|
|**Revisión arquitectónica**|Agentes con marcos de evaluación distintos (rendimiento, mantenibilidad, coste, seguridad) confrontando una propuesta de diseño|
|**Revisión de código**|Legibilidad vs eficiencia vs extensibilidad como marcos en tensión sobre el mismo fragmento|
|**Decisiones de diseño**|Trade-offs explicitados por confrontación entre perspectivas, no por checklist|

### La inversión lingüística

Los LLMs no son herramientas de programación que accidentalmente saben escribir. Son sistemas de lenguaje que accidentalmente también saben programar. LYCAEUM explota precisamente esa naturaleza: pone a los modelos a hacer lo que mejor hacen — argumentar, interpretar, confrontar ideas — en lugar de reducirlos a generadores de código.

## ¿Cómo?

### Arquitectura técnica

<div align=center>

|![](/images/docs/ai/bundungunLycaeum001.svg)
|-

</div>

### Flujo de un debate

<div align=center>

|![](/images/docs/ai/bundungunLycaeum002.svg)
|-

</div>

### Componentes del template

```
lycaeum/
├── README.md                  # Este documento
├── setup.sh                   # Configura el entorno (tmux + inotifywait)
├── debate.sh                  # Lanza un debate completo
├── config/
│   ├── debate.conf            # Parámetros: rondas, modelo por agente, timeouts
│   ├── marcos/                # Definiciones de marcos críticos
│   │   ├── formalismo.md      # Prompt del agente formalista
│   │   ├── fenomenologia.md   # Prompt del agente fenomenólogo
│   │   ├── deconstruccion.md  # Prompt del agente deconstructivista
│   │   └── moderador.md       # Prompt del moderador adversarial
│   └── ejemplos/              # Configuraciones predefinidas por dominio
│       ├── poesia.conf
│       ├── requisitos.conf
│       ├── arquitectura.conf
│       └── codigo.conf
├── agents/
│   ├── agent-wrapper.sh       # Wrapper genérico: CLI + prompt + blackboard I/O
│   ├── claude.sh              # Adaptador para Claude CLI
│   ├── gemini.sh              # Adaptador para Gemini CLI
│   ├── codex.sh               # Adaptador para Codex CLI
│   └── qwen.sh                # Adaptador para Qwen CLI
├── blackboard/
│   └── .gitkeep               # Directorio de trabajo del debate (efímero)
├── output/
│   └── .gitkeep               # Debates completados
└── docs/
    ├── arquitectura.md         # Decisiones de diseño
    ├── guia-marcos.md          # Cómo definir marcos críticos para nuevos dominios
    └── diagramas/
        └── *.puml              # Fuentes PlantUML
```

### Decisión: repo o carpeta

La respuesta es **ambos**, y el diseño lo permite:

|Escenario|Uso|
|---|---|
|**Repo standalone**|`git clone` para tener el template. Útil como referencia, para contribuir al proyecto, para experimentar con la herramienta aislada|
|**Carpeta dentro de un proyecto**|Copiar `lycaeum/` al directorio raíz de cualquier proyecto. El debate ocurre *junto a* los artefactos que se analizan. El `.gitignore` del proyecto puede excluir `lycaeum/blackboard/` y `lycaeum/output/` si se prefiere|
|**Submodule**|`git submodule add` para mantener la herramienta actualizada dentro de un proyecto sin duplicar código|

La recomendación es que el template se diseñe como **carpeta autosuficiente**: sin dependencias de paths absolutos, sin configuración global. Todo relativo a su propio directorio. Esto permite los tres modos de uso sin modificación.

### Prerrequisitos

- `tmux` (multiplexor de terminal)
- `inotifywait` (paquete `inotify-tools`)
- Al menos un CLI de LLM instalado y en PATH (`claude`, `gemini`, `codex`, `qwen`)
- `bash` 4+

### Ejecución mínima

```bash
# Desde el directorio del proyecto que contiene lycaeum/
cd lycaeum

# Configurar un debate sobre un archivo de requisitos
./debate.sh \
    --objeto ../docs/requisitos-v2.md \
    --marcos config/ejemplos/requisitos.conf \
    --rondas 5

# El debate se desarrolla en tmux
# El resultado queda en output/
```

## ¿Y ahora qué?

### Líneas abiertas

1. **Persistencia de contexto entre rondas**: actualmente cada turno envía el estado completo del blackboard como contexto. Con debates largos, esto excede ventanas de contexto. Se requiere un mecanismo de resumen progresivo o de selección de contexto relevante.

2. **Métricas de calidad del debate**: ¿cómo medir si la tensión entre marcos está produciendo hallazgos reales o solo ruido argumentativo? Posible indicador: frecuencia de cambios de posición o de refinamiento de argumentos entre rondas.

3. **Marcos dinámicos**: los marcos críticos están predefinidos. Una extensión natural es que el moderador sugiera marcos adicionales cuando detecte que los existentes no cubren un ángulo relevante del objeto.

4. **Integración con flujos de trabajo existentes**: LYCAEUM como paso en un pipeline de CI/CD (revisión arquitectónica automática), como herramienta de aula (análisis colectivo de requisitos), como instrumento de investigación.

---

*Proyecto derivado de [bundungún](https://github.com/mmasias), un lanzador de workspace multi-LLM.*