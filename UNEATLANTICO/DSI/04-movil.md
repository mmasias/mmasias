# El móvil - Componentes de su sistema de información

## ¿Por qué?

Los dispositivos móviles actuales enfrentan desafíos significativos como sistemas de información personales en un entorno digital cada vez más complejo:

|||
|-|-|
|Sobrecarga informativa|Los usuarios se enfrentan a un volumen creciente de datos personales, aplicaciones, notificaciones y contenidos multimedia que resulta difícil de gestionar, organizar y priorizar eficientemente.|
|Vulnerabilidad de datos sensibles|Los dispositivos móviles almacenan información altamente confidencial (datos bancarios, comunicaciones privadas, información médica) que queda expuesta a múltiples vectores de ataque físicos y digitales.|
|Fragmentación de la experiencia|Las aplicaciones funcionan como silos aislados que rara vez se comunican entre sí, obligando al usuario a cambiar constantemente de contexto y dificultando la integración de información relacionada.|
|Limitaciones de recursos|Las restricciones de batería, almacenamiento, capacidad de procesamiento y conectividad imponen compromisos constantes en el uso y funcionamiento del dispositivo.|
|Conflictos de privacidad|Resulta complejo para el usuario mantener el control sobre qué información personal se comparte, con quién y bajo qué circunstancias, especialmente con la proliferación de servicios basados en la nube.|
|Dependencia tecnológica|La creciente centralidad del móvil en la vida cotidiana genera problemas de dependencia y vulnerabilidad ante fallos técnicos, pérdidas o daños del dispositivo.|
|Obsolescencia acelerada|Los ciclos de actualización de hardware y software generan incompatibilidades progresivas y degradación del rendimiento que afectan la continuidad en el acceso a la información.|

## ¿Qué?

Identificar:

<div align=center>

|Hardware|Software|Datos|Procedimientos|Usuarios|
|-|-|-|-|-|

</div>

## ¿Para qué?

|||Abordando...|
|-|-|-|
|Seguridad personal | Establecer qué componentes forman parte del sistema de información móvil permite definir estrategias de protección adecuadas para salvaguardar datos personales y mantener la privacidad. | • Vulnerabilidad de datos sensibles<br>• Conflictos de privacidad<br>• Dependencia tecnológica |
|Optimización de recursos | Facilita la gestión eficiente de la capacidad de almacenamiento, consumo de batería y rendimiento general del dispositivo. | • Limitaciones de recursos<br>• Obsolescencia acelerada |
|Flujos de información coherentes | Permite diseñar y configurar el dispositivo para facilitar la comunicación entre aplicaciones y servicios, creando experiencias más integradas. | • Fragmentación de la experiencia<br>• Sobrecarga informativa |
|Continuidad digital | Ayuda a establecer estrategias de respaldo, sincronización y recuperación que garanticen el acceso a la información independientemente de incidentes con el dispositivo físico. | • Dependencia tecnológica<br>• Obsolescencia acelerada |
|Control de la experiencia digital | Proporciona al usuario herramientas para gestionar conscientemente sus interacciones digitales, filtrando distracciones y priorizando lo importante. | • Sobrecarga informativa<br>• Conflictos de privacidad |
|Adaptabilidad personal | Facilita la personalización del sistema según necesidades específicas del usuario, mejorando la accesibilidad y usabilidad. | • Fragmentación de la experiencia<br>• Dependencia tecnológica |
|Toma de decisiones informada | Permite evaluar conscientemente qué aplicaciones, servicios y dispositivos conectados incorporar al ecosistema personal. | • Conflictos de privacidad<br>• Sobrecarga informativa<br>• Obsolescencia acelerada |

## ¿Cómo?

### Empezando por lo obvio

#### Hardware

- Procesador y chips de apoyo (CPU, GPU, chips de seguridad)
- Memoria RAM y almacenamiento interno
- Pantalla y panel táctil
- Cámara(s) y sensores (acelerómetro, giroscopio, proximidad, etc.)
- Batería y sistema de carga
- Componentes de conectividad (antenas, módulos WiFi, Bluetooth, NFC)
- Periféricos (altavoces, micrófono, puertos de conexión)

#### Software

- Sistema operativo (Android, iOS, etc.)
- Firmware y controladores de hardware
- Aplicaciones preinstaladas (navegador, cámara, mensajería, etc.)
- Aplicaciones instaladas por el usuario
- Servicios en segundo plano (sincronización, ubicación, notificaciones)
- Capa de seguridad (cifrado, control de permisos, antimalware)
- Interfaz de usuario y sistema de personalización

#### Datos

- Contactos y agenda personal
- Fotografías, vídeos y archivos multimedia
- Mensajes y conversaciones
- Datos de aplicaciones y configuraciones
- Historial de navegación y búsquedas
- Información de ubicaciones y actividad física
- Credenciales y tokens de acceso a servicios

#### Procedimientos

- Métodos de autenticación (PIN, patrón, biometría)
- Patrones de uso y rutinas interactivas
- Procedimientos de respaldo y restauración
- Gestión de notificaciones y alertas
- Actualización de sistema y aplicaciones
- Procesos de ahorro de energía y gestión de recursos
- Configuración de privacidad y permisos

#### Usuarios

