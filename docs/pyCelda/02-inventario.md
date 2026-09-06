# 02 - Inventario: que tiene el repo

Metricas verificadas por conteo directo sobre el arbol de trabajo (excluidos `node_modules/`, `dist/`, `.git/`, `__pycache__/`, `.venv/`, `.pytest_cache/`). Tamaño del repo en GitHub: ~12,2 MB. Los nombres de entidades y ficheros se citan traducidos al vocabulario de la nota de edicion del indice.

## Estructura raiz

```
backend/    aplicacion FastAPI (Python 3.11+, gestion uv) + tests + Dockerfile
frontend/   SPA React 19 + TypeScript + Vite
RUP/        documentacion de proceso por fases (00-04 + 99-seguimiento)
docs/       corpus de referencia, wireframes, plantilla, auditorias, scripts
images/     SVGs renderizados de la RUP (espejo de RUP/) + logo
.claude/    settings.local.json (permisos de herramientas; sin CLAUDE.md en repo)
.githooks/  commit-msg + pre-push (exigen seccion "Deploy:" al tocar produccion)
deploy.sh, DEPLOY.md, docker-compose.yml, Dockerfile.caddy, Caddyfile
README.md, RESUMEN.md, pycelda.db (residuo, gitignored)
```

## Backend (`backend/`)

Stack (segun `pyproject.toml`): FastAPI >= 0.115, SQLAlchemy >= 2.0, Pydantic v2, Authlib (OAuth contra proveedor externo), itsdangerous, Jinja2, WeasyPrint >= 63 (PDF). Dev: pytest, httpx, openpyxl. Contenedor: `python:3.12-slim` + libpango para WeasyPrint, uvicorn en :8000.

| Elemento | Cantidad | Detalle |
|---|---:|---|
| Ficheros .py en `app/` | 111 | 11.619 LoC |
| Modelos SQLAlchemy | 20 | Organizacion, Division, Programa, Actividad, ActividadPrograma, Modulo, Especialista, DirectorPrograma, Documento, Ponderacion, SistemaDeControl, ResultadoEsperado, Metodologia, MetodologiaModulo, ReferenciaDocumental, Sesion, HistorialCambio, ActividadOperativa, ActividadOperativaModulo, ActividadOperativaActividadPrograma + tabla asociativa documentos-especialistas |
| Routers | 16 | todos con prefijo `/api/v1`; el mayor: `documento.py` (12 endpoints, 519 lineas) |
| Endpoints | 126 | 63 GET, 29 POST, 19 PUT, 14 DELETE + `GET /api/health` en `main.py` |
| Repositorios | 17 | acceso a datos puro con eager loading explicito |
| Schemas Pydantic | 17 | Request/Response por endpoint |
| Scripts de datos | 28 | 14 `migrar_*` + 14 seed/cargar/backfill, cada uno con test espejo |
| Modulos core | 4 | database, config (Settings), auth (OAuth+JWT, 181 lineas), render/documento (HTML Jinja2 + PDF WeasyPrint, 264 lineas) |

