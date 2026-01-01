# Diexismo

Cosas que he ido recopilando relativas al diexismo

<div align=center>

|![](https://github.com/user-attachments/assets/12525367-518b-423f-b6ef-3673cd69f7eb)|[Receptor de la Universidad de Twente](http://websdr.ewi.utwente.nl:8901/)|
|-|-|
||El WebSDR de la Universidad de Twente es una interfaz web que permite sintonizar señales de radiofrecuencia reales capturadas por antenas físicas ubicadas en los Países Bajos, sin necesidad de poseer equipo receptor propio.

</div>


## WebSDR de la Universidad de Twente

### ¿Por qué?

Acceder a transmisiones de radiofrecuencia requiere tradicionalmente inversión en equipamiento especializado: receptor de radio, antenas específicas para cada banda, conocimiento técnico para configuración y sintonización. Un receptor multibanda capaz de cubrir HF, VHF y UHF representa inversión considerable. La ubicación geográfica limita las señales accesibles: antenas urbanas sufren interferencias, entornos sin espacio exterior impiden instalación de antenas direccionales.

Para propósitos educativos o exploración inicial del espectro electromagnético, esta barrera de entrada excluye experimentación sin compromiso económico previo. No existe forma de verificar interés real antes de invertir en hardware.

### ¿Qué?

WebSDR es una implementación de **Software defined radio** accesible mediante navegador web. La Universidad de Twente mantiene receptores SDR conectados permanentemente a Internet, permitiendo sintonización remota del espectro de radiofrecuencia mediante interfaz gráfica web.

### ¿Para qué?

Elimina requisito de poseer hardware receptor: cualquier dispositivo con navegador y conexión a Internet accede a las capacidades de recepción. Permite exploración del espectro sin inversión previa, facilitando evaluación de interés antes de comprometer recursos en equipamiento propio.

Múltiples usuarios simultáneos sintonizan frecuencias diferentes sobre la misma captura de espectro, convirtiendo un receptor físico en recurso compartido. Aplicaciones educativas demuestran fenómenos de propagación, modulación y características espectrales sin necesidad de equipar laboratorios completos.

La ubicación de las antenas en Países Bajos proporciona acceso a señales europeas, propagación ionosférica transoceánica y comunicaciones marítimas del Atlántico Norte, complementando perspectiva geográfica del usuario.

### ¿Cómo?

**Arquitectura del sistema:**

Antenas físicas conectadas a receptores SDR digitalizan segmentos del espectro electromagnético. El conversor analógico-digital captura la señal cruda en frecuencias específicas (bandas HF, VHF, UHF disponibles según configuración del servidor). Esta información digitalizada se transmite a servidores que procesan las solicitudes de múltiples usuarios.

**Interacción del usuario:**

1. Acceso web a http://websdr.ewi.utwente.nl:8901/ mediante navegador
2. Selección de banda disponible en menú desplegable (ejemplos: 0-30 MHz para HF, 144-146 MHz para banda de 2 metros)
3. Ajuste de frecuencia específica mediante:
   - Entrada numérica directa
   - Clic sobre espectrograma visual
   - Controles de sintonización fina
4. Selección de modo de demodulación según tipo de señal (AM, FM, SSB, CW)
5. Reproducción de audio demodulado directamente en navegador

**Procesamiento:**

El servidor aplica filtrado digital, selecciona frecuencia solicitada del espectro capturado, ejecuta demodulación según modo elegido, genera stream de audio transmitido al cliente. El espectrograma muestra representación visual de intensidad de señal versus frecuencia en tiempo real.

**Limitaciones operativas:**

Recepción limitada a señales que alcancen geográficamente las antenas en Países Bajos. Transmisiones locales débiles, estaciones en otros continentes sin propagación ionosférica adecuada, o frecuencias bloqueadas por obstáculos locales resultan inaccesibles. Saturación del servidor durante eventos de interés (competiciones de radioaficionados, lanzamientos espaciales) puede degradar rendimiento o limitar accesos simultáneos.

### ¿Alternativas?

**KiwiSDR**: Red distribuida de receptores SDR particulares compartidos públicamente, proporciona cobertura geográfica global pero con disponibilidad variable según voluntad de operadores individuales.

**OpenWebRX**: Software open-source que permite montar servidor WebSDR propio, requiere inversión en hardware SDR pero proporciona control total sobre configuración y disponibilidad.

**RTL-SDR local**: Dongle USB de bajo costo (~25€) permite recepción directa en equipo propio, requiere software adicional pero elimina dependencia de servidores remotos y latencia de red.88888
