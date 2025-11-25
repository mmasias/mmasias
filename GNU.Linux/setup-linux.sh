#!/bin/bash

# Script de configuración para diferentes distribuciones Linux
# Detecta automáticamente la distribución y ejecuta los comandos correspondientes

# Colores para mensajes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para mostrar mensajes informativos
info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Función para mostrar mensajes de éxito
success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Función para mostrar mensajes de error
error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Función para mostrar mensajes de advertencia
warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Función para pausar la ejecución y pedir confirmación
confirm() {
    read -p "¿Deseas continuar? (s/n): " response
    case "$response" in
        [sS]) 
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Detectar el tipo de distribución - MEJORADO
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        DISTRO_FAMILY=""

        # Determinar la familia de la distribución con casos adicionales
        if [[ "$ID" == "manjaro" || "$ID" == "arch" || "$ID" == "endeavouros" || "$ID_LIKE" == *"arch"* ]]; then
            DISTRO_FAMILY="arch"
        elif [[ "$ID" == "ubuntu" || "$ID" == "debian" || "$ID" == "linuxmint" || "$ID" == "elementary" || "$ID" == "pop" || "$ID" == "zorin" || "$ID_LIKE" == *"debian"* || "$ID_LIKE" == *"ubuntu"* ]]; then
            DISTRO_FAMILY="debian"
        elif [[ "$ID" == "fedora" || "$ID" == "rhel" || "$ID" == "centos" || "$ID" == "rocky" || "$ID" == "almalinux" || "$ID_LIKE" == *"fedora"* || "$ID_LIKE" == *"rhel"* ]]; then
            DISTRO_FAMILY="rpm"
        else
            warning "Distribución '$ID' no reconocida específicamente, intentando detectar gestor de paquetes..."
            # Fallback: detectar por gestor de paquetes disponible
            if command -v apt &> /dev/null; then
                DISTRO_FAMILY="debian"
                info "Detectado gestor apt, asumiendo familia Debian"
            elif command -v dnf &> /dev/null; then
                DISTRO_FAMILY="rpm"
                info "Detectado gestor dnf, asumiendo familia RPM"
            elif command -v yum &> /dev/null; then
                DISTRO_FAMILY="rpm"
                info "Detectado gestor yum, asumiendo familia RPM"
            elif command -v pacman &> /dev/null; then
                DISTRO_FAMILY="arch"
                info "Detectado gestor pacman, asumiendo familia Arch"
            else
                error "No se pudo determinar el gestor de paquetes de la distribución"
                exit 1
            fi
        fi

        success "Distribución detectada: $DISTRO (Familia: $DISTRO_FAMILY)"
    else
        error "No se pudo detectar la distribución"
        exit 1
    fi
}

# Helpers para configuración de GPG idempotente
set_gpg_agent_option() {
    local key="$1"
    local value="$2"
    local file="$HOME/.gnupg/gpg-agent.conf"

    mkdir -p "$HOME/.gnupg"

    if [ -f "$file" ]; then
        sed -i "/^${key}[[:space:]]/d" "$file"
    fi

    echo "${key} ${value}" >> "$file"
}

select_gpg_key_for_email() {
    local email="$1"
    local key_id=""

    if [[ -n "$email" ]]; then
        key_id=$(gpg --list-secret-keys --keyid-format=long --with-colons "$email" 2>/dev/null | awk -F: '/^sec/{print $5; exit}')
    fi

    if [[ -z "$key_id" ]]; then
        key_id=$(gpg --list-secret-keys --keyid-format=long --with-colons 2>/dev/null | awk -F: '/^sec/{print $5; exit}')
    fi

    echo "$key_id"
}

# Instalar dependencias básicas según la distribución - MEJORADO
install_dependencies() {
    info "Instalando dependencias básicas para $DISTRO_FAMILY..."

    case $DISTRO_FAMILY in
        debian)
            # Actualizar primero
            info "Actualizando repositorios..."
            sudo apt update

            # Instalar herramientas básicas (incluyendo curl y gdebi)
            sudo apt install -y curl wget git unzip zip software-properties-common apt-transport-https ca-certificates gnupg lsb-release gdebi-core

            # Verificar si universe está habilitado en Ubuntu
            if [[ "$DISTRO" == "ubuntu" ]]; then
                sudo add-apt-repository universe -y
                sudo apt update
            fi

            success "Dependencias básicas instaladas (incluyendo curl y gdebi)"
            ;;
        rpm)
            info "Actualizando repositorios..."
            sudo dnf check-update || true  # No fallar si no hay actualizaciones

            # Instalar herramientas básicas (incluyendo curl)
            sudo dnf install -y curl wget git unzip zip dnf-plugins-core

            # Habilitar repositorios adicionales si están disponibles
            if command -v dnf &> /dev/null; then
                # Para Fedora
                if [[ "$DISTRO" == "fedora" ]]; then
                    sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm || true
                fi
            fi

            success "Dependencias básicas instaladas (incluyendo curl)"
            ;;
        arch)
            info "Actualizando sistema..."
            sudo pacman -Syu --noconfirm

            sudo pacman -S --noconfirm curl wget git unzip zip base-devel

            # Instalar yay si no está instalado
            if ! command -v yay &> /dev/null; then
                info "Instalando yay para acceso a AUR..."
                git clone https://aur.archlinux.org/yay-git.git /tmp/yay-git
                cd /tmp/yay-git
                makepkg -si --noconfirm
                cd - > /dev/null
                rm -rf /tmp/yay-git
                success "yay instalado correctamente"
            else
                info "yay ya está instalado"
            fi

            success "Dependencias básicas instaladas (incluyendo curl)"
            ;;
    esac
}

# Instalar Google Chrome - MEJORADO
install_chrome() {
    info "Instalando Google Chrome..."

    # Verificar si ya está instalado
    if command -v google-chrome &> /dev/null; then
        success "Google Chrome ya está instalado"
    else
        case $DISTRO_FAMILY in
            debian)
                # Método más robusto
                temp_dir=$(mktemp -d)
                cd "$temp_dir"

                wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

                if sudo dpkg -i google-chrome-stable_current_amd64.deb; then
                    success "Google Chrome instalado correctamente"
                else
                    info "Corrigiendo dependencias..."
                    sudo apt install -f -y
                    success "Google Chrome instalado correctamente (con corrección de dependencias)"
                fi

                cd - > /dev/null
                rm -rf "$temp_dir"
                ;;
            rpm)
                # Agregar repositorio
                sudo tee /etc/yum.repos.d/google-chrome.repo > /dev/null <<EOF
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
EOF
                sudo dnf install -y google-chrome-stable
                success "Google Chrome instalado correctamente"
                ;;
            arch)
                yay -S --noconfirm google-chrome
                success "Google Chrome instalado correctamente"
                ;;
        esac
    fi
}

# Instalar Brave Browser - NUEVO
install_brave() {
    info "Instalando Brave Browser..."

    # Verificar si ya está instalado
    if command -v brave-browser &> /dev/null; then
        success "Brave Browser ya está instalado"
        return 0
    fi

    case $DISTRO_FAMILY in
        debian)
            # Agregar clave y repositorio de Brave
            if sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg; then
                echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

                if sudo apt update && sudo apt install -y brave-browser; then
                    success "Brave Browser instalado correctamente desde repositorio oficial"
                    return 0
                else
                    # Limpiar repositorio fallido
                    warning "Falló la instalación desde repositorio oficial. Limpiando archivos de repositorio..."
                    sudo rm -f /etc/apt/sources.list.d/brave-browser-release.list
                    sudo rm -f /usr/share/keyrings/brave-browser-archive-keyring.gpg
                    sudo apt update
                fi
            fi

            error "No se pudo instalar Brave Browser desde el repositorio oficial"
            info "Puedes instalarlo manualmente desde: https://brave.com/download/"
            return 1
            ;;
        rpm)
            # Agregar repositorio de Brave
            sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
            sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

            if sudo dnf install -y brave-browser; then
                success "Brave Browser instalado correctamente desde repositorio oficial"
                return 0
            else
                # Limpiar repositorio fallido
                warning "Falló la instalación desde repositorio oficial. Limpiando archivos de repositorio..."
                sudo rm -f /etc/yum.repos.d/brave-browser.repo
                sudo dnf clean all
            fi

            error "No se pudo instalar Brave Browser desde el repositorio oficial"
            info "Puedes instalarlo manualmente desde: https://brave.com/download/"
            return 1
            ;;
        arch)
            if yay -S --noconfirm brave-bin; then
                success "Brave Browser instalado correctamente desde AUR"
                return 0
            else
                error "No se pudo instalar Brave Browser desde AUR"
                info "Puedes instalarlo manualmente desde: https://brave.com/download/"
                return 1
            fi
            ;;
    esac
}

