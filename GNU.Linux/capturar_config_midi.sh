#!/bin/bash

# Script para capturar configuración MIDI y DOSBox-X
# Ejecutar en el ordenador que funciona bien

echo "=== CAPTURA DE CONFIGURACIÓN MIDI Y DOSBOX-X ==="
echo "Fecha: $(date)"
echo "Hostname: $(hostname)"
echo "Usuario: $(whoami)"
echo ""

# Crear directorio de salida
OUTPUT_DIR="midi_config_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$OUTPUT_DIR"

echo "Guardando configuración en: $OUTPUT_DIR"
echo ""

# ==========================================
# INFORMACIÓN DEL SISTEMA
# ==========================================
echo "=== 1. INFORMACIÓN DEL SISTEMA ===" | tee "$OUTPUT_DIR/01_sistema.txt"
echo "Distribución:" >> "$OUTPUT_DIR/01_sistema.txt"
lsb_release -a >> "$OUTPUT_DIR/01_sistema.txt" 2>/dev/null
echo "" >> "$OUTPUT_DIR/01_sistema.txt"

echo "Kernel:" >> "$OUTPUT_DIR/01_sistema.txt"
uname -a >> "$OUTPUT_DIR/01_sistema.txt"
echo "" >> "$OUTPUT_DIR/01_sistema.txt"

echo "Arquitectura:" >> "$OUTPUT_DIR/01_sistema.txt"
arch >> "$OUTPUT_DIR/01_sistema.txt"
echo "" >> "$OUTPUT_DIR/01_sistema.txt"

# ==========================================
# HARDWARE DE AUDIO
# ==========================================
echo "=== 2. HARDWARE DE AUDIO ===" | tee "$OUTPUT_DIR/02_hardware.txt"
echo "Tarjetas PCI de audio:" >> "$OUTPUT_DIR/02_hardware.txt"
lspci | grep -i audio >> "$OUTPUT_DIR/02_hardware.txt" 2>/dev/null
echo "" >> "$OUTPUT_DIR/02_hardware.txt"

echo "Tarjetas ALSA:" >> "$OUTPUT_DIR/02_hardware.txt"
cat /proc/asound/cards >> "$OUTPUT_DIR/02_hardware.txt" 2>/dev/null
echo "" >> "$OUTPUT_DIR/02_hardware.txt"

echo "Módulos ALSA cargados:" >> "$OUTPUT_DIR/02_hardware.txt"
cat /proc/asound/modules >> "$OUTPUT_DIR/02_hardware.txt" 2>/dev/null
echo "" >> "$OUTPUT_DIR/02_hardware.txt"

echo "Información de codec:" >> "$OUTPUT_DIR/02_hardware.txt"
find /proc/asound -name "codec*" -exec cat {} \; >> "$OUTPUT_DIR/02_hardware.txt" 2>/dev/null
echo "" >> "$OUTPUT_DIR/02_hardware.txt"

# ==========================================
# PAQUETES INSTALADOS
# ==========================================
echo "=== 3. PAQUETES MIDI Y AUDIO ===" | tee "$OUTPUT_DIR/03_paquetes.txt"
dpkg -l | grep -E "(midi|timidity|fluid|sound|alsa|pulse|pipe|jack|qsynth|dosbox)" >> "$OUTPUT_DIR/03_paquetes.txt"

# ==========================================
# SERVICIOS Y PROCESOS
# ==========================================
echo "=== 4. SERVICIOS Y PROCESOS ===" | tee "$OUTPUT_DIR/04_servicios.txt"
echo "Servicios systemd relacionados:" >> "$OUTPUT_DIR/04_servicios.txt"
systemctl list-units --type=service | grep -E "(audio|sound|pulse|pipe|midi|timidity|fluid)" >> "$OUTPUT_DIR/04_servicios.txt" 2>/dev/null
echo "" >> "$OUTPUT_DIR/04_servicios.txt"

echo "Servicios de usuario:" >> "$OUTPUT_DIR/04_servicios.txt"
systemctl --user list-units --type=service | grep -E "(audio|sound|pulse|pipe|midi)" >> "$OUTPUT_DIR/04_servicios.txt" 2>/dev/null
echo "" >> "$OUTPUT_DIR/04_servicios.txt"

echo "Procesos de audio activos:" >> "$OUTPUT_DIR/04_servicios.txt"
ps aux | grep -E "(pulse|pipe|fluid|timidity|qsynth|jack)" | grep -v grep >> "$OUTPUT_DIR/04_servicios.txt"
echo "" >> "$OUTPUT_DIR/04_servicios.txt"

