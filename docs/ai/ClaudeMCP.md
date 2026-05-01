# MCP Subordinados — Claude Code como orquestador

Sistema para que Claude Code invoque agentes LLM externos (Gemini, OpenCode/z.ai) como herramientas MCP durante sesiones de trabajo autónomo.

## ¿Por qué?

Claude Code ya tiene el bucle de control, el filesystem y el criterio de parada. Lo que le falta es poder delegar subproblemas a otros modelos con perspectivas distintas. Este sistema lo resuelve exponiendo cada CLI externo como herramienta MCP: Claude Code llama a `gemini_run` o `opencode_run` igual que llama a `bash`.

## Arquitectura

```
Claude Code (orquestador)
    │
    ├── gemini_run / gemini_run_async / gemini_done
    │       └── gemini_mcp.py  →  gemini CLI  →  Google Gemini
    └── opencode_run / opencode_run_async / opencode_done
            └── opencode_mcp.py  →  opencode-wrapper.sh  →  z.ai / OpenCode
```

El output de cada agente son **ficheros en un directorio de trabajo** (`workdir`), no texto capturado de stdout. El prompt especifica qué ficheros producir; Claude inspecciona los resultados con Read, Glob, Grep. Ambos servidores son estructuralmente idénticos — solo difieren en el binario que invocan.

Cada servidor expone dos modos de invocación:

| Herramienta | Modo | Comportamiento |
|---|---|---|
| `gemini_run` / `opencode_run` | Síncrono | Bloquea hasta terminar; escribe ficheros en workdir |
| `gemini_run_async` / `opencode_run_async` | Async | Devuelve `job_id` inmediatamente |
| `gemini_done` / `opencode_done` | Consulta | Devuelve `"pendiente"`, `"listo"` o `"error: ..."` |

Cada agente subordinado:

- No sabe que está siendo orquestado
- No tiene estado entre llamadas
- Recibe solo el contexto mínimo necesario
- Sus tokens se imputan a su propio proveedor (no a Anthropic)

## Requisitos previos

- Claude Code instalado (`npm install -g @anthropic-ai/claude-code`)
- `gemini` CLI instalado y autenticado
- `opencode` CLI instalado y autenticado con z.ai
- Python 3.x disponible
- `pip3` disponible
- `opencode` CLI capaz de ejecutarse sin TTY (verificado en v1.14+)

## Instalación

### 1. Instalar dependencia Python

**Debian/Ubuntu:**
```bash
sudo apt install python3-pip
pip3 install mcp --break-system-packages
```

**Fedora:**
```bash
sudo dnf install python3-pip -y
pip3 install mcp --break-system-packages
```

### 2. Crear directorio de scripts

```bash
mkdir -p ~/mcp-servers
```

### 3. Detectar rutas de Node/nvm

Los CLI de gemini y opencode están instalados via nvm. La ruta varía por máquina:

```bash
which gemini   # p.ej. ~/.nvm/versions/node/v24.14.1/bin/gemini
which opencode # misma ruta base
```

Anotar la ruta base: `~/.nvm/versions/node/vX.Y.Z/bin`

### 4. Detectar modelo disponible en OpenCode

```bash
opencode models 2>/dev/null | head -10
```

Elegir un modelo disponible. Ejemplos reales por máquina:

| Máquina | Node | Modelo opencode |
|---|---|---|
| Principal (Fedora KDE) | v24.12.0 | zai-coding-plan/glm-5.1 |
| Prometeus (Fedora KDE) | v24.14.0 | opencode/big-pickle |
| @U (Kubuntu 24) | v24.14.1 | opencode/big-pickle |

### 5. Crear los scripts

#### `~/mcp-servers/gemini_mcp.py`

Sustituir `/home/manuel/.nvm/versions/node/vX.Y.Z` con la ruta real.
Estructuralmente idéntico a `opencode_mcp.py` — solo difiere en el binario invocado.
Requiere `-y` (auto-approve all tools) y `--skip-trust` (confiar en el workdir sin confirmación interactiva).

