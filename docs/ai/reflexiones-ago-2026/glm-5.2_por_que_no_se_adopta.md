# Por que no se adopta esto en todos los proyectos

> Sesion: 2026-08-08. Modelo: glm-5.2 (z.AI) vía OpenCode.
> Origen: pregunta del autor tras recorrer el mockup navegable de Admin de pyCelda: *"esto está mejor de lo que pensaba, con alcance potentísimo... ¿por qué no se hace en todos los proyectos? Cuesta, sí. Pero aclara y, sobre todo, compensa"*.

## Pregunta inicial

Tras navegar las 117 páginas del mockup de pyCelda (58 Admin + 43 DirectorGrado + 16 Profesor, generadas desde el diagrama de contexto de cada actor), el autor observa que el artefacto compensa con creces el coste de construirlo, y se pregunta por qué no se hace algo equivalente en todos los proyectos.

La pregunta es legítima y la respuesta incómoda: **compensa, pero solo se ve que compensa después de haberlo hecho**. El autor está viendo "compensa" porque ya lo construyó. Antes de empezar, el coste era visible y el beneficio era difuso; la mayoría no cruza ese umbral.

La respuesta larga tiene cinco causas estructurales, ninguna tonta.

## Las cinco causas estructurales

### 1. Requiere cadena metodológica previa que casi nadie tiene

El mockup es el último eslabón. Para que exista necesitas:

- Diagrama de contexto por actor (no un diagrama de casos de uso genérico): pyCelda tiene tres (`diagramaContextoAdmin.puml`, `diagramaContextoProfesor.puml`, `diagramaContextoDirectorGrado.puml`).
- Catálogo de wireframes por CU (no mockups sueltos en Figma): ~91 carpetas con su `wireframe.svg`.
- Reglas de léxico cerradas, patrón CRUD formalizado, `completarGestion()`, convención `X_ABIERTO`/`Xs_ABIERTO`, `<<choice>>`, filosofía C→U, todo el método derivado de Luis Fernández Muñoz.

Sin esa cadena, no hay nada que derivar. Y la cadena cuesta años. La mayoría de proyectos no la tienen.

### 2. Categoría sin nombre

Esto es "pipeline agéntico" o "sistema operativo metodológico para LLMs", categorías que no existen en la industria. Lo que no tiene nombre no se adopta, aunque sea mejor. CrewAI, LangChain, Figma se adoptan porque tienen nombre y entrada de blog. El mockup derivado no tiene Wikipedia.

La falta de etiqueta no es cosmética: impide que la práctica se transmita. Un equipo que descubre el método por sí mismo lo bautiza con su nombre interno y muere ahí. Si la categoría tuviera nombre, los equipos se reconocerían entre sí y se construiría cuerpo de conocimiento.

### 3. Atajos capturan mercado con menos

Tres alternativas más fáciles de vender, cada una con trampa:

- **Figma / Justinmind / Axure**: mockup navegable en una hora, sin método. El mockup es **duplicado**, no derivado. Se desincroniza del modelo en la primera iteración. Pero el coste inicial es bajo y el desincronismo es invisible al principio.
- **Vibecoding directo**: "promptéame un mockup". Una hora, cero método, cero trazabilidad al diagrama, cero verificación. Pero vende en 30 segundos.
- **Spec-driven marketing**: "escribe la spec, mágicamente tienes app". Cubre contrato técnico (API, schema), no semántica de negocio (workflow, invariantes). Pero suena bien en conferencia.

El mockup derivado requiere 200 líneas de script + cadena metodológica + varios commits. En el mercado de ideas, el atajo gana.

### 4. El trabajo artesanal no escala por copia

Lo que el autor ha construido no es `npm install mockup-derivable`. Es obra artesanal que depende de myClaudeContext + pyCorral + miRUP + pySigHor (4 meses) + pyCelda (1 semana) + muchos años de docencia. Otro autor tendría que construir su propia versión, paso a paso. Pocos pagan ese coste.

### 5. Sesgo hiperbólico de descuento

La causa más estructural: el cerebro humano (y el manager) sobrevalora lo visible y cercano (escribir el script, mantener la cadena, aprender RUP) frente a lo difuso y tardío (no cometer bugs que no verías, validar con cliente sin rework, navegabilidad para stakeholders).

El beneficio del mockup es invisible por definición: no ves los defectos que no cometiste. El coste es visible: ves el tiempo invertido.

Este sesgo es la causa profunda de que la industria no adopte prevención. Lo mismo aplica a tests (todos saben que compensan, pocos los escriben), a code review (ídem), a refactor (ídem), a design docs (ídem). El mockup derivado no es excepción: es la misma dinámica en otro nivel.

