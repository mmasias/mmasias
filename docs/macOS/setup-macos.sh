#!/bin/bash

# Script de configuración para macOS
# Detecta automáticamente la arquitectura (Apple Silicon / Intel)

# Colores para mensajes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Versiones de software (constantes para facilitar actualizaciones)
PLANTUML_VERSION="v1.2024.8"
NVM_VERSION="v0.40.3"
NODE_VERSION="24"

# Funciones de logging
info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; }
warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

confirm() {
    read -p "¿Deseas continuar? (s/n): " response
    case "$response" in
        [sS]) return 0 ;;
        *)    return 1 ;;
    esac
}

get_shell_rc_file() {
    local shell_name
    shell_name=$(basename "$SHELL")
    case "$shell_name" in
        bash) echo "$HOME/.bash_profile" ;;
        zsh)  echo "$HOME/.zshrc" ;;
        *)    echo "$HOME/.profile" ;;
    esac
}

# ──────────────────────────────────────────────
# Detectar arquitectura
# ──────────────────────────────────────────────
detect_arch() {
    ARCH=$(uname -m)
    if [[ "$ARCH" == "arm64" ]]; then
        ARCH_NAME="Apple Silicon (arm64)"
        BREW_PREFIX="/opt/homebrew"
    else
        ARCH_NAME="Intel (x86_64)"
        BREW_PREFIX="/usr/local"
    fi
    success "Arquitectura detectada: $ARCH_NAME"
}

# ──────────────────────────────────────────────
# Homebrew
# ──────────────────────────────────────────────
ensure_homebrew() {
    if command -v brew &> /dev/null; then
        info "Homebrew ya está instalado"
        brew update
        return 0
    fi

    info "Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    local shell_rc
    shell_rc=$(get_shell_rc_file)
    echo "eval \"\$(${BREW_PREFIX}/bin/brew shellenv)\"" >> "$shell_rc"
    eval "$("${BREW_PREFIX}/bin/brew" shellenv)"

    if command -v brew &> /dev/null; then
        success "Homebrew instalado correctamente"
    else
        error "No se pudo instalar Homebrew"
        exit 1
    fi
}

# ──────────────────────────────────────────────
# Helpers GPG (idempotentes)
# ──────────────────────────────────────────────
set_gpg_agent_option() {
    local key="$1" value="$2"
    local file="$HOME/.gnupg/gpg-agent.conf"
    mkdir -p "$HOME/.gnupg"
    [ -f "$file" ] && sed -i '' "/^${key}[[:space:]]/d" "$file"
    echo "${key} ${value}" >> "$file"
}

select_gpg_key_for_email() {
    local email="$1" key_id=""
    [[ -n "$email" ]] && \
        key_id=$(gpg --list-secret-keys --keyid-format=long --with-colons "$email" 2>/dev/null | awk -F: '/^sec/{print $5; exit}')
    [[ -z "$key_id" ]] && \
        key_id=$(gpg --list-secret-keys --keyid-format=long --with-colons 2>/dev/null | awk -F: '/^sec/{print $5; exit}')
    echo "$key_id"
}

cleanup_gpg_agent_conf() {
    local file="$HOME/.gnupg/gpg-agent.conf"
    [ ! -f "$file" ] && { info "No existe $file; nada que limpiar"; return 0; }

    local cleaned=false
    for key in "pinentry-program" "default-cache-ttl" "max-cache-ttl"; do
        if grep -q "^${key}[[:space:]]" "$file"; then
            local last_line
            last_line=$(grep "^${key}[[:space:]]" "$file" | tail -n 1)
            sed -i '' "/^${key}[[:space:]]/d" "$file"
            echo "$last_line" >> "$file"
            cleaned=true
        fi
    done

    [[ "$cleaned" == true ]] \
        && success "Limpieza de $file completada" \
        || info "No se encontraron entradas duplicadas en $file"
}

# ──────────────────────────────────────────────
# 2) Dependencias básicas
# ──────────────────────────────────────────────
install_dependencies() {
    info "Instalando dependencias básicas..."
    ensure_homebrew
    brew install curl wget git unzip
    success "Dependencias básicas instaladas"
    info "Instalando Node.js (dependencia básica)..."
    install_nodejs
}

# ──────────────────────────────────────────────
# 4) Navegadores
# ──────────────────────────────────────────────
install_chrome() {
    info "Instalando Google Chrome..."
    if [ -d "/Applications/Google Chrome.app" ]; then
        success "Google Chrome ya está instalado"
        return 0
    fi
    brew install --cask google-chrome
    success "Google Chrome instalado correctamente"
}

install_browsers() {
    install_chrome
    echo
    info "ACCIONES NECESARIAS ANTES DE CONTINUAR:"
    info "1. Definir navegador por defecto (Ajustes del Sistema → General)"
    info "2. Loguearse en GitHub en el navegador elegido"
    info "   (Necesario para configuración de Git y GPG en pasos siguientes)"
    echo
    warning "Por favor, realiza estas acciones ahora y luego continúa."
    read -p "Presiona Enter cuando hayas terminado..." < /dev/tty
    echo
}