```python
import asyncio, subprocess, os, uuid
from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp.types import Tool, TextContent

server = Server("gemini")
_jobs = {}

GEMINI_BIN = "/home/manuel/.nvm/versions/node/vX.Y.Z/bin/gemini"

@server.list_tools()
async def list_tools():
    return [
        Tool(
            name="gemini_run",
            description="Ejecuta Gemini con un prompt en un directorio de trabajo. Gemini crea o modifica ficheros en workdir. El prompt debe especificar qué ficheros producir. Devuelve 'listo' o 'error: ...'.",
            inputSchema={
                "type": "object",
                "properties": {
                    "prompt": {"type": "string"},
                    "workdir": {"type": "string", "description": "Directorio donde Gemini operará"}
                },
                "required": ["prompt", "workdir"]
            }
        ),
        Tool(
            name="gemini_run_async",
            description="Lanza Gemini en background. Devuelve job_id para consultar con gemini_done.",
            inputSchema={
                "type": "object",
                "properties": {
                    "prompt": {"type": "string"},
                    "workdir": {"type": "string"}
                },
                "required": ["prompt", "workdir"]
            }
        ),
        Tool(
            name="gemini_done",
            description="Consulta el estado de un job async lanzado con gemini_run_async. Devuelve 'pendiente', 'listo' o 'error: ...'.",
            inputSchema={
                "type": "object",
                "properties": {"job_id": {"type": "string"}},
                "required": ["job_id"]
            }
        ),
    ]

@server.call_tool()
async def call_tool(name: str, arguments: dict):
    if name == "gemini_run":
        workdir = arguments["workdir"]
        os.makedirs(workdir, exist_ok=True)
        result = subprocess.run(
            [GEMINI_BIN, "-y", "--skip-trust", "-p", arguments["prompt"]],
            cwd=workdir,
            stdin=subprocess.DEVNULL,
            stdout=subprocess.DEVNULL, stderr=subprocess.PIPE,
            timeout=120
        )
        if result.returncode != 0:
            return [TextContent(type="text", text=f"error: código {result.returncode}: {result.stderr.decode()[:300]}")]
        return [TextContent(type="text", text="listo")]

    elif name == "gemini_run_async":
        job_id = str(uuid.uuid4())[:8]
        workdir = arguments["workdir"]
        os.makedirs(workdir, exist_ok=True)
        proc = subprocess.Popen(
            [GEMINI_BIN, "-y", "--skip-trust", "-p", arguments["prompt"]],
            cwd=workdir,
            stdin=subprocess.DEVNULL,
            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
        )
        _jobs[job_id] = {"proc": proc, "workdir": workdir}
        return [TextContent(type="text", text=job_id)]

    elif name == "gemini_done":
        job_id = arguments["job_id"]
        if job_id not in _jobs:
            return [TextContent(type="text", text=f"error: job_id '{job_id}' no encontrado")]
        job = _jobs[job_id]
        if job["proc"].poll() is None:
            return [TextContent(type="text", text="pendiente")]
        returncode = job["proc"].returncode
        del _jobs[job_id]
        if returncode != 0:
            return [TextContent(type="text", text=f"error: código {returncode}")]
        return [TextContent(type="text", text="listo")]

async def main():
    async with stdio_server() as streams:
        await server.run(streams[0], streams[1], server.create_initialization_options())

asyncio.run(main())
```

#### `~/mcp-servers/opencode-wrapper.sh`

Sustituir `MODEL` con el modelo detectado en el paso 4.

```bash
#!/bin/bash
export NVM_DIR="/home/manuel/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
PROMPT="$(cat "$1")"
rm -f "$1"
opencode --log-level ERROR -m "MODEL" run "$PROMPT"
```

```bash
chmod +x ~/mcp-servers/opencode-wrapper.sh
```

> **Por qué no redirigir stdout a fichero**: el output de opencode son los ficheros
> que crea/modifica en el directorio de trabajo (`cwd`). El MCP server no necesita
> capturar stdout — Claude inspeccionará los ficheros resultantes con sus propias
> herramientas (Read, Glob, Grep).

> **Por qué fichero temporal para el prompt**: pasar el prompt como argumento
> directo permite que backticks en el contenido (p.ej. código Markdown con
> triple-backtick) se interpreten como command substitution en bash. Escribir el
> prompt a fichero y leerlo con `$(cat "$1")` evita esa reinterpretación.

#### `~/mcp-servers/opencode_mcp.py`

Sustituir la versión de Node en PATH.