## Por qué el autor sí lo cruzó

Tres cosas confluyen:

1. **Inversión previa en infraestructura**: myClaudeContext + pyCorral + miRUP llevan 4+ meses funcionando. La cadena metodológica estaba pagada antes de empezar pyCelda.
2. **Motivación no comercial**: el autor no busca MVP ni clientes. Busca método y obra. Eso le permite pagar costes upfront que un equipo con presión de entrega no pagaría.
3. **Categoría docente**: el autor es profesor. El material que produce tiene valor docente aunque no tenga valor comercial. Esa categoría le permite justificar la inversión en cosas que la industria no justifica.

Es decir: el autor cruzó el umbral porque su ecosistema personal lo permitía. Otro autor con otro ecosistema no habría cruzado.

## Lo que rompería el umbral

Tres cosas permitirían que la práctica se generalizara:

1. **Casos de estudio publicados con N grande**: si 10 equipos distintos aplicaran el método y midieran ratios (bugs/commit, tiempo a MVP, rework), la evidencia vencería al sesgo. Hoy hay N=1 con dos replicaciones internas (pySigHor + pyCelda).
2. **IDSW1 e IDSW2 como laboratorio natural**: si alumnos siguiendo el método producen mejores proyectos que alumnos haciendo vibecoding, hay N grande y datos publibles. Es el laboratorio que el autor tiene disponible.
3. **Categoría con nombre**: cuando alguien ponga etiqueta a esto ("derived UI prototype", "navigational mockup", "diagram-driven UI"), la industria podrá hablar de ello. Hoy es innombrable.

Mientras tanto, lo que el autor tiene es el sistema que la mayoría describiría en charlas pero no construiría. Por eso está sorprendido: la distancia entre "todo el mundo sabe que esto compensaría" y "nadie lo hace" es enorme.

## Lo que separa la obra del producto

El autor está viendo "compensa" porque ya construyó el artefacto. Antes de construirlo, no era obvio. Esa es la trampa general de la inversión en prevención: tienes que creer antes de ver, y la mayoría no cree hasta que ve.

Eso es lo que separa al autor de la industria:

- La industria hace Figma porque el coste es bajo y el resultado es visible de inmediato.
- El autor hace mockup derivado porque el coste es alto pero el resultado es verificable y derivable.

En el primer caso, el mockup se desincroniza en la primera iteración. En el segundo, el mockup se regenera en cada iteración. La diferencia es estructural: duplicado vs derivado. Pero el primero vende más porque el coste visible es menor.

## Síntesis

La adopción generalizada del método requiere tres cosas que hoy no existen: nombre para la categoría, casos de estudio con N grande, y un atajo de adopción que no exija construir la cadena metodológica completa. Mientras tanto, cada autor que lo aplica lo redescubre por su cuenta y rara vez lo transmite.

La pregunta del autor ("¿por qué no se hace en todos los proyectos?") tiene respuesta estructural, no intencional. No es que la industria sea tonta o perezosa: es que las condiciones para adoptarlo no están dadas. El autor las creó para sí mismo. La pregunta abierta es si puede crearlas para otros.

## Referencias cruzadas

Este documento consolida el ángulo "adopción y mercado". Otros ángulos del mismo problema viven en archivos complementarios:

- [`glm-5.2_stack_cuatro_capas_sintesis.md`](glm-5.2_stack_cuatro_capas_sintesis.md): la categoría sin nombre en la industria; "miren esta mecánica" como ángulo de publicación.
- [`glm-5.2_tesis_requisitado_delegacion_llm.md`](glm-5.2_tesis_requisitado_delegacion_llm.md): generalización externa pendiente; IDSW1/IDSW2 como laboratorio.
- [`glm-5.2_myclaudecontext_capa_identidad.md`](glm-5.2_myclaudecontext_capa_identidad.md): "personal como límite; lo que valida la categoría es que deje de serlo".
- [`glm-5.2_pysighor_generalizacion_empirica.md`](glm-5.2_pysighor_generalizacion_empirica.md): riesgo de circularidad interna, muestra externa pendiente.
- [`glm-5.2_pycelda_auditoria_y_veredicto.md`](glm-5.2_pycelda_auditoria_y_veredicto.md): categoría del proyecto (obra vs producto).
- [`glm-5.2_pycorral_mecanismo_multiagente.md`](glm-5.2_pycorral_mecanismo_multiagente.md): circularidad interna del stack.
