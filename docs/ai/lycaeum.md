# LYCAEUM

Sistema multi-agente de análisis crítico por debate estructurado.

Tres (o más) LLMs con marcos interpretativos distintos debaten sobre un objeto concreto. Un moderador — también un LLM — identifica desacuerdos y fuerza confrontación. El resultado: lecturas que ningún agente individual habría producido.

## ¿Por qué?

Un único modelo ante un objeto de análisis produce una lectura coherente pero sesgada. No hay tensión interna que fuerce la revisión de supuestos.

Los frameworks multi-agente existentes usan hub-and-spoke: un agente central orquesta, filtra y sintetiza. El centro es cuello de botella interpretativo.

LYCAEUM usa **blackboard pattern**: un espacio de conocimiento compartido (filesystem) donde todos los agentes tienen acceso simétrico al estado completo del debate. El moderador no sintetiza: provoca.

## ¿Qué?

|Componente|Función|Implementación|
|---|---|---|
|**Moderador**|Orquesta el debate. Identifica tensiones. Provoca. No opina sobre el objeto.|LLM con prompt (protocolo + dominio)|
|**Agentes**|Analizan desde marcos críticos asignados. Debaten entre sí.|CLIs de LLM en sesiones tmux persistentes|
|**Blackboard**|Estado completo del debate, visible para todos.|Archivos markdown en filesystem|
|**Script**|Transporte: lanza sesiones, envía tareas, espera archivos.|Bash + tmux + inotifywait|

La inteligencia del sistema está en el moderador y en los contextos de los agentes, no en el script. El script es transporte.

## ¿Para qué?

Cualquier dominio donde la tensión entre perspectivas produce hallazgos. Dominios predefinidos:

|||
|---|---|
|**Poesía**|formalismo × fenomenología × deconstrucción|
|**Requisitos**|usuario × técnico × negocio|
|**Arquitectura**|rendimiento × mantenibilidad × coste|
|**Código**|legibilidad × eficiencia × extensibilidad|
|**Otro**|plantilla para dominios personalizados|

## ¿Cómo?

### Prerrequisitos

```bash
# tmux + inotify-tools
sudo apt install tmux inotify-tools    # Debian/Ubuntu
sudo dnf install tmux inotify-tools    # Fedora

# Al menos un CLI de LLM en PATH
which claude gemini qwen opencode      # los que tengas
```

### Estructura

```
lycaeum/
├── lycaeum.sh                          # Script de transporte
├── config/
│   ├── protocolo/                      # Invariante — no cambia por dominio
│   │   ├── moderador-base.md           #   Fase A/B, reglas, formato blackboard
│   │   └── agente-base.md              #   Cómo leer tasks, dónde escribir
│   ├── dominios/                       # Variable — un directorio por dominio
│   │   ├── poesia/
│   │   │   ├── moderador.md            #   Extensión del moderador para poesía
│   │   │   ├── formalismo.md           #   Marco + pregunta permanente
│   │   │   ├── fenomenologia.md
│   │   │   └── deconstruccion.md
│   │   ├── requisitos/
│   │   ├── arquitectura/
│   │   ├── codigo/
│   │   └── otro/                       #   Plantilla para dominios nuevos
│   └── instancia/
│       └── debate.conf                 #   Dominio, agentes, CLIs, rondas
├── _LYCAEUM/                           # Directorio de trabajo del debate
│   ├── rondas/                         #   ronda_01/, ronda_02/, ...
│   └── blackboard.md                   #   Estado acumulado
├── objeto/                             # El objeto de análisis
└── docs/
    ├── de-bundungun-a-lycaeum.md       # Artículo: evolución del proyecto
    ├── arquitectura.md                 # Decisiones de diseño
    ├── guia-marcos.md                  # Cómo crear marcos para nuevos dominios
    └── diagramas/
```

### Tres capas de configuración

|Capa|Qué contiene|Cuándo cambia|
|---|---|---|
|**Protocolo**|Fase A/B, reglas de moderación, formato del blackboard|Nunca|
|**Dominio**|Marcos críticos, preguntas permanentes, extensión del moderador|Al cambiar de dominio|
|**Instancia**|Objeto concreto, qué CLI va con qué marco, número de rondas|Cada debate|

El contexto que recibe cada agente se compone concatenando `protocolo/agente-base.md` + `dominio/marco.md`. El moderador recibe `protocolo/moderador-base.md` + `dominio/moderador.md`. El script hace la composición automáticamente.

### Configurar

Editar `config/instancia/debate.conf`:

```bash
DOMINIO=requisitos

AGENTES=(
    "usuario:claude:usuario"
    "tecnico:gemini:tecnico"
    "negocio:qwen:negocio"
)

MODERADOR_CLI=claude
RONDAS=5
```

### Ejecutar

```bash
./lycaeum.sh start        # Lanza sesiones, carga contextos
./lycaeum.sh ronda 1      # Gestiona ronda 1 (Fase A + B)
./lycaeum.sh ronda 2      # ...
./lycaeum.sh status       # Estado de todas las rondas
```

### Crear un dominio nuevo

1. Copiar `config/dominios/otro/` a `config/dominios/mi-dominio/`
2. Rellenar `moderador.md` con la tabla de marcos y preguntas guía
3. Crear un `.md` por marco usando `marco-plantilla.md` como base
4. Ajustar `config/instancia/debate.conf`

Ver [docs/guia-marcos.md](docs/guia-marcos.md) para el principio de diseño: **tensión, no complementariedad**.

### Uso como carpeta dentro de otro proyecto

```
mi-proyecto/
├── src/
├── docs/
├── lycaeum/        ← copiar aquí
└── README.md
```

Sin dependencias de paths absolutos. Todo relativo a su propio directorio.

## Origen

Evolución de [bundungún](https://github.com/mmasias) — script que lanzaba 4 CLIs de LLM en grid 2x2 para consulta paralela. Ver [de-bundungun-a-lycaeum.md](docs/de-bundungun-a-lycaeum.md).