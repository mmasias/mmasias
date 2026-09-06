# 03 - Tiempo usado

## Ventana total

| Hito | Fecha |
|---|---|
| Creacion del repo en GitHub | 2026-07-31 16:37 UTC |
| Primer commit ("Initial commit") | 2026-07-31 |
| Ultimo push (a fecha de corte) | 2026-09-06 21:07 UTC |
| Duracion total | **38 dias de calendario (~5,4 semanas)** |

Dias con commits: 30 de 38. Dos huecos de calendario: **9-16 de agosto** (8 dias sin commits, justo despues de cerrar el catalogo de 91 CU y las auditorias duales del 8-ago) y el 27 de agosto (1 dia).

## El tiempo por disciplina (medicion interna, discussion #92)

El propio proyecto se midio: la discussion #92 (llevada por glm-5.2/OpenCode como bitacora) cuantifica el tiempo por disciplina RUP en la ventana 31-jul -> 21-ago (21 dias), con metodologia explicita: 654 eventos (commits no-merge clasificados por rutas con credito fraccional + comentarios en los 67 hilos de issues/discussions), corte de sesion a 3h de inactividad -> 21 sesiones, excluyendo del churn los ~293k lineas de seed JSON y los SVG regenerados.

| Disciplina | Dias activos | Eventos | Notas |
|---|---|---:|---|
| Modelo del dominio | 3 (31-jul -> 2-ago) | 49 | cierre del modelo + issues #1-#4 |
| Requisitos | 6 (3 -> 8-ago) | 271 (41% del total) | sesiones maratonicas de 9-15h de span; lotes L1-L9 con debates "cierre antes de especificar" |
| Intermedio (mockups, wireframes, docs) | 8-17 ago | ~180 | pausa entre requisitos y analisis |
| Analisis | 2 (17-18 ago) | 29 | rebanada vertical de calibracion (9 CU) |
| Diseno | 1 (18 ago) | 15 | misma sesion que analisis |
| Desarrollo (backend+frontend+pruebas) | 4 (18-21 ago) | 30 | 43 CU: rebanada + 28 de DirectorPrograma delegados |
| Despliegue | 2 (19-20 ago) | 34 | Docker + Caddy + protocolo commit-driven |

Conclusion que el propio proyecto extrae de esa medicion: la hipotesis "requisitos bien hechos -> desarrollo rapido" sale reforzada pero con el mecanismo corregido: **requisitos -> decidibilidad -> delegabilidad -> velocidad**. El 18-ago una rebanada cruzo analisis->diseno->desarrollo en horas porque los `<<choice>>` dudosos ya estaban cerrados; 43 CU quedaron implementados y desplegados en 72h. La medicion tambien contabiliza la contraprueba de retrocesos: 4 defectos detectados en fase de requisitos corregidos en minutos vs 1 defecto escapado a desarrollo (#86, IDOR por omision transversal).

## Las dos fases macro segun RESUMEN.md

- **3,5 semanas de definicion pura antes de la primera linea de codigo**: 151 commits, cero codigo. Requisitos completo y arranque de Analisis antes de tocar Python.
- **~1,5 semanas de construccion** (con la RUP avanzando en paralelo, pipeline vertical por CU). El titular declarado: los ~20.000 LoC caben en una semana de trabajo; lo que no cabe en una semana es el calendario, porque el pensamiento se hizo por delante.

Nota: esas cifras corresponden al estado a ~1-sep. A fecha de corte (6/7-sep) la construccion se alargo a ~3 semanas de calendario con las ampliaciones posteriores (render/PDF, ActividadOperativa, importaciones).

## Ritmo de trabajo (distribucion de los 545 commits)

Por dia: media 18,2 commits/dia activo; picos 45 (5-sep), 33 (30-ago, 31-ago, 1-sep, 6-sep); minimos 1 (28-ago) y 3 (29-ago).

Por hora de commit (hora local de cada maquina):

| Franja | Commits | Lectura |
|---|---:|---|
| 00:00-02:59 | 106 | sesiones trasnochadas |
| 03:00-08:59 | **0** | zona muerta absoluta |
| 09:00-17:59 | 172 | trabajo de manana/tarde |
| 18:00-23:59 | 267 | franja dominante (pico 18-21h: 202 commits) |

Patron claro de trabajo vespertino/nocturno con incursiones a la madrugada; nadie commitea de 4 a 9 de la manana. Coherente con sesiones largas de orquestacion de agentes en tiempo libre + jornadas de oficina.

## Las maquinas (autorias git)

| Autor git | Commits | Rango | Maquina |
|---|---:|---|---|
| manuel@sdf1.fedora | 245 | 31-jul -> 3-sep | SDF1 (principal en casa) |
| manuel@oficina | 150 | 3-ago -> 6-sep | equipo del despacho |
| Manuel Masias | 143 | 31-jul -> 6-sep | identidad sin hostname (config distinta) |
| manuel@prometeus | 7 | 19-ago -> 1-sep | Prometeus (nodo de despliegue) |

Las cuatro identidades son la misma persona (y sus agentes commiteando como el usuario); la separacion por maquina confirma la malla multi-sesion declarada: desarrollo en las maquinas de casa y despacho, despliegue en Prometeus. La autoria humano-vs-LLM no se rastrea aqui sino en las etiquetas `agente:humano`/`agente:llm` de GitHub.

## Versiones como marcas de tiempo

| Tag | Fecha | Contexto |
|---|---|---|
| stable-primer-despliegue-produccion | 2026-08-20 | primera puesta en produccion |
| v0.1.0 | 2026-08-21 | cierre de la rebanada vertical |
| v0.2.0 | 2026-08-23 | UI completa de DirectorPrograma (28 CU) |
| v0.3.0 | 2026-08-23 | UI de autoria del Especialista |
| v0.4.0 | 2026-08-25 | bloque Admin bottom-up (con checklist manual de pruebas, #131) |
| v0.5.0 | 2026-08-26 | datos reales de los dos programas + condiciones de envio |
| v0.6.0 | 2026-08-30 | planificacion de operaciones + DER |
| v0.7.0 | 2026-09-05 | render/PDF oficial + ActividadOperativa |
| v0.8.0 | 2026-09-06 | iteracion de PDF + planificacion generica |

De la primera linea de codigo (18-ago) a v0.1.0 en produccion: **3 dias**. De cero absoluto a v0.8.0: 37 dias.
