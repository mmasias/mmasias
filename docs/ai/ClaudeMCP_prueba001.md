# CORRAL — Prueba 001: Evaluación del nombre del proyecto

Demostración del flujo de orquestación multi-agente del sistema CORRAL aplicado a sí mismo: Claude lanza dos agentes en paralelo para evaluar el nombre del proyecto, recoge sus análisis y debate los resultados.

---

## Contexto

Durante el desarrollo del sistema de orquestación multi-agente, se propone el nombre **CORRAL** como identidad del proyecto:

> **C**laude **O**rchestrated **R**untime for **R**emote **A**gent **L**ogic

La pregunta es si el acrónimo es técnicamente honesto y si la metáfora del corral comunica bien la arquitectura del sistema. En lugar de resolverlo internamente, se somete al juicio de los propios agentes subordinados — que son, a la vez, objeto del análisis y herramienta del mismo.

---

## Prompt enviado a ambos agentes

El mismo prompt, adaptado al nombre de cada agente:

```
Se está nombrando un proyecto de software. El nombre propuesto es CORRAL,
acrónimo de "Claude Orchestrated Runtime for Remote Agent Logic". El proyecto
es un sistema de orquestación multi-agente donde Claude Code actúa como
orquestador y otros agentes LLM (como tú mismo) actúan como nodos de ejecución
subordinados invocados via protocolo MCP.

Evalúa el nombre y el acrónimo. Considera: precisión técnica del acrónimo,
resonancia semántica del término "corral" en el contexto de agentes de IA,
si el nombre comunica bien lo que hace el sistema, y cualquier connotación
positiva o negativa relevante.

Escribe tu análisis en un fichero llamado corral_[agente].md. Sé directo y breve.
```

Ambos jobs lanzados en paralelo (async) sobre el mismo `workdir`:

| Agente | job_id | Fichero producido |
|---|---|---|
| Gemini | `9012afe3` | `corral_gemini.md` |
| OpenCode / GLM-5.1 | `1c0a2967` | `corral_opencode.md` |

---

## Respuesta de Gemini

> Rol en el sistema: verificador / critic

---

**Precisión técnica del acrónimo**

El acrónimo CORRAL (Claude Orchestrated Runtime for Remote Agent Logic) es técnicamente sólido y descriptivo:
- "Claude Orchestrated": identifica claramente la tecnología de control y su rol funcional.
- "Runtime": define el sistema como un entorno de ejecución dinámico, no solo un framework estático.
- "Remote Agent Logic": describe con precisión la naturaleza desacoplada de los nodos de ejecución invocados vía MCP.

**Resonancia semántica y metáfora**

El término "corral" es altamente efectivo en el contexto de agentes de IA:
- Contención y control: sugiere un entorno seguro donde los agentes operan bajo reglas definidas.
- Gestión de rebaño: evoca la gestión de múltiples entidades autónomas bajo una dirección central.
- Seguridad (AI Safety): la idea de cercar o delimitar el alcance de la IA es un concepto central en la seguridad actual.

**Connotaciones**
- Positivas: organización, robustez, seguridad, arquitectura clara (Hub-and-Spoke).
- Negativas: podría interpretarse como limitante para la autonomía de los agentes subordinados — lo cual es, de hecho, una característica deseada en este diseño.

**Conclusión:** el nombre es excelente. Logra un equilibrio poco común entre un acrónimo que mantiene sentido técnico y una metáfora visual potente que facilita la comprensión intuitiva de la arquitectura.

---

## Respuesta de OpenCode / GLM-5.1

> Rol en el sistema: arquitecto / generador

---

**Precisión técnica del acrónimo**

Las siglas mapean correctamente: C-O-R-R-A-L. El problema está en la cohesión interna.

"Claude Orchestrated" y "Runtime" son precisos. "Remote Agent Logic" es donde se fuerza la mano. Un runtime no ejecuta "lógica" de agentes; ejecuta *agentes* o *tareas*. "Logic" está ahí para completar la L, no porque sea la palabra más precisa. Alternativas más honestas: "Remote Agents Layer", "Remote Agent Loop", "Routed Agent Link".

La expansión funciona, pero delata que se llegó al acrónimo antes que al nombre completo.

**Resonancia semántica de "corral"**

Positivo:
- El verbo "to corral" captura exactamente la función del orquestador: reunir agentes dispersos y dirigirlos hacia un objetivo.
- Evoca la metáfora de "herding cats": gestionar entidades autónomas que tienden a dispersarse.
- Es corto, memorable, fácil de pronunciar. Funciona bien como comando de CLI (`corral run`, `corral deploy`).
- Tiene registro coloquial sin ser informal: suena a herramienta de trabajo, no a producto de marketing.

Negativo:
- Un corral contiene ganado. La metáfora implícita — que los agentes subordinados son "ganado" que el ranchero (Claude) mustrea — puede resultar reductiva si se interpreta literalmente.
- "Corral" evoca confinamiento. En un contexto donde la narrativa dominante es sobre autonomía y expansión de capacidades, un nombre que sugiere *restricción* transmite el mensaje equivocado si no se matiza.
- En español, "corral" tiene resonancias rurales neutras, pero también aparece en "corralito" (restricción financiera en Argentina). Dependiendo de la audiencia hispanohablante, puede haber connotación involuntaria.

**¿Comunica lo que hace el sistema?**

No directamente. "Corral" no sugiere orquestación, agentes, ni IA sin conocer el acrónimo. Pero esto es estándar en nombres de proyecto (Kubernetes = "helmsman", Kafka = escritor checo). Lo importante es que una vez conoces el acrónimo, la conexión semántica refuerza la comprensión. El nombre funciona mejor como *brand* que como descriptor funcional.

**Veredicto:** nombre sólido. El acrónimo tiene una letra forzada ("Logic"), pero "corral" como metáfora de orquestación es efectivo y memorable. Las connotaciones negativas son menores y dependen del contexto cultural. Recomendado con la salvedad de revisar "Logic" por algo más preciso.

---

## Debate posterior

Los dos agentes votan a favor, pero con matices distintos que reflejan sus roles.

**Gemini** aprueba sin reservas y celebra la metáfora como señal de control y seguridad. Correcto, pero algo complaciente — en línea con su rol de verificador que confirma más que cuestiona.

**OpenCode** aprueba con una objeción técnica real: **"Logic" es la letra forzada**. Está ahí para cerrar el acrónimo, no porque sea la palabra más honesta. Propone alternativas: `Remote Agents Layer`, `Remote Agent Loop`, `Routed Agent Link`. También identifica el riesgo del "corralito" para audiencias hispanohablantes.

**La mejor alternativa de OpenCode:** `Remote Agent Loop` — un orquestador es exactamente un loop (lanzar, esperar, recoger). Quedaría:

> **C**laude **O**rchestrated **R**untime for **R**emote **A**gent **L**oop

Semánticamente más preciso, y el loop refuerza el patrón async (`_run_async` -> `_done`) que es el núcleo del sistema.

---

## Nota sobre el propio experimento

Este documento es a la vez la documentación del experimento y una demostración del patrón que documenta: Claude diseñó el prompt, lanzó los dos agentes en paralelo sin supervisión, recogió los artefactos cuando estuvieron listos, y ensambló el análisis final. Los agentes evaluaron el nombre del sistema que los orquesta sin saber que lo estaban haciendo.