# ──────────────────────────────────────────────
# 3) Configurar Git
# ──────────────────────────────────────────────
configure_git() {
    info "Configurando Git..."
    ensure_homebrew

    # macOS trae git de Apple; instalamos la versión brew si no hay otra
    if ! command -v git &> /dev/null || git --version | grep -q "Apple"; then
        info "Instalando Git (versión más reciente vía Homebrew)..."
        brew install git
    fi

    local current_name current_email
    current_name=$(git config --global user.name 2>/dev/null || echo "")
    current_email=$(git config --global user.email 2>/dev/null || echo "")

    if [[ -n "$current_name" && -n "$current_email" ]]; then
        info "Git ya está configurado:"
        info "  Nombre: $current_name"
        info "  Email:  $current_email"
        if ! confirm; then return 0; fi
    fi

    read -p "Introduce tu nombre para Git (sugerencia: usuario@lugar): " git_name

    while true; do
        read -p "Introduce tu email para Git: " git_email
        if [[ "$git_email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
            break
        else
            error "El formato del email '$git_email' no es válido"
            info "Formato esperado: usuario@dominio.com"
            if ! confirm; then
                warning "Configurando con email inválido."
                break
            fi
        fi
    done

    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    git config --global core.autocrlf input

    success "Git configurado con nombre: $git_name y email: $git_email"
}

# ──────────────────────────────────────────────
# 5) JDK & graphviz
# ──────────────────────────────────────────────
install_jdk() {
    info "Instalando JDK..."

    # En macOS existe un stub 'java' aunque no haya JDK instalado;
    # verificamos que el comando realmente funcione antes de darlo por instalado
    if command -v java &> /dev/null && java -version &> /dev/null; then
        local java_version
        java_version=$(java -version 2>&1 | head -n 1)
        info "Java ya está instalado: $java_version"
        if ! confirm; then return 0; fi
    fi

    echo "¿Qué JDK prefieres?"
    echo "1) Temurin 17 (recomendado - OpenJDK)"
    echo "2) Temurin 11"
    echo "3) Temurin 21"
    echo "4) OpenJDK (última versión via Homebrew)"
    read -p "Selecciona (1-4): " jdk_choice

    case $jdk_choice in
        1) brew install --cask temurin@17 ;;
        2) brew install --cask temurin@11 ;;
        3) brew install --cask temurin@21 ;;
        4) brew install openjdk ;;
        *) brew install --cask temurin@17 ;;
    esac

    if command -v java &> /dev/null; then
        local java_version
        java_version=$(java -version 2>&1 | head -n 1)
        success "JDK instalado correctamente: $java_version"
    fi
}

install_jdk_and_graphviz() {
    install_jdk
    info "Instalando graphviz..."
    brew install graphviz
    success "graphviz instalado correctamente"
}

# ──────────────────────────────────────────────
# 6) PlantUML
# ──────────────────────────────────────────────
install_plantuml() {
    info "Instalando PlantUML..."

    if command -v plantuml &> /dev/null; then
        success "PlantUML ya está instalado"
        return 0
    fi

    if ! command -v java &> /dev/null; then
        warning "Java no está instalado. PlantUML requiere Java."
        info "Instalando Java automáticamente..."
        install_jdk || { error "No se pudo instalar Java."; return 1; }
    fi

    if ! command -v dot &> /dev/null; then
        warning "Graphviz no está instalado. Instalando automáticamente..."
        brew install graphviz
    fi

    if brew install plantuml; then
        success "PlantUML instalado correctamente desde Homebrew"
        return 0
    fi

    # Método de respaldo: JAR directo
    info "Instalando PlantUML desde JAR oficial..."
    sudo mkdir -p /opt/plantuml
    if sudo curl -L -o /opt/plantuml/plantuml.jar \
        "https://github.com/plantuml/plantuml/releases/download/$PLANTUML_VERSION/plantuml-${PLANTUML_VERSION#v}.jar"; then
        sudo tee /usr/local/bin/plantuml > /dev/null <<'EOF'
#!/bin/bash
java -jar /opt/plantuml/plantuml.jar "$@"
EOF
        sudo chmod +x /usr/local/bin/plantuml
        success "PlantUML instalado desde JAR oficial"
        return 0
    else
        error "No se pudo instalar PlantUML"
        return 1
    fi
}

# ──────────────────────────────────────────────
# 7) Visual Studio Code
# ──────────────────────────────────────────────
install_vscode() {
    info "Instalando Visual Studio Code..."

    if command -v code &> /dev/null || [ -d "/Applications/Visual Studio Code.app" ]; then
        success "Visual Studio Code ya está instalado"
        return 0
    fi

    brew install --cask visual-studio-code
    success "Visual Studio Code instalado correctamente"
}