# Instalar Chrome y Brave - COMBINADO
install_browsers() {
    info "Instalando navegadores..."
    install_chrome
    
    # Hacer Brave opcional
    echo
    info "¿Deseas instalar Brave Browser?"
    if confirm; then
        install_brave
    else
        info "Instalación de Brave Browser omitida"
    fi
    
    success "Navegadores instalados correctamente"

    # Pausa informativa para acciones manuales necesarias
    echo
    info "ACCIONES NECESARIAS ANTES DE CONTINUAR:"
    info "1. Definir navegador por defecto"
    info "2. Loguearse en GitHub en el navegador elegido"
    info "   (Necesario para configuración de Git y GPG en pasos siguientes)"
    echo
    warning "Por favor, realiza estas acciones ahora y luego continúa."
    read -p "Presiona Enter cuando hayas terminado de configurar los navegadores..." < /dev/tty
    echo
}

# Configurar Git - MEJORADO
configure_git() {
    info "Configurando Git..."
    
    # Instalar Git si no está instalado
    if ! command -v git &> /dev/null; then
        case $DISTRO_FAMILY in
            debian)
                sudo apt install -y git
                ;;
            rpm)
                sudo dnf install -y git
                ;;
            arch)
                sudo pacman -S --noconfirm git
                ;;
        esac
    fi
    
    # Verificar si ya está configurado
    current_name=$(git config --global user.name 2>/dev/null || echo "")
    current_email=$(git config --global user.email 2>/dev/null || echo "")
    
    if [[ -n "$current_name" && -n "$current_email" ]]; then
        info "Git ya está configurado:"
        info "  Nombre: $current_name"
        info "  Email: $current_email"
        
        if ! confirm; then
            return 0
        fi
    fi
    
    # Preguntar por el nombre y email para la configuración
    read -p "Introduce tu nombre para Git (sugerencia: usuario@lugar): " git_name

    # Validar email con oportunidad de corrección
    while true; do
        read -p "Introduce tu email para Git: " git_email

        # Validar email básico
        if [[ "$git_email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
            break
        else
            error "El formato del email '$git_email' no es válido"
            info "Formato esperado: usuario@dominio.com"

            if ! confirm; then
                warning "Configurando con email inválido. Esto puede causar problemas con Git."
                break
            fi
        fi
    done
    
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    
    # Configuraciones adicionales útiles
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    git config --global core.autocrlf input
    
    success "Git configurado con nombre: $git_name y email: $git_email"
}

# Instalar JDK - MEJORADO
install_jdk() {
    info "Instalando JDK..."
    
    # Verificar si ya está instalado
    if command -v java &> /dev/null; then
        java_version=$(java -version 2>&1 | head -n 1)
        info "Java ya está instalado: $java_version"
        
        if ! confirm; then
            return 0
        fi
    fi
    
    case $DISTRO_FAMILY in
        debian)
            # Ofrecer opción entre OpenJDK y Oracle JDK
            echo "¿Qué JDK prefieres?"
            echo "1) OpenJDK 17 (recomendado)"
            echo "2) OpenJDK 11"
            echo "3) OpenJDK 21"
            read -p "Selecciona (1-3): " jdk_choice
            
            case $jdk_choice in
                1) sudo apt install -y openjdk-17-jdk-headless openjdk-17-jdk ;;
                2) sudo apt install -y openjdk-11-jdk-headless openjdk-11-jdk ;;
                3) sudo apt install -y openjdk-21-jdk-headless openjdk-21-jdk ;;
                *) sudo apt install -y openjdk-17-jdk-headless openjdk-17-jdk ;;
            esac
            ;;
        rpm)
            sudo dnf install -y java-latest-openjdk-devel java-latest-openjdk
            ;;
        arch)
            sudo pacman -S --noconfirm jdk-openjdk openjdk-doc
            ;;
    esac
    
    # Mostrar versión instalada
    if command -v java &> /dev/null; then
        java_version=$(java -version 2>&1 | head -n 1)
        success "JDK instalado correctamente: $java_version"
    fi
}

# Instalar JDK y graphviz juntos
install_jdk_and_graphviz() {
    install_jdk

    info "Instalando graphviz..."

    case $DISTRO_FAMILY in
        debian)
            sudo apt install -y graphviz
            ;;
        rpm)
            sudo dnf install -y graphviz
            ;;
        arch)
            sudo pacman -S --noconfirm graphviz
            ;;
    esac

    success "graphviz instalado correctamente"
}

# Instalar PlantUML
install_plantuml() {
    info "Instalando PlantUML..."

    # Verificar si ya está instalado
    if command -v plantuml &> /dev/null; then
        success "PlantUML ya está instalado"
        return 0
    fi

    # Verificar dependencias: Java y graphviz
    if ! command -v java &> /dev/null; then
        warning "Java no está instalado. PlantUML requiere Java."
        info "Instalando Java automáticamente..."
        if ! install_jdk; then
            error "No se pudo instalar Java. PlantUML no puede instalarse sin Java."
            return 1
        fi
    fi

    if ! command -v dot &> /dev/null; then
        warning "Graphviz no está instalado. PlantUML requiere graphviz para algunos diagramas."
        info "Instalando graphviz automáticamente..."
        case $DISTRO_FAMILY in
            debian)
                sudo apt install -y graphviz
                ;;
            rpm)
                sudo dnf install -y graphviz
                ;;
            arch)
                sudo pacman -S --noconfirm graphviz
                ;;
        esac
    fi

    case $DISTRO_FAMILY in
        debian)
            # Intentar instalar desde repositorio
            if sudo apt install -y plantuml; then
                success "PlantUML instalado correctamente desde repositorio"
                return 0
            else
                warning "PlantUML no disponible en repositorio, instalando manualmente..."
            fi
            ;;
        rpm)
            # Intentar instalar desde repositorio
            if sudo dnf install -y plantuml; then
                success "PlantUML instalado correctamente desde repositorio"
                return 0
            else
                warning "PlantUML no disponible en repositorio, instalando manualmente..."
            fi
            ;;
        arch)
            # En Arch, PlantUML suele estar disponible
            if sudo pacman -S --noconfirm plantuml; then
                success "PlantUML instalado correctamente desde repositorio"
                return 0
            else
                warning "PlantUML no disponible en repositorio, instalando manualmente..."
            fi
            ;;
    esac

    # Método de respaldo: descargar JAR directamente
    info "Descargando PlantUML JAR..."
    sudo mkdir -p /opt/plantuml

    if sudo curl -L -o /opt/plantuml/plantuml.jar https://github.com/plantuml/plantuml/releases/download/v1.2024.8/plantuml-1.2024.8.jar; then
        # Crear script wrapper
        sudo tee /usr/local/bin/plantuml > /dev/null <<'EOF'
#!/bin/bash
java -jar /opt/plantuml/plantuml.jar "$@"
EOF
        sudo chmod +x /usr/local/bin/plantuml

        success "PlantUML instalado correctamente desde JAR oficial"
        info "Versión instalada: 1.2024.8"
        info "Ubicación del JAR: /opt/plantuml/plantuml.jar"
        return 0
    else
        error "No se pudo descargar PlantUML"
        info "Puedes instalarlo manualmente desde: https://plantuml.com/download"
        return 1
    fi
}

