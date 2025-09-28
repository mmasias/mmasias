#!/bin/bash

# Script para listar programas instalados en diferentes distribuciones Linux
# Autor: Script de migración de distro
# Fecha: $(date +%Y-%m-%d)

echo "=== LISTADO DE PROGRAMAS INSTALADOS ==="
echo "Fecha: $(date)"
echo "Sistema: $(uname -a)"
echo "Distribución: $(lsb_release -d 2>/dev/null || cat /etc/os-release | grep PRETTY_NAME)"
echo ""

# Función para detectar el gestor de paquetes
detect_package_manager() {
    if command -v apt &> /dev/null; then
        echo "apt"
    elif command -v yum &> /dev/null; then
        echo "yum"
    elif command -v dnf &> /dev/null; then
        echo "dnf"
    elif command -v zypper &> /dev/null; then
        echo "zypper"
    elif command -v pacman &> /dev/null; then
        echo "pacman"
    elif command -v portage &> /dev/null || command -v emerge &> /dev/null; then
        echo "portage"
    elif command -v xbps-query &> /dev/null; then
        echo "xbps"
    elif command -v apk &> /dev/null; then
        echo "apk"
    else
        echo "unknown"
    fi
}

# Función para listar paquetes según el gestor
list_packages() {
    local pm=$1
    local output_file="programas_instalados_$(date +%Y%m%d_%H%M%S).txt"
    
    echo "Detectado gestor de paquetes: $pm"
    echo "Generando lista en: $output_file"
    echo ""
    
    case $pm in
        "apt")
            echo "=== PAQUETES APT (Debian/Ubuntu) ===" | tee $output_file
            echo "" | tee -a $output_file
            echo "# Para reinstalar estos paquetes:" | tee -a $output_file
            echo "# sudo apt update && sudo apt install \\" | tee -a $output_file
            
            # Listar solo paquetes instalados manualmente (no dependencias)
            apt-mark showmanual | while read package; do
                echo "#   $package \\" | tee -a $output_file
            done
            echo "" | tee -a $output_file
            
            echo "=== TODOS LOS PAQUETES INSTALADOS ===" | tee -a $output_file
            dpkg --get-selections | grep -v deinstall | awk '{print $1}' | tee -a $output_file
            ;;
            
        "yum"|"dnf")
            echo "=== PAQUETES $pm (RedHat/Fedora/CentOS) ===" | tee $output_file
            echo "" | tee -a $output_file
            echo "# Para reinstalar estos paquetes:" | tee -a $output_file
            echo "# sudo $pm install \\" | tee -a $output_file
            
            # Listar paquetes instalados por el usuario
            $pm history userinstalled | tail -n +2 | while read package; do
                echo "#   $package \\" | tee -a $output_file
            done 2>/dev/null
            echo "" | tee -a $output_file
            
            echo "=== TODOS LOS PAQUETES INSTALADOS ===" | tee -a $output_file
            $pm list installed | awk '{print $1}' | grep -v "^Installed" | tee -a $output_file
            ;;
            
        "zypper")
            echo "=== PAQUETES ZYPPER (openSUSE) ===" | tee $output_file
            echo "" | tee -a $output_file
            echo "# Para reinstalar estos paquetes:" | tee -a $output_file
            echo "# sudo zypper install \\" | tee -a $output_file
            
            zypper search --installed-only | awk '/^i/ {print $3}' | while read package; do
                echo "#   $package \\" | tee -a $output_file
            done
            ;;
            
        "pacman")
            echo "=== PAQUETES PACMAN (Arch Linux) ===" | tee $output_file
            echo "" | tee -a $output_file
            echo "# Para reinstalar estos paquetes:" | tee -a $output_file
            echo "# sudo pacman -S \\" | tee -a $output_file
            
            # Paquetes instalados explícitamente
            pacman -Qe | awk '{print $1}' | while read package; do
                echo "#   $package \\" | tee -a $output_file
            done
            echo "" | tee -a $output_file
            
            echo "=== PAQUETES DE AUR ===" | tee -a $output_file
            pacman -Qm | awk '{print $1}' | tee -a $output_file
            ;;
            
        "portage")
            echo "=== PAQUETES PORTAGE (Gentoo) ===" | tee $output_file
            echo "" | tee -a $output_file
            ls /var/db/pkg/*/* | sed 's/.*\///' | sed 's/-[0-9].*//' | sort -u | tee -a $output_file
            ;;
            
        "xbps")
            echo "=== PAQUETES XBPS (Void Linux) ===" | tee $output_file
            echo "" | tee -a $output_file
            xbps-query -l | awk '{print $2}' | sed 's/-[0-9].*//' | tee -a $output_file
            ;;
            
        "apk")
            echo "=== PAQUETES APK (Alpine Linux) ===" | tee $output_file
            echo "" | tee -a $output_file
            apk info | tee -a $output_file
            ;;
            
        *)
            echo "Gestor de paquetes no reconocido" | tee $output_file
            echo "Listando programas en /usr/bin y /usr/local/bin:" | tee -a $output_file
            ls /usr/bin /usr/local/bin 2>/dev/null | sort -u | tee -a $output_file
            ;;
    esac
}

