# 01 - Identidad: que es pyCelda

## El nombre y la definicion

pyCelda es un sistema web para gestionar el ciclo de vida completo de documentos de gestion empresarial: `Borrador -> En Revision -> Aprobada`, con reapertura por incidencia o revocacion, planificacion de operaciones por sesiones, ponderaciones, referencias documentales y generacion del PDF oficial de cada documento con la plantilla de la organizacion.

Dominio de negocio modelado (3 roles):

- **Especialista**: redacta los apartados de sus documentos (contenido, referencias, planificacion de operaciones, ponderaciones), los envia a revision y descarga/previsualiza el PDF.
- **Director**: mantiene el catalogo de su programa (modulos, resultados esperados, actividades del programa, asociaciones con metodologias y actividades operativas), revisa, aprueba, rechaza o escala documentos, y consulta el estado del periodo.
- **Admin**: mantiene el catalogo institucional (organizacion, divisiones, programas, actividades, metodologias, sistemas de control, plantilla de personas, direccion de programa, periodo operativo) y genera/regenera los PDF.

Acceso con cuenta corporativa (OAuth2/OIDC contra proveedor externo, dominio de correo restringido, sin auto-registro), JWT en cookie httpOnly.

## Estado: sistema en produccion real

No es un ejercicio de laboratorio. Verificado en el arbol y en la documentacion de despliegue:

- Desplegado en una maquina de sobremesa propia (Prometeus) con Docker Compose (backend FastAPI + Caddy), TLS de Let's Encrypt, DNS resuelto en el router y un dominio de acceso publico propio.
- Base de datos SQLite en volumen Docker (`pycelda-db`) con **108 documentos reales** importados de las planillas Excel de la organizacion: 55 del Programa A y 53 del Programa B.
- Protocolo de despliegue documentado y automatizado (`DEPLOY.md`, `deploy.sh`, githooks que exigen seccion `Deploy:` en los commits que tocan produccion), con health-check real y verificacion de bundle del frontend en cada despliegue.

## Doble naturaleza: sistema y experimento

El repo es a la vez un producto y el objeto/documento de un experimento de ingenieria de software con agentes LLM, descrito en `RESUMEN.md` y materializado en la propia historia del repo:

- **Tres roles de agente**, todos Claude Sonnet 5 diferenciados por sesion y prompt: gestor (disena, revisa cada entrega de forma independiente, aprueba merges, coordina despliegues), developer (con agentes delegados via CORRAL/MCP: Z.AI GLM en OpenCode para el volumen mecanico, Kiro, y Gemini, descrito como "una decepcion"), y despliegue (aplica produccion siguiendo el ritual).
- **Regla de reparto**: Claude orquesta y verifica; el becario delegado escribe el volumen; Claude consolida y comprueba linea a linea. Cada entrega del constructor se re-ejecuta en un clon dedicado (tests, compilacion, render), nunca se acepta el resumen del agente autor.
- **Trazabilidad de autoria**: todos los commits firman `manuel@<maquina>`; la autoria real (humano vs LLM) se rastrea con las etiquetas `agente:humano` / `agente:llm` de issues y discussions.
- **Malla multi-sesion**: sesiones en tres maquinas (dos en casa, una en el despacho), sin memoria nativa entre sesiones; la continuidad la sostienen el `conversation-log` (60 conversaciones registradas, externo al repo) y ficheros de memoria versionados fuera del repo.
- **El proceso se audita a si mismo**: auditorias externas duales (Claude y glm-5.2 sobre el mismo commit, comparadas sin arbitrar), retrospectivas formales que cambian el metodo (p. ej. #213), y metricas del propio proceso (#92).

## Origen

El punto de partida conservado en `docs/guionEventos.txt`: un guion en prosa de como "deben haber elementos configurados" antes de que todo empiece (alta de divisiones, programas, especialistas y metodologias M1-M7 del catalogo, modulos y resultados esperados por programa, equipo por cada actividad del programa, periodo operativo, flujo de revision/aprobacion, notificacion al admin y generacion de PDFs). Ese guion se convirtio primero en modelo del dominio PlantUML (31-jul -> 2-ago) y despues en catalogo de casos de uso; el corpus de apoyo (planes de programa en PDF/XLSX, dossieres de tres programas, documentos reales de los que se extrajo el seed) vive en `docs/`.

Relacion con otros proyectos del autor: el criterio de Analisis se transfirio explicitamente de pySigHor (discussion #54) y el patron de Diseno (fastapi-react) tambien fue heredado de pySigHor (#58); un Agente maestro externo (`bundungun`, "consejo de sabios") aparece en el contexto global de trabajo como herramienta de contraste.