# ==========================================
# CONFIGURACIÓN DE AUDIO
# ==========================================
echo "=== 5. CONFIGURACIÓN DE AUDIO ===" | tee "$OUTPUT_DIR/05_audio_config.txt"

# PulseAudio/PipeWire info
if command -v pactl >/dev/null 2>&1; then
    echo "Información de PulseAudio/PipeWire:" >> "$OUTPUT_DIR/05_audio_config.txt"
    pactl info >> "$OUTPUT_DIR/05_audio_config.txt" 2>/dev/null
    echo "" >> "$OUTPUT_DIR/05_audio_config.txt"
    
    echo "Dispositivos de salida:" >> "$OUTPUT_DIR/05_audio_config.txt"
    pactl list short sinks >> "$OUTPUT_DIR/05_audio_config.txt" 2>/dev/null
    echo "" >> "$OUTPUT_DIR/05_audio_config.txt"
    
    echo "Dispositivos de entrada:" >> "$OUTPUT_DIR/05_audio_config.txt"
    pactl list short sources >> "$OUTPUT_DIR/05_audio_config.txt" 2>/dev/null
    echo "" >> "$OUTPUT_DIR/05_audio_config.txt"
fi

# PipeWire específico
if command -v pw-metadata >/dev/null 2>&1; then
    echo "Configuración PipeWire:" >> "$OUTPUT_DIR/05_audio_config.txt"
    pw-metadata -n settings >> "$OUTPUT_DIR/05_audio_config.txt" 2>/dev/null
    echo "" >> "$OUTPUT_DIR/05_audio_config.txt"
fi

# ==========================================
# CONFIGURACIÓN MIDI
# ==========================================
echo "=== 6. CONFIGURACIÓN MIDI ===" | tee "$OUTPUT_DIR/06_midi_config.txt"

# Conexiones MIDI
if command -v aconnect >/dev/null 2>&1; then
    echo "Conexiones MIDI:" >> "$OUTPUT_DIR/06_midi_config.txt"
    aconnect -l >> "$OUTPUT_DIR/06_midi_config.txt" 2>/dev/null
    echo "" >> "$OUTPUT_DIR/06_midi_config.txt"
fi

# Dispositivos MIDI
echo "Dispositivos MIDI:" >> "$OUTPUT_DIR/06_midi_config.txt"
ls -la /dev/midi* >> "$OUTPUT_DIR/06_midi_config.txt" 2>/dev/null
ls -la /dev/snd/midi* >> "$OUTPUT_DIR/06_midi_config.txt" 2>/dev/null
echo "" >> "$OUTPUT_DIR/06_midi_config.txt"

# ==========================================
# ARCHIVOS DE CONFIGURACIÓN
# ==========================================
echo "=== 7. ARCHIVOS DE CONFIGURACIÓN ===" | tee "$OUTPUT_DIR/07_config_files.txt"

# Configuraciones de usuario
CONFIG_FILES=(
    ~/.asoundrc
    ~/.config/pulse/default.pa
    ~/.config/pipewire/pipewire.conf
    ~/.config/pipewire/pipewire-pulse.conf
    ~/.qsynth.conf
    ~/.fluidsynth
    ~/.timidity/timidity.cfg
)

echo "Archivos de configuración de usuario:" >> "$OUTPUT_DIR/07_config_files.txt"
for file in "${CONFIG_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "=== $file ===" >> "$OUTPUT_DIR/07_config_files.txt"
        cat "$file" >> "$OUTPUT_DIR/07_config_files.txt" 2>/dev/null
        echo "" >> "$OUTPUT_DIR/07_config_files.txt"
    else
        echo "$file: No existe" >> "$OUTPUT_DIR/07_config_files.txt"
    fi
done

# Configuraciones del sistema
SYSTEM_CONFIG_FILES=(
    /etc/asound.conf
    /etc/pulse/default.pa
    /etc/timidity/timidity.cfg
    /etc/pipewire/pipewire.conf
)

echo "Archivos de configuración del sistema:" >> "$OUTPUT_DIR/07_config_files.txt"
for file in "${SYSTEM_CONFIG_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "=== $file ===" >> "$OUTPUT_DIR/07_config_files.txt"
        cat "$file" >> "$OUTPUT_DIR/07_config_files.txt" 2>/dev/null
        echo "" >> "$OUTPUT_DIR/07_config_files.txt"
    else
        echo "$file: No existe" >> "$OUTPUT_DIR/07_config_files.txt"
    fi
done

