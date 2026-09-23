# Anexo: QA en vivo, mismo día de escritura de este documento

Este anexo no reconstruye un ejemplo después del hecho. Es la traza pública de un episodio real -- auditoría externa de pyCelda, discusión resultante, corrección y verificación cruzada -- ocurrido el mismo día en que se preparó esta charla, con enlaces directos a cada pieza de evidencia. `charla001.md` ya usa pyCelda como ejemplo del caso `CursoAcademico`; este anexo añade una segunda instancia del mismo argumento, más reciente, y con un rol que el ejemplo original no tenía: un auditor externo sin ningún contexto previo del repo.

## ¿Por qué?

`charla001.md` insiste en que "verificar con evidencia directa antes de dar algo por bueno... es el motivo por el que el rol de pruebas existe como rol separado" y que "ya lo he probado" dicho por un desarrollador no es evidencia, es una afirmación. Ambas frases se pueden dejar como principio abstracto, o se pueden mostrar funcionando. Este anexo es la segunda opción: cada afirmación de la charla tiene, en este episodio, un commit, una discussion o un comentario que la sostiene -- no una anécdota parafraseada de memoria.

## ¿Qué? -- cronología con los cuatro roles de la charla identificados

1. **Auditoría externa solicitada.** Se pidió una lectura completa de pyCelda en solo lectura, sin trabajo previo en el repo -- el equivalente exacto de la cita RUP de la charla: *"quien construye no puede ser el único juez de que está bien construido"*. La auditoría partió de `ls`, `grep` y `git log`, no de memoria de sesiones anteriores en el proyecto.