```python
import asyncio, subprocess, os, uuid
from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp.types import Tool, TextContent

server = Server("opencode")
_jobs = {}

WRAPPER = "/home/manuel/mcp-servers/opencode-wrapper.sh"
NVM_NODE_BIN = "/home/manuel/.nvm/versions/node/vX.Y.Z/bin"

def make_env():
    return {
        **os.environ,
        "PATH": f"{NVM_NODE_BIN}:{os.environ.get('PATH', '')}",
        "HOME": "/home/manuel",
    }

@server.list_tools()
async def list_tools():
    return [
        Tool(
            name="opencode_run",
            description="Ejecuta OpenCode con un prompt en un directorio de trabajo. OpenCode crea o modifica ficheros en workdir. Devuelve 'listo' o 'error: ...'.",
            inputSchema={
                "type": "object",
                "properties": {
                    "prompt": {"type": "string"},
                    "workdir": {"type": "string", "description": "Directorio donde OpenCode operará"}
                },
                "required": ["prompt", "workdir"]
            }
        ),
        Tool(
            name="opencode_run_async",
            description="Lanza OpenCode en background. Devuelve job_id para consultar con opencode_done.",
            inputSchema={
                "type": "object",
                "properties": {
                    "prompt": {"type": "string"},
                    "workdir": {"type": "string"}
                },
                "required": ["prompt", "workdir"]
            }
        ),
        Tool(
            name="opencode_done",
            description="Consulta el estado de un job async lanzado con opencode_run_async. Devuelve 'pendiente', 'listo' o 'error: ...'.",
            inputSchema={
                "type": "object",
                "properties": {"job_id": {"type": "string"}},
                "required": ["job_id"]
            }
        ),
    ]

@server.call_tool()
async def call_tool(name: str, arguments: dict):
    if name == "opencode_run":
        workdir = arguments["workdir"]
        os.makedirs(workdir, exist_ok=True)
        prompt_file = f"/tmp/opencode_prompt_{os.getpid()}.txt"
        with open(prompt_file, "w") as f:
            f.write(arguments["prompt"])
        result = subprocess.run(
            [WRAPPER, prompt_file],
            env=make_env(), cwd=workdir,
            stdin=subprocess.DEVNULL,
            stdout=subprocess.DEVNULL, stderr=subprocess.PIPE,
            timeout=300
        )
        if result.returncode != 0:
            return [TextContent(type="text", text=f"error: código {result.returncode}: {result.stderr.decode()[:300]}")]
        return [TextContent(type="text", text="listo")]

    elif name == "opencode_run_async":
        job_id = str(uuid.uuid4())[:8]
        workdir = arguments["workdir"]
        os.makedirs(workdir, exist_ok=True)
        prompt_file = f"/tmp/opencode_prompt_{job_id}.txt"
        with open(prompt_file, "w") as f:
            f.write(arguments["prompt"])
        proc = subprocess.Popen(
            [WRAPPER, prompt_file],
            env=make_env(), cwd=workdir,
            stdin=subprocess.DEVNULL,
            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
        )
        _jobs[job_id] = {"proc": proc, "workdir": workdir}
        return [TextContent(type="text", text=job_id)]

    elif name == "opencode_done":
        job_id = arguments["job_id"]
        if job_id not in _jobs:
            return [TextContent(type="text", text=f"error: job_id '{job_id}' no encontrado")]
        job = _jobs[job_id]
        if job["proc"].poll() is None:
            return [TextContent(type="text", text="pendiente")]
        returncode = job["proc"].returncode
        del _jobs[job_id]
        if returncode != 0:
            return [TextContent(type="text", text=f"error: código {returncode}")]
        return [TextContent(type="text", text="listo")]

async def main():
    async with stdio_server() as streams:
        await server.run(streams[0], streams[1], server.create_initialization_options())

asyncio.run(main())
```

### 6. Verificar scripts antes de registrar

```bash
# Verificar sintaxis Python
python3 -c "import ast; ast.parse(open('/home/manuel/mcp-servers/gemini_mcp.py').read()); print('ok')"
python3 -c "import ast; ast.parse(open('/home/manuel/mcp-servers/opencode_mcp.py').read()); print('ok')"

# Verificar gemini: debe crear /tmp/gemini_test/hola.txt con contenido
mkdir -p /tmp/gemini_test
/home/manuel/.nvm/versions/node/vX.Y.Z/bin/gemini \
  -y --skip-trust \
  -p "Crea un fichero llamado hola.txt con el texto 'hola mundo'" \
  2>/dev/null
ls /tmp/gemini_test/   # debe mostrar hola.txt
# Nota: gemini trabaja con cwd=workdir, no captura stdout

# Verificar wrapper de opencode: debe crear ficheros en /tmp/opencode_test/
mkdir -p /tmp/opencode_test
echo "Crea un fichero llamado hola.txt con el texto 'hola mundo'" > /tmp/test_prompt.txt
~/mcp-servers/opencode-wrapper.sh /tmp/test_prompt.txt  # cwd debe ser /tmp/opencode_test
ls /tmp/opencode_test/
```

