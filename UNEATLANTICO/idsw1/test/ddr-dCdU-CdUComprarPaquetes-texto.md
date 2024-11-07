# CASO DE USO: Comprar paquetes

## Información General

**Caso:** 1. Comprar Paquetes  
**Fecha:** 2024

## Descripción

Permite realizar la compra de paquetes a través de una pasarela de pago, gestionando todo el proceso desde la selección hasta la confirmación o cancelación de la compra.

## Actores

- Usuario del sistema

## Precondiciones

- El usuario debe tener acceso al sistema
- Deben existir paquetes disponibles para la compra

## Flujo Normal

1. El usuario solicita comprar paquetes
1. El sistema despliega el catálogo de paquetes disponibles
1. El usuario selecciona el paquete que desea comprar
1. El sistema presenta la interfaz de autenticación de la pasarela de pago
1. El usuario introduce sus credenciales (email y contraseña)
1. El sistema valida las credenciales
1. El sistema presenta la pantalla de verificación de compra
1. El usuario confirma la transacción
1. El sistema registra la compra y emite la confirmación
1. El sistema habilita las opciones de gestión post-compra

## Flujo Alternativo

1. Si las credenciales son inválidas, el sistema solicita nuevamente el ingreso de credenciales
1. Si el usuario cancela la transacción, el sistema registra la cancelación y emite la notificación correspondiente

## Poscondiciones

El sistema habilita las siguientes funcionalidades:

- Retorno al inicio
- Reinicialización de paquetes
- Nueva adquisición
- Desvinculación de cuenta