**Estilo arquitectonico: Fat Model, thin controller, sin capa de servicios.** Decision explicita documentada en tres sitios (RUP/03-diseno/README.md, docs/2Think/MVCHowTo.md, RESUMEN.md) y verificable en el codigo: la logica de dominio vive en los modelos (`models/documento.py`: `bloqueo_ponderaciones()`, `sincronizar_*()`, `aprobar()/rechazar()/escalar...()`, regla c3 de planificacion minima), los repositorios solo persisten y los routers orquestan auth + serializacion. Patrones transversales: comentarios con trazabilidad densa a issues/discussions/PRs, y politica de autorizacion 404-uniforme (recurso ajeno -> 404, no 403) con una unica relajacion documentada (importacion entre documentos hermanos de operaciones hermanas, #184).

## Frontend (`frontend/src/`)

Stack: React 19.2, react-router-dom 7.18, Vite 8.2, TypeScript 7.0. **Sin librerias de UI, de estado ni de data-fetch** (fetch nativo con `credentials: "include"`, CSS propio).

| Elemento | Cantidad |
|---|---:|
| Paginas `.tsx` (`pages/`) | 84, una por caso de uso, nombres espejo del catalogo RUP (`AbrirDocumento.tsx`, `ImportarReferenciasDeDocumentoHermano.tsx`...) |
| Componentes (`components/`) | 4 (`LeyendaSesiones`, `ListaDocumentosDelPrograma` con prop modo Admin/Director, `NavPrograma`, `RequireSession`) |
| Utilidades `.ts` | 5 (`api.ts` cliente HTTP central, fecha, listaTrabajo, referenciaDocumental, sesionTipo) |
| LoC TS/TSX | 12.483 |

## RUP/ (la columna vertebral documental)

| Fase | .md | .puml | Contenido |
|---|---:|---:|---|
| 00-modelo-del-dominio | 1 | 3 | modelo completo + simplificado + maquina de estados del Documento (11 transiciones); README con decisiones de modelado |
| 01-requisitos | 106 | 214 | actores/CU (diagramas de contexto por actor) + detalle de 105 carpetas de CU: `especificacion.puml` (statechart) + `wireframes.puml` (Salt) + README |
| 02-analisis | 97 | 96 | por CU: diagrama de colaboracion (B/C/E) + README; diagrama de clases de analisis consolidado |
| 03-diseno | 100 | 97 | por CU: diagrama de secuencia (MVC) + README con bloque de decisiones; configuracion-proyecto.md; diagrama de clases de diseno; modelo-datos/ (DER + diccionario) |
| 04-desarrollo | 97 | 0 | por CU: ficha que enlaza al codigo real (router/repositorio/modelo/schema/tests/UI) + contrato de endpoint JSON + campo Estado |
| 99-seguimiento | 1 | 1 | dashboard por actor coloreado por fase RUP alcanzada, enlazado a cada especificacion |

- Total: 402 Markdown (25.362 lineas) + 411 PlantUML; los 454 SVG renderizados viven en `images/RUP/` (los SVG de `RUP/` estan gitignored).
- **Catalogo: 102 casos de uso deduplicados** (cuenta una vez los compartidos por herencia de actores), completo en Requisitos. Organizacion bottom-up por capas de dependencia del dominio L0-L10 (14+16+7+10+12+5+7+2+11+12+6), no por familia de actor. Evolucion del catalogo: 91 originales -> 95 (Planificacion/Sesion, #140) -> 96 (previsualizarDocumento, #218) -> 99 (ActividadOperativa, #227) -> 101 (importacion entre operaciones hermanas, #184) -> 102 (generarPlanificacionGenerica, #272). Las 3 carpetas extra de detalle son primitivas de navegacion fuera de catalogo (iniciarSesion, cerrarSesion, abrirPanelAdministracion).
- 93/102 con Analisis + Diseno + Desarrollo; los 9 pendientes son todos de Admin (periodo operativo x5, activarSemestre, eliminarModulo, generarDocumentosPDF, reabrirDocumentoPorIncidencia), despriorizados a proposito.

## docs/

- **Corpus de referencia**: planes de programa (PDF/XLSX/MD), dossieres de tres programas, documentos reales en PDF, `guionEventos.txt` (guion original de partida).
- **PROPUESTA_WIREFRAME/**: mockup navegable de 139 Markdown (Admin 59 paginas, DirectorPrograma 43, Especialista 16), generado por script desde los diagramas de contexto.
- **PROPUESTA_PLANTILLA/**: formulario oficial .docx y plantilla PDF del documento de la organizacion (fuente del render de produccion).
- **AUDITORIAS/**: 23 Markdown. 8 aspectos (Mecanica, Ausencia, Logica, Metricas, Cualitativa, Redundancia, Trazabilidad, Aportaciones) auditados dos veces de forma independiente (Claude Sonnet 5 y glm-5.2) sobre el catalogo de 91 CU en el commit `f1f71b2` (2026-08-08), con tabla comparativa que expone discrepancias sin arbitrarlas.
- **scripts/**: `extractor.py` (seed JSON desde los .docx del corpus), `generar_mockup_navegable.py`, `verificar_contextual_labels.py` (anti-deriva del diccionario de botones).
- **2Think/**: `MVCHowTo.md`, nota teorica que justifica el Fat Model.

## Tests (`backend/tests/`)

- pytest + TestClient de FastAPI: **tests de integracion contra la API real, no tests de dominio puro** (decision explicita, discussion #57).
- 85 ficheros (83 `test_*.py` + conftest + init), **557 funciones `def test_`**, 11.118 LoC. Un fichero por caso de uso o script de migracion, nombres espejo del catalogo RUP.
- `conftest.py` (346 lineas): SQLite en memoria por test, override de dependencias, fixture que ejercita el mecanismo OAuth/JWT real, fixtures de dominio encadenadas (programa -> modulo -> actividad de programa -> documento vinculado) y un segundo director de programa explicito para probar IDOR.
- Sin suite de frontend (ningun framework de test JS en package.json).

## Infraestructura y despliegue

- `docker-compose.yml`: 2 servicios (backend con volumen nombrado `pycelda-db` en /data; caddy multi-stage que compila Vite con node:22 y sirve estaticos con caddy:2-alpine).
- `Caddyfile`: dominio de acceso publico propio, TLS automatico, `/api/*` y `/auth/*` al backend, SPA-fallback y `Cache-Control: no-store`.
- `deploy.sh` (123 lineas): pull ff-only, build, down/up, health-check contra produccion (10 intentos) y **chequeo de bundle** (si el rango toco frontend/, verifica que el hash del asset JS servido cambio). Registra el commit desplegado en `.deployed-commit`.
- `.githooks/`: commit-msg + pre-push exigen seccion `Deploy:` en commits que tocan produccion (el pre-push cubre el hueco de que `git revert` no invoca commit-msg).
- `DEPLOY.md`: protocolo con 3 roles de agente y 5 reglas, incluyendo documentacion de bugs reales de infraestructura (PYTHONPATH, volumenes huerfanos).
- Politica de backups: issue #185 cerrado (copias diarias automaticas); en el arbol quedan 3 snapshots manuales `pycelda.db.bak.*` en backend/ (gitignored) y un `pycelda.db` residual en raiz.

## Metricas agregadas

| Ambito | LoC |
|---|---:|
| Python backend/app | 11.619 |
| Python backend/tests | 11.118 |
| TS/TSX frontend/src | 12.483 |
| Markdown RUP/ | 25.362 |

Ratio documentacion RUP / codigo funcional: ~1,05:1 (25.362 vs 24.102). Ratio test/codigo en backend: ~0,96:1. Ficheros: 199 .py, 96 .tsx, 6 .ts, 563 .md, 411 .puml, 455 .svg.