### 7. Configurar permisos para modo autónomo

Para que Claude Code invoque las herramientas MCP sin pedir confirmación en cada llamada, añadir a `~/.claude/settings.json`:

```json
{
  "permissions": {
    "allow": [
      "mcp__gemini__*",
      "mcp__opencode__*"
    ]
  }
}
```

Esto es condición necesaria para orquestación real: sin estos permisos, cada `gemini_run` o `opencode_run_async` interrumpe al usuario para pedir aprobación, lo que anula la ventaja del paradigma async.

### 8. Registrar en Claude Code

```bash
claude mcp add gemini --scope user \
  -- python3 /home/manuel/mcp-servers/gemini_mcp.py

claude mcp add opencode --scope user \
  -- python3 /home/manuel/mcp-servers/opencode_mcp.py

claude mcp list
# gemini:   ✓ Connected
# opencode: ✓ Connected
```

### 9. Verificar desde Claude Code

```bash
claude
```

**Prueba 1 — OpenCode sync (crear fichero):**
```
> usa opencode_run con prompt "Crea un fichero llamado hola.txt con el texto 'hola mundo'"
  y workdir "/tmp/octest"
> [esperado: "listo"]
> usa Glob en /tmp/octest/ para ver si hola.txt existe
> lee /tmp/octest/hola.txt
```

**Prueba 2 — Gemini sync (crear fichero):**
```
> usa gemini_run con prompt "Crea un fichero llamado resumen.md con un párrafo breve sobre Python"
  y workdir "/tmp/gtest"
> [esperado: "listo"]
> usa Glob en /tmp/gtest/ para ver si resumen.md existe y tiene contenido
```

> **Nota de seguridad:** `cwd=workdir` aísla la operación de Gemini al directorio
> especificado. Usar siempre directorios dedicados, nunca rutas sensibles del sistema.

**Prueba 3 — async (OpenCode):**
```
> usa opencode_run_async con prompt "Crea un fichero poema.md con una poesía corta sobre el mar"
  y workdir "/tmp/ocasync"
> [anotar job_id, seguir trabajando...]
> usa opencode_done con el job_id cada ~1 min hasta obtener "listo"
> usa Glob en /tmp/ocasync/ para verificar poema.md
```

## Diagnóstico de problemas frecuentes

### `Failed to connect` en `claude mcp list`

El script Python falla al arrancar. Ejecutar directamente:

```bash
python3 ~/mcp-servers/gemini_mcp.py
# Si se queda colgado sin error: correcto (espera mensajes MCP por stdin)
# Si muestra error: corregir antes de registrar
```

### Timeout en gemini_ask

Causa más común: PATH incorrecto. Claude Code no hereda el PATH del shell.

Solución: usar ruta absoluta al binario (ya está en el script).

### Timeout en opencode_ask

Causas posibles:

1. Modelo no disponible → verificar con `opencode models` y actualizar wrapper
2. opencode no autenticado → ejecutar `opencode` en TUI y configurar proveedor

### OpenCode no crea ficheros en workdir

Verificar permisos del wrapper:
```bash
chmod +x ~/mcp-servers/opencode-wrapper.sh
```

Probar el wrapper directamente con un workdir explícito:
```bash
mkdir -p /tmp/oc_test
echo "Crea un fichero llamado resultado.txt con el texto 'prueba ok'" > /tmp/test_prompt.txt
cd /tmp/oc_test && ~/mcp-servers/opencode-wrapper.sh /tmp/test_prompt.txt
ls /tmp/oc_test/
```

Si no crea ficheros, el problema es el modelo o la autenticación con z.ai.

### `error: job_id 'xxx' no encontrado` en `gemini_done` / `opencode_done`

El dict `_jobs` es efímero: vive solo mientras el proceso MCP server está activo.
Si Claude Code se reinició entre el `_ask_async` y el `_result`, el job_id se perdió.
Solución: lanzar y recoger resultados dentro de la misma sesión de Claude Code.

### `_result` cuelga indefinidamente (nunca devuelve nada)

Causa: el proceso lanzado con `Popen` hereda el stdin del servidor MCP (el pipe
JSON-RPC entre Claude Code y el servidor). El CLI hijo (Gemini/OpenCode/Node.js)
mantiene ese fd abierto; cuando Claude Code envía el siguiente mensaje al servidor
(la llamada a `_result`), el servidor no puede leerlo porque el hijo interfiere en
el pipe.

