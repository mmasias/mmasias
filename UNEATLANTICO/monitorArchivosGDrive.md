# Monitor de cambios

## ¿Por qué?

La gestión de documentos compartidos en Google Drive puede volverse compleja, especialmente cuando múltiples personas trabajan en diferentes archivos dentro de una misma estructura de carpetas. Es crucial mantenerse al día de los cambios realizados, pero revisar manualmente cada archivo resulta ineficiente y propenso a errores. Se necesita una forma automatizada de monitorizar estos cambios.

## ¿Qué?

Un script de Google Apps Script que monitoriza automáticamente una carpeta específica de Google Drive y todas sus subcarpetas. El script realiza comprobaciones periódicas y envía notificaciones por email detallando los cambios encontrados o confirmando que no se han producido modificaciones.

## ¿Para qué?

Este script permite:

- Mantener un registro de todas las modificaciones en los archivos.
- Recibir notificaciones automáticas de cambios.
- Identificar quién ha realizado modificaciones.
- Acceder directamente a los archivos modificados mediante URLs.
- Asegurar que ningún cambio pase desapercibido.
- Mantener un histórico de revisiones a través de los emails.

## ¿Cómo?

### Requisitos Previos

- Cuenta de Google.
- Acceso a Google Drive.
- Permisos para usar Google Apps Script.

### 1. Crear nuevo proyecto

1. Accede a [script.google.com](https://script.google.com)
1. Clic en "Nuevo proyecto"
1. Nombra el proyecto (ej: "Monitor Drive")

### 2. Preparar el entorno

1. Activa la API de Drive:
   - En el editor, clic en "+" junto a "Servicios"
   - Busca y selecciona "Drive API"
   - Clic en "Añadir"
1. Obtén el ID de la carpeta a monitorizar:
   - Abre la carpeta en Google Drive
   - Copia el ID de la URL (parte después de `/folders/`)
   - Ejemplo: `https://drive.google.com/drive/folders/1A2B3C4D5E6F` → ID: `1A2B3C4D5E6F`

### 3. Implementar el código

1. Copia el código del archivo [**code.gs**](code.gs) al editor
1. Modifica las variables:

   ```javascript
   const FOLDER_ID = 'TU_ID_DE_CARPETA';  // Reemplaza con tu ID
   const NOTIFICATION_EMAIL = 'tu@email.com';  // Reemplaza con tu email
   ```

### 4. Configurar y activar

1. Guarda el proyecto (Ctrl/Cmd + S)
1. Ejecuta `createTimeTrigger` una vez para configurar el temporizador
1. Autoriza los permisos solicitados
1. Prueba el funcionamiento:
   - Ejecuta `checkFolderChanges` manualmente
   - Verifica la recepción del email

### Solución de Problemas

|No recibo emails|Error de permisos|Otros|
|-|-|-|
|Verifica la configuración del email|Ejecuta el script manualmente|Consulta el registro de ejecución|
|Revisa la carpeta de spam|Acepta todos los permisos|Confirma la activación de Drive API|
|Confirma los permisos otorgados|Verifica el acceso a la carpeta|Verifica el ID de carpeta|

### Personalización

#### Modificar la frecuencia

```javascript
// En createTimeTrigger()
.everyHours(1)  // Cambia el número para ajustar el intervalo
```

#### Ajustar el formato del email

```javascript
emailSubject = 'Tu asunto personalizado';
emailBody = 'Tu mensaje personalizado';
```

### Limitaciones

- Sujeto a cuotas de Google Apps Script
- No detecta cambios entre revisiones
- No monitoriza eliminaciones de archivos

### Próximas mejoras posibles

- Detección de archivos eliminados
- Filtros por tipo de archivo
- Interfaz de usuario para configuración
- Más detalles en las notificaciones

---

<div align=right>

***Para este documento:***

|*H*|*IA*|
|-|-|
|*60*|*40*|

</div>