# Instalar Antigravity IDE
install_antigravity() {
    info "Instalando Antigravity IDE..."

    # Verificar si ya está instalado
    if command -v antigravity &> /dev/null; then
        success "Antigravity IDE ya está instalado"
        return 0
    fi

    case $DISTRO_FAMILY in
        debian)
            info "Configurando repositorio de Antigravity para Debian/Ubuntu..."

            # Crear directorio para keyrings
            sudo mkdir -p /etc/apt/keyrings

            # Agregar clave GPG
            if curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/antigravity-repo-key.gpg; then
                # Agregar repositorio
                echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" | sudo tee /etc/apt/sources.list.d/antigravity.list > /dev/null

                # Actualizar e instalar
                if sudo apt update && sudo apt install -y antigravity; then
                    success "Antigravity IDE instalado correctamente desde repositorio oficial"
                    return 0
                else
                    # Limpiar repositorio fallido
                    warning "Falló la instalación desde repositorio oficial. Limpiando archivos de repositorio..."
                    sudo rm -f /etc/apt/sources.list.d/antigravity.list
                    sudo rm -f /etc/apt/keyrings/antigravity-repo-key.gpg
                    sudo apt update
                fi
            fi

            error "No se pudo instalar Antigravity IDE desde el repositorio oficial"
            info "Puedes descargar el tarball manualmente desde: https://antigravity.google/download/linux"
            return 1
            ;;
        rpm)
            info "Configurando repositorio de Antigravity para RPM..."

            # Agregar repositorio
            sudo tee /etc/yum.repos.d/antigravity.repo << 'EOL'
[antigravity-rpm]
name=Antigravity RPM Repository
baseurl=https://us-central1-yum.pkg.dev/projects/antigravity-auto-updater-dev/antigravity-rpm
enabled=1
gpgcheck=0
EOL

            # Actualizar cache e instalar
            if sudo dnf makecache && sudo dnf install -y antigravity; then
                success "Antigravity IDE instalado correctamente desde repositorio oficial"
                return 0
            else
                # Limpiar repositorio fallido
                warning "Falló la instalación desde repositorio oficial. Limpiando archivos de repositorio..."
                sudo rm -f /etc/yum.repos.d/antigravity.repo
                sudo dnf clean all
            fi

            error "No se pudo instalar Antigravity IDE desde el repositorio oficial"
            info "Puedes descargar el tarball manualmente desde: https://antigravity.google/download/linux"
            return 1
            ;;
        arch)
            warning "Antigravity IDE no tiene repositorio oficial para Arch Linux"
            info "Intentando buscar en AUR..."

            if yay -S --noconfirm antigravity 2>/dev/null; then
                success "Antigravity IDE instalado correctamente desde AUR"
                return 0
            else
                warning "No se encontró en AUR"
                info "Puedes descargar el tarball manualmente desde: https://antigravity.google/download/linux"
                return 1
            fi
            ;;
    esac
}

# Instalar Visual Studio Code - CORREGIDO
install_vscode() {
    info "Instalando Visual Studio Code..."

    # Verificar si ya está instalado
    if command -v code &> /dev/null; then
        success "Visual Studio Code ya está instalado"
        return 0
    fi
    
    case $DISTRO_FAMILY in
        debian)
            # Método 1: Intentar con repositorio oficial de Microsoft
            info "Instalando desde el repositorio oficial de Microsoft..."

            # Agregar clave y repositorio de Microsoft
            if wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg; then
                sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
                sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'

                # Actualizar e instalar
                if sudo apt update && sudo apt install -y code; then
                    success "Visual Studio Code instalado correctamente desde repositorio oficial"
                    return 0
                else
                    # Limpiar repositorio fallido
                    warning "Falló la instalación desde repositorio oficial. Limpiando archivos de repositorio..."
                    sudo rm -f /etc/apt/sources.list.d/vscode.list
                    sudo rm -f /etc/apt/trusted.gpg.d/packages.microsoft.gpg
                    sudo apt update
                fi
            fi

            # Método 2: Descarga directa como respaldo
            info "Intentando descarga directa..."
            temp_dir=$(mktemp -d)
            cd "$temp_dir"

            if wget -O vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"; then
                if sudo dpkg -i vscode.deb; then
                    success "Visual Studio Code instalado correctamente desde descarga directa"
                    cd - > /dev/null
                    rm -rf "$temp_dir"
                    return 0
                else
                    # Corregir dependencias rotas si es necesario
                    if sudo apt install -f -y; then
                        success "Visual Studio Code instalado correctamente (con corrección de dependencias)"
                        cd - > /dev/null
                        rm -rf "$temp_dir"
                        return 0
                    fi
                fi
            fi

            cd - > /dev/null
            rm -rf "$temp_dir"
            error "No se pudo instalar Visual Studio Code"
            info "Puedes instalarlo manualmente desde: https://code.visualstudio.com/download"
            return 1
            ;;
        rpm)
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
            sudo dnf check-update
            sudo dnf install -y code
            ;;
        arch)
            yay -S --noconfirm visual-studio-code-bin
            ;;
    esac
    
    success "Visual Studio Code instalado correctamente"
}

# Instalar Spotify - ACTUALIZADO según documentación oficial
install_spotify() {
    info "Instalando Spotify..."

    # Verificar si ya está instalado
    if command -v spotify &> /dev/null; then
        success "Spotify ya está instalado"
        return 0
    fi

    case $DISTRO_FAMILY in
        debian)
            # Intentar con repositorio oficial de Spotify
            info "Instalando desde el repositorio oficial de Spotify..."

            # Agregar clave y repositorio de Spotify (clave actualizada)
            if curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg; then
                echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

                # Actualizar e instalar
                if sudo apt update && sudo apt install -y spotify-client; then
                    success "Spotify instalado correctamente desde repositorio oficial"
                    return 0
                else
                    # Limpiar repositorio fallido
                    warning "Falló la instalación desde repositorio oficial. Limpiando archivos de repositorio..."
                    sudo rm -f /etc/apt/sources.list.d/spotify.list
                    sudo rm -f /etc/apt/trusted.gpg.d/spotify.gpg
                    sudo apt update
                fi
            else
                warning "No se pudo configurar el repositorio oficial de Spotify"
            fi

            # Método de respaldo: snap
            warning "Intentando instalar Spotify desde snap como respaldo..."
            if command -v snap &> /dev/null || sudo apt install -y snapd; then
                if sudo snap install spotify; then
                    success "Spotify instalado correctamente desde snap"
                    return 0
                fi
            fi

            error "No se pudo instalar Spotify desde ningún método"
            info "Puedes instalarlo manualmente desde: https://www.spotify.com/download/linux/"
            return 1
            ;;
        rpm)
            # Método preferido: snap
            info "Instalando Spotify desde snap..."
            if command -v snap &> /dev/null || sudo dnf install -y snapd; then
                if sudo snap install spotify; then
                    success "Spotify instalado correctamente desde snap"
                    return 0
                fi
            fi

            error "No se pudo instalar Spotify"
            info "Puedes instalarlo manualmente desde: https://www.spotify.com/download/linux/"
            return 1
            ;;
        arch)
            if yay -S --noconfirm spotify; then
                success "Spotify instalado correctamente desde AUR"
                return 0
            else
                error "No se pudo instalar Spotify desde AUR"
                info "Puedes instalarlo manualmente desde: https://www.spotify.com/download/linux/"
                return 1
            fi
            ;;
    esac
}

# Instalar VLC
install_vlc() {
    info "Instalando VLC..."
    
    case $DISTRO_FAMILY in
        debian)
            sudo apt install -y vlc
            ;;
        rpm)
            sudo dnf install -y vlc
            ;;
        arch)
            sudo pacman -S --noconfirm vlc
            ;;
    esac
    
    success "VLC instalado correctamente"
}

