# MCP Subordinados — Claude Code como orquestador

Sistema para que Claude Code invoque agentes LLM externos (Gemini, OpenCode/z.ai) como herramientas MCP durante sesiones de trabajo autónomo.

## ¿Por qué?

Claude Code ya tiene el bucle de control, el filesystem y el criterio de parada. Lo que le falta es poder delegar subproblemas a otros modelos con perspectivas distintas. Este sistema lo resuelve exponiendo cada CLI externo como herramienta MCP: Claude Code llama a `gemini_ask` o `opencode_ask` igual que llama a `bash`.

## Arquitectura

```
Claude Code (orquestador)
    │
    ├── gemini_ask / gemini_ask_async / gemini_result
    │       └── gemini_mcp.py  →  gemini CLI  →  Google Gemini
    └── opencode_ask / opencode_ask_async / opencode_result
            └── opencode_mcp.py  →  opencode-wrapper.sh  →  z.ai / OpenCode
```

Cada servidor expone dos modos de invocación:

| Herramienta | Modo | Comportamiento |
|---|---|---|
| `gemini_ask` / `opencode_ask` | Síncrono | Bloquea hasta obtener respuesta |
| `gemini_ask_async` / `opencode_ask_async` | Async | Devuelve `job_id` inmediatamente |
| `gemini_result` / `opencode_result` | Consulta | Devuelve resultado o `"pendiente"` |

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
- `expect` instalado (para `unbuffer`) — solo Linux

## Instalación

### 1. Instalar dependencia Python

**Debian/Ubuntu:**
```bash
sudo apt install python3-pip
pip3 install mcp --break-system-packages
```

**Fedora:**
```bash
sudo dnf install python3-pip expect -y
pip3 install mcp --break-system-packages
```

> En Fedora, `expect` provee el comando `unbuffer`, necesario para que opencode
> funcione sin TTY desde un subprocess.

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

```python
import asyncio, subprocess, os, uuid
from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp.types import Tool, TextContent

server = Server("gemini")
_jobs = {}

@server.list_tools()
async def list_tools():
    return [
        Tool(
            name="gemini_ask",
            description="Consulta a Gemini CLI en modo no-interactivo.",
            inputSchema={
                "type": "object",
                "properties": {"prompt": {"type": "string"}},
                "required": ["prompt"]
            }
        ),
        Tool(
            name="gemini_ask_async",
            description="Lanza una consulta a Gemini en background. Devuelve un job_id para recoger el resultado más tarde con gemini_result.",
            inputSchema={
                "type": "object",
                "properties": {"prompt": {"type": "string"}},
                "required": ["prompt"]
            }
        ),
        Tool(
            name="gemini_result",
            description="Recoge el resultado de una consulta async lanzada con gemini_ask_async. Devuelve 'pendiente' si el proceso aún no terminó.",
            inputSchema={
                "type": "object",
                "properties": {"job_id": {"type": "string"}},
                "required": ["job_id"]
            }
        ),
    ]

@server.call_tool()
async def call_tool(name: str, arguments: dict):
    if name == "gemini_ask":
        result = subprocess.run(
            ["/home/manuel/.nvm/versions/node/vX.Y.Z/bin/gemini", "-p", arguments["prompt"]],
            capture_output=True, text=True, timeout=120, stdin=subprocess.DEVNULL
        )
        return [TextContent(type="text", text=result.stdout)]

    elif name == "gemini_ask_async":
        job_id = str(uuid.uuid4())[:8]
        outfile = f"/tmp/gemini_job_{job_id}.txt"
        with open(outfile, "w") as f:
            proc = subprocess.Popen(
                ["/home/manuel/.nvm/versions/node/vX.Y.Z/bin/gemini", "-p", arguments["prompt"]],
                stdout=f, stderr=subprocess.DEVNULL, stdin=subprocess.DEVNULL
            )
        _jobs[job_id] = {"proc": proc, "outfile": outfile}
        return [TextContent(type="text", text=job_id)]

    elif name == "gemini_result":
        job_id = arguments["job_id"]
        if job_id not in _jobs:
            return [TextContent(type="text", text=f"job_id '{job_id}' no encontrado")]
        job = _jobs[job_id]
        if job["proc"].poll() is None:
            return [TextContent(type="text", text="pendiente")]
        with open(job["outfile"]) as f:
            result = f.read()
        os.unlink(job["outfile"])
        del _jobs[job_id]
        return [TextContent(type="text", text=result)]

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
OUTFILE="${OPENCODE_OUTFILE:-/tmp/opencode_out.txt}"
PROMPT="$(cat "$1")"
rm -f "$1"
unbuffer opencode --log-level ERROR -m "MODEL" run "$PROMPT" 2>/dev/null | col -b > "$OUTFILE"
sed -i 's/\x1b\[[0-9;]*m//g; s/\r//g; s/^0m$//g' "$OUTFILE"
```

