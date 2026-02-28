# :robot:

Esto, que empezó como una chuleta de cosas por hacer cuando instalaba la distribución de elementaryOS en un ordenador nuevo, ha crecido hasta convertirse en un chuletón que automatiza (hasta donde es posible) las cosas que hago cuando instalo casi que cualquier distribución de GNU/Linux en un ordenador nuevo.

```console
SCRIPT DE CONFIGURACIÓN LINUX
manuel@Ubuntu 25.10 | git: manuel@oficina | Chrome | VSCode | Agentes: C/G/C/Q/O/H
==============================================

1)  Todo!                                     2)  Dependencias básicas
3)  Configurar Git                            4)  Navegadores (Chrome & Brave)
5)  JDK & graphviz                            6)  PlantUML
7)  Visual Studio Code                        8)  Antigravity IDE
9)  GitHub CLI                                10) Configurar firma GPG
11) Node.js (nvm)                             12) Workspace IA (Agentes + bundungun)
13) Spotify                                   14) VLC
15) Utilitarios                               16) oh-my-posh
17) Carpeta repo                              18) Descargar repos
19) Limpiar sistema                           20) Quitar bloatware
21) SysInfo                                   22) Ver estado
99)  Salir                                    

Ingresa tu opción:
```

## Instalación rápida

### Automática (instalación completa)
```bash
curl -fsSL https://raw.githubusercontent.com/mmasias/mmasias/main/GNU.Linux/setup-linux.sh | bash
```

### Interactiva (menú de opciones)
```bash
wget https://raw.githubusercontent.com/mmasias/mmasias/main/GNU.Linux/setup-linux.sh
bash setup-linux.sh
```