# ──────────────────────────────────────────────
# 8) Workspace IA: agentes + iTerm2 + bundungun
# ──────────────────────────────────────────────
install_agents() {
    info "Instalando agentes de IA..."

    if ! command -v npm &> /dev/null; then
        warning "Node.js no está instalado. Es requerido para los agentes de IA."
        info "Instalando Node.js automáticamente..."
        install_nodejs || { error "No se pudo instalar Node.js."; return 1; }
    fi

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    echo
    info "¿Qué agentes deseas instalar?"
    echo "1) Claude Code"
    echo "2) Gemini CLI"
    echo "3) Codex"
    echo "4) Qwen Code"
    echo "5) OpenCode AI"
    echo "6) Coding Helper (Z.ai)"
    echo "7) Todos"
    read -p "Selecciona (1-7, o varios separados por comas): " agent_choice

    local install_claude=false install_gemini=false install_codex_agent=false
    local install_qwen=false install_opencode=false install_coding_helper=false

    case $agent_choice in
        *7*|*"todos"*|*"Todos"*)
            install_claude=true; install_gemini=true; install_codex_agent=true
            install_qwen=true;   install_opencode=true; install_coding_helper=true
            ;;
        *)
            [[ $agent_choice == *1* ]] && install_claude=true
            [[ $agent_choice == *2* ]] && install_gemini=true
            [[ $agent_choice == *3* ]] && install_codex_agent=true
            [[ $agent_choice == *4* ]] && install_qwen=true
            [[ $agent_choice == *5* ]] && install_opencode=true
            [[ $agent_choice == *6* ]] && install_coding_helper=true
            ;;
    esac

    # Instalar Claude Code
    if [ "$install_claude" = true ]; then
        info "Instalando Claude Code..."
        if npm list -g @anthropic-ai/claude-code &> /dev/null; then
            success "Claude Code ya está instalado"
        else
            npm install -g @anthropic-ai/claude-code \
                && success "Claude Code instalado correctamente" \
                || error "No se pudo instalar Claude Code"
        fi
    fi

    # Instalar Gemini CLI
    if [ "$install_gemini" = true ]; then
        info "Instalando Gemini CLI..."
        if npm list -g @google/gemini-cli &> /dev/null; then
            success "Gemini CLI ya está instalado"
        else
            npm install -g @google/gemini-cli \
                && success "Gemini CLI instalado correctamente" \
                || error "No se pudo instalar Gemini CLI"
        fi
    fi

    # Instalar Codex
    if [ "$install_codex_agent" = true ]; then
        info "Instalando Codex..."
        if npm list -g @openai/codex &> /dev/null; then
            success "Codex ya está instalado"
        else
            npm install -g @openai/codex \
                && success "Codex instalado correctamente" \
                || error "No se pudo instalar Codex"
        fi
    fi

    # Instalar Qwen Code
    if [ "$install_qwen" = true ]; then
        info "Instalando Qwen Code..."
        if npm list -g @qwen-code/qwen-code &> /dev/null; then
            success "Qwen Code ya está instalado"
        else
            npm install -g @qwen-code/qwen-code@latest \
                && success "Qwen Code instalado correctamente" \
                || error "No se pudo instalar Qwen Code"
        fi
    fi

    # Instalar OpenCode AI
    if [ "$install_opencode" = true ]; then
        info "Instalando OpenCode AI..."
        if npm list -g opencode-ai &> /dev/null; then
            success "OpenCode AI ya está instalado"
        else
            npm install -g opencode-ai \
                && success "OpenCode AI instalado correctamente" \
                || error "No se pudo instalar OpenCode AI"
        fi
    fi

    # Instalar Coding Helper (Z.ai)
    if [ "$install_coding_helper" = true ]; then
        info "Instalando Coding Helper (Z.ai)..."
        if npm list -g @z_ai/coding-helper &> /dev/null; then
            success "Coding Helper ya está instalado"
        else
            npm install -g @z_ai/coding-helper \
                && success "Coding Helper instalado correctamente" \
                || error "No se pudo instalar Coding Helper"
        fi
    fi

    # Instalar iTerm2 y configurar workspace
    info "Configurando workspace de agentes con iTerm2..."
    if install_iterm2; then
        configure_bundungun_launcher
        success "Workspace IA configurado: iTerm2 + bundungun listo"
    else
        warning "iTerm2 no se instaló correctamente. Los agentes están instalados pero bundungun no estará disponible."
    fi

    success "Agentes de IA configurados correctamente"
}

# Instalar iTerm2
install_iterm2() {
    info "Instalando iTerm2..."
    if [ -d "/Applications/iTerm.app" ]; then
        success "iTerm2 ya está instalado"
        return 0
    fi
    if brew install --cask iterm2; then
        success "iTerm2 instalado correctamente"
        return 0
    else
        error "No se pudo instalar iTerm2"
        return 1
    fi
}

ensure_local_bin_in_path() {
    # En macOS los terminales abren login shells, que cargan .zprofile antes que .zshrc.
    # Escribimos en ambos para garantizar que ~/.local/bin esté siempre en el PATH.
    local path_line='export PATH="$HOME/.local/bin:$PATH"'
    local added=false

    for rc in "$HOME/.zprofile" "$HOME/.zshrc" "$HOME/.bash_profile"; do
        [ -f "$rc" ] || continue
        if ! grep -q '\.local/bin' "$rc"; then
            echo '' >> "$rc"
            echo "$path_line" >> "$rc"
            info "Añadido ~/.local/bin al PATH en $rc"
            added=true
        fi
    done

    # Aplicar en la sesión actual también
    export PATH="$HOME/.local/bin:$PATH"

    [[ "$added" == false ]] && info "~/.local/bin ya estaba en PATH"
}