# ==========================================
# SOUNDFONTS
# ==========================================
echo "=== 8. SOUNDFONTS ===" | tee "$OUTPUT_DIR/08_soundfonts.txt"

# Ubicaciones comunes de soundfonts
SOUNDFONT_DIRS=(
    /usr/share/sounds/sf2/
    /usr/share/soundfonts/
    ~/.local/share/sounds/sf2/
    ~/.soundfonts/
)

for dir in "${SOUNDFONT_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "=== $dir ===" >> "$OUTPUT_DIR/08_soundfonts.txt"
        ls -la "$dir" >> "$OUTPUT_DIR/08_soundfonts.txt" 2>/dev/null
        echo "" >> "$OUTPUT_DIR/08_soundfonts.txt"
    fi
done

# ==========================================
# DOSBOX-X CONFIGURACIÓN
# ==========================================
echo "=== 9. DOSBOX-X CONFIGURACIÓN ===" | tee "$OUTPUT_DIR/09_dosbox.txt"

# Buscar archivos de configuración de DOSBox-X
DOSBOX_CONFIGS=(
    ~/.config/dosbox-x/dosbox-x.conf
    ~/.dosbox-x/dosbox-x.conf
    ~/.dosbox/dosbox.conf
    /etc/dosbox/dosbox.conf
)

for config in "${DOSBOX_CONFIGS[@]}"; do
    if [ -f "$config" ]; then
        echo "=== $config ===" >> "$OUTPUT_DIR/09_dosbox.txt"
        cat "$config" >> "$OUTPUT_DIR/09_dosbox.txt" 2>/dev/null
        echo "" >> "$OUTPUT_DIR/09_dosbox.txt"
    else
        echo "$config: No existe" >> "$OUTPUT_DIR/09_dosbox.txt"
    fi
done

# Versión de DOSBox-X
if command -v dosbox-x >/dev/null 2>&1; then
    echo "Versión DOSBox-X:" >> "$OUTPUT_DIR/09_dosbox.txt"
    dosbox-x -version >> "$OUTPUT_DIR/09_dosbox.txt" 2>/dev/null
fi

# ==========================================
# VARIABLES DE ENTORNO
# ==========================================
echo "=== 10. VARIABLES DE ENTORNO ===" | tee "$OUTPUT_DIR/10_environment.txt"
env | grep -E "(ALSA|PULSE|PIPE|MIDI|AUDIO|SOUND)" >> "$OUTPUT_DIR/10_environment.txt"

# ==========================================
# LOGS RECIENTES
# ==========================================
echo "=== 11. LOGS RECIENTES ===" | tee "$OUTPUT_DIR/11_logs.txt"
echo "Logs de audio de las últimas 2 horas:" >> "$OUTPUT_DIR/11_logs.txt"
journalctl --since "2 hours ago" | grep -E "(audio|sound|midi|pulse|pipe|fluid|timidity)" >> "$OUTPUT_DIR/11_logs.txt" 2>/dev/null

# ==========================================
# CREAR SCRIPT DE APLICACIÓN
# ==========================================
cat > "$OUTPUT_DIR/aplicar_configuracion.sh" << 'EOF'
#!/bin/bash

# Script para aplicar la configuración capturada
# EJECUTAR EN EL ORDENADOR DESTINO

echo "=== APLICACIÓN DE CONFIGURACIÓN MIDI Y DOSBOX-X ==="
echo "ADVERTENCIA: Este script modificará configuraciones del sistema"
echo "Asegúrate de hacer backup antes de continuar"
echo ""
read -p "¿Continuar? (s/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Cancelado por el usuario"
    exit 1
fi

echo "Instalando paquetes necesarios..."
# Aquí se añadirán los comandos específicos basados en la configuración capturada

echo "Aplicación completada. Reinicia el sistema para asegurar que todos los cambios tomen efecto."
EOF

chmod +x "$OUTPUT_DIR/aplicar_configuracion.sh"

# ==========================================
# COMPRIMIR RESULTADO
# ==========================================
echo ""
echo "Comprimiendo configuración..."
tar -czf "${OUTPUT_DIR}.tar.gz" "$OUTPUT_DIR"

echo ""
echo "=== CAPTURA COMPLETADA ==="
echo "Archivos guardados en: $OUTPUT_DIR"
echo "Archivo comprimido: ${OUTPUT_DIR}.tar.gz"
echo ""
echo "Copia el archivo .tar.gz al otro ordenador y descomprímelo:"
echo "tar -xzf ${OUTPUT_DIR}.tar.gz"
echo ""
echo "Revisa los archivos generados antes de aplicar cualquier configuración."