Solución: `stdin=subprocess.DEVNULL` en todos los `Popen` y `subprocess.run` de
los servidores MCP. Ya está incluido en los snippets de esta guía.

### `gemini_done` / `opencode_done` devuelve `"pendiente"` indefinidamente

El proceso background colgó. Verificar manualmente:
```bash
ps aux | grep gemini   # o grep opencode
# Si hay proceso activo: aún está trabajando (normal en opencode, ~2-3 min)
# Si no hay proceso: el proceso murió sin actualizar _jobs — reiniciar Claude Code
```

## ¿Y ahora qué? — Incorporar nuevos agentes

### Proceso de incorporación

Añadir un nuevo agente subordinado sigue siempre el mismo patrón:

**Paso 1 — Verificar que el CLI tiene modo no-interactivo limpio**
```bash
nuevo-cli --help | grep -i "prompt\|non-interactive\|headless"
nuevo-cli -p "responde solo: ok"  # o el flag equivalente
```

**Paso 2 — Verificar captura de output**
```bash
python3 -c "
import subprocess
r = subprocess.run(['nuevo-cli', '-p', 'ok'], capture_output=True, text=True, timeout=60)
print('STDOUT:', repr(r.stdout[:100]))
print('STDERR:', repr(r.stderr[:100]))
"
```

Si stdout está vacío, el CLI escribe a TTY → necesita wrapper con `unbuffer`.
Si stdout tiene ANSI escapes → añadir `sed` de limpieza.

**Paso 3 — Crear el MCP server**

Copiar `gemini_mcp.py` como plantilla, cambiar:
- Nombre del servidor: `Server("nuevo-agente")`
- Nombres de herramientas: `nuevo_agente_run`, `nuevo_agente_run_async`, `nuevo_agente_done`
- Comando del subprocess
- Si el agente trabaja con ficheros en workdir (como opencode): usar `cwd=workdir` y `stdout=DEVNULL`
- Si el agente solo produce texto (como gemini): redirigir stdout a `{workdir}/response.md`

**Paso 4 — Registrar**
```bash
claude mcp add nuevo-agente --scope user \
  -- python3 /home/manuel/mcp-servers/nuevo_agente_mcp.py
```

## Patrón de orquestación paralela

El caso de uso más potente del sistema: Claude diseña la estructura, delega secciones a cada agente en paralelo, y ensambla el resultado cuando todos terminan.

### Regla de escritura concurrente

Nunca enviar a dos agentes a escribir el mismo fichero en paralelo. Si ambos modifican `index.html` simultáneamente, el segundo sobreescribe al primero.

Solución: cada agente escribe **solo su propio artefacto**. El orquestador (Claude) hace el ensamblado final.

### Ejemplo: web hecha por los tres agentes

```
# 1. Claude crea la estructura con placeholders
Write("/tmp/webtest/index.html")  # con <!-- GEMINI_SUMMARY --> y <!-- OPENCODE_SUMMARY -->

# 2. Delegar en paralelo (async)
job_g = gemini_run_async(
    prompt="Crea gemini.html presentándote + gemini_summary.txt con 2 frases",
    workdir="/tmp/webtest"
)
job_o = opencode_run_async(
    prompt="Crea opencode.html presentándote + opencode_summary.txt con 2 frases",
    workdir="/tmp/webtest"
)

# 3. Mientras trabajan: Claude documenta, planifica, hace otras cosas
# No hacer poll ansioso. Recoger cuando convenga.

# 4. Recoger cuando el usuario lo indique (o tras el tiempo estimado)
gemini_done(job_g)   # -> "listo"
opencode_done(job_o) # -> "listo"

# 5. Ensamblar: Claude lee los summaries e inyecta en index.html
Read("/tmp/webtest/gemini_summary.txt")   -> texto
Read("/tmp/webtest/opencode_summary.txt") -> texto
Edit("/tmp/webtest/index.html")  # sustituir placeholders por los textos reales
```

### Principio operativo: delegar y olvidar

El `job_id` se conoce al lanzar. A partir de ahí el agente es independiente.

- No hacer poll ansioso: recoger cuando convenga, no cuando el agente termine.
- El orden de magnitud de tiempo (segundos vs. minutos) es lo único útil para decidir si recoger en esta vuelta o más tarde.
- Gemini: ~30 segundos. OpenCode: ~2-3 minutos.