# Lanzador bundungun para macOS (iTerm2 con layout "sabios" via osascript)
configure_bundungun_launcher() {
    info "Creando lanzador bundungun en ~/.local/bin..."

    local bin_dir="$HOME/.local/bin"
    local launcher="$bin_dir/bundungun"
    mkdir -p "$bin_dir"

    # Nota: usamos 'BUNDUNGUN' sin comillas para que ${CURRENT_DIR} se expanda
    # al ejecutar bundungun, NO al escribir el archivo.
    # Las comillas dobles en el osascript -e se escapan con \"
    cat > "$launcher" <<'BUNDUNGUN'
#!/bin/bash
# bundungun - lanza iTerm2 con el layout "sabios" (4 agentes IA)
CURRENT_DIR="$(pwd)"

osascript -e "
tell application \"iTerm\"
    activate
    set W to (create window with default profile)
    set zoomed of W to true
    tell W
        set S1 to current session of current tab
        tell S1
            write text \"cd '${CURRENT_DIR}' && source ~/.nvm/nvm.sh 2>/dev/null; claude\"
            set S2 to (split vertically with default profile)
        end tell
        tell S2
            write text \"cd '${CURRENT_DIR}' && source ~/.nvm/nvm.sh 2>/dev/null; gemini\"
        end tell
        tell S1
            set S3 to (split horizontally with default profile)
        end tell
        tell S3
            write text \"cd '${CURRENT_DIR}' && source ~/.nvm/nvm.sh 2>/dev/null; opencode\"
        end tell
        tell S2
            set S4 to (split horizontally with default profile)
        end tell
        tell S4
            write text \"cd '${CURRENT_DIR}' && source ~/.nvm/nvm.sh 2>/dev/null; qwen\"
        end tell
    end tell
end tell
"
BUNDUNGUN

    chmod +x "$launcher"
    info "Lanzador bundungun creado en $launcher"

    ensure_local_bin_in_path
    success "bundungun disponible en el PATH"
}

# ──────────────────────────────────────────────
# 9) GitHub CLI
# ──────────────────────────────────────────────
install_github_cli() {
    info "Instalando GitHub CLI..."

    if command -v gh &> /dev/null; then
        success "GitHub CLI ya está instalado"
        info "Versión: $(gh --version | head -n 1)"

        if gh auth status &> /dev/null; then
            info "GitHub CLI ya está autenticado"
        else
            info "Configurando autenticación de GitHub CLI..."
            gh auth login
        fi

        if gh extension list | grep -q "github/gh-classroom"; then
            info "Extensión gh-classroom ya está instalada"
        else
            info "Instalando extensión gh-classroom..."
            gh extension install github/gh-classroom
        fi

        return 0
    fi

    brew install gh
    info "Configurando autenticación..."
    gh auth login
    gh extension install github/gh-classroom

    success "GitHub CLI instalado y configurado correctamente"
}

# ──────────────────────────────────────────────
# 10) Configurar firma GPG para Git
# ──────────────────────────────────────────────
configure_gpg() {
    info "Configurando firma GPG para Git..."

    local current_signing_key gpg_sign_enabled git_email
    current_signing_key=$(git config --global user.signingkey 2>/dev/null || echo "")
    gpg_sign_enabled=$(git config --global commit.gpgsign 2>/dev/null || echo "")
    git_email=$(git config --global user.email 2>/dev/null || echo "")

    if [[ -n "$current_signing_key" && "$gpg_sign_enabled" == "true" ]]; then
        success "GPG ya está configurado para Git"
        info "Clave de firma: $current_signing_key"
        return 0
    fi

    # En macOS: gnupg + pinentry-mac (integración nativa con el llavero)
    brew install gnupg pinentry-mac

    info "Se va a generar una nueva clave GPG. Sigue las instrucciones en pantalla."
    info "Recomendaciones:"
    info "1. Seleccionar RSA and RSA (opción por defecto)"
    info "2. Usar 4096 bits"
    info "3. Elegir tiempo de validez (0 = no expira)"
    info "4. Email debe coincidir con el de GitHub"

    if confirm; then
        gpg --full-generate-key

        local key_id
        key_id=$(select_gpg_key_for_email "$git_email")

        if [[ -n "$key_id" ]]; then
            gpg --armor --export "$key_id"

            info "Copia la clave pública mostrada arriba (incluyendo las líneas BEGIN y END)"
            info "Ve a GitHub → Settings → SSH and GPG keys → 'New GPG key' → Pega la clave"
            read -p "Presiona Enter cuando hayas añadido la clave a GitHub..."

            git config --global user.signingkey "$key_id"
            git config --global commit.gpgsign true

            local shell_rc
            shell_rc=$(get_shell_rc_file)
            if ! grep -q "export GPG_TTY" "$shell_rc"; then
                echo "" >> "$shell_rc"
                echo "export GPG_TTY=\$(tty)" >> "$shell_rc"
                info "Se ha añadido 'export GPG_TTY=\$(tty)' a $shell_rc"
            fi

            # pinentry-mac: integración con el llavero de macOS
            set_gpg_agent_option "pinentry-program" "$(brew --prefix)/bin/pinentry-mac"
            set_gpg_agent_option "default-cache-ttl" "34560000"
            set_gpg_agent_option "max-cache-ttl" "34560000"

            gpgconf --kill gpg-agent
            gpgconf --launch gpg-agent

            success "GPG configurado correctamente con la clave $key_id"
        else
            error "No se pudo obtener el ID de la clave GPG"
        fi
    else
        info "Configuración de GPG cancelada"
    fi
}

# ──────────────────────────────────────────────
# 11) Spotify
# ──────────────────────────────────────────────
install_spotify() {
    info "Instalando Spotify..."
    if [ -d "/Applications/Spotify.app" ]; then
        success "Spotify ya está instalado"
        return 0
    fi
    brew install --cask spotify
    success "Spotify instalado correctamente"
}

