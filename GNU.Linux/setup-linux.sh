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

# Detectar el tipo de distribución
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        DISTRO_FAMILY=""

        # Determinar la familia de la distribución
        if [[ "$ID" == "manjaro" || "$ID" == "arch" || "$ID_LIKE" == *"arch"* ]]; then
            DISTRO_FAMILY="arch"
        elif [[ "$ID" == "ubuntu" || "$ID" == "debian" || "$ID" == "elementary" || "$ID_LIKE" == *"debian"* ]]; then
            DISTRO_FAMILY="debian"
        elif [[ "$ID" == "fedora" || "$ID" == "rhel" || "$ID" == "centos" || "$ID_LIKE" == *"fedora"* || "$ID_LIKE" == *"rhel"* ]]; then
            DISTRO_FAMILY="rpm"
        else
            error "Distribución no reconocida: $ID"
            exit 1
        fi

        success "Distribución detectada: $DISTRO (Familia: $DISTRO_FAMILY)"
    else
        error "No se pudo detectar la distribución"
        exit 1
    fi
}

# Instalar dependencias básicas según la distribución
install_dependencies() {
    info "Instalando dependencias básicas para $DISTRO_FAMILY..."
    
    case $DISTRO_FAMILY in
        debian)
            sudo apt update
            sudo apt install -y curl wget git unzip
            ;;
        rpm)
            sudo dnf check-update
            sudo dnf install -y curl wget git unzip
            ;;
        arch)
            sudo pacman -Syu --noconfirm curl wget git unzip
            
            # Instalar yay si no está instalado
            if ! command -v yay &> /dev/null; then
                info "Instalando yay para acceso a AUR..."
                sudo pacman -S --needed --noconfirm base-devel
                git clone https://aur.archlinux.org/yay-git.git /tmp/yay-git
                cd /tmp/yay-git
                makepkg -si --noconfirm
                cd - > /dev/null
                success "yay instalado correctamente"
            else
                info "yay ya está instalado"
            fi
            ;;
    esac
    
    success "Dependencias básicas instaladas"
}

# Instalar Google Chrome
install_chrome() {
    info "Instalando Google Chrome..."
    
    case $DISTRO_FAMILY in
        debian)
            wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
            sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
            sudo apt update
            sudo apt install -y google-chrome-stable
            ;;
        rpm)
            sudo dnf install -y fedora-workstation-repositories
            sudo dnf config-manager --set-enabled google-chrome
            sudo dnf install -y google-chrome-stable
            ;;
        arch)
            yay -S --noconfirm google-chrome
            ;;
    esac
    
    success "Google Chrome instalado correctamente"
}

# Configurar Git
configure_git() {
    info "Configurando Git..."
    
    # Instalar Git si no está instalado
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
    
    # Preguntar por el nombre y email para la configuración
    read -p "Introduce tu nombre para Git: " git_name
    read -p "Introduce tu email para Git: " git_email
    
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    
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

# Instalar JDK
install_jdk() {
    info "Instalando JDK..."
    
    case $DISTRO_FAMILY in
        debian)
            sudo apt install -y openjdk-17-jdk-headless
            ;;
        rpm)
            sudo dnf install -y java-latest-openjdk-devel.x86_64
            ;;
        arch)
            sudo pacman -S --noconfirm jdk-openjdk
            ;;
    esac
    
    success "JDK instalado correctamente"
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

# Instalar Visual Studio Code
install_vscode() {
    info "Instalando Visual Studio Code..."
    
    case $DISTRO_FAMILY in
        debian)
            # Verificar si snap está instalado, si no, instalarlo
            if ! command -v snap &> /dev/null; then
                info "Instalando snap..."
                sudo apt install -y snapd
                sudo systemctl enable snapd
                sudo systemctl start snapd
            fi
            sudo snap install code --classic
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

# Instalar Spotify
install_spotify() {
    info "Instalando Spotify..."
    
    case $DISTRO_FAMILY in
        debian)
            # Verificar si snap está instalado, si no, instalarlo
            if ! command -v snap &> /dev/null; then
                info "Instalando snap..."
                sudo apt install -y snapd
                sudo systemctl enable snapd
                sudo systemctl start snapd
            fi
            sudo snap install spotify
            ;;
        rpm)
            # Verificar si snap está instalado, si no, instalarlo
            if ! command -v snap &> /dev/null; then
                info "Instalando snap..."
                sudo dnf install -y snapd
                sudo systemctl enable snapd
                sudo systemctl start snapd
            fi
            sudo snap install spotify
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

# Menú principal
show_menu() {
    clear
    echo "======================================"
    echo "     SCRIPT DE CONFIGURACIÓN LINUX    "
    echo "======================================"
    echo "Distribución detectada: $DISTRO (Familia: $DISTRO_FAMILY)"
    echo
    echo "Selecciona una opción:"
    echo "1) Instalar todo"
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