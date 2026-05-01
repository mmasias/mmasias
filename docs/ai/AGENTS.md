# Perfil de agentes subordinados

Resultados de la entrevista de selección ejecutada el 2026-05-01.
Protocolo: `ClaudeMCP_Entrevista.md`. Orquestador: Claude Code (claude-sonnet-4-6).

---

## Gemini CLI (Google Gemini)

**Herramienta MCP:** `gemini_ask` / `gemini_ask_async`
**Rol asignado:** Verificador / Critic

### Evidencia de la entrevista

| Pregunta | Respuesta resumida | Observacion |
|---|---|---|
| Bug Java | `items` no inicializado -> NPE | Correcto, directo |
| Estructura de datos | Trie, O(L) independiente del vocabulario | Correcto, justificacion minima |
| Resumen HTTP/2 | 3 bullets precisos | Bien delimitado |
| Sesgo elegante vs conservador | Conservador; un solo ejemplo (no contrasta) | Respuesta corta |
| Spec ambigua | Pide aclaraciones: TPS, latencia, proveedores, idempotencia | Sistematico |
| HashMap global | Ataca: sin eviction, consistencia, concurrencia | Correcto, sin proponer alternativas |

### Perfil observado

- Respuestas cortas y directas.
- Correcto en todos los items tecnicos.
- No elabora mas alla de lo preguntado.
- No propone alternativas salvo que se le pida explicitamente.
- Sesgo conservador confirmado.

### Uso recomendado

- Verificar corrección de código o lógica.
- Detectar bugs, inconsistencias, casos borde.
- Revisar especificaciones en busca de ambigüedades o riesgos.
- Segunda opinión rápida sobre una decisión técnica.
- No adecuado para generación de diseño o exploración de alternativas.

---

## OpenCode / GLM-5.1 (z.ai)

**Herramienta MCP:** `opencode_ask` / `opencode_ask_async`
**Rol asignado:** Generador / Architect

### Evidencia de la entrevista

| Pregunta | Respuesta resumida | Observacion |
|---|---|---|
| Bug Java | NPE por `items` null; incluye solucion | Correcto, propositivo |
| Estructura de datos | Trie; descarta HashMap y BST con razonamiento | Mas completo que Gemini |
| Resumen HTTP/2 | 3 bullets equivalentes | Correcto |
| Sesgo elegante vs conservador | Conservador; da AMBOS ejemplos y explica fallo del elegante | Elaborado, didáctico |
| Spec ambigua | Pide aclaraciones; especifica qué asume | Mas preguntas, mayor cobertura |
| HashMap global | Ataca: OOM, obsolescencia, thread-safety, observabilidad; propone Caffeine/Guava | Exhaustivo y propositivo |

### Perfil observado

- Respuestas mas largas con contexto y comparativas.
- Tiende a cubrir casos que no se le preguntaron explicitamente.
- Propone alternativas concretas (librerias, patrones).
- Sesgo conservador, pero con mayor disposicion a elaborar el contraste.

### Uso recomendado

- Generar borradores de diseño o arquitectura.
- Explorar alternativas de implementacion.
- Documentar decisiones tecnicas con justificacion.
- Desarrollar ejemplos pedagogicos con contraste explicito.
- No adecuado como verificador rapido: sus respuestas tienen más ruido.

---

## Notas operativas

### Bug conocido en el wrapper de OpenCode

El script `opencode-wrapper.sh` pasa el prompt como `"$1"` en bash.
Los triple-backtick de Markdown dentro del prompt se interpretan como command substitution.
Workaround: evitar backticks en prompts enviados a OpenCode via MCP. Usar indentacion o comillas simples para bloques de codigo.

### Latencia observada

- OpenCode: ~2-3 minutos para prompts de 6 preguntas complejas.
- Gemini: ~30-60 segundos para el mismo prompt.

---

## Estado del sistema

| Agente | CLI | Proveedor | Rol asignado | Fecha |
|---|---|---|---|---|
| gemini_ask | gemini CLI | Google Gemini | Verificador / Critic | 2026-05-01 |
| opencode_ask | opencode CLI | z.ai / GLM-5.1 | Generador / Architect | 2026-05-01 |
