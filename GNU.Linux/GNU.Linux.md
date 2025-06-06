# :robot:

Esto, que empezó como una chuleta de cosas por hacer cuando instalaba la distribución de elementaryOS en un ordenador nuevo, ha crecido hasta convertirse en un chuletón de cosas por hacer cuando instale casi que cualquier distribución de GNU/Linux en un ordenador nuevo.

TsP / TpR: 20 min / 7 min

> Gracias a [Claude (Anthropic)](https://claude.ai), habemus [archivo de instalación](setup-linux.sh) que realiza todo esto!

## Instalar Chrome

Del [canal oficial](https://www.google.com/chrome/?platform=linux) de la distro.

```manjaro
# Manjaro
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si

yay -S google-chrome
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
git config --global user.name "manuel@dondeSea"
git config --global user.email "manuel@masiasweb.com"
```

> [Configurar GPG para firma](GNU.Linux.GPG.md)

## Instalar gdebi

```bash
# Debian_Based distro:
sudo apt install gdebi

# RPM_Based distro:
# No es necesario gdebi en distribuciones RPM
# Para instalar paquetes rpm, usa dnf directamente:
# sudo dnf install ./paquete.rpm

# Manjaro
# No es necesario gdebi, para paquetes .pkg.tar.zst usa pacman
# Para paquetes AUR usa yay o pamac
```

## Instalar curl

```bash
# Debian_Based distro:
sudo apt install curl

# RPM_Based distro:
sudo dnf install curl

# Manjaro
sudo pacman -Syu curl
```

## Instalar jdk

```bash
# Debian_Based distro:
sudo apt install openjdk-17-jdk-headless

# RPM_Based distro:
sudo dnf install java-latest-openjdk-devel.x86_64

# Manjaro
 sudo pacman -Syu jdk-openjdk
```

## Instalar graphviz

```bash
# Debian_Based distro:
sudo apt install graphviz

# RPM_Based distro:
sudo dnf install graphviz

# Manjaro
 sudo pacman -Syu graphviz
```

## Instalar Visual Studio Code

```bash
# Debian_Based distro:
sudo snap install code --classic

# RPM_Based distro:
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf check-update
sudo dnf install code


# Manjaro
yay -S visual-studio-code-bin # sudo pacman -Syu code lo instala sin posibilidad de conectar con GIT
```

## Instalar Spotify

```bash
# Debian_Based distro:
sudo snap install spotify

# RPM_Based distro:
sudo snap install spotify

# Manjaro
yay -S spotify 
```

## Instalar VLC

```bash
# Debian_Based distro:
sudo apt install vlc

# RPM_Based distro:
sudo snap install vlc

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
- [Config](../imagenes/impresoraCanonGNU.png)

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

1. Download a [Nerd Font](http://nerdfonts.com/): [FiraCode](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip) && [MesloLG](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Meslo.zip)
1. Unzip and copy to ```~/.fonts```
1. Run the command ```fc-cache -fv``` to manually rebuild the font cache

Tema: nordtron

<img width="434" alt="image" src="https://user-images.githubusercontent.com/8528047/215170894-5f288539-7a31-45c2-b4fb-bd557a14e3b5.png">

En ```.bashrc```

```
eval "$(oh-my-posh init bash --config /home/USERNAME/.poshthemes/nordtron.omp.json)"
```

## Otros utilitarios interesantes

```bash
# Debian_Based distro:
sudo apt install tree # tree -pugh
sudo apt install eza  # eza -l --tree --group --header

# RPM_Based distro:
sudo dnf install tree
sudo dnf install eza  # Si no está disponible en los repos oficiales, puede requerir EPEL

# Manjaro - Otros utilitarios
sudo pacman -Syu tree
sudo pacman -Syu eza  # O instalarlo desde AUR con: yay -S eza
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