# ──────────────────────────────────────────────
# 12) VLC
# ──────────────────────────────────────────────
install_vlc() {
    info "Instalando VLC..."
    if [ -d "/Applications/VLC.app" ]; then
        success "VLC ya está instalado"
        return 0
    fi
    brew install --cask vlc
    success "VLC instalado correctamente"
}

# ──────────────────────────────────────────────
# 13) Utilitarios
# ──────────────────────────────────────────────
install_utilities() {
    info "Instalando utilitarios y herramientas de desarrollo..."

    brew install \
        tree \
        htop \
        fastfetch \
        bat \
        fd \
        ripgrep \
        tmux \
        vim \
        eza

    # DOSBox-X
    info "Instalando DOSBox-X..."
    if ! brew list --cask dosbox-x &> /dev/null 2>&1; then
        brew install --cask dosbox-x || warning "DOSBox-X no disponible en este momento"
    else
        info "DOSBox-X ya está instalado"
    fi

    # KDEnLive
    info "Instalando KDEnLive..."
    brew install --cask kdenlive || warning "KDEnLive no disponible en este momento"

    # Virtualización: VirtualBox (Intel) o UTM (Apple Silicon recomendado)
    if [[ "$ARCH" == "x86_64" ]]; then
        info "Instalando VirtualBox (Intel)..."
        brew install --cask virtualbox \
            || warning "VirtualBox requiere permisos en Ajustes del Sistema → Privacidad y seguridad"
    else
        warning "VirtualBox en Apple Silicon tiene soporte experimental (requiere VirtualBox 7.1+)."
        info "Se recomienda UTM (gratuito) como alternativa nativa."
        echo "¿Qué prefieres instalar?"
        echo "1) UTM (recomendado para Apple Silicon)"
        echo "2) VirtualBox (soporte experimental)"
        echo "3) Ambos"
        echo "4) Ninguno"
        read -p "Selecciona (1-4): " vm_choice
        case $vm_choice in
            1) brew install --cask utm ;;
            2) brew install --cask virtualbox ;;
            3) brew install --cask utm; brew install --cask virtualbox ;;
            *) info "Virtualización omitida" ;;
        esac
    fi

    success "Utilitarios instalados correctamente"
}

# ──────────────────────────────────────────────
# 14) oh-my-posh + Nerd Fonts
# ──────────────────────────────────────────────
install_oh_my_posh() {
    info "Instalando oh-my-posh..."

    if ! command -v oh-my-posh &> /dev/null; then
        brew install jandedobbeleer/oh-my-posh/oh-my-posh
    else
        success "oh-my-posh ya está instalado"
    fi

    # Nerd Fonts via Homebrew (la forma correcta en macOS)
    info "Instalando Nerd Fonts (FiraCode y MesloLG)..."

    local firacode_installed=false meslo_installed=false

    if brew list --cask font-fira-code-nerd-font &> /dev/null 2>&1; then
        firacode_installed=true
        info "FiraCode Nerd Font ya está instalada"
    fi

    if brew list --cask font-meslo-lg-nerd-font &> /dev/null 2>&1; then
        meslo_installed=true
        info "MesloLG Nerd Font ya está instalada"
    fi

    [[ "$firacode_installed" == false ]] && brew install --cask font-fira-code-nerd-font
    [[ "$meslo_installed" == false ]]    && brew install --cask font-meslo-lg-nerd-font

    success "Nerd Fonts instaladas correctamente"

    # Configurar tema en el shell
    local shell_rc
    shell_rc=$(get_shell_rc_file)
    local shell_name
    shell_name=$(basename "$SHELL")

    read -p "¿Qué tema de oh-my-posh deseas usar? (por defecto: nordtron): " theme
    theme=${theme:-nordtron}

    local omp_init="eval \"\$(oh-my-posh init ${shell_name} --config \$(brew --prefix oh-my-posh)/themes/${theme}.omp.json)\""

    if grep -q "oh-my-posh init" "$shell_rc"; then
        sed -i '' "s|.*oh-my-posh init.*|${omp_init}|g" "$shell_rc"
    else
        echo "$omp_init" >> "$shell_rc"
    fi

    info "Configuración añadida a $shell_rc con el tema $theme"
    success "oh-my-posh instalado correctamente"
}

# ──────────────────────────────────────────────
# Node.js via nvm
# ──────────────────────────────────────────────
install_nodejs() {
    info "Instalando Node.js vía nvm..."

    if [ -s "$HOME/.nvm/nvm.sh" ]; then
        info "nvm ya está instalado"
        \. "$HOME/.nvm/nvm.sh"
    else
        info "Descargando e instalando nvm..."
        curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | bash

        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

        if [ -s "$HOME/.nvm/nvm.sh" ]; then
            success "nvm instalado correctamente"
        else
            error "No se pudo instalar nvm"
            return 1
        fi
    fi

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    if command -v node &> /dev/null; then
        local node_version
        node_version=$(node --version)
        info "Node.js ya está instalado: $node_version"

        if [[ "${FUNCNAME[1]}" == "install_agents" || \
              "${FUNCNAME[1]}" == "install_utilities" || \
              "${FUNCNAME[1]}" == "install_dependencies" ]]; then
            return 0
        fi

        if ! confirm; then return 0; fi
    fi

    info "Instalando Node.js v$NODE_VERSION..."
    nvm install "$NODE_VERSION"

    if command -v node &> /dev/null; then
        success "Node.js instalado: $(node --version) | npm: $(npm --version)"
    else
        error "No se pudo instalar Node.js"
        return 1
    fi
}

