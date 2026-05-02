# Orquestación multi-agente con MCP

Sistema para que Claude Code invoque agentes LLM externos (Gemini, OpenCode/z.ai) como herramientas MCP durante sesiones de trabajo autónomo.

---

## ¿Por qué?

Claude Code ya tiene el bucle de control, el acceso al filesystem y el criterio de parada. Lo que no tiene es capacidad para delegar subproblemas a otros modelos con perspectivas distintas.

El problema no es solo técnico. Los modelos LLM tienen costes de razonamiento distintos: mantener a Claude concentrado en la coordinación y el criterio de calidad, mientras tareas de generación simple (borradores, análisis, ficheros) se delegan a modelos más rápidos y baratos, es una decisión de diseño que afecta tanto al coste como al resultado final.

Las plataformas SaaS de orquestación ofrecen esta capacidad, pero a cambio de pérdida de control, dependencia de proveedor y envío de datos a intermediarios. Este sistema resuelve el mismo problema desde la infraestructura propia: cada CLI externo se expone como herramienta MCP, y Claude Code lo invoca igual que invoca `bash`.

---

## ¿Qué?

### Arquitectura: Control Plane / Data Plane

El sistema opera bajo una separación de responsabilidades clara:

- **Control Plane (Claude Code):** decide, planifica, delega y ensambla. Es la unidad de razonamiento.
- **Data Plane (Gemini, OpenCode):** ejecutan subproblemas acotados, producen artefactos y terminan sin estado persistente. No saben que están siendo orquestados.

```
Claude Code (orquestador)
    │
    ├── gemini_run / gemini_run_async / gemini_done
    │       └── gemini_mcp.py  ->  gemini CLI  ->  Google Gemini
    └── opencode_run / opencode_run_async / opencode_done
            └── opencode_mcp.py  ->  opencode-wrapper.sh  ->  z.ai / OpenCode
```

### El sistema de ficheros como bus de datos

El output de cada agente no es texto capturado de `stdout` — son ficheros escritos en un directorio de trabajo (`workdir`). El orquestador inspecciona los resultados con sus propias herramientas (`Read`, `Glob`, `Grep`).

Esto elimina la dependencia de flujos de texto volátiles (no estructurados, propensos a ANSI escapes, difíciles de validar) y permite verificación determinista sobre el artefacto final.

### Modos de invocación

Cada servidor expone tres herramientas:

| Herramienta | Modo | Comportamiento |
|---|---|---|
| `gemini_run` / `opencode_run` | Síncrono | Bloquea hasta terminar; escribe ficheros en workdir |
| `gemini_run_async` / `opencode_run_async` | Async | Devuelve `job_id` inmediatamente |
| `gemini_done` / `opencode_done` | Consulta | Devuelve `"pendiente"`, `"listo"` o `"error: ..."` |

Ambos servidores son estructuralmente idénticos — solo difieren en el binario que invocan. Los tokens de cada agente se imputan a su propio proveedor, no a Anthropic.

### Limitaciones actuales

| Limitación | Descripción |
|---|---|
| Persistencia volátil | `_jobs` vive en memoria del proceso MCP. Un reinicio de sesión pierde todos los job_ids activos. |
| Sin retry automático | Si un agente falla a mitad de tarea, no hay rollback ni reintento. El error se detecta pero la recuperación es manual. |
| Sin observabilidad | No hay logs estructurados del ciclo de vida de cada job. Diagnóstico limitado a `stderr` en modo sync y nada en async. |
| Aislamiento por convención | La seguridad depende de que el prompt especifique un `workdir` adecuado. No hay sandboxing real del proceso hijo. |

---

## ¿Para qué?

### Arbitraje de costos y especialización

Cada agente subordinado tiene un perfil distinto. En esta implementación:

| Agente | Rol | Velocidad |
|---|---|---|
| Gemini | Verificador / critic | ~30 segundos |
| OpenCode / GLM-5.1 | Generador / arquitecto | ~2-3 minutos |

Asignar tareas según el perfil — generación a OpenCode, verificación a Gemini, coordinación a Claude — optimiza tanto el tiempo como el coste total.

### Paralelismo real

El modo async permite lanzar varios agentes simultáneamente sobre subtareas independientes. En ese caso el tiempo total se aproxima al del agente más lento, no a la suma de todos. En flujos con dependencias secuenciales, no hay ganancia de tiempo.

