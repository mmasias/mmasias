# :robot:

Esto, que empezó como una chuleta de cosas por hacer cuando instalaba la distribución de elementaryOS en un ordenador nuevo, ha crecido hasta convertirse en un chuletón de cosas por hacer cuando instale casi que cualquier distribución de GNU/Linux en un ordenador nuevo.

TsP / TpR: 20 min / 7 min

## Instalar Chrome

Del [canal oficial](https://www.google.com/chrome/?platform=linux) de la distro.

## Instalar GIT

```bash
# Debian_Based distro:
sudo apt install git

# RPM_Based distro:
sudo dnf install git

git config --global user.name "manuel@dondeSea"
git config --global user.email "manuel@masiasweb.com"
```

## Instalar gdebi

```bash
# Debian_Based distro:
sudo apt install gdebi
```

## Instalar curl

```bash
# Debian_Based distro:
sudo apt install curl
```

## Instalar jdk

```bash
# Debian_Based distro:
sudo apt install openjdk-17-jdk-headless

# RPM_Based distro:
sudo dnf install java-latest-openjdk-devel.x86_64
```

## Instalar graphviz

```bash
# Debian_Based distro:
sudo apt install graphviz
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
```

## Instalar Spotify

```bash
# Debian_Based distro:
sudo snap install spotify

# RPM_Based distro:
sudo snap install spotify
```

## Instalar VLC

```bash
# Debian_Based distro:
sudo apt install vlc

# RPM_Based distro:
sudo snap install vlc
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
- [Config](imagenes/impresoraCanonGNU.png)

### Instalar oh-my-posh

```bash
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh
mkdir ~/.poshthemes
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.omp.*
rm ~/.poshthemes/themes.zip
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
### Tema (KDE)

[Future](https://store.kde.org/p/1491484)
Utterly Nord Ligth Solid

## Notas adicionales

- DOSBOX de Flatpak
