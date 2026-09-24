# QA en el proceso de software: límites y responsabilidades

> "No existe ninguna otra actividad de pruebas que produzca una detección y corrección de errores de forma más eficiente (inversión/ahorro de tiempo y coste) que las pruebas estáticas basadas en revisiones."
> — C. Kaner, J. Falk, H.Q. Nguyen, *Testing Computer Software*

## ¿Por qué?

Un [proyecto de software](https://github.com/mmasias/PRG1/blob/main/temario/00000-introduccion.md#proyecto-de-software) tiene problemas, por tanto se establecen unas [disciplinas](https://github.com/mmasias/PRG1/blob/main/temario/00001-disciplinasSw.md) las cuales, siguiendo un [proceso](https://github.com/mmasias/PRG1/blob/main/temario/00002-procesoSw.md) permiten la transición del [problema a una solución](https://github.com/mmasias/PRG1/blob/main/temario/00003-preAlgoritmos.md#qu%C3%A9)

### ¿QA?

Control de Calidad no es solo pruebas, son varias técnicas distintas y la revisión suele ser la más barata y la más efectiva de todas. Si el proceso de calidad de un equipo empieza y termina en "ejecutar tests", ya está dejando la mitad del trabajo sobre la mesa.

Un fallo que llega a producción no es una anécdota puntual, es un fallo silencioso que finalmente hizo ruido demasiado tarde.

|Fecha|Desastre|Causa|Coste|
|-|-|-|-|
|1962|El cohete Mariner 1, en una investigación espacial destinada a Venus, se desvió de su trayectoria de vuelo poco después de su lanzamiento. El control de la misión destruyó el cohete pasados 293 segundos desde el despegue.|Un programador codificó incorrectamente en el software una fórmula manuscrita, saltándose un simple guión sobre una expresión. Sin la función de suavizado indicada por este símbolo, el software interpretó como serias las variaciones normales de velocidad y causó correcciones erróneas en el rumbo que hicieron que el cohete saliera de su trayectoria.|18,5 millones de dólares
|1978|Sólo unas horas después de que miles de aficionados al hockey abandonaran el Hartford Coliseum, la estructura de acero de su techo se desplomaba debido al peso de la nieve.|El desarrollador del software de diseño asistido (CAD) utilizado para diseñar el coliseo asumió incorrectamente que los soportes de acero del techo sólo debían aguantar la compresión de la propia estructura. Sin embargo, cuando uno de estos soportes se dobló debido al peso de la nieve, inició una reacción en cadena que hizo caer a las demás secciones del techo como si se tratara de piezas de dominó.|70 millones de dólares, más otros 20 millones en daños a la economía local.
|1982|El software de control se volvió loco y produjo una presión excesiva en la tubería de gas transsiberiana, provocando la mayor explosión no nuclear, causada por el hombre, de la historia de la tierra.|los agentes de la CIA supuestamente introdujeron un error en el sistema informático canadiense adquirido por los soviéticos para controlar sus tuberías de gas. La compra era parte de un estratégico plan soviético para robar u obtener de forma encubierta tecnología secreta de los Estados Unidos. Cuando la CIA descubrió la compra, sabotearon el software de forma que éste superara la inspección soviética pero fallara una vez operativo|Millones de dólares, daño significativo a la economía soviética.
|1996|El Ariane 5, el más novedoso cohete espacial no tripulado Europeo, fue destruido intencionadamente segundos después de su lanzamiento en su vuelo inaugural. Con él se destruyó su carga de cuatro satélites científicos destinados a estudiar la interacción del campo magnético de la tierra con los vientos solares.|El problema surgió cuando el sistema de guiado intentó convertir la velocidad lateral de la nave de 64 a 16 bits. El número era demasiado alto y se produjo un error de desbordamiento, lo que hizo que el sistema de guiado se detuviera. En ese momento, el control pasó a un sistema idéntico redundante, que también falló al ejecutar el mismo algoritmo.|500 millones de dólares.
|2000|El software de radiación terapéutica creado por Multidata Systems International fallaba al calcular la dosis apropiada, exponiendo a los pacientes a peligrosos, y en algunos casos mortales, niveles de radiación. Los físicos, a los que legalmente se exige una doble comprobación de los cálculos del software, fueron acusados de asesinato.|El software calculaba la dosis de radiación basándose en el orden en que los datos eran introducidos, lo que provocaba que a veces generara una dosis doble de radiación.|8 personas muertas, 20 heridas de gravedad.
|2004|[El gigante de servicios EDS desarrolló un sistema informático para la agencia británica "Child Support Agency (CSA)" que accidentalmente pagó más de lo debido a 1.900.000 personas](https://www.information-age.com/eds-admits-csa-bungle-22051/), pagó de menos a otras 700.000, tenía 3.500 millones de libras de manutención de niños sin cobrar, un atraso de 239.000 casos, 36.000 nuevos casos bloqueados en el sistema, y todavía hay más de 500 bugs documentados.|EDS introdujo un enorme y complejo sistema de información en la CSA de forma simultánea a una reestructuración de la agencia.|539 millones de libras, y sumando.
|1999-2024|[El software de contabilidad Horizon, de Fujitsu, mostraba faltantes de dinero inexistentes en cientos de oficinas postales del Reino Unido](https://cnnespanol.cnn.com/2024/01/13/falla-software-oficina-correos-reino-unido-arruino-vidas-trax). Cerca de 700 empleados fueron acusados y condenados por robo o fraude a partir de esos datos, varios encarcelados, arruinados, y al menos cuatro se suicidaron. Es el mayor error judicial en masa de la historia británica.|Una sentencia judicial de 2019 confirmó que Horizon "contenía errores, fallos y defectos" nunca investigados a fondo durante 16 años, mientras Fujitsu ayudaba a la fiscalía a procesar a los propios empleados perjudicados por esos defectos.|Más de 1.000 millones de libras reservados por el gobierno británico en compensaciones, cifra aún en aumento.
|2024|El 19 de julio, una actualización de contenido de CrowdStrike Falcon provocó pantallas azules en 8,5 millones de equipos Windows en todo el mundo: vuelos cancelados en masa, hospitales que aplazaron cirugías, bancos, aeropuertos y centrales de emergencias 911 caídos. El mayor apagón informático de la historia.|El propio validador de contenido de CrowdStrike, el componente responsable de comprobar la integridad de una actualización antes de desplegarla, tenía un defecto que dejó pasar sin detectarlo el archivo defectuoso.|5.400 millones de dólares solo en empresas Fortune 500 (estimación de Parametrix); CrowdStrike perdió más de 30.000 millones de dólares en valor bursátil.

### Esta semana

[Un equipo viejo provoca un apagón informático en el Ayuntamiento de Santander](https://www.eldiario.es/cantabria/equipo-viejo-provoca-apagon-informatico-ayuntamiento-santander-sigue-arreglarse_1_13527001.html).

<div align=center>

<table>
<tr><th align=center><img width="75%" src="https://github.com/user-attachments/assets/ad82b035-414b-4a8b-a085-8f23779c772f" /></th></tr>
<tr><td>
El Ayuntamiento de Santander sufre una caída de la infraestructura informática que ha paralizado su actividad al completo. Actualmente todos los servicios municipales están cerrados al público y se prevé que el problema persista, al menos, durante dos días.<br>Los trabajadores han sido enviados a sus casas ante la imposibilidad de continuar con su trabajo. No funcionan ni los servicios informáticos ni las líneas de teléfono de la casa consistorial y el edificio de la calle la Paz.<br>Fuentes cercanas al suceso denuncian que la infraestructura lleva meses dañada. Alcanzando los 40 grados el sistema, no pueden instalar aire acondicionado por riesgo de incendio de la infraestructura eléctrica. 
</td></tr>
</table>

</div>

### Aquí, en casa

Supongamos

- 1.000 empleados, 1.200 €/mes cada uno.
- Jornada estándar: 40 h/semana son 173,33 horas/mes (*40×52/12, conversión que usan los convenios laborales en España*).
- Una caída de SG a las 16:00h de España, la hora "letal": el momento del día en que todas las sedes están conectadas a la vez, así que el supuesto de que los 1.000 empleados quedan parados simultáneamente deja de ser una hipótesis pesimista y pasa a ser el escenario real de máximo impacto.

<div align=center>

|||
|-|-|
Coste/hora por empleado|1.200 / 173,33 = 6,92 €
Coste/minuto por empleado|6,92 / 60 = 0,115 €
Coste/minuto, 1.000 empleados parados|0,115 × 1.000 = 115,38 €/minuto
Coste/hora, 1.000 empleados parados|6.923 €/hora
Coste/jornada completa (8h) parada|55.385 €/día

#### SG caído

|Un minuto|Una hora|Un día|
|:-:|:-:|:-:|
115 €|~ 6.900 €|~ 55.000 €

</div>

Y esto es el suelo, no el techo. Solo cuenta salario bruto de gente sentada sin producir. No cuenta:

- Carga social de empresa (en España ronda +30% sobre el bruto): con eso, el minuto sube a 150 € y la hora a 9.000 €.
- Ingresos que la empresa dejó de facturar mientras el sistema estaba caído.
- Penalizaciones de SLA con clientes.
- El coste de recuperación posterior (horas extra deshaciendo el desastre, que casi siempre superan el tiempo de la caída original).

Conocido el precio, queda la pregunta incómoda: ¿en qué fase mental se está pagando esa factura? Boris Beizer describió cinco fases por las que pasa quien entiende (o no) para qué sirven las pruebas:

<div align=center>

|Fase 0|Fase 1|Fase 2|Fase 3|Fase 4|
|-|-|-|-|-|
|No hay ninguna diferencia entre prueba y depuración. Las pruebas no tienen ningún propósito propio.|El objetivo de la prueba es demostrar que el software funciona.|El objetivo de la prueba es demostrar que el software **no** funciona.|El propósito no es demostrar nada, sino reducir el riesgo percibido cuando el software no se comporta dentro de valores aceptables.|Las pruebas no son un acto, son una disciplina mental que produce software de bajo riesgo sin esfuerzo excesivo en pruebas.|
|Muy mal|Mal|Regular|Bien|Muy bien|

</div>

La mayoría de los equipos "sin rigor" viven en Fase 0 o 1: para ellos "probar" es "he pulsado el botón y no ha fallado". Eso es exactamente el nivel de rigor con el que se paga la factura de la tabla anterior.

RUP [es explícito en la separación de roles](https://github.com/mmasias/idsw1/blob/main/temario/00002-rup.md#roles): "Ingeniero de pruebas" != "Ingeniero de componentes" != "Ingeniero de requisitos" por una razón de diseño, no burocrática: ***quien construye algo no puede ser el único juez de que está bien construido***.

Esa es la motivación entera de por qué QA existe como función independiente y no como "el desarrollador que prueba al final".

## ¿Qué?

Primera precisión, incómoda a propósito: RUP no tiene ninguna disciplina llamada "QA". Lo que corre en paralelo a Análisis, Diseño e Implementación es la **Disciplina de Pruebas** (Test), y eso es Control de Calidad (QC), no Aseguramiento de Calidad (QA). QC detecta defectos en el producto ya construido. QA previene mejorando el proceso que lo construye. Son categorías distintas, no sinónimos con nombre bonito.

Con esa precisión hecha, el límite de responsabilidad concreto ya está en el propio RUP, actividad "Realizar Pruebas de Integración":

> "Informe los defectos **al ingeniero de componentes**, que es responsable de los componentes que probablemente contengan la falla" frente a "Informar los defectos **a los diseñadores de pruebas**, quienes luego utilizan los defectos para evaluar los resultados generales del esfuerzo de prueba."

Traducido a los dos roles que nos ocupan:

- **QA diagnostica**: reproduce, aporta evidencia, clasifica severidad/prioridad, no propone la solución técnica.
- **Desarrollador repara**: dueño del código, dueño del arreglo.

Y esa reparación, o esa detección, es sencilla o brutal según cómo se haya construido el software. Cuatro pares de cualidades, en positivo y en negativo:

| Mantenible | No mantenible |
|:-:|:-:|
| **Fluido**: se puede entender con facilidad | **Viscoso**: no se puede entender con facilidad |
| **Flexible**: se puede cambiar con facilidad | **Rígido**: no se puede cambiar con facilidad |
| **Fuerte**: se puede probar con facilidad | **Frágil**: no se puede probar con facilidad |
| **Reusable**: se puede reutilizar con facilidad | **Inmóvil**: no se puede reutilizar con facilidad |

El par que le toca directamente a esta charla es fragilidad contra fortaleza. Un ejemplo real, en positivo, de un proyecto en marcha ahora mismo, desarrollado por una sola persona con varios LLM como programadores, bajo un proceso con los mismos roles separados de los que habla esta charla: quien construye no es quien da el visto bueno, y cada entrega se revisa con evidencia real antes de aceptarla, no con un "ya lo he probado".

Al introducir `CursoAcademico` como concepto nuevo, el sistema siguió funcionando en apariencia. Con un solo curso académico activo en producción, la suite de 777 tests seguía entera en verde. Pero nueve puntos distintos del código -- el listado de guías del profesor, la Auditoría, la importación de contenido entre asignaturas hermanas, los scripts de siembra de datos -- asumían en silencio que solo existiría un curso académico para siempre. Nadie había escrito esa suposición en ningún sitio: se heredó de cómo se construyó cada pieza por separado, en momentos distintos.

Ningún test lo detectó fallando. Lo detectó el propio proceso: antes de seguir añadiendo nada más, se paró explícitamente a auditar el diseño completo ("asegúrate de que los elementos que deben estar asociados al curso académico lo están"). Cada uno de los nueve puntos se cerró por separado, revisado con evidencia real antes de darlo por bueno, sin que ninguna corrección generara un problema nuevo.

Eso es lo que separa un sistema frágil que sobrevive de uno que no: no evitar la fragilidad -- casi imposible en cualquier sistema que crece por iteración -- sino tener un proceso que la encuentra antes de que la encuentre un usuario real.

Vocabulario que un equipo necesita compartir para que esto no sea ambiguo:

| Término | Qué es | Confusión habitual |
|---|---|---|
| QA *vs* <br>QC *vs* <br>Testing | QA = proceso (prevenir defectos).<br>QC = producto (detectarlos), mediante cuatro técnicas que se detallan en ¿Cómo?.<br>Testing es solo una de esas cuatro. | Llamar "QA" a "los que testean" ya es síntoma de falta de rigor. |
| Defecto *vs*<br>Fallo | Defecto: error en el artefacto.<br>Fallo: su manifestación observable en ejecución. | Un defecto puede vivir meses sin fallar. No detectarlo no es "no pasa nada", es un fallo silencioso en espera. |
| Severidad *vs*<br>Prioridad | Severidad: impacto técnico.<br>Prioridad: urgencia de negocio. | Se mezclan constantemente al priorizar la lista de defectos pendientes. |

Un par aparte, porque no es una fila más de la tabla: **verificación** y **validación**. En español se juegan en el orden de dos palabras -- "hacerlo correcto" (verificación: ¿el código cumple lo que el propio código promete?) y "hacer lo correcto" (validación: ¿era eso lo que realmente hacía falta?). No son alternativas -- **"vs" es la palabra equivocada aquí** --, son dos preguntas distintas y hace falta responder las dos, no una en vez de la otra.

Un test unitario, por diseñado que esté, solo puede responder a la primera. Nunca a la segunda: no existe ningún test que compruebe si el propio requisito que está verificando era el correcto, porque el test nace del mismo sitio que el requisito. Caso real: una suite de más de 700 tests puede quedar entera en verde -- verificación perfecta -- mientras a la funcionalidad entregada le faltan piezas enteras que nadie escribió como requisito en ningún sitio, porque el hueco estaba en el encargo, no en el código. Eso no lo encuentra ningún test, por definición: hace falta alguien releyendo el encargo original contra lo entregado, no el código contra sí mismo. Las pruebas que hacen falta *además de* las unitarias no son "más pruebas del mismo tipo" -- son pruebas que miran hacia fuera del código, no hacia dentro.

## ¿Para qué?

|||||
|-|-|-|-
Separar diagnóstico de reparación evita que el límite se disuelva junto con la responsabilidad de quién responde de qué.|Y resuelve, de raíz, el problema real: **"ya lo he probado" dicho por un desarrollador no es evidencia, es una afirmación.**|Verificar con evidencia directa antes de dar algo por bueno no es desconfianza personal, es el motivo por el que el rol de pruebas existe como rol separado.|Dicho más corto: **prevenir cuesta menos que corregir.**

Esa "evidencia directa" no distingue jerarquías: en el mismo proyecto, quien iba a desplegar una migración de base de datos no siguió a ciegas la instrucción recibida de quien coordinaba ("primero migra, luego despliega") -- comprobó el esquema real en producción, vio que la tabla nueva todavía no existía, y preguntó antes de seguir. La instrucción estaba mal: para ese cambio concreto el orden correcto era el contrario. Nadie perdió autoridad por preguntar en vez de obedecer -- se evitó un despliegue roto. La instrucción de quien coordina tampoco es evidencia por sí sola; solo lo es el estado real del sistema.

## ¿Cómo?

Las cuatro técnicas con las que se hace Control de Calidad:

| Técnica | En qué consiste | Naturaleza | Responsabilidad típica |
|---|---|---|---|
| Revisar | Repaso informal del código, iniciado por el propio autor, sin checklist. | Estática: se lee el código, no se ejecuta. | El propio desarrollador, antes de entregar. |
| Inspeccionar | Repaso formal, iniciado por el equipo, con checklist y moderador. | Estática: se lee el código, no se ejecuta. | Alguien que no lo construyó -- QA u otro desarrollador, nunca el autor. |
| Probar | Ejecutar el software para comprobar su comportamiento frente a casos concretos. | Dinámica: se ejecuta el código y se compara el resultado con lo esperado. | Desarrollador a nivel de unidad; QA a nivel de integración y sistema. |
| Depurar | Localizar y corregir, dentro del propio código, la causa de un fallo ya detectado. | Dinámica: se ejecuta el código para localizar la causa del fallo. | Siempre el desarrollador -- dueño del código, dueño del arreglo. |

Un test unitario cae sin ambigüedad en Probar, no en Inspeccionar: es ejecución, no lectura. Y lo que hace QA también cae en Probar, no es una técnica distinta: la diferencia con el test unitario del desarrollador es el nivel (integración y sistema, no unidad) y el rol (QA planifica, diseña con trazabilidad y evalúa el resultado; no solo ejecuta y da por bueno).

Y esto es lo que rompe el límite en un equipo sin rigor, con ejemplos fácilmente reconocibles:

- Pruebas solo al final, todo de golpe, que contradice la naturaleza iterativa del propio proceso.

- Reportes de defecto sin pasos de reproducción ni evidencia (capturas, logs, entorno).

- Sin trazabilidad caso de uso -> caso de prueba: nadie sabe qué parte del sistema no se ha tocado.

- Criterios de entrada/salida inexistentes o informales ("cuando esté tranquilo lo paso a producción").

- QA proponiendo el arreglo técnico, o el desarrollador decidiendo unilateralmente qué no hace falta probar.

Un equipo con este límite claro, en cambio, **rara vez** discute en la incidencia quién tiene la culpa, **rara vez** repite la pregunta "¿esto es tuyo o mío?", y **rara vez** descubre en producción algo que ya sabía que no había probado.

## ¿Y ahora qué?

> "Las buenas prácticas no son suficientes por sí mismas, tienen que entenderse bajo un conjunto de valores y principios que permiten al equipo comportarse como una unidad con un objetivo común."
> — Kent Beck, *Extreme Programming Explained*

Un fallo en producción no es un fracaso del desarrollador ni de QA individualmente, es que el proceso no hizo ruido a tiempo. Eso se audita, no solo se cierra la incidencia.

---

**Fuentes de la cita RUP**: tabla de roles en `idsw1/temario/00002-rup.md`; actividad "Realizar Pruebas de Integración" en el material de Luis (`3-publicaciones/USantaTecla/5-rup/5-pruebas`), adaptación directa del Rational Unified Process; corroborado externamente por OpenUP (Eclipse Process Framework, derivado abierto oficial de RUP), que define **Developer** y **Tester** como roles separados.

**Fuente de las fases de madurez**: Boris Beizer, *Software Testing Techniques*, tal como aparece recogido en el material de Luis (`3-publicaciones/USantaTecla/4-pruebas/0-itinerario`).

**Fuente de Calidad/QA/QC y las técnicas de Control de Calidad**: apartado "Gestión de Calidad Software" del mismo material de Luis (`3-publicaciones/USantaTecla/4-pruebas/0-itinerario`, sección ¿Cómo?).

**Fuente de las cuatro cualidades de mantenibilidad**: mismo concepto en el material de Luis (imágenes `arbolMantenible`/`arbolNoMantenible` de `3-publicaciones/USantaTecla/4-pruebas/0-itinerario`) y desarrollado con ejemplos propios en `idsw2/temario/00-introduccion/proyectosSoftware.md`.