# Instalar agentes de IA (Claude Code, Gemini CLI, Codex) - CONSOLIDADO
install_agents() {
    info "Instalando agentes de IA..."

    # Verificar si Node.js está instalado, si no, instalarlo automáticamente
    if ! command -v npm &> /dev/null; then
        warning "Node.js no está instalado. Es requerido para los agentes de IA."
        info "Instalando Node.js automáticamente..."

        if ! install_nodejs; then
            error "No se pudo instalar Node.js. No se pueden instalar los agentes de IA."
            return 1
        fi
    fi

    # Cargar nvm si está disponible
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # Array con los agentes disponibles
    declare -A agents=(
        ["claude-code"]="@anthropic-ai/claude-code"
        ["gemini-cli"]="@google/gemini-cli"
        ["codex"]="@openai/codex"
        ["qwen-code"]="@qwen-code/qwen-code"
    )

    # Preguntar qué agentes instalar
    echo
    info "¿Qué agentes deseas instalar?"
    echo "1) Claude Code"
    echo "2) Gemini CLI"
    echo "3) Codex"
    echo "4) Qwen Code"
    echo "5) Todos"
    read -p "Selecciona (1-5, o varios separados por comas): " agent_choice

    # Determinar qué instalar
    install_claude=false
    install_gemini=false
    install_codex_agent=false
    install_qwen=false

    case $agent_choice in
        *5*|*"todos"*|*"Todos"*)
            install_claude=true
            install_gemini=true
            install_codex_agent=true
            install_qwen=true
            ;;
        *)
            [[ $agent_choice == *1* ]] && install_claude=true
            [[ $agent_choice == *2* ]] && install_gemini=true
            [[ $agent_choice == *3* ]] && install_codex_agent=true
            [[ $agent_choice == *4* ]] && install_qwen=true
            ;;
    esac

    # Instalar Claude Code
    if [ "$install_claude" = true ]; then
        info "Instalando Claude Code..."
        if npm list -g @anthropic-ai/claude-code &> /dev/null; then
            success "Claude Code ya está instalado"
        else
            npm install -g @anthropic-ai/claude-code
            if npm list -g @anthropic-ai/claude-code &> /dev/null; then
                success "Claude Code instalado correctamente"
                info "Ejecutar con: claude-code"
            else
                error "No se pudo instalar Claude Code"
            fi
        fi
    fi

    # Instalar Gemini CLI
    if [ "$install_gemini" = true ]; then
        info "Instalando Gemini CLI..."
        if npm list -g @google/gemini-cli &> /dev/null; then
            success "Gemini CLI ya está instalado"
        else
            npm install -g @google/gemini-cli
            if npm list -g @google/gemini-cli &> /dev/null; then
                success "Gemini CLI instalado correctamente"
                info "Ejecutar con: gemini-cli"
            else
                error "No se pudo instalar Gemini CLI"
            fi
        fi
    fi

    # Instalar Codex
    if [ "$install_codex_agent" = true ]; then
        info "Instalando Codex..."
        if npm list -g @openai/codex &> /dev/null; then
            success "Codex ya está instalado"
        else
            npm install -g @openai/codex
            if npm list -g @openai/codex &> /dev/null; then
                success "Codex instalado correctamente"
                info "Ejecutar con: codex"
            else
                error "No se pudo instalar Codex"
            fi
        fi
    fi

    # Instalar Qwen Code
    if [ "$install_qwen" = true ]; then
        info "Instalando Qwen Code..."
        if npm list -g @qwen-code/qwen-code &> /dev/null; then
            success "Qwen Code ya está instalado"
        else
            npm install -g @qwen-code/qwen-code@latest
            if npm list -g @qwen-code/qwen-code &> /dev/null; then
                success "Qwen Code instalado correctamente"
                info "Ejecutar con: qwen-code"
            else
                error "No se pudo instalar Qwen Code"
            fi
        fi
    fi

    success "Agentes de IA configurados correctamente"
}

