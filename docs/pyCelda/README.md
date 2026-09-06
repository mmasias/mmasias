# Auditoria de pyCelda

Fecha de corte: 2026-09-07 (ultimo push a GitHub: 2026-09-06 21:07 UTC). Fuente: arbol de trabajo local de `main` (sincronizado), historial git completo (todas las ramas), API de GitHub (issues, PRs, discussions) y lectura dirigida de artefactos. Ningun fichero del repo fue modificado; esta carpeta es nueva y queda sin trackear.

**Nota de edicion para publicacion:** el servicio se referencia como "dominio de acceso publico", sin identificarlo. El dominio de negocio se presenta en vocabulario de gestion empresarial y los identificadores internos (entidades, casos de uso, ficheros, titulos de issues) aparecen traducidos de forma consistente a ese mismo vocabulario: Documento (ciclo de vida), Especialista, DirectorPrograma, Organizacion, Division, Programa, Modulo, Actividad, ActividadPrograma, ReferenciaDocumental, ActividadOperativa, periodo operativo. Todas las cifras, fechas, volumenes y estructuras corresponden literalmente al repositorio.

## Indice

| Fichero | Contenido |
|---|---|
| [01-identidad.md](01-identidad.md) | Que es: producto, dominio de negocio, doble naturaleza (sistema + experimento de desarrollo con agentes LLM) |
| [02-inventario.md](02-inventario.md) | Que tiene: inventario tecnico verificado con metricas (backend, frontend, RUP, docs, tests, infraestructura) |
| [03-tiempo.md](03-tiempo.md) | Tiempo usado: calendario, ritmo, maquinas, la medicion interna de tiempo por disciplina (discussion #92) |
| [04-camino.md](04-camino.md) | Camino hecho: linea temporal por hitos, de las 3,5 semanas sin codigo a la produccion con 108 documentos reales |
| [05-github.md](05-github.md) | Issues, PRs y discussions: numerica, tematica, estado actual y salud del tracker |
| [06-hallazgos.md](06-hallazgos.md) | Hallazgos de la auditoria: discrepancias detectadas, higiene, riesgos y puntos fuertes verificados |

## Resumen ejecutivo

pyCelda es un sistema de gestion del ciclo de vida de documentos de gestion empresarial (`Borrador -> En Revision -> Aprobada`), con catalogo institucional (organizacion, divisiones, programas, modulos, actividades y plantilla de personas), planificacion de operaciones por sesiones, ponderaciones, referencias documentales, actividades operativas y generacion del PDF oficial de cada documento con la plantilla de la organizacion. No es un prototipo: esta desplegado en produccion propia (Docker + Caddy + Let's Encrypt sobre una maquina de sobremesa, bajo un dominio de acceso publico) y en uso con 108 documentos reales de dos programas (55 del Programa A + 53 del Programa B).

Es ademas el objeto de un experimento de desarrollo conducido por agentes LLM: Claude Sonnet 5 como gestor/orquestador y verificador, agentes delegados (OpenCode/Z.AI GLM, Kiro, Gemini) como constructores de volumen. Toda la trazabilidad de quien hizo que vive en las etiquetas de GitHub (`agente:llm`, `agente:humano`), no en `git blame`, porque todos los commits firman como el usuario.

Cifras de corte (7-sep-2026):

- 38 dias de calendario desde la creacion del repo (31-jul) hasta el ultimo push (6-sep); 30 dias con commits.
- 545 commits alcanzables (303 en first-parent de `main`), 137 PRs (todos merged, ninguno abierto ni descartado), 56 issues (46 cerrados, 10 abiertos), 80 discussions: 273 elementos numerados en GitHub.
- 9 tags: `stable-primer-despliegue-produccion` + `v0.1.0` a `v0.8.0` (21-ago a 6-sep).
- Backend FastAPI: 20 modelos SQLAlchemy, 126 endpoints, 17 repositorios, 17 schemas Pydantic, 28 scripts de datos. 11.619 LoC Python en `app/`.
- Frontend React 19 + TypeScript + Vite: 84 paginas + 4 componentes, sin librerias de UI ni de estado. 12.483 LoC TS/TSX.
- Tests: 85 ficheros pytest de integracion, 557 funciones `def test_`, 11.118 LoC. Sin suite de frontend.
- RUP: 402 ficheros Markdown (25.362 lineas) + 411 PlantUML + 454 SVG. Catalogo de 102 casos de uso (deduplicado), 93 con Analisis + Diseno + Desarrollo; los 9 pendientes son todos de `Admin`, despriorizados a proposito.
- Ratio documentacion RUP / codigo funcional: ~1,05:1. Ratio test/codigo backend: ~0,96:1.