# ──────────────────────────────────────────────
# 15) Carpeta de repositorios
# ──────────────────────────────────────────────
setup_repos_directory() {
    info "Configurando carpeta de repositorios..."

    if [ ! -d "$HOME/misRepos" ]; then
        mkdir -p "$HOME/misRepos"
        success "Carpeta ~/misRepos creada"
    else
        info "Carpeta ~/misRepos ya existe"
    fi

    local shell_rc
    shell_rc=$(get_shell_rc_file)

    if [[ -n "$shell_rc" ]]; then
        if ! grep -q "cd.*misRepos" "$shell_rc"; then
            {
                echo ""
                echo "# Cambiar al directorio de repositorios al abrir terminal"
                echo "if [ \"\$PWD\" = \"\$HOME\" ]; then"
                echo "    cd ~/misRepos 2>/dev/null || true"
                echo "fi"
            } >> "$shell_rc"
            success "Configuración añadida a $shell_rc"
            info "El terminal abrirá en ~/misRepos por defecto"
            info "Para aplicar los cambios: source $shell_rc"
        else
            info "La configuración de directorio por defecto ya existe en $shell_rc"
        fi
    fi

    success "Carpeta de repositorios configurada correctamente"
}

# ──────────────────────────────────────────────
# 16) Descargar repositorios predefinidos
# ──────────────────────────────────────────────
download_repos() {
    info "Descargando repositorios en ~/misRepos..."
    setup_repos_directory

    if ! command -v git &> /dev/null; then
        brew install git
    fi

    local repos=(
        "https://github.com/mmasias/prg1"
        "https://github.com/mmasias/prg2"
        "https://github.com/mmasias/eda1"
        "https://github.com/mmasias/eda2"
        "https://github.com/mmasias/idsw1"
        "https://github.com/mmasias/idsw2"
    )

    for repo_url in "${repos[@]}"; do
        local repo_name target_dir
        repo_name=$(basename "$repo_url")
        target_dir="$HOME/misRepos/$repo_name"

        if [ -d "$target_dir/.git" ]; then
            info "Repositorio $repo_name ya existe. Actualizando..."
            git -C "$target_dir" pull --ff-only \
                && success "$repo_name actualizado" \
                || warning "No se pudo actualizar $repo_name (revisa el repo manualmente)"
        else
            info "Clonando $repo_name..."
            git clone "$repo_url" "$target_dir" \
                && success "$repo_name clonado en ~/misRepos" \
                || error "Falló la clonación de $repo_name"
        fi
    done

    success "Repositorios descargados/actualizados"
}

# ──────────────────────────────────────────────
# 17) Limpiar sistema
# ──────────────────────────────────────────────
cleanup_system() {
    info "Limpiando sistema..."
    brew cleanup
    brew autoremove

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

# ──────────────────────────────────────────────
# 18) Quitar bloatware
# ──────────────────────────────────────────────
remove_bloatware() {
    info "En macOS el 'bloatware' son principalmente apps Apple preinstaladas."

    local garageband_installed=false imovie_installed=false
    [ -d "/Applications/GarageBand.app" ] && garageband_installed=true
    [ -d "/Applications/iMovie.app" ]     && imovie_installed=true

    if [[ "$garageband_installed" == false && "$imovie_installed" == false ]]; then
        success "GarageBand e iMovie ya no están instalados"
        return 0
    fi

    echo
    echo "Apps detectadas:"
    [[ "$garageband_installed" == true ]] && echo "  · GarageBand  (~1.8 GB)"
    [[ "$imovie_installed"     == true ]] && echo "  · iMovie      (~3 GB)"
    echo
    echo "¿Qué deseas eliminar?"
    [[ "$garageband_installed" == true ]] && echo "1) GarageBand"
    [[ "$imovie_installed"     == true ]] && echo "2) iMovie"
    [[ "$garageband_installed" == true && "$imovie_installed" == true ]] && echo "3) Ambas"
    echo "4) Ninguna / Omitir"
    read -p "Selecciona: " bloat_choice

    warning "Estas apps pueden reinstalarse desde la App Store si las necesitas después."
    if ! confirm; then
        info "Operación cancelada"
        return 0
    fi

    case $bloat_choice in
        1)
            if [[ "$garageband_installed" == true ]]; then
                sudo rm -rf /Applications/GarageBand.app
                rm -rf ~/Library/Application\ Support/GarageBand
                rm -rf ~/Library/Audio/Apple\ Loops
                success "GarageBand eliminado"
            else
                info "GarageBand no está instalado"
            fi
            ;;
        2)
            if [[ "$imovie_installed" == true ]]; then
                sudo rm -rf /Applications/iMovie.app
                rm -rf ~/Library/Application\ Support/iMovie
                success "iMovie eliminado"
            else
                info "iMovie no está instalado"
            fi
            ;;
        3)
            [[ "$garageband_installed" == true ]] && {
                sudo rm -rf /Applications/GarageBand.app
                rm -rf ~/Library/Application\ Support/GarageBand
                rm -rf ~/Library/Audio/Apple\ Loops
                success "GarageBand eliminado"
            }
            [[ "$imovie_installed" == true ]] && {
                sudo rm -rf /Applications/iMovie.app
                rm -rf ~/Library/Application\ Support/iMovie
                success "iMovie eliminado"
            }
            ;;
        *)
            info "Operación cancelada"
            ;;
    esac
}