> TsP / TpR: 20 min / 30 min
>
> TsP: Tiempo en ser productivo | TpR: Tiempo productividad recuperada
>
> **Actualizado**: menú extendido (PlantUML, Antigravity, GitHub CLI, agentes IA con Node/nvm, utilitarios DOSBox-X/Jorts/KDEnLive/VirtualBox), limpieza avanzada de bloatware, carpeta `~/misRepos` con clonado automático, pinentry GPG
>
> Agradecimientos a [Claude (Anthropic)](https://claude.ai) y [Codex (OpenAI)](https://platform.openai.com/docs/assistants/coding) por ayudar a iterar el [archivo de instalación](setup-linux.sh) que realiza todo esto.

Las secciones siguientes son solo para instalación manual o puntual. Si ya usas el script, no necesitas repetirlas.

## Funcionalidades destacadas del script

### ¿Qué hace ahora el script?

- Detecta la distro (Debian/Ubuntu, RPM/Fedora, Arch/Manjaro) y adapta cada instalación.
- Instala Chrome y, si quieres, Brave; luego pausa para que los configures como predeterminados y loguees GitHub.
- Configura Git (nombre/email), GPG con pinentry según escritorio y GitHub CLI + extensión Classroom.
- Java (elige versión), graphviz, PlantUML; VSCode y Antigravity IDE.
- Node.js v24 vía nvm, agentes de IA (`claude-code`, `gemini-cli`, `codex`, `qwen-code`), utilitarios (tree/htop/neofetch/bat/fd/rg/tmux/vim/eza), DOSBox-X, Jorts, KDEnLive, VirtualBox.
- oh-my-posh con temas y Nerd Fonts (FiraCode/Meslo) automáticas.
- Crea `~/misRepos`, puede clonar/actualizar tus repos de clase y dejar el terminal apuntando allí.
- Limpieza de bloatware (Firefox, LibreOffice, Thunderbird) opcional y limpieza de paquetes/cache.

### Terminator con layout "sabios"

El script configura automáticamente Terminator con un layout personalizado de 4 paneles que ejecuta los agentes de IA:

- **Panel superior izquierdo**: Claude Code (`claude`)
- **Panel inferior izquierdo**: Gemini CLI (`gemini`)
- **Panel superior derecho**: Codex (`codex`)
- **Panel inferior derecho**: Qwen Code (`qwen`)

La configuración incluye la fuente FiraCode Nerd Font Propo Medium 15 y se guarda en `~/.config/terminator/config`.

### Lanzador bundungun

<img src="../../images/bundungunLogo.png" width=25% align=right>

El script crea un lanzador llamado `bundungun` en `~/.local/bin/` que:

- Lanza Terminator con el layout "sabios" (4 paneles con agentes IA)
- Se ejecuta desde cualquier directorio conservando tu ubicación actual
- Abre los 4 agentes de IA listos para usar en un solo comando

Uso:
```bash
bundungun
```

El script se asegura de que `~/.local/bin` esté en tu PATH automáticamente.

### Verificación de estado (Opción 22)

El script incluye una función completa de diagnóstico que muestra el estado de instalación de todos los componentes:

```console
======================================
  ESTADO DE INSTALACIÓN
======================================
Distribución: ubuntu (debian)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
HERRAMIENTAS BÁSICAS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
curl:                                    ✓ INSTALADO
wget:                                    ✓ INSTALADO
git:                                     ✓ INSTALADO
unzip:                                   ✓ INSTALADO

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CONFIGURACIÓN DE GIT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Git user.name:                           ✓ CONFIGURADO
Git user.email:                          ✓ CONFIGURADO
Git GPG signing:                         ✓ CONFIGURADO

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
AGENTES DE IA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Claude Code:                             ✓ INSTALADO
Gemini CLI:                              ✓ INSTALADO
Codex:                                   ✓ INSTALADO
Qwen Code:                               ✓ INSTALADO
```

Incluye verificaciones de:
- Herramientas básicas (curl, wget, git, unzip)
- Configuración de Git y GPG
- Navegadores (Chrome, Brave)
- IDEs (VS Code, Antigravity)
- Herramientas de desarrollo (Java, graphviz, PlantUML, GitHub CLI)
- Multimedia (Spotify, VLC, KDEnLive)
- Utilidades (Node.js, npm, nvm, tree, htop, neofetch, bat, ripgrep, tmux, vim, eza, bundungun, Terminator, VirtualBox, DOSBox-X)
- Personalización (oh-my-posh)
- Agentes de IA con formato visual C/G/C/Q
- Carpeta ~/misRepos

### Pausa inteligente para configuración de navegadores

Después de instalar Chrome y Brave, el script pausa la ejecución y solicita que realices manualmente:

1. Definir el navegador por defecto del sistema
2. Iniciar sesión en GitHub en el navegador elegido (necesario para configuración de Git y GPG)

Esta pausa garantiza que los pasos siguientes (configuración de GPG, GitHub CLI) funcionen correctamente.

### Detección automática de pinentry

El script detecta automáticamente tu entorno de escritorio (KDE, GNOME, XFCE u otros) e instala y configura el pinentry correcto:

- **KDE**: `pinentry-qt`
- **GNOME**: `pinentry-gnome3`
- **Otros**: `pinentry-gtk2`

Esto evita problemas al firmar commits con GPG en diferentes entornos gráficos.

### Limpieza de configuración GPG

La opción de limpieza de sistema (19) incluye una función que:

- Detecta entradas duplicadas en `~/.gnupg/gpg-agent.conf`
- Mantiene solo los últimos valores configurados de cada parámetro
- Limpia `pinentry-program`, `default-cache-ttl` y `max-cache-ttl`

Esto evita conflictos causados por ejecuciones múltiples del script.

---

## Instalación manual (opcional)

## Instalar Chrome & Brave
Manual (si no usas el script): Chrome del [canal oficial](https://www.google.com/chrome/?platform=linux) y Brave del [canal oficial](https://brave.com/download/).

```bash
# Debian_Based distro:
# Chrome
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

# Brave
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser

# RPM_Based distro:
# Chrome
sudo tee /etc/yum.repos.d/google-chrome.repo > /dev/null <<EOF
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
EOF
sudo dnf install google-chrome-stable

# Brave
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf install brave-browser

# Manjaro
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si

yay -S google-chrome
yay -S brave-bin
```

## Instalar GIT

```bash
# Debian_Based distro:
sudo apt install git

# RPM_Based distro:
sudo dnf install git

# Manjaro
sudo pacman -Syu git

# Común a las tres
git config --global user.name "nick@dondeSea" # usa algo que te ubique (casa/oficina/aula/portátil)
git config --global user.email "tu@email"
```

> [Configurar GPG para firma](GNU.Linux.GPG.md)

## Instalar gdebi, curl, jdk, graphviz, VSCode

Ya lo hace el script. Solo si quieres a mano: gdebi (Debian), curl en tu gestor, `openjdk`/`graphviz` desde repos, y VSCode desde el [link oficial](https://code.visualstudio.com/docs/setup/linux).

## Instalar Spotify

```bash
# Debian_Based distro:
curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update
sudo apt install spotify-client

# RPM_Based distro (snap es la vía más estable):
sudo dnf install snapd
sudo ln -s /var/lib/snapd/snap /snap 2>/dev/null || true
sudo systemctl enable --now snapd.socket
sudo snap install spotify
# Alternativa con repo oficial:
sudo rpm --import https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg
sudo tee /etc/yum.repos.d/spotify.repo > /dev/null <<EOF
[spotify]
name=Spotify repository
baseurl=http://repository.spotify.com/rpm/stable/x86_64/
enabled=1
gpgcheck=1
gpgkey=https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg
EOF
sudo dnf install spotify-client || echo "Si falla, usa snap arriba"

# Manjaro
yay -S spotify
```

## Instalar VLC

```bash
# Debian_Based distro:
sudo apt install vlc

# RPM_Based distro:
sudo dnf install vlc

# Manjaro
sudo pacman -Syu vlc
```

### Instalar la impresora

Instalar el [Driver CQue DEB](https://www.canon.es/support/products/imagerunner/imagerunner-advance-c5235i.html?type=drivers&driverdetailid=tcm:86-1894069&os=linux%20%2864-bit%29&language=es)

```bash
sudo systemctl stop cups
sudo vi /etc/cups/printers.conf
# Editar la IP
sudo systemctl restart cups
```

> #notaMental: 213, iR-ADV C5235/5240 UFR II

#### Semi-Auto

- [Drivers](https://drive.google.com/drive/folders/1HjncE-cJPyxzEuDZsfUW21V7-b5mSSA3?usp=sharing)
- [Config](../images/impresoraCanonGNU.png)

### Instalar oh-my-posh

```bash
# Debian_Based distro y RPM_Based distro:
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh
mkdir ~/.poshthemes
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.omp.*
rm ~/.poshthemes/themes.zip

# Manjaro
# Preinstalado por defecto
```

Nerd Fonts incluidas automáticamente: [FiraCode](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip) && [MesloLG](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Meslo.zip) (el script las descarga e instala automáticamente)

Tema: nordtron

<img width="434" alt="image" src="https://user-images.githubusercontent.com/8528047/215170894-5f288539-7a31-45c2-b4fb-bd557a14e3b5.png">

En ```.bashrc```

```
eval "$(oh-my-posh init bash --config /home/USERNAME/.poshthemes/nordtron.omp.json)"
```

## Otros utilitarios interesantes

```bash
# Debian_Based distro:
sudo apt install tree htop neofetch bat fd-find ripgrep tmux vim
# eza no está en los repos oficiales, instálalo con cargo
sudo apt install cargo && cargo install eza
sudo apt install kdenlive virtualbox virtualbox-ext-pack || sudo apt install virtualbox
# DOSBox-X y Jorts (cliente Mastodon) van mejor por flatpak:
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.dosbox_x.DOSBox-X ca.joshuadoes.Jorts

# RPM_Based distro:
sudo dnf install tree htop neofetch bat fd-find ripgrep tmux vim gcc gcc-c++ make
sudo dnf install eza || (sudo dnf install cargo && cargo install eza)
sudo dnf install kdenlive VirtualBox
# DOSBox-X y Jorts por flatpak (añadir Flathub si hace falta)
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.dosbox_x.DOSBox-X ca.joshuadoes.Jorts

# Manjaro - Otros utilitarios
sudo pacman -Syu tree htop neofetch bat fd ripgrep tmux vim base-devel
sudo pacman -Syu eza || yay -S --noconfirm eza
sudo pacman -Syu kdenlive virtualbox virtualbox-host-modules-arch
yay -S --noconfirm dosbox-x jorts
```

## Node.js (nvm)

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install 24
```

## Agentes IA (CLI)

Requieren Node/npm global:

```bash
npm install -g @anthropic-ai/claude-code @google/gemini-cli @openai/codex @qwen-code/qwen-code
```

## PlantUML

```bash
# Debian_Based distro:
sudo apt install plantuml graphviz

# RPM_Based distro:
sudo dnf install plantuml graphviz

# Manjaro
sudo pacman -Syu plantuml graphviz

# Si no está en repos, descargar JAR
sudo mkdir -p /opt/plantuml
sudo curl -L -o /opt/plantuml/plantuml.jar https://github.com/plantuml/plantuml/releases/download/v1.2024.8/plantuml-1.2024.8.jar
sudo tee /usr/local/bin/plantuml >/dev/null <<'EOF'
#!/bin/bash
java -jar /opt/plantuml/plantuml.jar "$@"
EOF
sudo chmod +x /usr/local/bin/plantuml
```

## Antigravity IDE

```bash
# Debian_Based distro:
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/antigravity-repo-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" | sudo tee /etc/apt/sources.list.d/antigravity.list
sudo apt update && sudo apt install antigravity

# RPM_Based distro:
sudo tee /etc/yum.repos.d/antigravity.repo <<'EOL'
[antigravity-rpm]
name=Antigravity RPM Repository
baseurl=https://us-central1-yum.pkg.dev/projects/antigravity-auto-updater-dev/antigravity-rpm
enabled=1
gpgcheck=0
EOL
sudo dnf makecache && sudo dnf install antigravity

# Manjaro (AUR)
yay -S --noconfirm antigravity || echo "No disponible en AUR, usar tarball"
```

## Carpeta de repos y clones

```bash
mkdir -p ~/misRepos
cd ~/misRepos
for repo in prg1 prg2 eda1 eda2 idsw1 idsw2; do
  git clone https://github.com/mmasias/$repo || git -C "$repo" pull --ff-only
done
```

En tu shell (`.bashrc`/`.zshrc`), puedes añadir:

```bash
if [ "$PWD" = "$HOME" ]; then
  cd ~/misRepos 2>/dev/null || true
fi
```

## Quitar bloatware (opcional)

El script ofrece purgar Firefox, LibreOffice y Thunderbird (y sus idiomas) y marcar que no se reinstalen. Manualmente:

```bash
# Debian_Based distro:
sudo apt purge -y firefox firefox-esr libreoffice* thunderbird
sudo apt autoremove --purge -y && sudo apt autoclean

# RPM_Based distro:
sudo dnf remove -y firefox libreoffice* thunderbird
sudo dnf autoremove -y && sudo dnf clean all

# Manjaro
sudo pacman -Rns --noconfirm firefox libreoffice-fresh thunderbird
sudo pacman -Sc --noconfirm
```

### Tema (KDE)

[Future](https://store.kde.org/p/1491484)
Utterly Nord Ligth Solid

## Configuración Github classroom

```bash
# Debian_Based distro:
sudo apt install gh

# RPM_Based distro:
sudo dnf install gh

# Manjaro
sudo pacman -Syu github-cli

# Común a las tres
gh auth login
gh extension install github/gh-classroom
gh classroom list
gh classroom clone student-repos
```

## Otras utilidades

- https://flathub.org/apps/com.vixalien.sticky
- 
