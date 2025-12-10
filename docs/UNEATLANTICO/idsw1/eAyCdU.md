# 2Think

## Hospital con telemedicina

- Un hospital implementa un sistema que integra consultas presenciales y telemedicina.
- Los pacientes pueden agendar citas presenciales o virtuales.
- Las recetas se envían automáticamente a farmacias externas.
- El sistema debe notificar al paciente 24 horas antes de su cita.
- Los médicos pueden solicitar interconsultas con especialistas de otros hospitales.
- El seguro médico del paciente debe validar la cobertura antes de autorizar ciertos procedimientos.
- Los resultados de laboratorios externos se importan automáticamente.
- Existe un sistema de auditoría que revisa aleatoriamente el 10% de las consultas cada mes.

<details>
<summary>🚬</summary>

|ACTORES (tienen objetivos, atacan el sistema)|NO SON ACTORES (servicios/sistemas consultados)|CONSIDERAR|
|:-:|:-:|:-:|
|¿Paciente?|¿Sistema de notificaciones?|¿Actor Tiempo para notificaciones y auditorías automáticas?|
|¿Médico?|¿Farmacia externa?|¿Especialista de otro hospital: actor o parte del sistema distribuido?|
|¿Personal administrativo?|¿Seguro médico?||
|¿Especialista externo?|¿Laboratorio externo?||
|¿Auditor?|¿Sistema de auditoría?||

</details>

## Crowdfunding

- Plataforma donde creadores proponen proyectos que requieren financiación.
- Los patrocinadores aportan dinero a cambio de recompensas.
- Existe un sistema de verificación de identidad que valida creadores mediante servicios externos.
- Los proyectos tienen fechas límite; si no alcanzan el objetivo, se devuelve el dinero automáticamente.
- Existe un comité de ética que puede suspender proyectos.
- Los creadores pueden subcontratar servicios de marketing a agencias especializadas.
- PayPal y Stripe procesan pagos.
- Un sistema de reputación calcula automáticamente la credibilidad de los creadores basándose en proyectos anteriores.
- Los medios de comunicación pueden solicitar información de proyectos destacados mediante API.

<details>
<summary>Distinguir</summary>

|ACTORES (tienen objetivos, atacan el sistema)|NO SON ACTORES (servicios/sistemas consultados)|CONSIDERAR|
|:-:|:-:|:-:|
|¿Creador?|¿Sistema de verificación de identidad?|¿Actor Tiempo para devoluciones automáticas?|
|¿Patrocinador?|¿PayPal/Stripe?|¿El mismo usuario como Creador y Patrocinador: un actor con dos roles o dos actores?|
|¿Comité de ética?|¿Sistema de reputación?|¿Agencia de marketing: actor o servicio externo contratado?|
|¿Agencia de marketing?|¿API para medios?||
|¿Medio de comunicación?|||

</details>

## Prácticas profesionales

- Los estudiantes deben realizar prácticas en empresas.
- Las empresas publican ofertas que deben ser aprobadas por coordinadores académicos antes de ser visibles.
- Un tutor académico supervisa al estudiante, mientras un tutor empresarial lo guía en la empresa.
- La universidad tiene convenios con empresas; estos convenios tienen fechas de caducidad.
- Un sistema externo de la Seguridad Social valida que el estudiante está dado de alta antes de comenzar.
- Las empresas evalúan a los estudiantes mediante formularios.
- El sistema genera automáticamente certificados cuando se completan las horas requeridas.
- Existe un proceso de resolución de conflictos donde interviene el decano.
- Los padres de estudiantes menores de edad deben autorizar electrónicamente las prácticas.
- El departamento de seguros de la universidad debe aprobar prácticas en empresas de "alto riesgo".

<details>
<summary>🚬</summary>