```bash
chmod +x ~/mcp-servers/opencode-wrapper.sh
```

> **Por qué `unbuffer`**: opencode detecta ausencia de TTY y no escribe su output
> a stdout/stderr sino directamente a `/dev/tty`. `unbuffer` crea un pseudo-TTY
> que engaña al proceso. En macOS usar `script -q /dev/null` en su lugar.

> **Por qué fichero temporal para el output**: aunque `unbuffer` resuelve el TTY,
> `capture_output` de Python no captura la salida. El wrapper escribe a fichero;
> el MCP lee el fichero.

> **Por qué `col -b`**: el TUI de opencode emite secuencias de cursor al terminar
> que sobreescriben la respuesta en el fichero de output. `col -b` procesa esas
> secuencias y deja solo el texto visible final.

> **Por qué fichero temporal para el prompt**: pasar el prompt como `$1` permite
> que backticks en el contenido (p.ej. código Markdown con triple-backtick) se
> interpreten como command substitution dentro de la variable bash. Escribir el
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

@server.list_tools()
async def list_tools():
    return [
        Tool(
            name="opencode_ask",
            description="Consulta a OpenCode (z.ai) en modo no-interactivo.",
            inputSchema={
                "type": "object",
                "properties": {"prompt": {"type": "string"}},
                "required": ["prompt"]
            }
        ),
        Tool(
            name="opencode_ask_async",
            description="Lanza una consulta a OpenCode en background. Devuelve un job_id para recoger el resultado más tarde con opencode_result.",
            inputSchema={
                "type": "object",
                "properties": {"prompt": {"type": "string"}},
                "required": ["prompt"]
            }
        ),
        Tool(
            name="opencode_result",
            description="Recoge el resultado de una consulta async lanzada con opencode_ask_async. Devuelve 'pendiente' si el proceso aún no terminó.",
            inputSchema={
                "type": "object",
                "properties": {"job_id": {"type": "string"}},
                "required": ["job_id"]
            }
        ),
    ]

