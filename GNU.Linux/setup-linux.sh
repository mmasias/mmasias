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
        return 0
    fi
    
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
            ;;
        arch)
            yay -S --noconfirm google-chrome
            ;;
    esac
    
    success "Google Chrome instalado correctamente"
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
    read -p "Introduce tu nombre para Git: " git_name
    read -p "Introduce tu email para Git: " git_email
    
    # Validar email básico
    if [[ ! "$git_email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        warning "El formato del email parece incorrecto, pero se configurará de todos modos"
    fi
    
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
            wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
            sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
            sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
            
            # Actualizar e instalar
            sudo apt update
            if sudo apt install -y code; then
                success "Visual Studio Code instalado correctamente desde repositorio oficial"
                return 0
            else
                warning "Falló la instalación desde repositorio oficial, intentando con snap..."
            fi
            
            # Método 2: Intentar con snap como respaldo
            if ! command -v snap &> /dev/null; then
                info "Instalando snap..."
                if sudo apt install -y snapd; then
                    sudo systemctl enable snapd
                    sudo systemctl start snapd
                    # Esperar a que snap esté listo
                    sleep 5
                    sudo snap install code --classic
                else
                    warning "No se pudo instalar snapd. Intentando descarga directa..."
                    # Método 3: Descarga directa como último recurso
                    temp_dir=$(mktemp -d)
                    cd "$temp_dir"
                    wget -O vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
                    if sudo dpkg -i vscode.deb; then
                        success "Visual Studio Code instalado correctamente desde descarga directa"
                    else
                        # Corregir dependencias rotas si es necesario
                        sudo apt install -f -y
                        success "Visual Studio Code instalado correctamente (con corrección de dependencias)"
                    fi
                    cd - > /dev/null
                    rm -rf "$temp_dir"
                fi
            else
                sudo snap install code --classic
            fi
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
            # Método 1: Intentar con repositorio oficial de Spotify
            info "Instalando desde el repositorio oficial de Spotify..."
            
            # Agregar clave y repositorio de Spotify
            curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
            echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
            
            # Actualizar e instalar
            sudo apt update
            if sudo apt install -y spotify-client; then
                success "Spotify instalado correctamente desde repositorio oficial"
                return 0
            else
                warning "Falló la instalación desde repositorio oficial, intentando con snap..."
            fi
            
            # Método 2: Intentar con snap como respaldo
            if ! command -v snap &> /dev/null; then
                info "Instalando snap..."
                if sudo apt install -y snapd; then
                    sudo systemctl enable snapd
                    sudo systemctl start snapd
                    # Esperar a que snap esté listo
                    sleep 5
                    sudo snap install spotify
                else
                    warning "No se pudo instalar snapd ni el repositorio oficial de Spotify"
                    info "Puedes instalarlo manualmente desde: https://www.spotify.com/download/linux/"
                    return 1
                fi
            else
                sudo snap install spotify
            fi
            ;;
        rpm)
            # Método 1: Intentar con repositorio oficial
            info "Instalando desde repositorio oficial de Spotify..."
            sudo rpm --import https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg
            
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
                warning "Falló la instalación desde repositorio oficial, intentando con snap..."
            fi
            
            # Método 2: Respaldo con snap
            if ! command -v snap &> /dev/null; then
                info "Instalando snap..."
                if sudo dnf install -y snapd; then
                    sudo systemctl enable snapd
                    sudo systemctl start snapd
                    sleep 5
                    sudo snap install spotify
                else
                    warning "No se pudo instalar snapd ni el repositorio oficial de Spotify"
                    info "Puedes instalarlo manualmente desde: https://www.spotify.com/download/linux/"
                    return 1
                fi
            else
                sudo snap install spotify
            fi
            ;;
        arch)
            yay -S --noconfirm spotify
            ;;
    esac
    
    success "Spotify instalado correctamente"
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
        info "Por favor, instala una Nerd Font para una visualización correcta: https://www.nerdfonts.com/"
        info "Sugerencias: FiraCode (https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip)"
        info "             MesloLG (https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Meslo.zip)"
        info "Después de descargar, descomprime y copia a ~/.fonts y ejecuta 'fc-cache -fv'"
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
            sudo apt remove -y firefox firefox-esr || true
            
            info "Removiendo LibreOffice..."
            sudo apt remove -y libreoffice* || true
            
            info "Removiendo Thunderbird..."
            sudo apt remove -y thunderbird || true
            
            # Limpiar paquetes huérfanos
            sudo apt autoremove -y
            ;;
        rpm)
            info "Removiendo Firefox..."
            sudo dnf remove -y firefox || true
            
            info "Removiendo LibreOffice..."
            sudo dnf remove -y libreoffice* || true
            
            info "Removiendo Thunderbird..."
            sudo dnf remove -y thunderbird || true
            
            # Limpiar paquetes huérfanos
            sudo dnf autoremove -y
            ;;
        arch)
            info "Removiendo Firefox..."
            sudo pacman -Rns --noconfirm firefox || true
            
            info "Removiendo LibreOffice..."
            # En Arch, LibreOffice puede estar instalado como paquetes individuales
            sudo pacman -Rns --noconfirm libreoffice-fresh libreoffice-still || true
            # También remover componentes individuales si existen
            sudo pacman -Rns --noconfirm $(pacman -Qq | grep libreoffice) 2>/dev/null || true
            
            info "Removiendo Thunderbird..."
            sudo pacman -Rns --noconfirm thunderbird || true
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
    echo "1) Instalar todo (configuración completa)"
    echo "2) Instalar dependencias básicas"
    echo "3) Instalar Google Chrome"
    echo "4) Configurar Git"
    echo "5) Instalar gdebi (solo Debian)"
    echo "6) Instalar curl"
    echo "7) Instalar JDK"
    echo "8) Instalar graphviz"
    echo "9) Instalar Visual Studio Code"
    echo "10) Instalar Spotify"
    echo "11) Instalar VLC"
    echo "12) Instalar oh-my-posh"
    echo "13) Instalar utilitarios (tree, eza)"
    echo "14) Instalar GitHub CLI"
    echo "15) Configurar firma GPG para Git"
    echo "16) Instalar utilidades adicionales (htop, neofetch, bat, etc.)"
    echo "17) Limpiar sistema"
    echo "18) Quitar bloatware (LibreOffice, Firefox, Thunderbird)"
    echo "19) Mostrar información del sistema"
    echo "0) Salir"
    echo
    read -p "Ingresa tu opción: " option
    
    case $option in
        1)
            install_dependencies
            install_chrome
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
            cleanup_system
            ;;
        2) install_dependencies ;;
        3) install_chrome ;;
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
        17) cleanup_system ;;
        18) remove_bloatware ;;
        19) 
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
    
    # Mostrar menú
    show_menu
}

# Ejecutar script
main