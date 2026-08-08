# pySigHor: del N=1 al N=2 con codigo

> Sesion: 2026-08-07. Modelo: glm-5.2 via OpenCode.
> Origen: lectura de https://github.com/mmasias/pySigHor (README, extraDocs, conversation-log) tras debatir la tesis del autor sobre requisitado riguroso vs delegacion.

## Que aporta pySigHor al debate

pyCelda no puede validar la tesis del autor porque no tiene codigo de aplicacion. pySigHor si: 32 CU analizados, 4 implementaciones paralelas (FastAPI+React, Spring+Angular, CLI standalone, CLI HTTP), 321 commits, mas de un ano de evolucion (desde ~julio 2025 hasta hoy).

La hipotesis del Art 003 de pySigHor (julio 2025) formulaba: **"Un analisis RUP completo puede soportar multiples implementaciones tecnologicas sin modificaciones"**. Cinco meses despues, la Conversacion 50 (dic 2025) decide validarla. El Art 015 reporta el resultado: **0 modificaciones al analisis tras 4 caminos evolutivos distintos**.

Eso es protocolo empirico: hipotesis, experimento, resultado, replica (la replica es pyCelda en curso, no aqui).

## Lo que pySigHor resuelve definitivamente

La sospecha de circularidad sobre pyCelda ("proyecto disenado para confirmar la tesis") se cae del todo. pySigHor no se construyo como experimento para validar la tesis; se construyo como proyecto, y la tesis emergio de el. Es observacion pre-teorica, que es la mejor materia prima para inducir.

Ademas:

- +1 ano de evolucion con LLM significa que el autor ya paso por **mantenimiento**, no solo generacion. Eso era mi contraargumento del turno 3 ("el LLM es bueno generando, regular manteniendo").
- 4 implementaciones paralelas sobre el mismo analisis es la prueba mas fuerte posible de independencia tecnologica.

## Lo que pySigHor matiza

El **Art 024** ("Auditoria diseno vs implementacion") es la pieza mas valiosa del repo para el debate. Cifras:

- 20 desviaciones diseno-codigo en 5 CU implementadas (D01 a D20).
- ~4 desviaciones por CU cuando el caso es CRUD+workflow simple.
- Las desviaciones concretas: D01 (sync/async), D05 (sin auth), D08 (sin alembic), D02 (pydantic v1 -> v2).
- El Art 025 cierra: 18/20 resueltas, 2 pendientes (D12 selectores FK, D19 utils/).

Esto es exactamente la lista de "lo que el requisitado no cubre" que yo habia planteado en abstracto. pySigHor lo confirma con numeros: concurrencia, transaccionalidad, ORM, migraciones, autenticacion son decisiones que **aparecen en Diseno, no en Analisis**.

El Art 027 lo refuerza: "Un requisito que estaba en la especificacion desaparecio en el diagrama de secuencia y el codigo lo implemento fielmente... sin el". La spec se respeta en analisis, se degrada en diseno, se propaga en codigo. El autor lo caza, lo documenta, lo cierra.

## La calibracion que pySigHor permite formular

La tesis del autor ("programacion trivial y delegable al 100%") admite ahora formulation precisa:

> La spec rigurosa deja **inmutable el ANALISIS**. No decide el DISENO. La friccion que parecia "lo que el requisitado no cubre" es la capa de diseno: sync/async, ORM, auth, migraciones. pySigHor lo demuestra con 20 desviaciones reales en 5 CU (~4 decisiones por CU).

Esto da anclaje medible al umbral `riesgo_introducido(diseno) = medio` en miRUP: corresponde a ese orden de magnitud. Era lo que faltaba para calibrar la residencia en banda.

## Lo que pySigHor confirma sin reservas

1. **Veto humano.** Art 010 ("Incidente de aplicacion automatica post-compactacion") como caso de estudio de control de calidad. El autor registra cuando la IA se excede.
2. **Critica al vibecoding con autoridad.** Art 021 ("Sesiones de vibeCoding con agentes: LYCAEUM") y 022 (LYCAEUM -> CORRAL). El autor **ha hecho vibecoding**, lo ha dotado de arquitectura multiagente, y desde ahi lo critica. No ataca espantapajos.
3. **Verificacion multi-LLM.** Arts 009 (valoracion de ChatGPT externo) y 017 (opinion cruzada entre LLMs). Lo que en pyCelda son 4 capas (Claude/OpenCode/Kiro/Web), en pySigHor ya estaba sistematizado como practica documentada.
4. **Uso docente real.** Art 026 (mapa RUP con conexiones a IDSW1/IDSW2); Conversacion 53 redefiniendo ARTEFACTOS.md como "catalogo demo de que artefactos debe traer un TFG de informatica".

## Lo que sigue abierto

La generalizacion externa. pySigHor (32 CU, 4 stacks) + pyCelda (91 CU, 1 stack en curso) son **N=2 del mismo autor**. Valida la tesis **para el metodo del autor**, no para la industria.

Laboratorio natural: IDSW1 e IDSW2. Si el autor pide a alumnos que sigan su metodo y mide su ratio de exito comparado con vibecoding directo, hay N grande y publiable. Sin eso, la tesis es estudio de caso autoral con dos replicaciones internas.

## Veredicto

pySigHor **no es solo el predecesor**: es la prueba principal de la tesis del autor. pyCelda es la replica en otro dominio.

La tesis esta mucho mas cerca de demostrada que de hipotetica. Lo que pyCelda aporta a la tesis es refinar el metodo y, posiblemente, publicar la generalizacion. La duda externa (otros desarrolladores, otros dominios) sigue abierta pero la base es muy solida para un solo autor.

Lo que pySigHor no permite hacer es descartar el limite empirico documentado en su propio Art 024: **el analisis es inmutable, el diseno introduce ~4 decisiones por CU, la implementacion ya decidida es lo trivial**. La tesis en su forma operacional ("implementacion delegable tras diseno cerrado") es la que sobrevive a evidencia. La tesis en su forma ambiciosa ("todo trivial") no.

pySigHor es, en terminos del autor, "obra por gusto, para ayudar a companeros". Como evidencia metodologica, vale mucho mas que como producto: ofrece al resto de la comunidad datos primarios sobre hasta donde llega la delegacion al LLM con requisitado riguroso. Esa contribucion es original y publica.
