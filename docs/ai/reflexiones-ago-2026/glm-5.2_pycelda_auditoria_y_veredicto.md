# pyCelda: metricas, cualitativa y veredicto

> Sesion: 2026-08-07. Modelo: glm-5.2 (z.AI) via OpenCode, invocado por el usuario desde el repositorio pyCelda.
> Origen: peticion explicita de auditoria de tiempo y esfuerzo sobre pyCelda (github.com/mmasias/pyCelda), seguida de opinion cualitativa y debate.

## Encargo y alcance

Dos auditorias solicitadas en secuencia:

1. **AUDITORIA_DE_METRICAS.md** (`/home/manuel/misRepos/_PROYECTOS/pyCelda/AUDITORIAS/`): mineria pura de repo, sin leer contenido. Medicion de commits, sesiones, disciplinas RUP, PRs, issues, discussions.
2. **AUDITORIA_CUALITATIVA.md** (mismo path): opinion basada en lectura de READMEs, PUML, issues y discussions representativas.

La primera producida con `git log`, `gh` y un script Python para clustering por gap temporal. La segunda con lectura dirigida y citas `archivo:linea`. Ambas entregadas en formato markdown con tablas, diagramas Mermaid (`gantt`, `pie`) y desglose por disciplina.

## Lo que el dato muestra

Cifras duras (datos del repo al 2026-08-07):

- 106 commits en `main`, rango 6,80 dias (2026-07-31 a 2026-08-07).
- 14 sesiones estimadas con umbral > 3h entre commits, suma de spans 42h 45m (cota superior, no horas trabajadas).
- 57 / 98 commits con diff (58,4%) concentran en las tres disciplinas RUP hardcore (`00-modelo-del-dominio`, `01-requisitos/01-actores-casos-uso`, `01-requisitos/03-detalle-casos-uso`).
- 7 PRs (todos merged, duracion 6s a 11m: mecanica de merge, no revision).
- 15 issues (13 cerradas, 2 abiertas con plan atado a L8).
- 13 discussions, todas abiertas por convencion (las discussions son archivo, no entidad operativa).

## Lo que la estructura no cuenta

Cinco sospechas iniciales levantadas a partir de metricas, todas desmentidas por la lectura del contenido:

1. "PRs de 6s a 11m = nadie revisa" -> falso. Cuatro capas de verificacion pre-PR: auditor externo IA (glm-5.2), verificador con contexto fresco (Claude Sonnet 5), validador conceptual (Claude Web / Kiro), veto humano. El PR dura segundos porque el trabajo ya paso cuatro filtros.
2. "Discussions nunca cerradas = descuido" -> falso. Convencion implicita registrada en `03-detalle-casos-uso/README.md:188` ("registro historico, no se continuan").
3. "Lifespan de 13h en issues #4 y #28 = debate distribuido" -> falso. Timestamps verificados: 9 minutos de trabajo real en #28, los 13h son la tarjeta durmiendo.
4. "2 issues abiertas = deuda quieta" -> falso. #14 fijada a L8 (crearReferenciaBibliografica); #23 es dato de entrada pendiente, no deuda tecnica.
5. "Cero lineas de codigo" -> matizado. `extractor.py` son 664 lineas de Python 3.10+ que procesa 834 guias docentes reales con 0 errores. Codigo de tooling, no de aplicacion; pero decir "cero codigo" es inexacto.

## Lo bien

1. **Disciplina de proceso rara.** Conventional commits consistentes en espanol, scopes estables, mensajes que describen el por que. En 106 commits, ni un "wip" ni un "fix2".
2. **Trazabilidad completa de diseno.** Cada decision de modelo pasa por issue/discussion y se cierra con commit que la referencia. Patron: debate -> decision -> commit de cierre con hash legible.
3. **Iteracion con auto-critica visible.** Lotes L0 a L6 generan issues de "Revision Lx" y commits `fix` posteriores. El rework en `01-actores-casos-uso` (1.539 lineas borradas sobre 2.654 anhadidas) es iteracion, no chapuza.
4. **Validacion contra corpus real.** 834 guias docentes reales procesadas, conteos citados (`55/55 asignaturas sin repetidos`, `63 variantes de sistema_evaluacion`). No es diseno en el vacio.
5. **Veto humano efectivo.** En discussion #11 el autor rechaza la correccion de OpenCode porque entiende que es regla mal escrita, no defecto, y reescribe la regla. La IA nunca cierra sola.

## Lo flojo

1. **Muestra de 7 dias.** Sprint de arranque, no patron. Sostenibilidad no inferible.
2. **Autor unico + auto-revision multi-IA.** Las cuatro capas de IA son mejor que nada, pero siguen sin ser un humano. Un segundo revisor humano encontraria cosas que glm-5.2 no ve.
3. **Sin codigo de aplicacion ni roadmap a implementacion.** El plan declarado es "terminar RUP y luego implementar". Las fases Analisis/Diseno pre-enlazadas en 88 READMEs apuntan a ficheros que no existen.
4. **Densidad documentalta para una sola persona.** 91 CU especificados + 3 auditorias + dashboard + 4 capas de verificacion en 7 dias. Justificado si es material docente; excesivo si es producto.

## Veredicto

Categoria confirmada: proyecto personal profesional con motivacion docente (autor: Dr. Manuel Masias, profesor de la UNEATLANTICO). No TFG, no producto comercial.

Como pieza de portafolio metodologico: ejemplar. Las auditorias glm-5.2 + el registro de prompts + la auto-atribucion estricta + el veto humano documentado convierten el repo en caso de estudio ensenable.

Como producto de software: suspende por inexistente. Cero lineas de aplicacion, sin fecha de inicio. La categoria relevante para el autor no es "cuando sale el MVP" sino "que tan bueno es el metodo", y en esa categoria el trabajo es de alto nivel.

La transicion RUP -> codigo es la duda abierta. Cuando pyCelda llegue a L7-L9 e implementacion, el ratio tiempo-requisitado / tiempo-codigo y las desviaciones diseno-implementacion diran si el metodo sostiene. Hasta entonces, es hipotesis bien fundamentada.