# Función para listar programas adicionales
list_additional_programs() {
    local output_file=$1
    
    echo "" | tee -a $output_file
    echo "=== PROGRAMAS ADICIONALES ===" | tee -a $output_file
    
    # Flatpak
    if command -v flatpak &> /dev/null; then
        echo "" | tee -a $output_file
        echo "--- FLATPAK ---" | tee -a $output_file
        flatpak list --app --columns=application | tail -n +1 | tee -a $output_file
    fi
    
    # Snap
    if command -v snap &> /dev/null; then
        echo "" | tee -a $output_file
        echo "--- SNAP ---" | tee -a $output_file
        snap list | awk 'NR>1 {print $1}' | tee -a $output_file
    fi
    
    # AppImage
    if [ -d "$HOME/.local/share/applications" ]; then
        echo "" | tee -a $output_file
        echo "--- POSIBLES APPIMAGES ---" | tee -a $output_file
        find "$HOME" -name "*.AppImage" 2>/dev/null | tee -a $output_file
    fi
    
    # Programas compilados desde código fuente (comunes)
    echo "" | tee -a $output_file
    echo "--- PROGRAMAS EN /usr/local ---" | tee -a $output_file
    ls /usr/local/bin 2>/dev/null | tee -a $output_file
}

# Función para generar script de reinstalación
generate_reinstall_script() {
    local pm=$1
    local output_file=$2
    local script_file="reinstalar_programas.sh"
    local interactive_script="reinstalar_interactivo.sh"
    
    # Script automático (original)
    echo "#!/bin/bash" > $script_file
    echo "# Script de reinstalación automática (todo de una vez)" >> $script_file
    echo "# Generado el $(date)" >> $script_file
    echo "" >> $script_file
    
    # Script interactivo (nuevo)
    echo "#!/bin/bash" > $interactive_script
    echo "# Script de reinstalación interactiva (uno por uno)" >> $interactive_script
    echo "# Generado el $(date)" >> $interactive_script
    echo "" >> $interactive_script
    echo "echo '=== INSTALACIÓN INTERACTIVA DE PROGRAMAS ==='" >> $interactive_script
    echo "echo 'Presiona ENTER para instalar, s para saltar, q para salir'" >> $interactive_script
    echo "" >> $interactive_script
    
    case $pm in
        "apt")
            echo "sudo apt update" >> $script_file
            echo "sudo apt install \\" >> $script_file
            
            echo "sudo apt update" >> $interactive_script
            echo "" >> $interactive_script
            
            apt-mark showmanual | while read package; do
                echo "  $package \\" >> $script_file
                
                # Versión interactiva
                cat >> $interactive_script << EOF
echo -n "¿Instalar $package? [Y/n/s/q]: "
read -r respuesta
case \$respuesta in
    [Qq]) echo "Saliendo..."; exit 0 ;;
    [Ss]) echo "Saltando $package" ;;
    [Nn]) echo "Saltando $package" ;;
    *) echo "Instalando $package..."
       sudo apt install -y $package
       if [ \$? -eq 0 ]; then
           echo "✓ $package instalado correctamente"
       else
           echo "✗ Error instalando $package"
       fi ;;
esac
echo ""
EOF
            done
            ;;
        "pacman")
            echo "sudo pacman -Syu" >> $script_file
            echo "sudo pacman -S \\" >> $script_file
            
            echo "sudo pacman -Syu" >> $interactive_script
            echo "" >> $interactive_script
            
            pacman -Qe | awk '{print $1}' | while read package; do
                echo "  $package \\" >> $script_file
                
                cat >> $interactive_script << EOF
echo -n "¿Instalar $package? [Y/n/s/q]: "
read -r respuesta
case \$respuesta in
    [Qq]) echo "Saliendo..."; exit 0 ;;
    [Ss]) echo "Saltando $package" ;;
    [Nn]) echo "Saltando $package" ;;
    *) echo "Instalando $package..."
       sudo pacman -S --noconfirm $package
       if [ \$? -eq 0 ]; then
           echo "✓ $package instalado correctamente"
       else
           echo "✗ Error instalando $package"
       fi ;;
esac
echo ""
EOF
            done
            ;;
        "dnf")
            echo "sudo dnf update -y" >> $script_file
            echo "sudo dnf install -y \\" >> $script_file
            
            echo "sudo dnf update -y" >> $interactive_script
            echo "" >> $interactive_script
            
            dnf history userinstalled | tail -n +2 | while read package; do
                echo "  $package \\" >> $script_file
                
                cat >> $interactive_script << EOF
echo -n "¿Instalar $package? [Y/n/s/q]: "
read -r respuesta
case \$respuesta in
    [Qq]) echo "Saliendo..."; exit 0 ;;
    [Ss]) echo "Saltando $package" ;;
    [Nn]) echo "Saltando $package" ;;
    *) echo "Instalando $package..."
       sudo dnf install -y $package
       if [ \$? -eq 0 ]; then
           echo "✓ $package instalado correctamente"
       else
           echo "✗ Error instalando $package"
       fi ;;
esac
echo ""
EOF
            done 2>/dev/null
            ;;
    esac
    
    chmod +x $script_file
    chmod +x $interactive_script
    echo "Scripts creados:"
    echo "  - $script_file (instalación automática)"
    echo "  - $interactive_script (instalación interactiva)"
}

# Función principal
main() {
    local pm=$(detect_package_manager)
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local output_file="programas_instalados_$timestamp.txt"
    
    # Listar paquetes principales
    list_packages $pm
    
    # Listar programas adicionales
    list_additional_programs $output_file
    
    # Generar script de reinstalación
    generate_reinstall_script $pm $output_file
    
    echo ""
    echo "=== RESUMEN ==="
    echo "✓ Lista completa guardada en: $output_file"
    echo "✓ Script automático: reinstalar_programas.sh"
    echo "✓ Script interactivo: reinstalar_interactivo.sh"
    echo ""
    echo "Para usar en la nueva distro:"
    echo "OPCIÓN 1 - Automático (todo de una vez):"
    echo "  ./reinstalar_programas.sh"
    echo ""
    echo "OPCIÓN 2 - Interactivo (pregunta uno por uno):"
    echo "  ./reinstalar_interactivo.sh"
    echo ""
    echo "3. Instala manualmente Flatpak/Snap si los usabas"
}

# Ejecutar función principal
main