@server.call_tool()
async def call_tool(name: str, arguments: dict):
    if name == "opencode_ask":
        outfile = f"/tmp/opencode_out_{os.getpid()}.txt"
        prompt_file = f"/tmp/opencode_prompt_{os.getpid()}.txt"
        with open(prompt_file, "w") as pf:
            pf.write(arguments["prompt"])
        env = {
            **os.environ,
            "PATH": f"/home/manuel/.nvm/versions/node/vX.Y.Z/bin:{os.environ.get('PATH', '')}",
            "HOME": "/home/manuel",
            "OPENCODE_OUTFILE": outfile,
        }
        subprocess.run(
            ["/home/manuel/mcp-servers/opencode-wrapper.sh", prompt_file],
            env=env, timeout=120, stdin=subprocess.DEVNULL
        )
        with open(outfile) as f:
            result = f.read()
        os.unlink(outfile)
        return [TextContent(type="text", text=result)]

    elif name == "opencode_ask_async":
        job_id = str(uuid.uuid4())[:8]
        outfile = f"/tmp/opencode_job_{job_id}.txt"
        prompt_file = f"/tmp/opencode_prompt_{job_id}.txt"
        with open(prompt_file, "w") as pf:
            pf.write(arguments["prompt"])
        env = {
            **os.environ,
            "PATH": f"/home/manuel/.nvm/versions/node/vX.Y.Z/bin:{os.environ.get('PATH', '')}",
            "HOME": "/home/manuel",
            "OPENCODE_OUTFILE": outfile,
        }
        proc = subprocess.Popen(
            ["/home/manuel/mcp-servers/opencode-wrapper.sh", prompt_file],
            env=env, stdin=subprocess.DEVNULL
        )
        _jobs[job_id] = {"proc": proc, "outfile": outfile}
        return [TextContent(type="text", text=job_id)]

    elif name == "opencode_result":
        job_id = arguments["job_id"]
        if job_id not in _jobs:
            return [TextContent(type="text", text=f"job_id '{job_id}' no encontrado")]
        job = _jobs[job_id]
        if job["proc"].poll() is None:
            return [TextContent(type="text", text="pendiente")]
        with open(job["outfile"]) as f:
            result = f.read()
        os.unlink(job["outfile"])
        del _jobs[job_id]
        return [TextContent(type="text", text=result)]

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

# Verificar subprocess de gemini
python3 -c "
import subprocess
r = subprocess.run(['/home/manuel/.nvm/versions/node/vX.Y.Z/bin/gemini', '-p', 'responde solo: ok'],
    capture_output=True, text=True, timeout=60)
print('STDOUT:', repr(r.stdout))
print('RC:', r.returncode)
"

# Verificar wrapper de opencode
echo "responde solo: ok" > /tmp/test_prompt.txt
OPENCODE_OUTFILE=/tmp/test.txt ~/mcp-servers/opencode-wrapper.sh /tmp/test_prompt.txt
cat /tmp/test.txt
```

### 7. Registrar en Claude Code

```bash
claude mcp add gemini --scope user \
  -- python3 /home/manuel/mcp-servers/gemini_mcp.py

claude mcp add opencode --scope user \
  -- python3 /home/manuel/mcp-servers/opencode_mcp.py

claude mcp list
# gemini:   ✓ Connected
# opencode: ✓ Connected
```

### 8. Verificar desde Claude Code

```bash
claude
```

**Modo síncrono:**
```
> usa la herramienta gemini_ask para preguntarle cuál es la capital de Francia
> usa la herramienta opencode_ask para preguntarle cuál es la capital de Alemania
```

**Modo async:**
```
> usa gemini_ask_async para preguntarle cuál es la capital de Japón y dime el job_id
> [seguir trabajando...]
> usa gemini_result con el job_id anterior para ver la respuesta
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

1. `unbuffer` no instalado → `sudo dnf install expect`
2. Modelo no disponible → verificar con `opencode models` y actualizar wrapper
3. opencode no autenticado → ejecutar `opencode` en TUI y configurar proveedor

### Output vacío en opencode

opencode escribe a `/dev/tty` en lugar de stdout. Solución: el wrapper con
`unbuffer` + fichero temporal ya lo resuelve. Si persiste, verificar que el
wrapper tiene permisos de ejecución: `chmod +x ~/mcp-servers/opencode-wrapper.sh`

### `job_id 'xxx' no encontrado` en `gemini_result` / `opencode_result`

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

### `_result` devuelve `"pendiente"` indefinidamente

El proceso background colgó. Verificar manualmente:
```bash
ls /tmp/gemini_job_*.txt   # o opencode_job_
# Si el fichero existe pero está vacío: el proceso colgó
# Si no existe: aún está escribiendo (normal en opencode, que es más lento)
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
- Nombre de la herramienta: `nuevo_agente_ask`
- Comando del subprocess

**Paso 4 — Registrar**
```bash
claude mcp add nuevo-agente --scope user \
  -- python3 /home/manuel/mcp-servers/nuevo_agente_mcp.py
```