### Extensibilidad sin dependencia de proveedor

El patrón "agente como herramienta" (wrapper Python + registro MCP) permite añadir cualquier CLI con modo no-interactivo sin modificar el orquestador. El contrato es mínimo: el agente recibe un `workdir` y un prompt, produce ficheros. Lo que hay dentro del agente es irrelevante para el sistema.

Frente a plataformas SaaS de orquestación: la ventaja no es tecnológica sino de control. Acceso total al filesystem, modelos intercambiables, sin datos enviados a intermediarios. La contrapartida es real: las plataformas cerradas incluyen observabilidad, retry logic y gestión de estado que aquí son responsabilidad del operador.

---

## ¿Cómo?

### Requisitos previos

- Claude Code instalado (`npm install -g @anthropic-ai/claude-code`)
- `gemini` CLI instalado y autenticado
- `opencode` CLI instalado y autenticado con z.ai (v1.14+ para modo no-interactivo)
- Python 3.x con `pip3` disponible

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

> **Por qué fichero temporal para el prompt:** pasar el prompt como argumento directo permite que backticks en el contenido (p.ej. código Markdown con triple-backtick) se interpreten como command substitution en bash. Escribir el prompt a fichero y leerlo con `$(cat "$1")` evita esa reinterpretación.

> **Por qué no redirigir stdout a fichero:** el output de opencode son los ficheros que crea o modifica en `cwd`. El MCP server descarta stdout — Claude inspeccionará los ficheros resultantes con sus propias herramientas.

#### `~/mcp-servers/opencode_mcp.py`

Sustituir la versión de Node en `NVM_NODE_BIN`.

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

# Verificar gemini: debe crear hola.txt en el workdir especificado
mkdir -p /tmp/gemini_test
cd /tmp/gemini_test && /home/manuel/.nvm/versions/node/vX.Y.Z/bin/gemini \
  -y --skip-trust \
  -p "Crea un fichero llamado hola.txt con el texto 'hola mundo'"
ls /tmp/gemini_test/   # debe mostrar hola.txt

# Verificar wrapper de opencode: debe crear ficheros en el workdir especificado
mkdir -p /tmp/opencode_test
echo "Crea un fichero llamado hola.txt con el texto 'hola mundo'" > /tmp/test_prompt.txt
cd /tmp/opencode_test && ~/mcp-servers/opencode-wrapper.sh /tmp/test_prompt.txt
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

Sin estos permisos, cada llamada a `gemini_run` o `opencode_run_async` interrumpe al usuario para pedir aprobación, lo que anula la ventaja del paradigma async.

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

Abrir una sesión (`claude`) y ejecutar estas tres pruebas en orden:

**Prueba 1 — OpenCode sync:**
```
usa opencode_run con prompt "Crea un fichero llamado hola.txt con el texto 'hola mundo'"
y workdir "/tmp/octest"
-> esperado: "listo"
-> verificar con Glob en /tmp/octest/ y Read /tmp/octest/hola.txt
```

**Prueba 2 — Gemini sync:**
```
usa gemini_run con prompt "Crea un fichero llamado resumen.md con un párrafo breve sobre Python"
y workdir "/tmp/gtest"
-> esperado: "listo"
-> verificar con Glob en /tmp/gtest/
```

**Prueba 3 — async (OpenCode):**
```
usa opencode_run_async con prompt "Crea un fichero poema.md con una poesía corta sobre el mar"
y workdir "/tmp/ocasync"
-> anotar job_id; seguir trabajando sin hacer poll
-> recoger con opencode_done(job_id) cuando convenga -> "listo"
-> verificar con Glob en /tmp/ocasync/
```

### Patrón de orquestación paralela

El caso de uso más potente: Claude diseña la estructura, delega secciones a cada agente en paralelo, y ensambla el resultado cuando todos terminan.

**Regla fundamental:** nunca enviar a dos agentes a escribir el mismo fichero en paralelo. El segundo sobreescribirá al primero. Cada agente escribe solo su propio artefacto; el orquestador hace el ensamblado final.