2. **Primera versión publicada, con errores reales.** El primer informe (identificado como `Claude-pyCelda-AUDIT`) se publicó como [discussion #475](https://github.com/mmasias/pyCelda/discussions/475) con cifras que parecían rigurosas -- y no lo eran del todo: 17 modelos declarados donde eran 21, 116 endpoints donde eran 138, 181 usos del patrón de guard donde eran 180. Verificación aparente, no verificación real -- exactamente la Fase 1 de Beizer que cita la charla ("demostrar que el software funciona"), aplicada aquí a "demostrar que la auditoría es rigurosa" en vez de intentar activamente encontrarle el fallo.

3. **Segunda pasada, más granular, corrige 5 cifras.** Un segundo análisis, con foco explícito en máxima precisión y citas de línea, corrigió las cinco cifras -- Fase 2 de Beizer, ahora sí buscando activamente el fallo en el propio trabajo antes de que lo encontrara otro.

4. **Recalibración del marco, a petición de quien encargó la auditoría.** El primer marco calificó pyCelda de "experimento de desarrollo agéntico". Se corrigió: es producción real con datos profesionales de ~400 docentes objetivo, no un experimento -- la gravedad de los mismos hechos (sin CI, sin `healthcheck`, `Caddyfile` sin cabeceras de hardening) cambia según lo que hay en juego, no según el hecho en sí. Esta es la distinción que la charla no nombra con estas palabras pero que es, en esencia, verificación (¿el sistema hace lo que dice?) sostenida, con validación (¿es esto lo que importa dado el contexto real?) aplicada después, por separado.

5. **Verificación independiente por un tercero que no aceptó el informe sin comprobarlo.** pySigHor -- otra sesión de Claude Code, con su propio trabajo previo en el mismo repo -- respondió [en la misma discussion](https://github.com/mmasias/pyCelda/discussions/475#discussioncomment-18572729) verificando por su cuenta contra el repo real antes de darle crédito a ninguna cifra, y aportó un hallazgo que la auditoría no cubría: una práctica real de backup/DR (manifiesto `backups_manifest.jsonl`, endpoint `GET /copias-seguridad`, issue #308) que matiza el riesgo de SQLite en producción. La auditoría, a su vez, no aceptó esa afirmación sin comprobarla -- verificó contra `backend/app/core/backups.py` antes de responder, y dejó explícito lo que no pudo verificar (el script bash y el timer systemd viven en Prometeus, fuera de su alcance desde la máquina donde corría). [Respuesta publicada aquí](https://github.com/mmasias/pyCelda/discussions/475#discussioncomment-18572740).

Ninguno de los tres pasos (2, 4, 5) confió en la palabra del paso anterior. Cada uno verificó contra el sistema real antes de aceptar o corregir.

## ¿Para qué? -- lo que esto prueba que la charla todavía no tenía tan documentado

**El reparto de roles de la charla, con agentes IA como titulares reales del rol, no como metáfora.** RUP separa "Ingeniero de pruebas" de "Ingeniero de componentes" por diseño. En pyCelda ese reparto ya corría con tres roles (pyCelda construye, pySigHor decide diseño y revisa, Claude@Prometeus despliega) y este episodio añadió un cuarto que no existía en el reparto habitual: auditoría externa sin contexto previo. El principio de la charla no describe una aspiración -- describe un proceso que se puede citar por su URL.

**La asimetría de coste que ilustra la tabla de desastres de la charla, a escala de un proyecto real y verificable.** El commit [`185f97f`](https://github.com/mmasias/pyCelda/commit/185f97fcc72be57c7dbafb4dff7562c2c395a464) (23-sep-2026, 40 archivos, +1414/-349) corrigió un IDOR de asignación cruzada entre universidades -- `asignar_profesor_a_asignatura_grado()` no comprobaba que el `Profesor` perteneciera a la misma universidad que la `AsignaturaGrado` -- detectado en revisión *antes* de merge, con test de regresión en el mismo commit. Es la misma estructura de argumento que Mariner 1 o Ariane 5 (un supuesto no escrito en ningún sitio, heredado de cómo se construyó cada pieza por separado), a escala de horas y de un proyecto auditable, no de una cifra en millones de dólares de hace décadas.

**Además, es la segunda vez que ocurre exactamente este patrón, no la primera.** El ejemplo de `CursoAcademico` que ya usa `charla001.md` -- nueve puntos del código asumiendo en silencio "un solo curso académico para siempre", ningún test lo detectó, lo detectó una auditoría de diseño explícita -- y el IDOR de `185f97f` de hoy son la misma clase de fallo en dos dimensiones distintas del dominio (multiplicidad de curso académico, luego multiplicidad de universidad). El proceso que lo caza no es una excepción puntual: se repite cuando el dominio vuelve a crecer.

**Una tensión honesta que la charla puede nombrar y hoy no nombra.** La cita RUP de la charla dice que QA "informa el defecto... no propone la solución técnica". La auditoría de este episodio, al ser consultiva y no un reporte de defecto durante testing, sí propuso soluciones técnicas concretas -- YAML de CI, `healthcheck` de Compose, cabeceras del `Caddyfile` -- [detalladas en un comentario de seguimiento](https://github.com/mmasias/pyCelda/discussions/475#discussioncomment-18572593). No es un incumplimiento del principio: es un género de intervención distinto (auditoría consultiva) que la tabla de técnicas de la charla no distingue todavía de "informar el defecto durante Probar/Inspeccionar". Vale la pena nombrarlo en la charla como matiz, no como excepción.

## ¿Cómo? -- las cuatro técnicas de la charla, con nombre y enlace

| Técnica (tabla de la charla) | Quién, en este episodio | Evidencia |
|---|---|---|
| **Revisar** (informal, el propio autor) | pyCelda se autorrevisa antes de abrir el commit | [`185f97f`](https://github.com/mmasias/pyCelda/commit/185f97fcc72be57c7dbafb4dff7562c2c395a464), mensaje completo del commit documenta el hallazgo propio |
| **Inspeccionar** (formal, quien no construyó) | pySigHor revisa con evidencia antes de dar crédito | [Comentario de verificación](https://github.com/mmasias/pyCelda/discussions/475#discussioncomment-18572729) |
| **Probar** (unidad: desarrollador; integración/sistema: QA) | 769 funciones `def test_`, con test de regresión nuevo en `185f97f` | Cifra verificada de forma independiente por pySigHor en su propio comentario |
| **Depurar** (siempre el desarrollador) | Fix real de `asignar_profesor_a_asignatura_grado()` | Mismo commit `185f97f` |
| *(sin nombre en la tabla de la charla)* **Auditoría arquitectónica externa retrospectiva** | Esta auditoría -- 8 ángulos, sin foco en un defecto concreto, sin conocimiento previo del repo | [Discussion #475](https://github.com/mmasias/pyCelda/discussions/475) (cuerpo principal, dos veces corregido) + [respuesta cruzada](https://github.com/mmasias/pyCelda/discussions/475#discussioncomment-18572740) |

## Fuentes de este anexo

- Discussion principal, versión final tras dos correcciones: <https://github.com/mmasias/pyCelda/discussions/475>
- Comentario con los tres pendientes detallados (CI, `healthcheck`, cabeceras): <https://github.com/mmasias/pyCelda/discussions/475#discussioncomment-18572593>
- Comentario de verificación independiente de pySigHor: <https://github.com/mmasias/pyCelda/discussions/475#discussioncomment-18572729>
- Respuesta de esta auditoría a la verificación de pySigHor: <https://github.com/mmasias/pyCelda/discussions/475#discussioncomment-18572740>
- Commit del IDOR de asignación cruzada entre universidades: <https://github.com/mmasias/pyCelda/commit/185f97fcc72be57c7dbafb4dff7562c2c395a464>
- Commit de sincronización RUP-código citado como precedente (`CursoAcademico`, mismo patrón de fallo en otra dimensión): <https://github.com/mmasias/pyCelda/commit/78dab5c78ea72d7642659f828d3c71fd6ea65f5e>
- Arquitectura de backup/DR verificada tras la corrección de pySigHor: `backend/app/core/backups.py`, router `copia_seguridad.py`, issue #308 del mismo repositorio.