|ACTORES (tienen objetivos, atacan el sistema)|NO SON ACTORES (servicios/sistemas consultados)|CONSIDERAR|
|:-:|:-:|:-:|
|¿Estudiante?|¿Seguridad Social?|¿Actor Tiempo para vencimiento de convenios?|
|¿Empresa?|¿Generación automática de certificados?|¿Tutor académico y tutor empresarial: un actor Tutor con especialización o dos actores distintos?|
|¿Coordinador académico?||¿Decano: actor que ataca con objetivo propio o rol administrativo que se invoca?|
|¿Tutor académico?|||
|¿Tutor empresarial?|||
|¿Decano?|||
|¿Padre/tutor legal?|||
|¿Departamento de seguros?|||

</details>

## Trading

- Plataforma donde inversores compran y venden acciones.
- Existen traders humanos y algoritmos de trading automatizado que operan según condiciones del mercado.
- Un organismo regulador (CNMV) puede suspender operaciones en cualquier momento.
- El sistema debe detener automáticamente la operativa si detecta movimientos anormales (circuit breakers).
- Los brokers intermedian entre inversores y el sistema.
- Analistas publican recomendaciones que pueden ser consultadas.
- Existe un servicio de datos de mercado que alimenta información en tiempo real desde múltiples bolsas mundiales.
- Los auditores externos requieren acceso de lectura para verificar cumplimiento normativo.
- El sistema ejecuta automáticamente órdenes condicionadas (stop-loss, take-profit) cuando se alcanzan ciertos precios.

<details>
<summary>🚬</summary>

|ACTORES (tienen objetivos, atacan el sistema)|NO SON ACTORES (servicios/sistemas consultados)|CONSIDERAR|
|:-:|:-:|:-:|
|¿Inversor?|¿Servicio de datos de mercado?|¿Algoritmo de trading: actor autónomo con objetivo propio o configuración del inversor?|
|¿Trader humano?|¿Circuit breakers?|¿CNMV: actor que ataca para supervisar o autoridad que se consulta?|
|¿Algoritmo de trading?|¿Ejecución automática de órdenes condicionadas?|¿Circuit breakers: lógica interna o actor Tiempo que monitoriza?|
|¿CNMV?||¿Broker: actor intermediario o rol del sistema?|
|¿Broker?|||
|¿Analista?|||
|¿Auditor externo?|||

</details>

## Emergencias

- Sistema que coordina respuesta ante emergencias (incendios, inundaciones, terremotos).
- Los ciudadanos reportan emergencias mediante llamada, app o sensores IoT.
- El sistema enruta automáticamente a los servicios apropiados (bomberos, policía, ambulancias).
- Existe un protocolo de escalado: si una emergencia supera capacidad local, se solicita apoyo a municipios vecinos.
- Los hospitales informan en tiempo real su capacidad de camas disponibles.
- Meteorología envía alertas automáticas que pueden activar protocolos preventivos.
- Los voluntarios de protección civil pueden ser convocados automáticamente según gravedad.
- Organismos internacionales (Cruz Roja) se coordinan en emergencias mayores.
- El sistema debe mantener comunicación con centrales nucleares que tienen sus propios protocolos.
- Existe un centro de mando que puede tomar control manual en situaciones críticas.

<details>
<summary>🚬</summary>

|ACTORES (tienen objetivos, atacan el sistema)|NO SON ACTORES (servicios/sistemas consultados)|CONSIDERAR|
|:-:|:-:|:-:|
|¿Ciudadano?|¿Sensores IoT?|¿Hospital: actor que informa disponibilidad o servicio consultado para derivación?|
|¿Bomberos/Policía/Ambulancias?|¿Enrutamiento automático?|¿Meteorología: actor que ataca con alertas o servicio que el sistema consulta?|
|¿Hospital?|¿Protocolo de escalado?|¿Voluntario: actor que responde a convocatoria o recurso gestionado por el sistema?|
|¿Municipio vecino?|¿Sistema de convocatoria automática?|¿Actor Tiempo para activaciones automáticas?|
|¿Meteorología?||¿Central nuclear: actor externo con protocolos propios o sistema crítico que se monitoriza?|
|¿Voluntario de protección civil?|||
|¿Cruz Roja?|||
|¿Central nuclear?|||
|¿Centro de mando?|||

</details>
