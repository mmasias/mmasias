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

# Instalar dependencias básicas según la distribución - MEJORADO
install_dependencies() {
    info "Instalando dependencias básicas para $DISTRO_FAMILY..."
    
    case $DISTRO_FAMILY in
        debian)
            # Actualizar primero
            info "Actualizando repositorios..."
            sudo apt update
            
            # Instalar herramientas básicas
            sudo apt install -y curl wget git unzip zip software-properties-common apt-transport-https ca-certificates gnupg lsb-release
            
            # Verificar si universe está habilitado en Ubuntu
            if [[ "$DISTRO" == "ubuntu" ]]; then
                sudo add-apt-repository universe -y
                sudo apt update
            fi
            ;;
        rpm)
            info "Actualizando repositorios..."
            sudo dnf check-update || true  # No fallar si no hay actualizaciones
            
            # Instalar herramientas básicas
            sudo dnf install -y curl wget git unzip zip dnf-plugins-core
            
            # Habilitar repositorios adicionales si están disponibles
            if command -v dnf &> /dev/null; then
                # Para Fedora
                if [[ "$DISTRO" == "fedora" ]]; then
                    sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm || true
                fi
            fi
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
            ;;
    esac
    
    success "Dependencias básicas instaladas"
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
    info "Instalando navegadores (Chrome & Brave)..."
    install_chrome
    install_brave
    success "Navegadores instalados correctamente"

    # Pausa informativa para acciones manuales necesarias
    echo
    info "ACCIONES NECESARIAS ANTES DE CONTINUAR:"
    info "1. Definir navegador por defecto (Chrome o Brave)"
    info "2. Loguearse en GitHub en el navegador elegido"
    info "   (Necesario para configuración de Git y GPG en pasos siguientes)"
    echo
    warning "Por favor, realiza estas acciones ahora y luego continúa."
    read -p "Presiona Enter cuando hayas terminado de configurar los navegadores..."
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

# Instalar gdebi (solo para distribuciones basadas en Debian)
install_gdebi() {
    if [[ "$DISTRO_FAMILY" == "debian" ]]; then
        info "Instalando gdebi..."
        sudo apt install -y gdebi
        success "gdebi instalado correctamente"
    else
        info "gdebi es específico para distribuciones basadas en Debian, saltando..."
    fi
}

# Instalar curl
install_curl() {
    info "Instalando curl..."
    
    # Verificar si ya está instalado
    if command -v curl &> /dev/null; then
        success "curl ya está instalado"
        return 0
    fi
    
    case $DISTRO_FAMILY in
        debian)
            sudo apt install -y curl
            ;;
        rpm)
            sudo dnf install -y curl
            ;;
        arch)
            sudo pacman -S --noconfirm curl
            ;;
    esac
    
    success "curl instalado correctamente"
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

# Instalar graphviz
install_graphviz() {
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

# Instalar Spotify - CORREGIDO
install_spotify() {
    info "Instalando Spotify..."

    # Verificar si ya está instalado
    if command -v spotify &> /dev/null; then
        success "Spotify ya está instalado"
        return 0
    fi

    case $DISTRO_FAMILY in
        debian)
            # Intentar con repositorio oficial de Spotify únicamente
            info "Instalando desde el repositorio oficial de Spotify..."

            # Agregar clave y repositorio de Spotify
            if curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg; then
                echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

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
            fi

            error "No se pudo instalar Spotify desde el repositorio oficial"
            info "Puedes instalarlo manualmente desde: https://www.spotify.com/download/linux/"
            return 1
            ;;
        rpm)
            # Intentar con repositorio oficial únicamente
            info "Instalando desde repositorio oficial de Spotify..."

            if sudo rpm --import https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg; then
                # Crear archivo de repositorio
                sudo tee /etc/yum.repos.d/spotify.repo > /dev/null <<EOF