# ──────────────────────────────────────────────
# 20) Verificar estado de instalaciones
# ──────────────────────────────────────────────
check_status() {
    clear
    echo "======================================"
    echo "  ESTADO DE INSTALACIÓN"
    echo "======================================"
    echo "Sistema: macOS $(sw_vers -productVersion) — $ARCH_NAME"
    echo

    check_item() {
        local name="$1" cmd="$2"
        printf "%-40s " "$name:"
        command -v "$cmd" &> /dev/null \
            && echo -e "${GREEN}✓ INSTALADO${NC}" \
            || echo -e "${RED}✗ NO INSTALADO${NC}"
    }

    check_app() {
        local name="$1" app_path="$2"
        printf "%-40s " "$name:"
        [ -d "$app_path" ] \
            && echo -e "${GREEN}✓ INSTALADO${NC}" \
            || echo -e "${RED}✗ NO INSTALADO${NC}"
    }

    check_config() {
        local name="$1" check_cmd="$2"
        printf "%-40s " "$name:"
        eval "$check_cmd" &> /dev/null \
            && echo -e "${GREEN}✓ CONFIGURADO${NC}" \
            || echo -e "${RED}✗ NO CONFIGURADO${NC}"
    }

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "HERRAMIENTAS BÁSICAS"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    check_item "Homebrew"  "brew"
    check_item "curl"      "curl"
    check_item "wget"      "wget"
    check_item "git"       "git"

    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "CONFIGURACIÓN DE GIT"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    check_config "Git user.name"    "git config --global user.name"
    check_config "Git user.email"   "git config --global user.email"
    check_config "Git GPG signing"  "git config --global commit.gpgsign | grep -q 'true'"

    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "NAVEGADORES"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    check_app "Google Chrome" "/Applications/Google Chrome.app"

    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "DESARROLLO"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    check_item "Java (JDK)"          "java"
    check_item "graphviz"            "dot"
    check_item "PlantUML"            "plantuml"
    check_app  "Visual Studio Code"  "/Applications/Visual Studio Code.app"
    check_item "GitHub CLI"          "gh"

    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "MULTIMEDIA"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    check_app "Spotify"   "/Applications/Spotify.app"
    check_app "VLC"       "/Applications/VLC.app"
    check_app "KDEnLive"  "/Applications/kdenlive.app"

    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "UTILIDADES"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    check_item "Node.js"    "node"
    check_item "npm"        "npm"
    printf "%-40s " "nvm:"
    [ -s "$HOME/.nvm/nvm.sh" ] \
        && echo -e "${GREEN}✓ INSTALADO${NC}" \
        || echo -e "${RED}✗ NO INSTALADO${NC}"
    check_item "tree"       "tree"
    check_item "htop"       "htop"
    check_item "fastfetch"  "fastfetch"
    check_item "bat"        "bat"
    check_item "ripgrep"    "rg"
    check_item "tmux"       "tmux"
    check_item "vim"        "vim"
    check_item "eza"        "eza"
    printf "%-40s " "bundungun:"
    [ -x "$HOME/.local/bin/bundungun" ] \
        && echo -e "${GREEN}✓ INSTALADO${NC}" \
        || echo -e "${RED}✗ NO INSTALADO${NC}"
    check_app  "iTerm2"     "/Applications/iTerm.app"

    if [[ "$ARCH" == "x86_64" ]]; then
        check_app "VirtualBox" "/Applications/VirtualBox.app"
    else
        check_app "UTM"        "/Applications/UTM.app"
        check_app "VirtualBox" "/Applications/VirtualBox.app"
    fi

    check_app "DOSBox-X" "/Applications/DOSBox-X.app"

    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "PERSONALIZACIÓN"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    check_item "oh-my-posh" "oh-my-posh"

    if [[ "$SHELL" == *"zsh"* ]]; then
        check_config "oh-my-posh en .zshrc" "grep -q 'oh-my-posh init' ~/.zshrc"
    elif [[ "$SHELL" == *"bash"* ]]; then
        check_config "oh-my-posh en .bash_profile" "grep -q 'oh-my-posh init' ~/.bash_profile"
    fi

    printf "%-40s " "Carpeta ~/misRepos:"
    [ -d "$HOME/misRepos" ] \
        && echo -e "${GREEN}✓ CREADA${NC}" \
        || echo -e "${RED}✗ NO CREADA${NC}"

    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "AGENTES DE IA"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if command -v npm &> /dev/null; then
        _check_agent() {
            printf "%-40s " "$1:"
            npm list -g "$2" &> /dev/null \
                && echo -e "${GREEN}✓ INSTALADO${NC}" \
                || echo -e "${RED}✗ NO INSTALADO${NC}"
        }
        _check_agent "Claude Code"          "@anthropic-ai/claude-code"
        _check_agent "Gemini CLI"           "@google/gemini-cli"
        _check_agent "Codex"                "@openai/codex"
        _check_agent "Qwen Code"            "@qwen-code/qwen-code"
        _check_agent "OpenCode AI"          "opencode-ai"
        _check_agent "Coding Helper (Z.ai)" "@z_ai/coding-helper"
    else
        echo -e "${YELLOW}[INFO]${NC} npm no está instalado. Los agentes de IA requieren Node.js/npm."
    fi

    echo
    echo "======================================"
}