# Instalar oh-my-posh
install_oh_my_posh() {
    info "Instalando oh-my-posh..."
    
    case $DISTRO_FAMILY in
        arch)
            # Verificar si oh-my-posh ya está instalado en Manjaro
            if command -v oh-my-posh &> /dev/null; then
                success "oh-my-posh ya está instalado en tu sistema Manjaro"
            else
                warning "oh-my-posh no está preinstalado en tu sistema Manjaro. Instalando..."
                sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
                sudo chmod +x /usr/local/bin/oh-my-posh
            fi
            ;;
        *)
            sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
            sudo chmod +x /usr/local/bin/oh-my-posh
            ;;
    esac
    
    # Configurar temas para todas las distros
    mkdir -p ~/.poshthemes
    wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
    unzip -o ~/.poshthemes/themes.zip -d ~/.poshthemes
    chmod u+rw ~/.poshthemes/*.omp.*
    rm ~/.poshthemes/themes.zip

    # Verificar e instalar Nerd Fonts (FiraCode y MesloLG)
    mkdir -p ~/.fonts

    # Verificar si las fuentes ya están instaladas
    firacode_installed=false
    meslo_installed=false

    if ls ~/.fonts/*FiraCode* &> /dev/null; then
        firacode_installed=true
    fi

    if ls ~/.fonts/*Meslo* &> /dev/null; then
        meslo_installed=true
    fi

    if [[ "$firacode_installed" == true && "$meslo_installed" == true ]]; then
        success "Nerd Fonts (FiraCode y MesloLG) ya están instaladas"
    else
        info "Descargando e instalando Nerd Fonts faltantes..."

        # Crear directorio temporal para descargas
        temp_fonts=$(mktemp -d)
        cd "$temp_fonts"

        # Descargar FiraCode si no está instalado
        if [[ "$firacode_installed" == false ]]; then
            info "Descargando FiraCode Nerd Font..."
            wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip
            unzip -q FiraCode.zip -d FiraCode/
            cp FiraCode/*.ttf ~/.fonts/ 2>/dev/null || true
        else
            info "FiraCode ya está instalado"
        fi

        # Descargar MesloLG si no está instalado
        if [[ "$meslo_installed" == false ]]; then
            info "Descargando MesloLG Nerd Font..."
            wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Meslo.zip
            unzip -q Meslo.zip -d Meslo/
            cp Meslo/*.ttf ~/.fonts/ 2>/dev/null || true
        else
            info "MesloLG ya está instalado"
        fi

        # Volver al directorio anterior y limpiar
        cd - > /dev/null
        rm -rf "$temp_fonts"

        # Reconstruir cache de fuentes solo si se instaló algo nuevo
        if [[ "$firacode_installed" == false || "$meslo_installed" == false ]]; then
            info "Reconstruyendo cache de fuentes..."
            fc-cache -fv > /dev/null 2>&1
        fi

        success "Nerd Fonts instaladas correctamente"
    fi
    
    # Determinar qué shell está usando el usuario
    SHELL_RC=""
    if [[ "$SHELL" == *"bash"* ]]; then
        SHELL_RC="$HOME/.bashrc"
    elif [[ "$SHELL" == *"zsh"* ]]; then
        SHELL_RC="$HOME/.zshrc"
    fi
    
    if [[ -n "$SHELL_RC" ]]; then
        # Preguntar por el tema
        read -p "¿Qué tema de oh-my-posh deseas usar? (por defecto: nordtron): " theme
        theme=${theme:-nordtron}
        
        # Obtener nombre del shell
        shell_name=$(basename "$SHELL" | tr -d '\n')

        # Verificar si ya existe la configuración
        if grep -q "oh-my-posh init" "$SHELL_RC"; then
            # Actualizar la configuración existente
            sed -i "s|oh-my-posh init .* --config .*|oh-my-posh init $shell_name --config $HOME/.poshthemes/$theme.omp.json|g" "$SHELL_RC"
        else
            # Añadir configuración
            echo "eval \"\$(oh-my-posh init $shell_name --config $HOME/.poshthemes/$theme.omp.json)\"" >> "$SHELL_RC"
        fi
        
        info "Configuración añadida a $SHELL_RC con el tema $theme"
        info "Las fuentes Nerd Font (FiraCode y MesloLG) ya han sido instaladas automáticamente"
        info "Si deseas usar otras fuentes Nerd Font, visita: https://www.nerdfonts.com/"
    else
        warning "No se pudo determinar el shell que estás usando. Por favor, configura oh-my-posh manualmente."
    fi
    
    success "oh-my-posh instalado correctamente"
}

# Instalar Node.js via nvm
install_nodejs() {
    info "Instalando Node.js vía nvm..."

    # Verificar si nvm ya está instalado
    if [ -s "$HOME/.nvm/nvm.sh" ]; then
        info "nvm ya está instalado"
        # Cargar nvm
        \. "$HOME/.nvm/nvm.sh"
    else
        # Descargar e instalar nvm
        info "Descargando e instalando nvm..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

        # Cargar nvm para usarlo inmediatamente
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

        if [ -s "$HOME/.nvm/nvm.sh" ]; then
            success "nvm instalado correctamente"
        else
            error "No se pudo instalar nvm"
            return 1
        fi
    fi

    # Cargar nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # Verificar si Node.js 24 ya está instalado
    if command -v node &> /dev/null; then
        node_version=$(node --version)
        info "Node.js ya está instalado: $node_version"

        # Si se llama desde otra función (agents o utilities), no preguntar, solo retornar
        if [[ "${FUNCNAME[1]}" == "install_agents" || "${FUNCNAME[1]}" == "install_utilities" ]]; then
            return 0
        fi

        # Si se llama directamente desde el menú, preguntar si quiere reinstalar
        if ! confirm; then
            return 0
        fi
    fi

    # Instalar Node.js versión 24
    info "Descargando e instalando Node.js v24..."
    nvm install 24

    # Verificar instalación
    if command -v node &> /dev/null; then
        node_version=$(node --version)
        npm_version=$(npm --version)
        success "Node.js instalado correctamente: $node_version"
        info "npm versión: $npm_version"
    else
        error "No se pudo instalar Node.js"
        return 1
    fi
}

# Instalar utilitarios adicionales y herramientas de desarrollo
install_utilities() {
    info "Instalando utilitarios y herramientas de desarrollo..."

    case $DISTRO_FAMILY in
        debian)
            # Herramientas de sistema básicas
            sudo apt install -y \
                tree \
                htop \
                neofetch \
                bat \
                fd-find \
                ripgrep \
                tmux \
                vim \
                build-essential

            # eza no está en los repositorios estándar de debian
            if ! command -v eza &> /dev/null; then
                warning "eza no está disponible en los repositorios estándar. Instalando mediante cargo..."
                sudo apt install -y cargo
                cargo install eza
            fi

            # Instalar DOSBox-X
            info "Instalando DOSBox-X..."
            if ! command -v dosbox-x &> /dev/null; then
                if command -v flatpak &> /dev/null || sudo apt install -y flatpak; then
                    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || true
                    flatpak install -y flathub com.dosbox_x.DOSBox-X || warning "DOSBox-X no disponible en Flathub"
                fi
            else
                info "DOSBox-X ya está instalado"
            fi

            # Instalar Jorts (cliente de Mastodon)
            if ! command -v jorts &> /dev/null; then
                info "Instalando Jorts..."
                if command -v flatpak &> /dev/null || sudo apt install -y flatpak; then
                    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || true
                    flatpak install -y flathub ca.joshuadoes.Jorts || info "Jorts no disponible en Flathub"
                fi
            fi

            # Instalar KDEnLive
            info "Instalando KDEnLive..."
            sudo apt install -y kdenlive

            # Instalar VirtualBox
            info "Instalando VirtualBox..."
            sudo apt install -y virtualbox virtualbox-ext-pack || sudo apt install -y virtualbox
            ;;
        rpm)
            # Herramientas de sistema básicas
            sudo dnf install -y \
                tree \
                htop \
                neofetch \
                bat \
                fd-find \
                ripgrep \
                tmux \
                vim \
                gcc \
                gcc-c++ \
                make

            # eza puede requerir EPEL
            if ! sudo dnf install -y eza 2>/dev/null; then
                warning "eza no está disponible en los repositorios estándar. Instalando mediante cargo..."
                sudo dnf install -y cargo
                cargo install eza
            fi

            # Instalar DOSBox-X
            info "Instalando DOSBox-X..."
            if ! command -v dosbox-x &> /dev/null; then
                if command -v flatpak &> /dev/null || sudo dnf install -y flatpak; then
                    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || true
                    flatpak install -y flathub com.dosbox_x.DOSBox-X || warning "DOSBox-X no disponible en Flathub"
                fi
            else
                info "DOSBox-X ya está instalado"
            fi

            # Instalar Jorts
            if ! command -v jorts &> /dev/null; then
                info "Instalando Jorts..."
                if command -v flatpak &> /dev/null || sudo dnf install -y flatpak; then
                    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || true
                    flatpak install -y flathub ca.joshuadoes.Jorts || info "Jorts no disponible en Flathub"
                fi
            fi

            # Instalar KDEnLive
            info "Instalando KDEnLive..."
            sudo dnf install -y kdenlive

            # Instalar VirtualBox
            info "Instalando VirtualBox..."
            sudo dnf install -y VirtualBox
            ;;
        arch)
            # Herramientas de sistema básicas
            sudo pacman -S --noconfirm \
                tree \
                htop \
                neofetch \
                bat \
                fd \
                ripgrep \
                tmux \
                vim \
                base-devel

            # eza podría estar en los repositorios oficiales o en AUR
            if ! sudo pacman -S --noconfirm eza 2>/dev/null; then
                yay -S --noconfirm eza
            fi

            # Instalar DOSBox-X
            info "Instalando DOSBox-X..."
            if ! command -v dosbox-x &> /dev/null; then
                yay -S --noconfirm dosbox-x || warning "DOSBox-X no disponible en AUR"
            else
                info "DOSBox-X ya está instalado"
            fi

            # Instalar Jorts
            if ! command -v jorts &> /dev/null; then
                info "Instalando Jorts..."
                yay -S --noconfirm jorts || info "Jorts no disponible en AUR"
            fi

            # Instalar KDEnLive
            info "Instalando KDEnLive..."
            sudo pacman -S --noconfirm kdenlive

            # Instalar VirtualBox
            info "Instalando VirtualBox..."
            sudo pacman -S --noconfirm virtualbox virtualbox-host-modules-arch
            ;;
    esac

    # Instalar Node.js llamando a la función dedicada
    install_nodejs

    success "Utilitarios y herramientas instalados correctamente"
}

# Instalar GitHub CLI
install_github_cli() {
    info "Instalando GitHub CLI..."

    # Verificar si ya está instalado
    if command -v gh &> /dev/null; then
        success "GitHub CLI ya está instalado"
        gh_version=$(gh --version | head -n 1)
        info "Versión: $gh_version"

        # Verificar si ya está autenticado
        if gh auth status &> /dev/null; then
            info "GitHub CLI ya está autenticado"
        else
            info "Configurando autenticación de GitHub CLI..."
            gh auth login
        fi

        # Verificar si ya tiene la extensión classroom
        if gh extension list | grep -q "github/gh-classroom"; then
            info "Extensión gh-classroom ya está instalada"
        else
            info "Instalando extensión gh-classroom..."
            gh extension install github/gh-classroom
        fi

        return 0
    fi

    case $DISTRO_FAMILY in
        debian)
            sudo apt install -y gh
            ;;
        rpm)
            sudo dnf install -y gh
            ;;
        arch)
            sudo pacman -S --noconfirm github-cli
            ;;
    esac

    info "Configurando GitHub CLI..."
    gh auth login
    gh extension install github/gh-classroom

    success "GitHub CLI instalado y configurado correctamente"
}

# Configurar firma GPG para Git
configure_gpg() {
    info "Configurando firma GPG para Git..."

    # Verificar si ya está configurado GPG para Git
    current_signing_key=$(git config --global user.signingkey 2>/dev/null || echo "")
    gpg_sign_enabled=$(git config --global commit.gpgsign 2>/dev/null || echo "")
    git_email=$(git config --global user.email 2>/dev/null || echo "")

    if [[ -n "$current_signing_key" && "$gpg_sign_enabled" == "true" ]]; then
        success "GPG ya está configurado para Git"
        info "Clave de firma: $current_signing_key"
        info "Firma automática: habilitada"
        return 0
    fi

    # Instalar GPG
    case $DISTRO_FAMILY in
        debian)
            sudo apt install -y gnupg
            ;;
        rpm)
            sudo dnf install -y gnupg2
            ;;
        arch)
            sudo pacman -S --noconfirm gnupg
            ;;
    esac
    
    info "Se va a generar una nueva clave GPG. Sigue las instrucciones en pantalla."
    info "Recomendaciones:"
    info "1. Seleccionar RSA and RSA (opción por defecto)"
    info "2. Usar 4096 bits"
    info "3. Elegir tiempo de validez (0 = no expira)"
    info "4. Ingresar nombre real, email (debe coincidir con el de GitHub) y contraseña segura"
    
    if confirm; then
        gpg --full-generate-key
        
        # Obtener el ID de la clave
        key_id=$(select_gpg_key_for_email "$git_email")
        
        if [[ -n "$key_id" ]]; then
            # Exportar clave para GitHub
            gpg --armor --export "$key_id"
            
            info "Copia la clave pública mostrada arriba (incluyendo las líneas BEGIN y END)"
            info "Ve a GitHub → Settings → SSH and GPG keys → Haz clic en 'New GPG key' → Pega la clave"
            
            read -p "Presiona Enter cuando hayas añadido la clave a GitHub..."
            
            # Configurar Git para usar la clave
            git config --global user.signingkey "$key_id"
            git config --global commit.gpgsign true
            
            # Configurar GPG_TTY
            shell_rc=""
            if [[ "$SHELL" == *"bash"* ]]; then
                shell_rc="$HOME/.bashrc"
            elif [[ "$SHELL" == *"zsh"* ]]; then
                shell_rc="$HOME/.zshrc"
            fi
            
            if [[ -n "$shell_rc" ]]; then
                if ! grep -q "export GPG_TTY" "$shell_rc"; then
                    echo "export GPG_TTY=\$(tty)" >> "$shell_rc"
                    info "Se ha añadido 'export GPG_TTY=\$(tty)' a $shell_rc"
                fi
            fi
            
            # Configurar cache de contraseña GPG
            set_gpg_agent_option "default-cache-ttl" "34560000"
            set_gpg_agent_option "max-cache-ttl" "34560000"
            info "Se ha configurado el cache de contraseña GPG"

            # Configurar pinentry para evitar problemas con aplicaciones gráficas
            configure_pinentry

            # Solución para macOS si es necesario
            if [[ "$(uname)" == "Darwin" ]]; then
                echo "export GPG_TTY=\$(tty)" >> ~/.gnupg/gpg-agent.conf
                info "Se ha añadido solución para macOS"
            fi
            
            success "GPG configurado correctamente con la clave $key_id"
        else
            error "No se pudo obtener el ID de la clave GPG"
        fi
    else
        info "Configuración de GPG cancelada"
    fi
}

# Limpia entradas duplicadas en gpg-agent.conf manteniendo la última
cleanup_gpg_agent_conf() {
    local file="$HOME/.gnupg/gpg-agent.conf"

    if [ ! -f "$file" ]; then
        info "No existe $file; nada que limpiar"
        return 0
    fi

    local cleaned=false

    for key in "pinentry-program" "default-cache-ttl" "max-cache-ttl"; do
        if grep -q "^${key}[[:space:]]" "$file"; then
            last_line=$(grep "^${key}[[:space:]]" "$file" | tail -n 1)
            sed -i "/^${key}[[:space:]]/d" "$file"
            echo "$last_line" >> "$file"
            cleaned=true
        fi
    done

    if [[ "$cleaned" == true ]]; then
        success "Limpieza de $file completada (se conservaron los últimos valores)"
    else
        info "No se encontraron entradas duplicadas en $file"
    fi
}

# Función para limpiar sistema después de instalaciones - NUEVO
cleanup_system() {
    info "Limpiando sistema..."

    case $DISTRO_FAMILY in
        debian)
            sudo apt autoremove -y
            sudo apt autoclean
            ;;
        rpm)
            sudo dnf autoremove -y
            sudo dnf clean all
            ;;
        arch)
            sudo pacman -Sc --noconfirm
            ;;
    esac

    echo
    info "¿Deseas limpiar entradas duplicadas en ~/.gnupg/gpg-agent.conf?"
    if [ -t 0 ]; then
        if confirm; then
            cleanup_gpg_agent_conf
        else
            info "Limpieza de configuración GPG omitida"
        fi
    else
        info "Modo no interactivo: omitiendo limpieza de gpg-agent.conf"
    fi

    success "Sistema limpiado"
}

# Configurar carpeta de repositorios y directorio por defecto - NUEVO
setup_repos_directory() {
    info "Configurando carpeta de repositorios..."

    # Crear carpeta ~/misRepos si no existe
    if [ ! -d "$HOME/misRepos" ]; then
        mkdir -p "$HOME/misRepos"
        success "Carpeta ~/misRepos creada"
    else
        info "Carpeta ~/misRepos ya existe"
    fi

    # Determinar qué shell está usando el usuario
    SHELL_RC=""
    if [[ "$SHELL" == *"bash"* ]]; then
        SHELL_RC="$HOME/.bashrc"
    elif [[ "$SHELL" == *"zsh"* ]]; then
        SHELL_RC="$HOME/.zshrc"
    fi

    if [[ -n "$SHELL_RC" ]]; then
        # Verificar si ya existe la configuración
        if ! grep -q "cd.*misRepos" "$SHELL_RC"; then
            # Añadir configuración para cambiar al directorio al abrir terminal
            echo "" >> "$SHELL_RC"
            echo "# Cambiar al directorio de repositorios al abrir terminal" >> "$SHELL_RC"
            echo "if [ \"\$PWD\" = \"\$HOME\" ]; then" >> "$SHELL_RC"
            echo "    cd ~/misRepos 2>/dev/null || true" >> "$SHELL_RC"
            echo "fi" >> "$SHELL_RC"

            success "Configuración añadida a $SHELL_RC"
            info "El terminal abrirá en ~/misRepos por defecto"
            info "Para aplicar los cambios: source $SHELL_RC"
        else
            info "La configuración de directorio por defecto ya existe en $SHELL_RC"
        fi
    else
        warning "No se pudo determinar el shell que estás usando. Configuración manual necesaria."
        info "Añade manualmente a tu archivo de configuración de shell:"
        info "if [ \"\$PWD\" = \"\$HOME\" ]; then"
        info "    cd ~/misRepos 2>/dev/null || true"
        info "fi"
    fi

    success "Carpeta de repositorios configurada correctamente"
}

# Descargar repositorios predefinidos
download_repos() {
    info "Descargando repositorios en ~/misRepos..."

    # Asegurar carpeta base
    setup_repos_directory

    # Verificar git
    if ! command -v git &> /dev/null; then
        warning "Git no está instalado. Instalándolo para poder clonar repos..."
        case $DISTRO_FAMILY in
            debian) sudo apt install -y git ;;
            rpm) sudo dnf install -y git ;;
            arch) sudo pacman -S --noconfirm git ;;
        esac
    fi

    # Lista de repos a clonar
    repos=(
        "https://github.com/mmasias/prg1"
        "https://github.com/mmasias/prg2"
        "https://github.com/mmasias/eda1"
        "https://github.com/mmasias/eda2"
        "https://github.com/mmasias/idsw1"
        "https://github.com/mmasias/idsw2"
    )

    for repo_url in "${repos[@]}"; do
        repo_name=$(basename "$repo_url")
        target_dir="$HOME/misRepos/$repo_name"

        if [ -d "$target_dir/.git" ]; then
            info "Repositorio $repo_name ya existe. Actualizando..."
            if git -C "$target_dir" pull --ff-only; then
                success "$repo_name actualizado"
            else
                warning "No se pudo actualizar $repo_name (revisa el repo manualmente)"
            fi
        else
            info "Clonando $repo_name..."
            if git clone "$repo_url" "$target_dir"; then
                success "$repo_name clonado en ~/misRepos"
            else
                error "Falló la clonación de $repo_name"
            fi
        fi
    done

    success "Repositorios descargados/actualizados"
}

# Función para quitar bloatware - NUEVO
remove_bloatware() {
    info "Quitando bloatware (LibreOffice, Firefox, Thunderbird)..."
    
    warning "Esta opción eliminará LibreOffice, Firefox y Thunderbird del sistema."
    warning "Si usas alguno de estos programas, cancela ahora."
    
    if ! confirm; then
        info "Operación cancelada"
        return 0
    fi
    
    case $DISTRO_FAMILY in
        debian)
            info "Removiendo Firefox..."
            sudo apt purge -y firefox firefox-esr || true
            # Remover paquetes de idiomas de Firefox
            sudo apt purge -y firefox-locale-* firefox-l10n-* || true

            info "Removiendo LibreOffice..."
            sudo apt purge -y libreoffice* || true
            # Remover paquetes de idiomas de LibreOffice
            sudo apt purge -y libreoffice-l10n-* libreoffice-help-* || true

            info "Removiendo Thunderbird..."
            sudo apt purge -y thunderbird || true
            # Remover paquetes de idiomas de Thunderbird
            sudo apt purge -y thunderbird-locale-* || true

            # Prevenir reinstalación automática
            info "Marcando paquetes como retenidos para prevenir reinstalación automática..."
            echo -e "firefox hold\nfirefox-esr hold\nlibreoffice* hold\nthunderbird hold" | sudo dpkg --set-selections 2>/dev/null || true

            # Limpiar paquetes huérfanos con purge
            info "Limpiando dependencias huérfanas..."
            sudo apt autoremove --purge -y

            # Limpiar registros dpkg residuales
            info "Limpiando registros dpkg residuales..."
            dpkg -l | grep "^rc" | awk '{print $2}' | sudo xargs dpkg --purge 2>/dev/null || true
            ;;
        rpm)
            info "Removiendo Firefox..."
            sudo dnf remove -y firefox || true
            # Remover paquetes de idiomas de Firefox
            sudo dnf remove -y firefox-langpacks-* || true

            info "Removiendo LibreOffice..."
            sudo dnf remove -y libreoffice* || true
            # Remover paquetes de idiomas de LibreOffice
            sudo dnf remove -y libreoffice-langpack-* || true

            info "Removiendo Thunderbird..."
            sudo dnf remove -y thunderbird || true
            # Remover paquetes de idiomas de Thunderbird
            sudo dnf remove -y thunderbird-langpacks-* || true

            # Prevenir reinstalación automática (añadir a excludes)
            info "Agregando paquetes a excludes para prevenir reinstalación automática..."
            if ! grep -q "exclude=firefox" /etc/dnf/dnf.conf; then
                echo "exclude=firefox firefox-esr libreoffice* thunderbird" | sudo tee -a /etc/dnf/dnf.conf >/dev/null
            fi

            # Limpiar paquetes huérfanos
            info "Limpiando dependencias huérfanas..."
            sudo dnf autoremove -y

            # Limpiar cache y metadatos
            info "Limpiando cache de dnf..."
            sudo dnf clean all
            ;;
        arch)
            info "Removiendo Firefox..."
            sudo pacman -Rns --noconfirm firefox || true
            # Remover paquetes de idiomas de Firefox
            sudo pacman -Rns --noconfirm $(pacman -Qq | grep firefox-i18n) 2>/dev/null || true

            info "Removiendo LibreOffice..."
            # En Arch, LibreOffice puede estar instalado como paquetes individuales
            sudo pacman -Rns --noconfirm libreoffice-fresh libreoffice-still || true
            # También remover componentes individuales si existen
            sudo pacman -Rns --noconfirm $(pacman -Qq | grep libreoffice) 2>/dev/null || true

            info "Removiendo Thunderbird..."
            sudo pacman -Rns --noconfirm thunderbird || true
            # Remover paquetes de idiomas de Thunderbird
            sudo pacman -Rns --noconfirm $(pacman -Qq | grep thunderbird-i18n) 2>/dev/null || true

            # Prevenir reinstalación automática agregando a IgnorePkg
            info "Agregando paquetes a IgnorePkg para prevenir reinstalación automática..."
            if ! grep -q "IgnorePkg.*firefox" /etc/pacman.conf; then
                sudo sed -i '/^#IgnorePkg/a IgnorePkg = firefox libreoffice-fresh libreoffice-still thunderbird' /etc/pacman.conf
            fi

            # Limpiar cache de pacman
            info "Limpiando cache de pacman..."
            sudo pacman -Sc --noconfirm

            # Verificar paquetes huérfanos adicionales
            info "Verificando paquetes huérfanos adicionales..."
            orphans=$(pacman -Qdtq 2>/dev/null) || true
            if [[ -n "$orphans" ]]; then
                sudo pacman -Rns --noconfirm $orphans || true
            fi
            ;;
    esac
    
    # Limpiar configuraciones de usuario (opcional)
    info "¿Deseas también eliminar las configuraciones de usuario de estos programas?"
    warning "Esto borrará perfiles, marcadores, emails guardados, etc."
    
    if confirm; then
        info "Eliminando configuraciones de usuario..."
        
        # Firefox
        rm -rf ~/.mozilla/firefox/ 2>/dev/null || true
        rm -rf ~/.cache/mozilla/ 2>/dev/null || true
        
        # LibreOffice
        rm -rf ~/.config/libreoffice/ 2>/dev/null || true
        rm -rf ~/.libreoffice/ 2>/dev/null || true
        
        # Thunderbird
        rm -rf ~/.thunderbird/ 2>/dev/null || true
        rm -rf ~/.cache/thunderbird/ 2>/dev/null || true
        
        success "Configuraciones de usuario eliminadas"
    else
        info "Configuraciones de usuario conservadas"
    fi
    
    success "Bloatware removido correctamente"
    info "Nota: Si instalaste Google Chrome, ahora será tu navegador principal"
}

# Función para verificar estado de instalaciones
check_status() {
    clear
    echo "======================================"
    echo "  ESTADO DE INSTALACIÓN"
    echo "======================================"
    echo "Distribución: $DISTRO ($DISTRO_FAMILY)"
    echo
    
    # Función auxiliar para verificar estado
    check_item() {
        local name="$1"
        local command="$2"
        
        printf "%-40s " "$name:"
        if command -v "$command" &> /dev/null; then
            echo -e "${GREEN}✓ INSTALADO${NC}"
            return 0
        else
            echo -e "${RED}✗ NO INSTALADO${NC}"
            return 1
        fi
    }
    
    # Función auxiliar para verificar configuración
    check_config() {
        local name="$1"
        local check_command="$2"
        
        printf "%-40s " "$name:"
        if eval "$check_command" &> /dev/null; then
            echo -e "${GREEN}✓ CONFIGURADO${NC}"
            return 0
        else
            echo -e "${RED}✗ NO CONFIGURADO${NC}"
            return 1
        fi
    }
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "HERRAMIENTAS BÁSICAS"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    check_item "curl" "curl"
    check_item "wget" "wget"
    check_item "git" "git"
    check_item "unzip" "unzip"
    
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "CONFIGURACIÓN DE GIT"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    check_config "Git user.name" "git config --global user.name"
    check_config "Git user.email" "git config --global user.email"
    check_config "Git GPG signing" "git config --global commit.gpgsign | grep -q 'true'"
    
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "NAVEGADORES"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    check_item "Google Chrome" "google-chrome"
    check_item "Brave Browser" "brave-browser"
    
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "DESARROLLO"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    check_item "Java (JDK)" "java"
    check_item "graphviz" "dot"
    check_item "PlantUML" "plantuml"
    check_item "Visual Studio Code" "code"
    check_item "Antigravity IDE" "antigravity"
    check_item "GitHub CLI" "gh"
    
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "MULTIMEDIA"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    check_item "Spotify" "spotify"
    check_item "VLC" "vlc"
    check_item "KDEnLive" "kdenlive"
    
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "UTILIDADES"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    check_item "Node.js" "node"
    check_item "npm" "npm"
    check_item "nvm" "nvm"
    check_item "tree" "tree"
    check_item "htop" "htop"
    check_item "neofetch" "neofetch"
    check_item "bat" "bat"
    check_item "ripgrep" "rg"
    check_item "tmux" "tmux"
    check_item "vim" "vim"
    check_item "eza" "eza"
    check_item "VirtualBox" "virtualbox"
    check_item "DOSBox-X" "dosbox-x"
    
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "PERSONALIZACIÓN"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    check_item "oh-my-posh" "oh-my-posh"
    
    # Verificar configuración de oh-my-posh
    if [[ "$SHELL" == *"bash"* ]]; then
        check_config "oh-my-posh en .bashrc" "grep -q 'oh-my-posh init' ~/.bashrc"
    elif [[ "$SHELL" == *"zsh"* ]]; then
        check_config "oh-my-posh en .zshrc" "grep -q 'oh-my-posh init' ~/.zshrc"
    fi
    
    # Verificar carpeta de repos
    printf "%-40s " "Carpeta ~/misRepos:"
    if [ -d "$HOME/misRepos" ]; then
        echo -e "${GREEN}✓ CREADA${NC}"
    else
        echo -e "${RED}✗ NO CREADA${NC}"
    fi
    
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "AGENTES DE IA"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Verificar agentes de IA (requieren npm)
    if command -v npm &> /dev/null; then
        printf "%-40s " "Claude Code:"
        if npm list -g @anthropic-ai/claude-code &> /dev/null; then
            echo -e "${GREEN}✓ INSTALADO${NC}"
        else
            echo -e "${RED}✗ NO INSTALADO${NC}"
        fi
        
        printf "%-40s " "Gemini CLI:"
        if npm list -g @google/gemini-cli &> /dev/null; then
            echo -e "${GREEN}✓ INSTALADO${NC}"
        else
            echo -e "${RED}✗ NO INSTALADO${NC}"
        fi
        
        printf "%-40s " "Codex:"
        if npm list -g @openai/codex &> /dev/null; then
            echo -e "${GREEN}✓ INSTALADO${NC}"
        else
            echo -e "${RED}✗ NO INSTALADO${NC}"
        fi

        printf "%-40s " "Qwen Code:"
        if npm list -g @qwen-code/qwen-code &> /dev/null; then
            echo -e "${GREEN}✓ INSTALADO${NC}"
        else
            echo -e "${RED}✗ NO INSTALADO${NC}"
        fi
    else
        echo -e "${YELLOW}[INFO]${NC} npm no está instalado. Los agentes de IA requieren Node.js/npm."
    fi
    
    echo
    echo "======================================"
}

# Menú principal - REORGANIZADO
show_menu() {
    clear
    local pretty_name="${PRETTY_NAME:-$DISTRO}"
    pretty_name="${pretty_name//\"/}"
    local git_user
    git_user=$(git config --global user.name 2>/dev/null || true)
    local identity="$USER@$pretty_name"
    if [[ -n "$git_user" ]]; then
        identity="$identity | git: $git_user"
    fi

    # Estado rápido de apps
    local chrome_status="Chrome:-"
    local code_status="VSCode:-"
    if command -v google-chrome &> /dev/null; then chrome_status="Chrome"; fi
    if command -v code &> /dev/null; then code_status="VSCode"; fi

    # Estado de agentes (C/G/C/Q)
    local agent_c=$(command -v claude &> /dev/null && echo "C" || echo "-")
    local agent_g=$(command -v gemini &> /dev/null && echo "G" || echo "-")
    local agent_x=$(command -v codex &> /dev/null && echo "C" || echo "-")
    local agent_q=$(command -v qwen &> /dev/null && echo "Q" || echo "-")
    local agents_summary="$agent_c/$agent_g/$agent_x/$agent_q"

    echo "SCRIPT DE CONFIGURACIÓN LINUX"
    echo "$identity | $chrome_status | $code_status | Agentes: $agents_summary"
    echo "=============================================="
    echo
    printf "%-45s %s\n" "1)  Todo!" "2)  Dependencias básicas"
    printf "%-45s %s\n" "3)  Configurar Git" "4)  Navegadores (Chrome & Brave)"
    printf "%-45s %s\n" "5)  JDK & graphviz" "6)  PlantUML"
    printf "%-45s %s\n" "7)  Visual Studio Code" "8)  Antigravity IDE"
    printf "%-45s %s\n" "9)  GitHub CLI" "10) Configurar firma GPG"
    printf "%-45s %s\n" "11) Node.js (nvm)" "12) Agentes IA (Claude/Gemini/Codex)"
    printf "%-45s %s\n" "13) Spotify" "14) VLC"
    printf "%-45s %s\n" "15) Utilitarios" "16) oh-my-posh"
    printf "%-45s %s\n" "17) Carpeta repo" "18) Descargar repos"
    printf "%-45s %s\n" "19) Limpiar sistema" "20) Quitar bloatware"
    printf "%-45s %s\n" "21) SysInfo" "22) Ver estado"
    printf "%-45s %s\n" "99)  Salir" ""
    echo
    read -p "Ingresa tu opción: " option
    
    case $option in
        1)
            # Instalación completa
            install_dependencies
            configure_git
            install_browsers
            install_jdk_and_graphviz
            install_plantuml
            install_vscode
            install_antigravity
            install_github_cli
            configure_gpg
            install_nodejs  # Instalar Node.js antes de agentes y utilities
            install_agents
            install_spotify
            install_vlc
            install_utilities
            install_oh_my_posh
            setup_repos_directory
            download_repos
            remove_bloatware
            cleanup_system
            ;;
        2) install_dependencies ;;
        3) configure_git ;;
        4) install_browsers ;;
        5) install_jdk_and_graphviz ;;
        6) install_plantuml ;;
        7) install_vscode ;;
        8) install_antigravity ;;
        9) install_github_cli ;;
        10) configure_gpg ;;
        11) install_nodejs ;;
        12) install_agents ;;
        13) install_spotify ;;
        14) install_vlc ;;
        15) install_utilities ;;
        16) install_oh_my_posh ;;
        17) setup_repos_directory ;;
        18) download_repos ;;
        19) cleanup_system ;;
        20) remove_bloatware ;;
        21)
            echo "Información del sistema:"
            echo "OS: $PRETTY_NAME"
            echo "Kernel: $(uname -r)"
            echo "Arquitectura: $(uname -m)"
            echo "Uptime: $(uptime -p)"
            echo "Memoria: $(free -h | grep Mem | awk '{print $3"/"$2}')"
            if command -v lscpu &> /dev/null; then
                echo "CPU: $(lscpu | grep 'Model name' | cut -d':' -f2 | sed 's/^ *//')"
            fi
            ;;
        22) check_status ;;
        99)
            echo "¡Gracias por usar el script!"
            exit 0
            ;;
        *)
            error "Opción inválida"
            ;;
    esac
    
    read -p "Presiona Enter para continuar..."
    show_menu
}

