# Conexión automática de dispositivos bluetooth 

## Problema

Al reiniciar un sistema Linux con KDE, los dispositivos Bluetooth no se reconectan automáticamente, incluso si estaban conectados antes del reinicio. Esto requiere reconexión manual cada vez que se inicia el sistema.

## Solución

Un script de autoconexión que identifica y conecta automáticamente los dispositivos Bluetooth emparejados al iniciar sesión o arrancar el sistema.

## Opciones de implementación

### Opción 1: Conexión al iniciar sesión (nivel usuario)

Este método conecta el dispositivo Bluetooth cuando un usuario inicia sesión.

1. **Crear el script de autoconexión**:

```bash
mkdir -p ~/.local/share/autostart
nano ~/.local/share/autostart/bluetooth-autoconnect.sh
```

2. **Contenido del script**:

```bash
#!/bin/bash

# Script para autoconectar dispositivo Bluetooth en KDE
# Guardar en ~/.local/share/autostart/

# Configuración de logging
LOG_FILE="$HOME/.local/share/bluetooth-autoconnect.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Función para obtener la MAC del dispositivo por su nombre
get_device_mac() {
    local device_name="$1"
    bluetoothctl devices | grep -i "$device_name" | cut -d ' ' -f 2
}

# Función para conectar dispositivo
connect_device() {
    local mac="$1"
    local max_attempts=3
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        log "Intento $attempt de $max_attempts para conectar dispositivo $mac"
        
        # Intentar conexión
        if bluetoothctl connect "$mac" 2>&1 | tee -a "$LOG_FILE"; then
            log "Conexión exitosa al dispositivo $mac"
            notify-send "Bluetooth" "Dispositivo conectado exitosamente" -i bluetooth
            return 0
        fi
        
        attempt=$((attempt + 1))
        sleep 2
    done
    
    log "Falló la conexión después de $max_attempts intentos"
    notify-send "Bluetooth" "No se pudo conectar el dispositivo" -i bluetooth
    return 1
}

# Esperar a que el servicio de Bluetooth esté completamente iniciado

sleep 20

# Asegurarse que Bluetooth está encendido

bluetoothctl power on

# Reemplazar "SPEAKER5.0" con el nombre de tu dispositivo

DEVICE_NAME="SPEAKER5.0"
DEVICE_MAC=$(get_device_mac "$DEVICE_NAME")

if [ -z "$DEVICE_MAC" ]; then
    log "No se encontró el dispositivo: $DEVICE_NAME"
    notify-send "Bluetooth" "No se encontró el dispositivo: $DEVICE_NAME" -i bluetooth
    exit 1
fi

# Intentar conectar
connect_device "$DEVICE_MAC"
```

3. **Establecer permisos de ejecución**:

```bash
chmod +x ~/.local/share/autostart/bluetooth-autoconnect.sh
```

4. **Añadir al inicio de sesión mediante la GUI de KDE**:

- Abrir Configuración del Sistema
- Ir a Startup and Shutdown → Autostart
- Hacer clic en Add Script
- Seleccionar el script recién creado

### Opción 2: Conexión al arranque del sistema (nivel sistema)

Este método conecta el dispositivo durante el arranque del sistema, incluso antes de que cualquier usuario inicie sesión.

1. **Crear el script en una ubicación del sistema**:

```bash
sudo nano /usr/local/bin/bluetooth-autoconnect.sh
```

2. **Usar el mismo contenido del script anterior**, y dar permisos:

```bash
sudo chmod +x /usr/local/bin/bluetooth-autoconnect.sh
```

3. **Crear un servicio de systemd**:

```bash
sudo nano /etc/systemd/system/bluetooth-autoconnect.service
```

4. **Contenido del servicio**:

```ini
[Unit]
Description=Bluetooth Speaker Autoconnect
After=bluetooth.service
Requires=bluetooth.service
StartLimitIntervalSec=0

[Service]
Type=oneshot
ExecStartPre=/bin/sleep 30
ExecStart=/usr/local/bin/bluetooth-autoconnect.sh
RemainAfterExit=yes
Restart=on-failure
RestartSec=30

[Install]
WantedBy=multi-user.target
```

5. **Habilitar e iniciar el servicio**:
```bash
sudo systemctl daemon-reload
sudo systemctl enable bluetooth-autoconnect
sudo systemctl start bluetooth-autoconnect
```

## Personalización

- **Cambiar el dispositivo a conectar**: Modificar la variable `DEVICE_NAME` con el nombre exacto del dispositivo Bluetooth
- **Ajustar tiempos de espera**: Si el script falla, aumentar el valor de `sleep` al inicio del script
- **Verificar el funcionamiento**: Revisar el archivo de log en `~/.local/share/bluetooth-autoconnect.log`

## Compatibilidad

Esta solución funciona en:
- KDE Neon
- Manjaro KDE
- Kubuntu
- Cualquier distribución basada en Linux con KDE Plasma y systemd

## Solución de problemas

- Si el script no funciona, verificar que el servicio Bluetooth esté en ejecución: `systemctl status bluetooth`
- Verificar que el dispositivo está emparejado: `bluetoothctl devices`
- Revisar los logs para diagnosticar errores: `cat ~/.local/share/bluetooth-autoconnect.log`
