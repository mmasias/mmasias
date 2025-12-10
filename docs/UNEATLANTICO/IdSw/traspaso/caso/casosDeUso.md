# Actores y casos de uso

## Actores

|Usuario|Descripción|
|-|-|
|Usuario no registrado|Individuo que accede al sistema por primera vez o que aún no ha creado una cuenta. Su principal interacción es la creación de una nueva cuenta de usuario.
|Usuario registrado|Persona que ha creado una cuenta en EcoTrack y utiliza regularmente el sistema para rastrear y reducir su huella de carbono. Es el actor principal que interactúa con la mayoría de las funcionalidades del sistema.
|Administrador|Personal autorizado con acceso privilegiado al sistema. Se encarga de la gestión de usuarios, moderación de contenido y análisis de datos a nivel global del sistema.
|Dispositivo externo|Representa cualquier dispositivo IoT o sistema de terceros que puede integrarse con EcoTrack para proporcionar datos automáticos sobre consumo energético u otras métricas relevantes para el cálculo de la huella de carbono.

## Casos de uso

![](/images/modelosUML/traspaso/caso/casosDeUso.svg)

## Detalle de casos de uso

- Crear cuenta de usuario
- Autenticar usuario
- Actualizar información personal
- [Calcular huella de carbono de una actividad](cduCalcularHuella.md)
- Revisar estadísticas de huella de carbono
- Definir metas de reducción de huella
- Obtener sugerencias personalizadas
- Registrar actividades cotidianas
- Contrastar huella de carbono con otros usuarios
- Unirse a retos de sostenibilidad
- Vincular dispositivos domésticos
- Obtener informe mensual de huella de carbono
- Difundir logros personales
- Buscar consejos de sostenibilidad
- Estimar ahorro económico por reducción de huella
- Contribuir a proyectos de compensación de carbono