# Punto de entrada principal
main() {
    # Verificar si el script se ejecuta como root
    if [[ $EUID -eq 0 ]]; then
        error "Este script no debe ejecutarse como root directamente."
        info "Usa 'bash $0' como usuario normal."
        exit 1
    fi

    # Detectar distribución
    detect_distro

    # Detectar si se ejecuta desde pipe (curl | bash)
    if [ ! -t 0 ]; then
        info "Ejecutando instalación completa automática..."
        install_dependencies
        configure_git
        install_browsers
        install_jdk_and_graphviz
        install_plantuml
        install_vscode
        install_antigravity
        install_github_cli
        configure_gpg
        install_nodejs  # Instalar Node.js antes de agentes y utilities
        install_agents
        install_spotify
        install_vlc
        install_utilities
        install_oh_my_posh
        setup_repos_directory
        download_repos
        remove_bloatware
        cleanup_system
        success "¡Instalación completa terminada!"
        exit 0
    fi

    # Mostrar menú solo si se ejecuta interactivamente
    show_menu
}

# Función para detectar entorno de escritorio
detect_desktop_environment() {
    if [[ "$XDG_CURRENT_DESKTOP" == *"KDE"* ]] || [[ "$DESKTOP_SESSION" == *"kde"* ]]; then
        echo "kde"
    elif [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]] || [[ "$DESKTOP_SESSION" == *"gnome"* ]]; then
        echo "gnome"
    elif [[ "$XDG_CURRENT_DESKTOP" == *"XFCE"* ]]; then
        echo "xfce"
    else
        echo "generic"
    fi
}