# ──────────────────────────────────────────────
# Menú principal
# ──────────────────────────────────────────────
show_menu() {
    clear
    local macos_version
    macos_version=$(sw_vers -productVersion)
    local git_user
    git_user=$(git config --global user.name 2>/dev/null || true)

    local chrome_status="-" code_status="-"
    [ -d "/Applications/Google Chrome.app" ] && chrome_status="Chrome"
    [ -d "/Applications/Visual Studio Code.app" ] && code_status="VSCode"

    local agent_c agent_o agent_g agent_q agent_x agent_h
    agent_c=$(command -v claude   &> /dev/null && echo "C" || echo "-")
    agent_o=$(command -v opencode &> /dev/null && echo "O" || echo "-")
    agent_g=$(command -v gemini   &> /dev/null && echo "G" || echo "-")
    agent_q=$(command -v qwen     &> /dev/null && echo "Q" || echo "-")
    agent_x=$(command -v codex    &> /dev/null && echo "X" || echo "-")
    agent_h=$(npm list -g @z_ai/coding-helper &> /dev/null 2>&1 && echo "H" || echo "-")
    local agents_summary="[$agent_c/$agent_o/$agent_g/$agent_q]/$agent_x/$agent_h"

    local tools_line=""
    [[ -n "$git_user" ]] && tools_line="git: $git_user | "
    tools_line="${tools_line}${chrome_status} | ${code_status} | Agentes: ${agents_summary}"

    echo "SCRIPT DE CONFIGURACIÓN macOS"
    echo "$USER@macOS $macos_version ($ARCH_NAME)"
    echo "$tools_line"
    echo "=============================================="
    echo
    printf "%-45s %s\n" "1)  Todo!" "2)  Dependencias básicas + Homebrew"
    printf "%-45s %s\n" "3)  Configurar Git" "4)  Google Chrome"
    printf "%-45s %s\n" "5)  JDK & graphviz" "6)  PlantUML"
    printf "%-45s %s\n" "7)  Visual Studio Code" "8)  Workspace IA (Agentes + bundungun)"
    printf "%-45s %s\n" "9)  GitHub CLI" "10) Configurar firma GPG"
    printf "%-45s %s\n" "11) Spotify" "12) VLC"
    printf "%-45s %s\n" "13) Utilitarios" "14) oh-my-posh"
    printf "%-45s %s\n" "15) Carpeta repo" "16) Descargar repos"
    printf "%-45s %s\n" "17) Limpiar sistema" "18) Quitar bloatware"
    printf "%-45s %s\n" "19) SysInfo" "20) Ver estado"
    printf "%-45s %s\n" "99) Salir" ""
    echo
    read -p "Ingresa tu opción: " option

    case $option in
        1)
            install_dependencies
            configure_git
            install_browsers
            install_jdk_and_graphviz
            install_plantuml
            install_vscode
            install_agents
            install_github_cli
            configure_gpg
            install_spotify
            install_vlc
            install_utilities
            install_oh_my_posh
            setup_repos_directory
            download_repos
            remove_bloatware
            cleanup_system
            ;;
        2)  install_dependencies ;;
        3)  configure_git ;;
        4)  install_browsers ;;
        5)  install_jdk_and_graphviz ;;
        6)  install_plantuml ;;
        7)  install_vscode ;;
        8)  install_agents ;;
        9)  install_github_cli ;;
        10) configure_gpg ;;
        11) install_spotify ;;
        12) install_vlc ;;
        13) install_utilities ;;
        14) install_oh_my_posh ;;
        15) setup_repos_directory ;;
        16) download_repos ;;
        17) cleanup_system ;;
        18) remove_bloatware ;;
        19)
            echo "Información del sistema:"
            echo "macOS:        $(sw_vers -productVersion) ($(sw_vers -buildVersion))"
            echo "Arquitectura: $ARCH_NAME"
            echo "Kernel:       $(uname -r)"
            echo "Uptime:       $(uptime)"
            echo "CPU:          $(sysctl -n machdep.cpu.brand_string 2>/dev/null || sysctl -n hw.model)"
            echo "Memoria:      $(( $(sysctl -n hw.memsize) / 1024 / 1024 / 1024 )) GB"
            ;;
        20) check_status ;;
        99)
            echo "¡Gracias por usar el script!"
            exit 0
            ;;
        *)  error "Opción inválida" ;;
    esac

    read -p "Presiona Enter para continuar..."
    show_menu
}

# ──────────────────────────────────────────────
# Punto de entrada principal
# ──────────────────────────────────────────────
main() {
    if [[ $EUID -eq 0 ]]; then
        error "Este script no debe ejecutarse como root directamente."
        info "Usa 'bash $0' como usuario normal."
        exit 1
    fi

    # Verificar que estamos en macOS
    if [[ "$(uname)" != "Darwin" ]]; then
        error "Este script es para macOS. Para Linux, usa setup-linux.sh"
        exit 1
    fi

    detect_arch

    # Modo pipe (curl | bash) → instalación completa sin menú
    if [ ! -t 0 ]; then
        info "Ejecutando instalación completa automática..."
        install_dependencies
        configure_git
        install_browsers
        install_jdk_and_graphviz
        install_plantuml
        install_vscode
        install_agents
        install_github_cli
        configure_gpg
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

    show_menu
}

main
