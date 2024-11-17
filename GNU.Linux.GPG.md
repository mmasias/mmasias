# Configuración de firma GPG para Git/GitHub

Este tutorial explica cómo configurar la firma de commits en Git usando GPG para verificar la autoría de los commits en GitHub.

## 1. Instalación de GPG

### Ubuntu/Debian

```bash
sudo apt-get install gnupg
```

### macOS (usando Homebrew)

```bash
brew install gnupg
```

### Windows

```bash
winget install GnuPG.GnuPG
```

## 2. Generación de la clave GPG

```bash
gpg --full-generate-key
```

Durante el proceso:

1. Seleccionar RSA and RSA (opción por defecto)
1. Usar 4096 bits
1. Elegir tiempo de validez (0 = no expira)
1. Ingresar:
    - Nombre real
    - Email (debe coincidir con el de GitHub)
    - Contraseña segura
  
## 3. Obtener el ID de la clave

```bash
gpg --list-secret-keys --keyid-format=long
```

La salida será similar a:

```
sec   rsa4096/DEA7FA78CAC07905 2024-11-17 [SC]
      325DACE2575260E9251D02D1DEA7FA78CAC07905
uid              [  absoluta ] mmasias (Manuel) <manuel@masiasweb.com>
ssb   rsa4096/526EF82E8ECB58B7 2024-11-17 [E]
```

El ID de la clave es la parte después de "rsa4096/" (en este ejemplo: `DEA7FA78CAC07905`)

## 4. Exportar la clave pública para GitHub

```bash
gpg --armor --export TU_ID_DE_CLAVE
```

## 5. Configuración en GitHub

1. Ir a GitHub → Settings → SSH and GPG keys
2. Click en "New GPG key"
3. Pegar la clave pública (incluir las líneas BEGIN y END)
4. Guardar

## 6. Configuración de Git

```bash
git config --global user.signingkey TU_ID_DE_CLAVE
git config --global commit.gpgsign true
```

## 7. Configuración del entorno

### Para Bash

```bash
echo "export GPG_TTY=$(tty)" >> ~/.bashrc
source ~/.bashrc  # Aplica los cambios inmediatamente
```

### Para Zsh
```bash
echo "export GPG_TTY=$(tty)" >> ~/.zshrc
source ~/.zshrc  # Aplica los cambios inmediatamente
```

### Para VS Code
En settings.json:
```json
{
    "git.enableCommitSigning": true
}
```

## 8. Prueba de commit firmado

```bash
git commit -S -m "Commit firmado de prueba"
```

## Consejos adicionales

### Cache de contraseña GPG

Para evitar ingresar la contraseña en cada commit:

```bash
echo "default-cache-ttl 34560000" >> ~/.gnupg/gpg-agent.conf
echo "max-cache-ttl 34560000" >> ~/.gnupg/gpg-agent.conf
```

### Solución para problemas en macOS

```bash
echo "export GPG_TTY=$(tty)" >> ~/.gnupg/gpg-agent.conf
```

## Verificación

Para verificar que todo está configurado correctamente:

```bash
# Verificar la configuración de git
git config --list | grep -i gpg

# Verificar que gpg está funcionando
echo "test" | gpg --clearsign
```

Si ves tu firma GPG después del último comando, todo está configurado correctamente.
