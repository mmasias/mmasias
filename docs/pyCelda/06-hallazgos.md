# 06 - Hallazgos de la auditoria

Observaciones propias, verificadas contra el arbol y el historial. Separadas en puntos fuertes verificados, discrepancias, higiene y riesgos. Identificadores traducidos segun la nota de edicion del indice.

## Puntos fuertes verificados

1. **Trazabilidad estructural excepcional.** La cadena requisito -> analisis -> diseno -> desarrollo -> codigo -> test es navegable en ambos sentidos: los README de cada CU enlazan a ficheros concretos del repo, los comentarios del codigo citan issues/discussions/PRs (#184, #210, #227...), y el dashboard de seguimiento se actualiza con cada merge. Los conteos fisicos cuadran con los declarados en cada fase (96 carpetas por fase, 105 de detalle, 102 CU deduplicados).
2. **El metodo declarado se cumple en los datos**: 3,5 semanas sin codigo, rebanada vertical completa en un dia, auditorias duales reales sobre el mismo commit, retrocesos documentados como tales (#72, #191, #212), y el catalogo absorbe +11 CU posteriores con el mismo ciclo por CU.
3. **Disciplina de seguridad con resultados**: dos auditorias IDOR (#96, #86) cerradas, politica 404-uniforme consistente, la unica relajacion (importacion entre documentos hermanos) esta acotada y documentada, y el checklist transversal cazo el IDOR de body (#210) que los tests por CU no veian.
4. **Produccion con protocolo**: health-check real, chequeo de bundle del frontend, hooks que blindan los commits de despliegue, `.deployed-commit` como registro, backups diarios (#185).
5. **Ratio test/codigo backend ~0,96:1** con tests de integracion contra la API real (decision consciente, #57), fixtures que construyen escenarios IDOR explicitamente.

## Discrepancias: la prosa desfasada en cascada

Ninguna cifra "oficial" coincide con la actual; cada documento quedo congelado en su fecha de escritura:

| Cifra | RESUMEN.md (~1-sep) | README raiz (~4-sep) | RUP/04 README | Arbol real (7-sep) |
|---|---|---|---|---|
| Catalogo CU | 96 | 99 | - | 102 (dashboard: 102/102) |
| CU con desarrollo | 89 | 90 | - | 93 (9 de Admin pendientes) |
| Commits | 436 | - | - | 545 |
| PRs | 110 | - | - | 137 merged |
| Items GitHub | 223 | - | - | 273 |
| Tests | - | 497/497 | 421/421 en 66 ficheros | 557 funciones en 83 ficheros |
| LoC | ~20.000 codigo / 7.800 tests / 23.141 RUP | - | - | 24.102 codigo / 11.118 tests / 25.362 RUP |

Diagnostico: la prosa se actualiza por bloques de trabajo (sincronizaciones tipo PR #204 "sincroniza resumenes con el estado real"), no continuamente; entre bloque y bloque, los numeros envejecen en dias. Es el coste residual de mantener resumenes manuales en un repo que cambia a 18 commits/dia. El dashboard de seguimiento es la unica fuente que cuadra con el arbol.

Detalle adicional dentro del propio RESUMEN.md: declara "Ratio test:codigo ~0,89:1" y "412 funciones test" con "454 casos ejecutados con parametrizacion" -- cifras ya superadas por el arbol actual.

## Higiene del arbol de trabajo

1. **`pycelda.db` en la raiz** (147 KB, 31-ago): residuo de ejecutar tests/app desde directorio incorrecto en algun momento; gitignored pero presente. La base canonica de trabajo es `backend/pycelda.db` (598 KB) y la de produccion el volumen Docker.
2. **Tres snapshots manuales** `pycelda.db.bak.2026*` en backend/ (gitignored) + `.pytest_cache/` duplicados en raiz y backend: mismos sintomas de ejecuciones historicas desde cwd inconsistente.
3. **Sin trackear**: `backend/uv.lock` (deberia versionarse: el Dockerfile usa uv y el lock garantiza reproducibilidad de builds de produccion) y 3 PDF grandes del corpus de docs/ (binarios de varios MB; decidir si entran al repo o a LFS/gitignore).
4. **Issues #268 y #270 abiertos con sus PRs ya mergeados** (#269, #271): falta el cierre manual (los PRs no usaron keyword de cierre).
5. **44+ ramas locales `cc/*` ya integradas**: cosmetico, pero `git branch --merged` limpiaria el listado.

## Riesgos y limitaciones tecnicas (algunos asumidos por decision)

1. **Sin CI**: no hay `.github/workflows`. La verificacion (tests, compilacion TS, render de diagramas) ocurre en el flujo de agente (clon dedicado antes del merge), pero nada lo impide a un cambio apresurado directo en main. Un workflow con pytest + `tsc --noEmit` + build Vite cubriria el hueco a coste casi nulo.
2. **Sin tests de frontend**: los 84 `.tsx` se verifican con checklist manual por version (#131, #145) y pruebas en produccion. Asumido hasta ahora; a medida que la UI crece, el coste de regresion manual sube.
3. **SQLite en produccion** con volumen Docker: adecuado a la escala (2 programas, 108 documentos, uso estacional), pero el propio tracker ya lista migraciones que fueron delicadas (#181 con datos reales). El issue #249 (referencias documentales normalizadas sobre 90/108 operaciones) sera la siguiente prueba de estres.
4. **JWT sin revocacion server-side** y admin resuelto por claim del token: decision consciente documentada; el riesgo es conocido (token valido tras cambio de rol hasta su expiracion).
5. **Lecturas en vivo que afectan a documentos aprobados** (#219): los resultados esperados se materializan en el PDF pero la vista HTML los lee en vivo del catalogo; editarlos altera documentos ya aprobados. Es el issue de diseno abierto mas sustancial junto a #222 (periodo operativo sin modelar, constante en configuracion).
6. **Documentacion derivada con riesgo de staleness estructural**: el issue #260 (diccionario de datos stale tras la FK de #181) muestra que el DER/diccionario se genera/actualiza a mano; mismo patron de riesgo que los READMEs de cifra.

## Sobre la evaluacion del experimento

El RESUMEN.md declara una tasa de escape medida: 2 defectos sustantivos y 1 menor sobre 91 CU en auditoria transversal (#92), los tres de autorizacion y los tres cazables con checklist. Los datos del tracker son consistentes con esa evaluacion: los unicos defectos de seguridad escapados (#86, #96) son transversales (por omision, no por mala especificacion de lo especificado), y el resto de bugs posteriores (#208, #210, #220, #226, #262) son discordancias codigo-vs-RUP o de datos reales, no fallos de logica de dominio. La deuda real del sistema esta concentrada y catalogada en los 10 issues abiertos, sin zonas oscuras no inventariadas: verificacion positiva tras contrastar codigo, RUP, dashboard y tracker.
