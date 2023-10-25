
TsP / TpR: 20 min / 7 min

## Instalar Chrome

``` 
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt update
sudo apt install google-chrome-stable
```

## Instalar GIT

```
sudo apt install git

git config --global user.name "mmasias"
git config --global user.email "manuel@masiasweb.com"

```

## Instalar gdebi

```
sudo apt install gdebi
```

## Instalar curl

```
sudo apt install curl
```

## Instalar jdk

```
sudo apt install openjdk-17-jdk-headless
```

## Instalar graphviz

```
sudo apt install graphviz
```
## Instalar Visual Studio Code

[Link](https://code.visualstudio.com/)


## Instalar Spotify

[Link](https://www.spotify.com/es/download/linux/)

## Instalar VLC

```
sudo apt install vlc
```

## Otras cosas...

* Configurar captura de pantalla (WIN+MAYUSC+S)

### Instalar elementary Tweaks

```
sudo apt install software-properties-common
sudo add-apt-repository ppa:philip.scott/pantheon-tweaks
sudo apt update
sudo apt install pantheon-tweaks
```

### Instalar la impresora

Instalar el [Driver CQue DEB](https://www.canon.es/support/products/imagerunner/imagerunner-advance-c5235i.html?type=drivers&driverdetailid=tcm:86-1894069&os=linux%20%2864-bit%29&language=es)

```
sudo systemctl stop cups
sudo vi /etc/cups/printers.conf
# Editar la IP
sudo systemctl restart cups
```

> #notaMental: 213, iR-ADV C5235/5240 UFR II


### Instalar oh-my-posh

```
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh
mkdir ~/.poshthemes
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.omp.*
rm ~/.poshthemes/themes.zip

```

1. Download a [Nerd Font](http://nerdfonts.com/)
1. Unzip and copy to ```~/.fonts```
1. Run the command ```fc-cache -fv``` to manually rebuild the font cache


> #notaMental: el tipo de letra se ajusta en los elementaryTweaks
> #notaMental: Ya no... Ahora es ```gsettings set io.elementary.terminal.settings font 'MesloLGS Nerd Font Regular 10'```
> Usabilidad... bah!

Tema: nordtron

<img width="434" alt="image" src="https://user-images.githubusercontent.com/8528047/215170894-5f288539-7a31-45c2-b4fb-bd557a14e3b5.png">

En ```.bashrc```
```
eval "$(oh-my-posh init bash --config /home/USERNAME/.poshthemes/nordtron.omp.json)"
```