- Usuario principal (propietario del dispositivo)
- Usuarios secundarios (en dispositivos compartidos)
- Aplicaciones que actúan como agentes autónomos
- Asistentes digitales (Siri, Google Assistant, etc.)
- Contactos frecuentes del usuario
- Servicios remotos que interactúan con el dispositivo
- Sistemas de soporte técnico y fabricante

### Los casos límite

<ul>
<li><details><summary>Aplicaciones en la nube (Google Photos, Spotify, etc.)</summary>
El procesamiento ocurre en servidores remotos pero se accede y controla desde el dispositivo

- ***¿Pertenece?*** Parcialmente
- ***Justificación*** La interfaz cliente y los datos almacenados localmente pertenecen al SI del móvil, pero la infraestructura de servidores y el procesamiento en la nube son externos. Es un sistema híbrido donde el móvil actúa como punto de acceso a servicios externos que extienden sus capacidades.
</details>
</li>
<li><details><summary>Wearables sincronizados (smartwatch, auriculares)</summary>
Dispositivos externos que se integran y comunican con el móvil

- ***¿Pertenece?*** Sí
- ***Justificación*** Aunque son físicamente distintos, estos dispositivos funcionan como extensiones del sistema móvil, compartiendo datos, configuraciones y funcionalidades de manera sincronizada. Conforman un ecosistema integrado bajo el control del usuario a través del móvil como hub central.
</details>
</li>
<li><details><summary>Aplicaciones de terceros con acceso limitado</summary>
Software que funciona en el dispositivo pero con permisos restringidos

- ***¿Pertenece?*** Sí
- ***Justificación*** Aunque con privilegios limitados, estas aplicaciones se ejecutan en el entorno del dispositivo y están sujetas a sus mecanismos de control. El sistema operativo las aísla y supervisa, garantizando que operen dentro de los límites establecidos como parte del ecosistema móvil.
</details>
</li>
<li><details><summary>Datos en tarjeta SD extraíble</summary>
Información almacenada en un medio físicamente separable

- ***¿Pertenece?*** Parcialmente
- ***Justificación*** Mientras la tarjeta está insertada, sus datos forman parte integral del sistema de almacenamiento del dispositivo. Sin embargo, su naturaleza extraíble la convierte en un componente híbrido que puede pertenecer a múltiples sistemas de información según dónde se utilice.
</details>
</li>
<li><details><summary>Cache de aplicaciones web (Gmail, YouTube)</summary>
Datos de servicios online almacenados temporalmente en el dispositivo

- ***¿Pertenece?*** Sí
- ***Justificación*** Aunque son representaciones temporales de contenido externo, estos datos ocupan espacio en el almacenamiento local, son gestionados por el sistema operativo y afectan al rendimiento del dispositivo, formando parte de su sistema de información mientras persisten.
</details>
</li>
<li><details><summary>Cuenta de usuario en tienda de aplicaciones</summary>
Perfil externo que gestiona licencias y compras de software

- ***¿Pertenece?*** Parcialmente
- ***Justificación*** La información de cuenta que reside en el dispositivo (credenciales, preferencias) forma parte del SI móvil, pero el registro completo, historial de compras y gestión de licencias existen primariamente en los servidores del proveedor de la tienda.
</details>
</li>
<li><details><summary>Datos personales en servidores del fabricante</summary>
Copias de seguridad, configuraciones y datos sincronizados automáticamente

- ***¿Pertenece?*** Parcialmente
- ***Justificación*** Son extensiones virtuales del sistema de información personal, creadas para garantizar su continuidad y recuperabilidad. Aunque físicamente externos, estos datos existen como imagen espejo del sistema local bajo una relación contractual específica.
</details>
</li>
<li><details><summary>Smart TV controlada desde el móvil</summary>
Dispositivo externo que recibe comandos desde aplicaciones móviles

- ***¿Pertenece?*** No
- ***Justificación*** El móvil actúa como control remoto pero no integra el televisor como parte de su sistema. Son dos sistemas distintos que establecen un canal de comunicación temporal, manteniendo sus respectivas independencias operativas y administrativas.
</details>
</li>
<li><details><summary>Aplicación de control domótico</summary>
Software móvil que gestiona dispositivos del hogar conectado

- ***¿Pertenece?*** Parcialmente
- ***Justificación*** La aplicación y sus datos pertenecen al SI móvil, pero los dispositivos controlados y su infraestructura conforman un sistema separado. El móvil actúa como interfaz de usuario para un ecosistema externo, sirviendo de puente entre ambos sistemas.
</details>
</li>
<li><details><summary>Email corporativo en dispositivo personal</summary>
Datos profesionales accedidos desde un dispositivo privado

- ***¿Pertenece?*** Parcialmente
- ***Justificación*** Las políticas MDM (Mobile Device Management) crean un contenedor gestionado corporativamente dentro del dispositivo personal. Es un "sistema dentro de un sistema" donde la información empresarial pertenece simultáneamente al SI móvil personal y al SI corporativo.
</details>
</li>
<li><details><summary>Metadatos recopilados por el fabricante</summary>
Información sobre uso del dispositivo enviada automáticamente para análisis

- ***¿Pertenece?*** Sí
- ***Justificación*** Estos datos se generan dentro del sistema de información móvil y reflejan su funcionamiento, aunque posteriormente se transmitan externamente. Representan atributos y comportamientos del SI móvil, siendo parte integral de su operación aunque con un destino externo.
</details>
</li>
</ul>