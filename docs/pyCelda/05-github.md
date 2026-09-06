# 05 - GitHub: issues, PRs y discussions

Estado a 7-sep-2026 (ultimo push 6-sep 21:07 UTC). Repo privado (`mmasias/pyCelda`), 0 stars/forks (privado, uso personal). Total de elementos numerados: **273** = 56 issues + 137 PRs + 80 discussions. Titulos de issues paráfraseados con el vocabulario de la nota de edicion; numeros literales.

## Numerica global

| Tipo | Total | Abiertos | Cerrados/Merged | Observacion |
|---|---:|---:|---|---|
| Issues | 56 | 10 | 46 | |
| Pull requests | 137 | 0 | 137 merged | **cero PRs descartados**: todo lo abierto llego a main |
| Discussions | 80 | (2 en-curso por label) | ~69 con label estado:concluida | sistema de labels propio |

Numeracion densa y compartida (issue #272 es el ultimo elemento). Ritmo medio: ~7,2 elementos numerados por dia de calendario; picos de creacion el 5-6 sep.

El uso de GitHub es parte del metodo: la etiqueta `agente:llm` / `agente:humano` documenta quien participa en cada hilo (la autoria real, dado que todos los commits firman como el usuario), y `resultado:aplicado` / `resultado:criterio-permanente` / `resultado:pendiente` cierra el circuito decision -> artefacto.

## Issues (56)

**Por naturaleza**:

- **Defectos y debates de modelo del dominio** (fase temprana): #1-#4, #13, #14. Cerrados en dias.
- **Issues de revision por capa** (patron repetido, un issue por lote L1-L9): #16, #21, #24, #28, #31, #34, #36, #40, #45, mas #23/#39 (datos reales de ejemplo) y #42, #48-#51, #55 (wireframes y navegacion).
- **Seguridad**: #96 (IDOR en endpoints del Especialista, 2 sin autenticacion) y #86 (IDOR en 44 puntos de DirectorPrograma). Ambos cerrados con auditoria transversal; el checklist que los cazo siguio cazando el IDOR de body (#210).
- **Integridad de datos/produccion**: #148 (Programa B duplicado por falta de unicidad de `Programa.codigo`), #181 (FK ausente ActividadPrograma->Actividad), #187 (seed no idempotente), #202 (scripts sin encontrar el seed en el contenedor).
- **Bugs funcionales**: #3, #55, #208 (sistemas de control sin ponderar no bloquean el envio), #210, #212, #220 (actor del endpoint PDF distinto del especificado), #223 (logo SVG de 54KB inline en cada respuesta), #226, #262 (idem #220 para la vista HTML).
- **Mejoras/features cerradas**: #6 (reabrirDocumentoPorIncidencia), #179, #184 (importacion entre documentos hermanos), #185 (backups diarios), #249... abiertas las que siguen.

**Los 10 issues abiertos a fecha de corte**:

| # | Titulo (paráfrasis) | Tipo |
|---|---|---|
| 219 | resultados esperados leidos en vivo: editarlos altera documentos ya aprobados | decision de diseno pendiente |
| 222 | modelar el periodo operativo (sustituir la constante de periodo vigente) | deuda de modelo |
| 248 | limpieza de datos: tipo de sistema de control sucio en una operacion del Programa B | mantenimiento |
| 249 | referencias documentales: escalar a modelo normalizado (90/108 operaciones afectadas) | evolutivo grande |
| 258 | indicadores de completitud junto a aprobar/rechazar documento | mejora UI |
| 260 | DER/diccionario stale tras la FK de #181 | deuda documental |
| 265 | abrirDocumento() da 403 al Admin, pero el diagrama de contexto lo modela | discordancia codigo/RUP |
| 266 | color de fila por tipo de sesion + pie del medidor | mejora UI |
| 268 | PDF: control de saltos de pagina | mejora |
| 270 | PDF: parrafo institucional de trazabilidad | mejora |

Nota de higiene: **#268 y #270 tienen sus PRs (#269, #271) ya mergeados en main el 6-sep**; el cuerpo de los PRs referencia el numero pero sin keyword de cierre ("fixes #"), asi que GitHub no los cerro automaticamente. Cierre manual pendiente. El resto de abiertos son trabajo real futuro, no descuido.

## Pull requests (137, todos merged)

- Convencion estable: `tipo(scope): descripcion (#issue)` o bloques "Frente A/B" para trabajos por partes (p. ej. el cluster de actividades operativas como pipeline #229/#231/#232, #206 como bloques 1/2/3).
- Cadencia creacion->merge tipica de minutos (p. ej. #273: creado 21:02, merged 21:03): el pipeline de revision (auditoria en clon + OK humano) ocurre antes de abrir el PR, no despues. El PR es el acta de la integracion, no la cola de revision.
- Contenido: cada PR de CU cierra el ciclo Requisitos -> Frontend de su caso de uso (pipeline vertical), incluida la actualizacion del dashboard de seguimiento y de los diagramas afectados (audit del cluster obligatorio).

## Discussions (80)

**Por tipologia** (recuento propio sobre titulos y labels):

| Tipo | Ejemplos | Rol en el metodo |
|---|---|---|
| Decisiones de criterio "cierre antes de especificar" por lote | #15, #18, #27, #33, #38, #44 | decidir en artefacto barato antes de especificar |
| Decisiones de formato/convencion | #9 (formato de especificacion), #12, #72 | criterios permanentes |
| Auditorias externas | #11 (OpenCode L0), #53 (glm-5.2), #69, #71, #75 | revision adversarial con contexto fresco |
| Bitacoras de sesion/trabajo | #19, #57, #61, #90, #101, #128, #130, #139, #143, #145, #167, #246 | memoria entre sesiones sin memoria nativa |
| Retrospectivas de proceso | #5, #43, #158, #213, #247 | el proceso se audita a si mismo y cambia |
| Metricas del proyecto | #92 | tiempo por disciplina RUP |
| Despliegue/infraestructura | #79, #80, #83, #105, #160, #162 | protocolo commit-driven, chequeo de bundle, hooks |
| Requerimientos evolutivos posteriores al cierre | #140, #191, #196, #198, #200, #205, #206, #217, #218, #224, #227, #228, #255, #259 | el catalogo crecio de 91 a 102 CU por esta via |
| Cultura de equipo / miscelanea | #30 (ideas de auditoria), #47, #76, #84 ("Fustigamientos: un chiste de una linea por cada metedura de pata"), #112, #113, #114, #146 ("QUIEN ERES"), #147 ("FUMADA MANTENIMIENTO EVOLUTIVO"), #149, #236 | humanoides: humor, opinion, brainstorming |

**Labels de autoria**: `agente:llm` esta presente en practicamente todas las discussions con labels; `agente:humano` en la mayoria de las de decision. Es decir: el tracker es una conversacion humano+agente(s) con multiples voces identificadas, no un buzon de tickets.

## Salud del tracker

- Sin issues zombies: los 46 cerrados lo estan por trabajo real; los 10 abiertos son accionables (2 solo pendientes de cierre manual).
- Sin PRs abandonados ni ramas eternas: 44+ ramas `cc/*` en local/remoto, todas correspondientes a PRs ya integrados; main es la unica rama viva.
- La numeracion issues/PRs/discussions es consecutiva y densa: GitHub funciona aqui como base de datos del proceso (decisiones, bitacoras, metricas), no solo como cola de trabajo.