```
# 1. Claude crea la estructura con placeholders
Write("index.html")  # con <!-- GEMINI_SUMMARY --> y <!-- OPENCODE_SUMMARY -->

# 2. Delegar en paralelo
job_g = gemini_run_async(prompt="Crea gemini.html + gemini_summary.txt", workdir="/tmp/webtest")
job_o = opencode_run_async(prompt="Crea opencode.html + opencode_summary.txt", workdir="/tmp/webtest")

# 3. Mientras trabajan: Claude documenta, planifica, hace otras cosas.
#    No hacer poll ansioso. Recoger cuando convenga.

# 4. Recoger
gemini_done(job_g)   # -> "listo"
opencode_done(job_o) # -> "listo"

# 5. Ensamblar
Read("gemini_summary.txt") -> texto
Read("opencode_summary.txt") -> texto
Edit("index.html")  # sustituir placeholders por los textos reales
```

---

## Diagnóstico de problemas frecuentes

### `Failed to connect` en `claude mcp list`

El script Python falla al arrancar. Ejecutar directamente:

```bash
python3 ~/mcp-servers/gemini_mcp.py
# Si se queda colgado sin error: correcto (espera mensajes MCP por stdin)
# Si muestra error: corregir antes de registrar
```

### Timeout en `gemini_run` o `opencode_run`

Causas más comunes:

- **PATH incorrecto:** Claude Code no hereda el PATH del shell. Usar ruta absoluta al binario (ya está en los scripts).
- **Modelo no disponible en OpenCode:** verificar con `opencode models` y actualizar el wrapper.
- **opencode no autenticado:** ejecutar `opencode` en TUI y configurar el proveedor z.ai.

### OpenCode no crea ficheros en workdir

```bash
chmod +x ~/mcp-servers/opencode-wrapper.sh

# Probar el wrapper directamente
mkdir -p /tmp/oc_test
echo "Crea un fichero llamado resultado.txt con el texto 'prueba ok'" > /tmp/test_prompt.txt
cd /tmp/oc_test && ~/mcp-servers/opencode-wrapper.sh /tmp/test_prompt.txt
ls /tmp/oc_test/
```

Si no crea ficheros, el problema es el modelo o la autenticación con z.ai.

### `error: job_id 'xxx' no encontrado`

El dict `_jobs` es efímero: vive solo mientras el proceso MCP server está activo. Si Claude Code se reinició entre el `_run_async` y el `_done`, el job_id se perdió. Lanzar y recoger resultados dentro de la misma sesión.

### `_done` cuelga indefinidamente

Causa: el proceso lanzado con `Popen` hereda el stdin del servidor MCP (el pipe JSON-RPC entre Claude Code y el servidor). El CLI hijo mantiene ese fd abierto e interfiere con los mensajes siguientes.

Solución: `stdin=subprocess.DEVNULL` en todos los `Popen` y `subprocess.run`. Ya está incluido en los scripts de esta guía.

### `_done` devuelve `"pendiente"` indefinidamente

El proceso background colgó:

```bash
ps aux | grep gemini   # o grep opencode
# Si hay proceso activo: aún está trabajando (normal en opencode ~2-3 min)
# Si no hay proceso: murió sin actualizar _jobs -> reiniciar Claude Code
```

---

## ¿Y ahora qué? — Incorporar nuevos agentes

El patrón "agente como herramienta" es extensible a cualquier CLI con modo no-interactivo.

**Paso 1 — Verificar modo no-interactivo:**
```bash
nuevo-cli --help | grep -i "prompt\|non-interactive\|headless"
nuevo-cli -p "responde solo: ok"
```

**Paso 2 — Verificar comportamiento de stdout:**
```bash
python3 -c "
import subprocess
r = subprocess.run(['nuevo-cli', '-p', 'ok'], capture_output=True, text=True, timeout=60)
print('STDOUT:', repr(r.stdout[:100]))
print('STDERR:', repr(r.stderr[:100]))
"
```

Si stdout está vacío, el CLI escribe a TTY y necesita wrapper con `unbuffer`.
Si stdout tiene ANSI escapes, añadir `sed` de limpieza.

**Paso 3 — Crear el MCP server:**

Copiar `gemini_mcp.py` como plantilla y cambiar:
- Nombre del servidor: `Server("nuevo-agente")`
- Nombres de herramientas: `nuevo_agente_run`, `nuevo_agente_run_async`, `nuevo_agente_done`
- Comando del subprocess y flags necesarios

**Paso 4 — Registrar y añadir permiso:**
```bash
claude mcp add nuevo-agente --scope user \
  -- python3 /home/manuel/mcp-servers/nuevo_agente_mcp.py
```

Añadir `"mcp__nuevo-agente__*"` al array `allow` en `~/.claude/settings.json`.
