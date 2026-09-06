# 04 - Camino hecho

Linea temporal reconstruida del historial git (545 commits), PRs, discussions, issues y tags. El camino es deliberadamente no-lineal: hay retrocesos puntuales a fases anteriores documentados como tales, y el orden de construccion fue por capas de dependencia del dominio (L0-L10), no por fases globales ni por actor. Identificadores traducidos segun la nota de edicion del indice.

## Fase 0 - Modelo del dominio (31-jul -> 2-ago, 3 dias, 49 eventos)

Partida: `docs/guionEventos.txt` (guion en prosa del flujo completo) y corpus real (planes de programa, documentos reales). Iteracion rapida de refinado del modelo PlantUML (composiciones, cascadas, terminologia del formulario oficial vs el sistema). Decisiones clave cerradas por issues: semantica de `HistorialCambio` (#1, #2), `Metodologia` como composicion y catalogo de la organizacion (#4), asignacion anual historica Especialista--Documento (#13). El 2-ago aparece el extractor de documentos reales y el seed inicial: el dominio se valida contra el corpus desde el primer dia.

## Fase 1 - Requisitos puros (3 -> 8-ago, 6 dias, 41% de todos los eventos del primer mes)

- Actores y casos de uso (diagramas de contexto por actor) y despues detalle CU por lotes de capa L1 -> L9, con un patron repetido: discussion de "cierre antes de especificar" por lote (#15, #18, #27, #33, #38, #44) e issue de revision por capa (#16, #21, #24, #28, #31, #34, #36, #40, #45).
- Formato de especificacion debatido turno a turno con el humano (#9) -> criterio permanente. Wireframes Salt en cada CU, con migracion al patron de tabla (#25) e incorporacion de datos reales como ejemplos (#23, #39).
- Primitivas de navegacion formalizadas como CU (#42, #48-#51: iniciarSesion por actor, variantes filtradas por especialista).
- **8-ago: cierre del catalogo original 91/91** e inmediatamente **auditorias duales** (8 aspectos x Claude Sonnet 5 y glm-5.2 sobre el mismo commit `f1f71b2`) + generacion del mockup navegable de 139 paginas (#43) y su auditoria de disenador (#52).
- Retroceso detectado y asumido: el propio proyecto llama a este periodo "3,5 semanas de definicion pura, 151 commits, cero codigo" (incluye la fase 0 y el interludio).

## Interludio (9-16 ago, 8 dias sin commits)

Pausa de calendario tras cerrar Requisitos. A la vuelta, lo primero es planificar Analisis y detectar huecos de Requisitos: sesion de cierre de huecos auditada externamente (#53) y transferencia del criterio de Analisis desde pySigHor (#54).

## Fase 2 - La rebanada vertical de calibracion (17-18 ago)

Arranque de Analisis con una rebanada vertical del Documento que empieza en 4 CU, crece a 7 y se queda en 9, con un **sobrediseno detectado a tiempo** (bitacora #57). Criterio de artefactos heredado de pySigHor (#54); patron de Diseno fastapi-react heredado tambien (#58). El 18-ago la rebanada cruza Analisis -> Diseno -> Desarrollo en un solo dia (#59, #60, #61), con validacion end-to-end. Aqui se decide el Fat Model (justificado en docs/2Think/MVCHowTo.md).

## Fase 3 - Construccion delegada a escala (18 -> 21-ago)

- **Primera delegacion grande**: Diseno de los 21 CU restantes de DirectorPrograma (L2-L6) a OpenCode, verificado por Claude y contrastado con pySigHor (#73); despues la primera delegacion de Desarrollo (#77) tras debatir si delegarlo (#76).
- Auditoria de cada PR por un revisor independiente (#69, #71, #75) antes del OK de Manuel: el flujo "escritor escribe -> orquestador verifica" queda instaurado.
- Cierre de UI completa de DirectorPrograma: 28 CU (#90, v0.2.0 el 23-ago).

## Fase 4 - Produccion (19-20 ago, en paralelo)

Primer despliegue real: decision de infraestructura debatida (#79, #80), protocolo de despliegue commit-driven cerrado con los tres nodos de agente (#83, criterio permanente). Tag `stable-primer-despliegue-produccion` (20-ago). Login real con el proveedor externo (#62) y su UI de prueba end-to-end, que encontro tres bugs reales (#64). Documentacion de incidentes de infraestructura en DEPLOY.md. Bug de Cache-Control del frontend (#105).

## Fase 5 - Autoria del Especialista y seguridad (21 -> 23-ago)

UI de autoria del Especialista (v0.3.0). **Auditoria IDOR**: issue #96 (endpoints del Especialista sin verificacion de pertenencia, 2 sin autenticacion) corregido; bitacora #101. El checklist transversal de autorizacion nace aqui y cazara despues el IDOR de body (#210).

## Fase 6 - Datos reales y Admin bottom-up (23 -> 26-ago)

- Seed del Programa A cruzando dossier interno vs documentos 2025 (#94); despues el Programa B. Resultado: 108 documentos reales en produccion.
- Reajuste de hoja de ruta (#65): Admin se puebla por SQL en bloque; orden Especialista/DirectorPrograma -> despliegue -> PDFs.
- **Bloque Admin bottom-up L0-L1 cerrado de punta a punta** (24-25 ago, bitacoras #128 y #139, v0.4.0 el 25-ago): scripts de soporte previos a la existencia de la UI (#114), checklist manual de pruebas (#131).
- **Segunda auditoria IDOR**: #86, 44 puntos de endpoints de DirectorPrograma sin verificar que el director dirige el recurso; cerrado con bitacora de convencion de malla por maquina (#130).

## Fase 7 - Planificacion de operaciones y consolidacion (29-ago -> 1-sep)

- Nuevo requerimiento post-cierre: el cronograma de sesiones (#140), construido desde #199 y renombrado completo a Planificacion (#198) con un nuevo tipo de sesion combinado.
- Importacion de planificaciones reales, piloto: 5 operaciones del primer ciclo del Programa A (#200, #201).
- Modelo de datos formal en RUP/03-diseno: DER + diccionario (#196, #197).
- **Caso de metodo**: condiciones de envio del documento (#206) ejecutadas en 3 bloques (medidor de completitud #207, fix aditivo #209, regla c3 #211) y la **retrospectiva #213**: la consolidacion de RUP se trato como opcional y desenredarlo costo 4 rondas -> nace el checkpoint "documentacion antes que codigo". La deriva abrio el issue #212 (consolidar RUP de abrirDocumento/abrirPonderaciones).
- Bugs de sincronizacion e integridad cazados por el checklist: #208, #210 (sincronizar_* fuera de alcance), #212. En produccion: Programa B duplicado por falta de unicidad de `Programa.codigo` (#148). v0.5.0 el 26-ago y v0.6.0 el 30-ago.

## Fase 8 - El PDF oficial y ActividadOperativa (2 -> 5-sep)

- **Render del documento en dos versiones**: v1 motor de render + vista HTML + materializacion de resultados esperados (#218, PR #221); v2 maquetacion al formulario oficial de la organizacion (diagnostico de encaje #217) + PDF real (#224, PR #225). Incluye perf: minificado del logo SVG inline (#223 -> PR #245).
- **Cluster ActividadOperativa** (nuevo requerimiento #227): reparto de horas por actividad operativa en Modulo/ActividadPrograma + medidor de consistencia. Ejecutado como pipeline de 3 PRs (#229 estructura + captura, #231 fix runbook, #232 medidor + render), en produccion.
- **Deuda tecnica estructural**: FK ausente `ActividadPrograma -> Actividad` pese a estar en el modelo de dominio desde el inicio (#181, PR #250) y, encima, la feature de importacion entre documentos hermanos de operaciones hermanas que dependia de ella (#184, PR #251) con las 2 CU nuevas (catalogo 99 -> 101).
- v0.7.0 (5-sep) + "tanda de 8 issues tecnicos" (#246): unicidad de codigo de programa (#148 -> PR #242), enum de tipo de referencia documental (#226 -> PR #243), mensajes de bloqueo con nombres reales (#179 -> PR #244), idempotencia del seed (#187 -> PR #241), seed dentro del paquete backend (#202 -> PR #240).

## Fase 9 - Iteracion fina sobre el PDF y cierre (6-sep)

Un solo dia, 16 commits first-parent, 7 PRs merged: equipo del documento re-derivado al aprobar (#254), requisitos previos de la actividad como campo de texto (#259/#261), previsualizarDocumento gana Admin + pantalla de monitoreo de estado del periodo para Admin (#262, PRs #263/#264, con hallazgo derivado #265), redondeo del medidor (#237), y la ronda de PDF: saltos de pagina (#268 -> PR #269), parrafo institucional de trazabilidad de autoria (#270 -> PR #271), colores por tipo de sesion (#266 -> PR #267), y `generarPlanificacionGenerica()` (#272 -> PR #273, catalogo 102). v0.8.0.

## El patron del camino

1. **Definir antes de construir** y validar el dominio contra datos reales desde el dia 2 (extractor + seed).
2. **Cierre antes de especificar**: cada decision costosa se debate y cierra en artefacto barato (discussion) antes del artefacto caro.
3. **Pipeline vertical por CU**: cada rebanada atraviesa Analisis/Diseno/Desarrollo en el mismo PR, nunca olas de fase.
4. **Delegacion con verificacion**: escritor subordinado + re-ejecucion en clon + auditor independiente + OK humano para merge.
5. **Retrocesos documentados**: #72 (vuelta puntual a Requisitos), #191 (retroceso a Modelo del Dominio para `Documento.contenido`), #212 (deriva RUP), todos asumidos como parte del metodo, no como fallos.
6. **El catalogo crecio por requerimientos posteriores al cierre** (+11 CU) y el proceso los absorbio con el mismo ciclo completo por CU.
