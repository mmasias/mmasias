# Arquitectura

![](/images/modelosUML/traspaso/caso/EcoTrack%20Architecture.svg)

## 1. Visión general de la arquitectura

EcoTrack utiliza una arquitectura de microservicios desplegada en la nube para garantizar escalabilidad y flexibilidad. Los componentes principales son:

- Cliente móvil: Aplicaciones nativas para iOS y Android.
- API gateway: Punto de entrada único para todas las solicitudes de clientes.
- Servidores de aplicación: Manejan la lógica de negocio principal.
- Base de datos: Almacena datos de usuarios y cálculos de huella de carbono.
- Servicios especializados: Cálculo de Huella, Recomendaciones, Autenticación, etc.

## 2. Componentes principales

### 2.1 Cliente móvil

- Desarrollado con React Native para compatibilidad multiplataforma.
- Utiliza Redux para la gestión del estado.
- Implementa almacenamiento local para funcionalidad offline.

### 2.2 API gateway

- Implementado con AWS API Gateway.
- Maneja autenticación, limitación de velocidad y enrutamiento de solicitudes.

### 2.3 Servidores de aplicación

- Desarrollados en Node.js con el framework Express.
- Desplegados en contenedores Docker para facilitar la escalabilidad.

### 2.4 Base de datos

- Utiliza MongoDB para almacenamiento de datos no estructurados.
- Implementa sharding para manejar grandes volúmenes de datos.

### 2.5 Servicio de cálculo de huella

- Microservicio independiente desarrollado en Python.
- Utiliza algoritmos de machine learning para mejorar la precisión de los cálculos.

### 2.6 Servicio de recomendaciones

- Basado en Apache Spark para procesamiento de datos a gran escala.
- Implementa algoritmos de filtrado colaborativo para generar recomendaciones personalizadas.

## 3. Flujos de datos principales

### 3.1 Registro de actividad del usuario

1. El usuario ingresa datos en la app móvil.
2. La app envía los datos al API Gateway.
3. El servidor de aplicación procesa y almacena los datos en la base de datos.
4. El servicio de cálculo de huella procesa los nuevos datos.
5. Los resultados se almacenan y se envían de vuelta al usuario.

### 3.2 Generación de recomendaciones

1. El servicio de recomendaciones analiza periódicamente los datos de los usuarios.
2. Se generan recomendaciones personalizadas.
3. Las recomendaciones se almacenan en la base de datos.
4. La app móvil recupera las recomendaciones en la próxima sincronización.

## 4. Consideraciones de seguridad

- Toda la comunicación se realiza a través de HTTPS.
- Se implementa autenticación JWT para todas las solicitudes de API.
- Los datos sensibles se encriptan en reposo y en tránsito.
- Se realizan auditorías de seguridad trimestrales.

## 5. Escalabilidad

- Los servidores de aplicación se escalan horizontalmente según la demanda.
- Se utiliza caching en varios niveles para reducir la carga en la base de datos.
- El sharding de la base de datos permite un crecimiento continuo de los datos.

## 6. Monitoreo y logging

- Se utiliza ELK Stack (Elasticsearch, Logstash, Kibana) para centralizar logs.
- Prometheus y Grafana se usan para monitoreo en tiempo real y alertas.
