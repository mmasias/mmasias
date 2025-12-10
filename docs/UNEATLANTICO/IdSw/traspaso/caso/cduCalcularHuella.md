# Caso de Uso: Calcular huella de carbono de una actividad

## Descripción

Este caso de uso describe el proceso de cálculo de la huella de carbono para una actividad específica registrada por un usuario en EcoTrack.

## Actor Principal

Usuario

## Precondiciones

- El usuario está identificado en el sistema.

## Detalle

|Texto|Actividades|Estados|
|-|-|-|
[Texto](cduCalcularHuellaDetalleTexto.md)|![](/images/modelosUML/traspaso/caso/detalleCdU.flujo.svg)|![](/images/modelosUML/traspaso/caso/detalleCdU.estados.svg)|


## Postcondiciones

- El sistema ha registrado la nueva actividad y su huella de carbono asociada.
- El sistema ha actualizado las estadísticas del usuario.

## Extensiones

10a. Si el usuario ha alcanzado un hito de reducción:
    1. El sistema muestra una notificación de logro.
11. El sistema muestra una sugerencia personalizada basada en la actividad registrada.

## Secciones adicionales

### Reglas de Negocio

- El sistema debe utilizar los factores de emisión más actualizados para los cálculos.
- El sistema debe considerar la ubicación y la fecha de la actividad en el cálculo.

### Requerimientos Especiales

- El sistema debe mostrar el resultado del cálculo rápidamente.
- El sistema debe proporcionar resultados precisos y confiables.

### Frecuencia de Ocurrencia

- El usuario puede solicitar este cálculo varias veces al día.

### Aspectos de Rendimiento

- El sistema debe responder de manera eficiente incluso cuando muchos usuarios solicitan cálculos simultáneamente.

### Aspectos de Seguridad

- El sistema debe proteger la información del usuario durante todo el proceso.
- El sistema debe permitir al usuario acceder solo a sus propios datos históricos de huella de carbono.
