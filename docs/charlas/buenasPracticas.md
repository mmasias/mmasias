# Buenas prácticas: de la intención al mecanismo

<div align=right>

[***2Think***](https://github.com/mmasias/idsw1/blob/main/temario/2think.md)

</div>

<!-- Reparto orientativo para 20 minutos: ¿Por qué? 4' · ¿Qué? 4' · ¿Para qué? 2' · ¿Cómo? 8' · #2Think y cierre 2' -->

> "No existe ningún desarrollo, ni en tecnología ni en técnica de gestión, que por sí solo prometa siquiera una mejora de un orden de magnitud en productividad, fiabilidad o simplicidad en una década."
> — Fred Brooks, *No Silver Bullet* (1986)

## ¿Por qué?

La [charla anterior](2QA/charla001.md) dejó una distinción: el control de calidad (QC) detecta defectos en el producto ya construido, el aseguramiento de calidad (QA) los previene mejorando el proceso que lo construye. Esta charla es la segunda mitad: qué prácticas concretas forman ese proceso y por qué la mayoría de las listas de "buenas prácticas" no lo forman.

### Lo caro ha cambiado de sitio

Brooks separaba la complejidad del software en dos tipos: la **esencial**, la del problema (qué hay que construir y cómo encaja) y la **accidental**, la de las herramientas (escribir, compilar, desplegar). Cuarenta años de lenguajes, IDE y frameworks han atacado la accidental. Los LLM son el ataque más fuerte hasta la fecha contra la más visible de todas: teclear código.

Un proyecto real, en producción, desarrollado por una persona con varios LLM como programadores: [pyCelda](https://github.com/mmasias/pyCelda), gestión del ciclo de vida de las guías docentes de una universidad.

<div align=center>

|Medida|Valor|
|-|-|
|Definición antes de la primera línea de código|3,5 semanas, 151 commits, cero código|
|Código de producto (sin tests)|47.728 LoC|
|Tests|1.035 funciones, 21.451 LoC, ratio test:código backend ~0,96:1|
|Documentación de proceso (RUP)|57.460 líneas, 124 casos de uso especificados|
|Historia|1.076 commits, 390 pull requests|
|En uso|16 programas, 775 guías docentes|

</div>

La conclusión que el propio proyecto saca de sus datos: aislando el esfuerzo de codificar, los primeros 20.000 LoC caben en aproximadamente una semana de trabajo. Lo que no cabe en una semana es el calendario, porque el pensamiento se hizo por delante y a fondo.

Si escribir código deja de ser el cuello de botella, el cuello de botella pasa a ser **decidir qué escribir** y **comprobar que lo escrito es lo que se decidió**. Ninguna de las dos se acelera con más velocidad de escritura. Las dos empeoran con ella: más código por día es más supuestos por día sin escribir y más superficie por día sin revisar.

No es un problema nuevo, solo más visible. Las causas de fracaso de proyectos que se manejan desde la [crisis del software](https://github.com/mmasias/idsw2/blob/main/temario/00-introduccion/crisisSoftware.md) ya lo decían:

<div align=center>

|Categoría|Incidencia|
|-|-|
|Requisitos (especificaciones poco claras, cambiantes, expectativas irreales)|35,3%|
|Gestión (usuario no involucrado, falta de apoyo, plazos irreales)|31,0%|
|Tecnología (deficiente o nueva)|10,7%|
|Otros|23,0%|

</div>

La tecnología es la categoría minoritaria. Un LLM ataca precisamente esa y deja intactas las dos que suman dos tercios.

### El problema de las listas

El 12 de junio de 2025, Google Cloud sufrió una caída global de varias horas que arrastró consigo a servicios de terceros. El 29 de mayo se había desplegado en Service Control, el componente que autoriza y aplica cuotas a las llamadas de API, una comprobación de cuotas nueva. Ese código no manejaba datos vacíos y no estaba protegido por un feature flag. Dos semanas después, una política con campos en blanco, replicada a todas las regiones, recorrió ese camino por primera vez: null pointer y procesos en bucle de reinicio, en todas las regiones a la vez. El [informe de Google](https://status.cloud.google.com/incidents/ow5i3PPK96RduMcb1SsW) lo dice sin rodeos: con el cambio protegido por un flag, el problema se habría detectado en staging.

Google no desconoce los feature flags ni el despliegue gradual por regiones; los usa como norma. El fallo no fue de conocimiento, fue de mecanismo: que ese cambio concreto pasara por un flag dependía de que alguien lo pusiera.

Las instrucciones con las que se trabaja con agentes LLM en este mismo entorno lo dicen de forma explícita a propósito de unas reglas tipográficas triviales: se aplican por post-proceso determinista y no como instrucción, porque *"un LLM las violará tarde o temprano, un proceso determinista no"*. La frase sigue siendo cierta si se cambia "LLM" por "persona".

## ¿Qué?

Una buena práctica no es un consejo. Es una decisión sobre el proceso con tres propiedades:

<div align=center>

|Anticipada|Orientada al cambio|Verificable|
|-|-|-|
|Se toma antes de que haga falta, no en el momento en que falla.|Su objetivo es abaratar el siguiente cambio, no embellecer el actual.|Se puede comprobar si se ha cumplido, sin preguntárselo a quien debía cumplirla.|

</div>

La segunda propiedad tiene una métrica final, ya conocida: un sistema mantenible es **fluido** (se entiende), **flexible** (se cambia), **fuerte** (se prueba) y **reusable**. Lo contrario, viscoso, rígido, frágil e inmóvil, rara vez es fruto de una mala decisión aislada: es la acumulación de **complejidad arbitraria**, decisiones que nadie tomó explícitamente.

La tercera propiedad es la que separa una práctica de una intención y admite niveles:

<div align=center>

|Nivel|Forma|Quién la hace cumplir|Cómo falla|En pyCelda|
|-|-|-|-|-|
|**Intención**|"Hay que tener cuidado con los permisos"|Nadie|En silencio|Endpoints del profesor sin verificar la pertenencia del recurso, dos de ellos sin autenticación (#96)|
|**Norma escrita**|Guía de estilo, `CLAUDE.md`, convención en un README|Quien la lee, si la lee|Con prisa, o cuando cambia quien la escribió|"Un diagrama consolidado es documento vivo": regla escrita y aun así incumplida por el propio revisor ([#213](https://github.com/mmasias/pyCelda/discussions/213))|
|**Checklist**|Lista de revisión transversal|Quien revisa, sin depender de su memoria|Cuando la lista no cubre la categoría del defecto|El checklist de autorización cazó el IDOR de cuerpo de petición que los tests por caso de uso no veían (#210)|
|**Mecanismo**|Test, restricción de BD, CI, hook|El sistema|Con ruido y antes de producción|Unicidad de `Programa.codigo` como restricción, tras un programa duplicado en producción (#148)|

</div>

Subir de nivel cuesta y no toda práctica merece llegar arriba. El criterio es el mismo que en la charla anterior: frecuencia por coste del fallo. Una regla tipográfica sube a mecanismo porque se aplica miles de veces; una política de autorización sube a mecanismo porque un solo fallo es un incidente de seguridad.

Y hay un techo. La charla anterior lo dejó claro: verificar (hacerlo correcto) se puede automatizar, validar (hacer lo correcto) no. Eso divide las buenas prácticas en dos familias:

<div align=center>

|Prácticas que deciden|Prácticas que comprueban|
|-|-|
|Fijan qué se construye y con qué supuestos.|Comprueban que lo construido cumple lo decidido.|
|No se automatizan: requieren a alguien leyendo el encargo contra la realidad.|Deben automatizarse en cuanto se repiten.|
|Su mecanismo es un artefacto barato y revisable: una discussion, un diagrama, un caso de uso.|Su mecanismo es un test, una restricción, un pipeline.|

</div>

## ¿Para qué?

||||
|-|-|-|
|**Coste de cambio predecible.** El catálogo de pyCelda pasó de 91 a 124 casos de uso después de "cerrarse" y cada uno nuevo entró con el mismo ciclo completo que los originales, sin rediseño.|**Defectos encontrados y medidos por el proceso, no por el usuario.** La auditoría transversal de pyCelda dio una tasa de escape de 2 defectos sustantivos y 1 menor sobre 91 casos de uso ([#92](https://github.com/mmasias/pyCelda/discussions/92)): los tres de autorización, los tres cazables con un checklist. Es una cifra, no una sensación.|**Independencia de quién escribe.** En pyCelda el código lo escribieron varios agentes distintos; uno de ellos se sustituyó por bajo rendimiento sin cambiar una sola regla del proceso. Un equipo con rotación de personas tiene exactamente el mismo problema.|

Y un cuarto, menos evidente: **el conocimiento sobrevive a quien lo tuvo**. Los agentes de pyCelda no tienen memoria entre sesiones; lo que cada uno "sabe" al empezar se reconstruye desde lo que el proceso dejó escrito. Un equipo humano funciona igual, solo que tarda más en notarlo: el día que se va la persona que "sabía cómo se despliega".

### Por qué cuesta adoptarlas

Si compensan, ¿por qué no las aplica todo el mundo? Porque el coste de una práctica preventiva es visible e inmediato (el tiempo de escribir el test, de cerrar la discussion, de montar el CI) y su beneficio es invisible por definición: **no se ven los defectos que no se cometieron**. Se tiende a infravalorar lo difuso y tardío frente a lo concreto y cercano; la mayoría de equipos no cruza ese umbral hasta que un incidente lo hace visible.

La presión de plazo agrava el sesgo. Beck lo formuló con las cuatro variables de un proyecto (ámbito, tiempo, coste, calidad): fuera se eligen tres, el equipo determina la cuarta; cuando fuera se pretende fijar las cuatro, *"la calidad siempre desaparece"*. Una práctica en nivel de intención es lo primero que desaparece con ella. Una práctica en nivel de mecanismo no pregunta si hay prisa.

## ¿Cómo?

Ocho prácticas, ordenadas por el momento en que se aplican. Todas tienen evidencia verificable en el mismo proyecto.

<div align=center>

|Antes de construir|Al construir|Al entregar|Después|
|-|-|-|-|
|1. Decidir en el artefacto barato<br>2. Escribir los supuestos|3. Rebanada vertical<br>4. Una sola fuente de verdad|5. Evidencia, no resumen<br>6. Lo transversal, transversalmente<br>7. Automatizar lo que se repite|8. El proceso se audita a sí mismo|

</div>

### Antes de construir

**1. Decidir en el artefacto barato antes que en el caro.** Cambiar una decisión en una discussion cuesta minutos; en un diagrama, una hora; en código desplegado con datos reales, días. En pyCelda cada decisión de criterio se cierra en una GitHub Discussion antes de escribir el código que la aplica. La primera rebanada de análisis empezó con 4 casos de uso, creció a 7 y se detuvo en 9: el sobrediseño se detectó en análisis, no en código. Matiz necesario: esto no es "documentación primero", la metodología de pasarse el proyecto escribiendo documentos y programar el último día. Lo que se adelanta son las decisiones, no el volumen de papel; y cada decisión se contrasta pronto contra código real (práctica 3) y contra datos reales: el extractor de los documentos reales y la primera carga de datos aparecieron el segundo día del proyecto.

**2. Escribir los supuestos y, si se puede, convertirlos en restricciones.** El defecto más caro es el supuesto que nadie escribió. Dos veces el mismo patrón en pyCelda: nueve puntos del código asumían en silencio que solo existiría un curso académico, con 777 tests en verde; después, una función de asignación asumía que profesor y asignatura pertenecían siempre a la misma universidad, un IDOR entre universidades cazado en revisión antes del merge (commit [`185f97f`](https://github.com/mmasias/pyCelda/commit/185f97fcc72be57c7dbafb4dff7562c2c395a464)). Fuera de pyCelda, el mismo patrón tumbó buena parte de [Cloudflare el 18 de noviembre de 2025](https://blog.cloudflare.com/18-november-2025-outage/): la consulta que genera un fichero de configuración asumía, sin decirlo en ningún sitio, que solo vería una base de datos; un cambio de permisos le hizo ver otra, el fichero duplicó su tamaño, superó un límite fijo del proxy y el proxy cayó. Un supuesto escrito se puede revisar; un supuesto convertido en restricción (una FK, una unicidad, un test de regresión) ya no depende de que nadie lo revise. La FK `ActividadPrograma -> Actividad` estaba en el modelo de dominio desde el primer día y faltó en la base de datos hasta que una funcionalidad posterior la necesitó (#181).

### Al construir

**3. Rebanada vertical, no olas de fase.** Cada caso de uso atraviesa análisis, diseño, desarrollo y pruebas en el mismo pull request. La alternativa, "primero todo el diseño, luego todo el código", acumula supuestos sin contrastar durante semanas. En pyCelda la primera rebanada cruzó las tres fases en un solo día y sirvió para calibrar el método antes de delegar el resto.

**4. Una sola fuente de verdad: lo derivado se genera o se mide, no se copia.** La auditoría de pyCelda encontró que ninguna cifra "oficial" coincidía con la real: el resumen decía 96 casos de uso, el README 99, el árbol tenía 102. Cada documento quedó congelado en su fecha de escritura. La única fuente que cuadraba era el panel de seguimiento, generado desde el propio árbol. Un número escrito a mano en un README empieza a ser falso al día siguiente; el diccionario de datos mantenido a mano tuvo el mismo problema (#260).

### Al entregar

**5. Evidencia, no resumen.** Quien construye no es quien da el visto bueno; el visto bueno se da contra el sistema real. Cada entrega de un agente se re-ejecuta en un clon dedicado: tests, compilación, render. Nunca se acepta el resumen del agente que escribió el código, ni el del propio revisor. Es la regla de la charla anterior aplicada al día a día: "ya lo he probado" es una afirmación, no evidencia. Una instrucción de quien coordina tampoco lo es.

**6. Lo transversal se revisa transversalmente.** Un test por caso de uso verifica ese caso de uso. La autorización, la concurrencia, la transaccionalidad, el manejo de errores o la migración de datos atraviesan todos: un defecto ahí no es visible desde ninguno en particular. Son además, justamente, lo que una especificación de requisitos no contesta por rigurosa que sea: lo decide el diseño o, si nadie lo decide, el código el día que se descubre que faltaba. pyCelda tuvo dos auditorías de autorización: la segunda encontró 44 puntos de endpoints del director de programa sin verificar que el director dirige el recurso (#86). De ahí nació un checklist transversal, que después cazó un vector nuevo: el identificador ajeno inyectado en el cuerpo JSON en vez de en la ruta. Con la misma lógica, antes de cualquier merge que cambie el comportamiento observable de un caso de uso, se revisan todos los casos de uso que leen o escriben el mismo agregado: la lista completa primero, un commit después.

**7. Automatizar lo que se repite, desde el primer commit.** Larry Wall atribuía al buen programador tres virtudes: pereza, impaciencia y arrogancia. La primera es la que interesa aquí: aversión al trabajo repetido, que se traduce en no comprobar a mano dos veces lo mismo. pyCelda funcionó semanas sin CI porque la verificación ocurría "en el flujo del agente". Una auditoría externa lo señaló como riesgo y se añadió. En su primer minuto de vida el CI encontró dos defectos reales que dos rondas de revisión no habían visto: una versión de `httpx` que rompía el cliente de test y una instalación de dependencias incompatible con el Python del runner. Hay prácticas que no esperan a la fase de construcción: el escaneo de secretos y la auditoría de variables de entorno (sin claves en el código, `.env` fuera del repositorio, sin secretos en el bundle del frontend) son condición de entrada al repo, no tarea pendiente.

### Después

**8. El proceso se audita a sí mismo.** Cuando algo se desvía, la pregunta no es solo qué falló en el código sino qué parte del proceso no hizo ruido. La [retrospectiva #213](https://github.com/mmasias/pyCelda/discussions/213) de pyCelda es literal en eso: el revisor comprobó que los 426 tests pasaban y que el diff era correcto, pero no que la documentación de diseño de una función cuyo comportamiento cambió se hubiera actualizado. *"No lo necesitaba para funcionar, así que pasó."* Desenredarlo costó cuatro rondas. El resultado no fue un arreglo puntual sino una regla nueva del método: el checkpoint "documentación antes que código". Los retrocesos a fases anteriores se documentan como parte del método, no se esconden como fallos.

### Qué evitar

Todo equipo conoce las [excusas](../laCojudez/excusasCojudas.md): "funciona en mi máquina", "pensé que alguien más lo arreglaría". Ambas son la misma cosa dicha en voz alta: una práctica que no existe como mecanismo (entorno reproducible en la primera, responsable asignado en la segunda). Los patrones menos graciosos, igual de reconocibles en equipos que "tienen buenas prácticas":

- La práctica existe solo en la cabeza de una persona, o en un documento que nadie abre desde que se escribió.
- Las cifras del estado del proyecto (cobertura, número de endpoints, versiones) escritas a mano en documentos que nadie regenera.
- Reglas que solo se cumplen cuando no hay prisa: si una regla se suspende bajo presión, no era una regla, era una preferencia.
- Revisiones que comprueban que el código funciona pero no que lo que lo rodea (documentación, migraciones, casos de uso vecinos) sigue siendo cierto.
- Incidentes cerrados con el arreglo del código y sin preguntar qué mecanismo debería haberlo detectado antes.
- Adoptar agentes LLM para escribir más rápido sin cambiar nada en cómo se decide y cómo se verifica: es multiplicar la velocidad a la que se acumulan los supuestos sin escribir.

### Validación

Una buena práctica se justifica con datos propios, no con su popularidad:

- **Fuga de defectos**: porcentaje de defectos que aparecen en producción en vez de antes. Si no baja, la práctica no está actuando.
- **Coste del cambio**: cuánto tarda en entrar un requisito nuevo de tamaño conocido. Si crece con el tamaño del sistema, la complejidad arbitraria está ganando.
- **Preguntas de memoria**: cada vez que alguien dice "¿quién se acordaba de...?", hay una práctica en nivel de intención que debería subir de nivel.

## #2Think

- De las prácticas que el equipo dice tener, ¿cuántas están en nivel de mecanismo y cuántas en nivel de intención?
- ¿Qué supuesto de diseño del sistema actual no está escrito en ningún sitio? ¿Qué pasaría si mañana dejara de ser cierto?
- ¿Cuál es la cifra del estado del proyecto que más se cita en las reuniones? ¿Se mide o se copia?
- ¿Qué categoría de defecto no puede detectar ningún test unitario del equipo, porque no pertenece a ninguna unidad?
- Del último incidente, ¿qué regla del proceso cambió como consecuencia?
- Si el equipo empezara a usar agentes LLM mañana, ¿qué parte del proceso actual dejaría de ser suficiente?

## ¿Y ahora qué?

El código barato no hace barato el software: traslada el coste a decidir y a comprobar. Las buenas prácticas son los mecanismos que mantienen ese coste bajo. Se distinguen de los buenos propósitos por una pregunta: ¿se cumple sin que nadie tenga que acordarse?

### Bibliografía

|||
|-|-|
|*The Mythical Man-Month* (edición 20º aniversario, incluye *No Silver Bullet*)|Frederick P. Brooks Jr. - Addison-Wesley|
|*Code Complete*, 2ª edición|Steve McConnell - Microsoft Press|
|*The Pragmatic Programmer*, 20th Anniversary Edition|David Thomas, Andrew Hunt - Addison-Wesley|
|*Extreme Programming Explained*, 2ª edición|Kent Beck - Addison-Wesley|
|[Del proceso de software a la calidad: límites y responsabilidades](2QA/charla001.md)|Charla anterior|
|[Ingeniería de software: requisitos](https://github.com/mmasias/idsw1)||
|[Ingeniería de software: diseño](https://github.com/mmasias/idsw2)||