[spotify]
name=Spotify repository
baseurl=http://repository.spotify.com/rpm/stable/x86_64/
enabled=1
gpgcheck=1
gpgkey=https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg
EOF

                if sudo dnf install -y spotify-client; then
                    success "Spotify instalado correctamente desde repositorio oficial"
                    return 0
                else
                    # Limpiar repositorio fallido
                    warning "Falló la instalación desde repositorio oficial. Limpiando archivos de repositorio..."
                    sudo rm -f /etc/yum.repos.d/spotify.repo
                    sudo dnf clean all
                fi
            fi

            error "No se pudo instalar Spotify desde el repositorio oficial"
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

    # Instalar Nerd Fonts (FiraCode y MesloLG)
    info "Descargando e instalando Nerd Fonts (FiraCode y MesloLG)..."
    mkdir -p ~/.fonts

    # Crear directorio temporal para descargas
    temp_fonts=$(mktemp -d)
    cd "$temp_fonts"

    # Descargar FiraCode Nerd Font
    info "Descargando FiraCode Nerd Font..."
    wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip
    unzip -q FiraCode.zip -d FiraCode/
    cp FiraCode/*.ttf ~/.fonts/ 2>/dev/null || true

    # Descargar MesloLG Nerd Font
    info "Descargando MesloLG Nerd Font..."
    wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Meslo.zip
    unzip -q Meslo.zip -d Meslo/
    cp Meslo/*.ttf ~/.fonts/ 2>/dev/null || true

    # Volver al directorio anterior y limpiar
    cd - > /dev/null
    rm -rf "$temp_fonts"

    # Reconstruir cache de fuentes
    info "Reconstruyendo cache de fuentes..."
    fc-cache -fv > /dev/null 2>&1

    success "Nerd Fonts instaladas correctamente (FiraCode y MesloLG)"
    
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
        
        # Verificar si ya existe la configuración
        if grep -q "oh-my-posh init" "$SHELL_RC"; then
            # Actualizar la configuración existente
            sed -i "s|oh-my-posh init .* --config .*|oh-my-posh init $(basename $SHELL | tr -d '\n') --config $HOME/.poshthemes/$theme.omp.json|g" "$SHELL_RC"
        else
            # Añadir configuración
            echo "eval \"\$(oh-my-posh init $(basename $SHELL | tr -d '\n') --config $HOME/.poshthemes/$theme.omp.json)\"" >> "$SHELL_RC"
        fi
        
        info "Configuración añadida a $SHELL_RC con el tema $theme"
        info "Las fuentes Nerd Font (FiraCode y MesloLG) ya han sido instaladas automáticamente"
        info "Si deseas usar otras fuentes Nerd Font, visita: https://www.nerdfonts.com/"
    else
        warning "No se pudo determinar el shell que estás usando. Por favor, configura oh-my-posh manualmente."
    fi
    
    success "oh-my-posh instalado correctamente"
}

# Instalar utilitarios adicionales
install_utilities() {
    info "Instalando utilitarios adicionales (tree, eza)..."
    
    case $DISTRO_FAMILY in
        debian)
            sudo apt install -y tree
            # eza no está en los repositorios estándar de debian, usar snap o instalar manualmente
            if ! command -v eza &> /dev/null; then
                warning "eza no está disponible en los repositorios estándar. Instalando mediante cargo..."
                sudo apt install -y cargo
                cargo install eza
            fi
            ;;
        rpm)
            sudo dnf install -y tree
            # eza puede requerir EPEL
            if ! sudo dnf install -y eza 2>/dev/null; then
                warning "eza no está disponible en los repositorios estándar. Instalando mediante cargo..."
                sudo dnf install -y cargo
                cargo install eza
            fi
            ;;
        arch)
            sudo pacman -S --noconfirm tree
            # eza podría estar en los repositorios oficiales o en AUR
            if ! sudo pacman -S --noconfirm eza 2>/dev/null; then
                yay -S --noconfirm eza
            fi
            ;;
    esac
    
    success "Utilitarios adicionales instalados correctamente"
}

# Instalar GitHub CLI
install_github_cli() {
    info "Instalando GitHub CLI..."
    
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
        key_id=$(gpg --list-secret-keys --keyid-format=long | grep sec | awk '{print $2}' | cut -d'/' -f2)
        
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
            mkdir -p ~/.gnupg
            if ! grep -q "default-cache-ttl" ~/.gnupg/gpg-agent.conf 2>/dev/null; then
                echo "default-cache-ttl 34560000" >> ~/.gnupg/gpg-agent.conf
                echo "max-cache-ttl 34560000" >> ~/.gnupg/gpg-agent.conf
                info "Se ha configurado el cache de contraseña GPG"
            fi

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

# Función para instalar utilidades adicionales - NUEVO
install_additional_utilities() {
    info "Instalando utilidades adicionales..."
    
    case $DISTRO_FAMILY in
        debian)
            sudo apt install -y \
                htop \
                neofetch \
                bat \
                fd-find \
                ripgrep \
                tmux \
                vim \
                build-essential
            ;;
        rpm)
            sudo dnf install -y \
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
            ;;
        arch)
            sudo pacman -S --noconfirm \
                htop \
                neofetch \
                bat \
                fd \
                ripgrep \
                tmux \
                vim \
                base-devel
            ;;
    esac
    
    success "Utilidades adicionales instaladas"
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

# Menú principal - ACTUALIZADO
show_menu() {
    clear
    echo "======================================"
    echo "     SCRIPT DE CONFIGURACIÓN LINUX    "
    echo "======================================"
    echo "Distribución detectada: $DISTRO (Familia: $DISTRO_FAMILY)"
    echo
    echo "Selecciona una opción:"
    printf "%-42s %s\n" "1)  Instalar todo (configuración completa)" "12) Instalar oh-my-posh"
    printf "%-42s %s\n" "2)  Instalar dependencias básicas" "13) Instalar utilitarios (tree, eza)"
    printf "%-42s %s\n" "3)  Instalar navegadores (Chrome & Brave)" "14) Instalar GitHub CLI"
    printf "%-42s %s\n" "4)  Configurar Git" "15) Configurar firma GPG para Git"
    printf "%-42s %s\n" "5)  Instalar gdebi (solo Debian)" "16) Instalar utilidades adicionales"
    printf "%-42s %s\n" "6)  Instalar curl" "17) Configurar carpeta repositorios"
    printf "%-42s %s\n" "7)  Instalar JDK" "18) Limpiar sistema"
    printf "%-42s %s\n" "8)  Instalar graphviz" "19) Quitar bloatware"
    printf "%-42s %s\n" "9)  Instalar Visual Studio Code" "20) Mostrar información del sistema"
    printf "%-42s %s\n" "10) Instalar Spotify" "0)  Salir"
    printf "%-42s %s\n" "11) Instalar VLC" ""
    echo
    read -p "Ingresa tu opción: " option
    
    case $option in
        1)
            install_dependencies
            install_browsers
            configure_git
            install_gdebi
            install_curl
            install_jdk
            install_graphviz
            install_vscode
            install_spotify
            install_vlc
            install_oh_my_posh
            install_utilities
            install_github_cli
            configure_gpg
            install_additional_utilities
            setup_repos_directory
            remove_bloatware
            cleanup_system
            ;;
        2) install_dependencies ;;
        3) install_browsers ;;
        4) configure_git ;;
        5) install_gdebi ;;
        6) install_curl ;;
        7) install_jdk ;;
        8) install_graphviz ;;
        9) install_vscode ;;
        10) install_spotify ;;
        11) install_vlc ;;
        12) install_oh_my_posh ;;
        13) install_utilities ;;
        14) install_github_cli ;;
        15) configure_gpg ;;
        16) install_additional_utilities ;;
        17) setup_repos_directory ;;
        18) cleanup_system ;;
        19) remove_bloatware ;;
        20)
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
        0)
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
        install_browsers
        configure_git
        install_gdebi
        install_curl
        install_jdk
        install_graphviz
        install_vscode
        install_spotify
        install_vlc
        install_oh_my_posh
        install_utilities
        install_github_cli
        configure_gpg
        install_additional_utilities
        setup_repos_directory
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
                    echo "pinentry-program /usr/bin/pinentry-qt" >> ~/.gnupg/gpg-agent.conf
                    ;;
                gnome)
                    sudo apt install -y pinentry-gnome3
                    echo "pinentry-program /usr/bin/pinentry-gnome3" >> ~/.gnupg/gpg-agent.conf
                    ;;
                *)
                    sudo apt install -y pinentry-gtk2
                    echo "pinentry-program /usr/bin/pinentry-gtk2" >> ~/.gnupg/gpg-agent.conf
                    ;;
            esac
            ;;
        rpm)
            case $desktop_env in
                kde)
                    sudo dnf install -y pinentry-qt
                    echo "pinentry-program /usr/bin/pinentry-qt" >> ~/.gnupg/gpg-agent.conf
                    ;;
                gnome)
                    sudo dnf install -y pinentry-gnome3
                    echo "pinentry-program /usr/bin/pinentry-gnome3" >> ~/.gnupg/gpg-agent.conf
                    ;;
                *)
                    sudo dnf install -y pinentry-gtk
                    echo "pinentry-program /usr/bin/pinentry-gtk" >> ~/.gnupg/gpg-agent.conf
                    ;;
            esac
            ;;
        arch)
            case $desktop_env in
                kde)
                    sudo pacman -S --noconfirm pinentry-qt
                    echo "pinentry-program /usr/bin/pinentry-qt" >> ~/.gnupg/gpg-agent.conf
                    ;;
                gnome)
                    sudo pacman -S --noconfirm pinentry-gnome
                    echo "pinentry-program /usr/bin/pinentry-gnome3" >> ~/.gnupg/gpg-agent.conf
                    ;;
                *)
                    sudo pacman -S --noconfirm pinentry-gtk
                    echo "pinentry-program /usr/bin/pinentry-gtk2" >> ~/.gnupg/gpg-agent.conf
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