# Función para configurar pinentry según el escritorio
configure_pinentry() {
    local desktop_env=$(detect_desktop_environment)
    info "Configurando pinentry para entorno $desktop_env..."
    
    case $DISTRO_FAMILY in
        debian)
            case $desktop_env in
                kde)
                    sudo apt install -y pinentry-qt
                    set_gpg_agent_option "pinentry-program" "/usr/bin/pinentry-qt"
                    ;;
                gnome)
                    sudo apt install -y pinentry-gnome3
                    set_gpg_agent_option "pinentry-program" "/usr/bin/pinentry-gnome3"
                    ;;
                *)
                    sudo apt install -y pinentry-gtk2
                    set_gpg_agent_option "pinentry-program" "/usr/bin/pinentry-gtk2"
                    ;;
            esac
            ;;
        rpm)
            case $desktop_env in
                kde)
                    sudo dnf install -y pinentry-qt
                    set_gpg_agent_option "pinentry-program" "/usr/bin/pinentry-qt"
                    ;;
                gnome)
                    sudo dnf install -y pinentry-gnome3
                    set_gpg_agent_option "pinentry-program" "/usr/bin/pinentry-gnome3"
                    ;;
                *)
                    sudo dnf install -y pinentry-gtk
                    set_gpg_agent_option "pinentry-program" "/usr/bin/pinentry-gtk"
                    ;;
            esac
            ;;
        arch)
            case $desktop_env in
                kde)
                    sudo pacman -S --noconfirm pinentry-qt
                    set_gpg_agent_option "pinentry-program" "/usr/bin/pinentry-qt"
                    ;;
                gnome)
                    sudo pacman -S --noconfirm pinentry-gnome
                    set_gpg_agent_option "pinentry-program" "/usr/bin/pinentry-gnome3"
                    ;;
                *)
                    sudo pacman -S --noconfirm pinentry-gtk
                    set_gpg_agent_option "pinentry-program" "/usr/bin/pinentry-gtk2"
                    ;;
            esac
            ;;
    esac
    
    # Reiniciar agente GPG
    gpgconf --kill gpg-agent
    gpgconf --launch gpg-agent
    
    success "Pinentry configurado correctamente para $desktop_env"
}

# Ejecutar script
main
