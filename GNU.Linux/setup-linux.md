# 🐧 Script de Configuración Linux

Un script automatizado para configurar sistemas Linux recién instalados con las herramientas y aplicaciones más comunes para desarrollo y uso diario.

## 🚀 Características

- **Detección automática** de distribución Linux
- **Compatibilidad multi-distribución**: Debian/Ubuntu, Fedora/RHEL/CentOS, Arch/Manjaro
- **Instalación inteligente** con métodos de respaldo cuando fallan las instalaciones principales
- **Menú interactivo** para seleccionar qué instalar
- **Verificación de software existente** para evitar reinstalaciones innecesarias

## 📋 Distribuciones Soportadas

### Familia Debian
- Ubuntu (todas las versiones)
- Debian
- Linux Mint
- Elementary OS
- Pop!_OS
- Zorin OS

### Familia RPM
- Fedora
- RHEL (Red Hat Enterprise Linux)
- CentOS
- Rocky Linux
- AlmaLinux

### Familia Arch
- Arch Linux
- Manjaro
- EndeavourOS

## ⚡ Instalación Rápida

```bash
# Descargar el script
wget https://raw.githubusercontent.com/tu-usuario/tu-repo/main/setup-linux.sh

# Dar permisos de ejecución
chmod +x setup-linux.sh

# Ejecutar
./setup-linux.sh
```

## 🛠 Herramientas Incluidas

### Desarrollo
- **Git** - Control de versiones con configuración completa
- **GitHub CLI** - Herramienta oficial de línea de comandos para GitHub
- **JDK** - Java Development Kit (OpenJDK 11, 17 o 21)
- **Visual Studio Code** - Editor de código
- **Graphviz** - Generación de gráficos

### Navegación y Multimedia
- **Google Chrome** - Navegador web
- **Spotify** - Reproductor de música
- **VLC** - Reproductor multimedia

### Terminal y Productividad
- **oh-my-posh** - Personalización del prompt del terminal
- **Tree** - Visualización de estructura de directorios
- **Eza** - Sustituto moderno de `ls`
- **htop** - Monitor de procesos mejorado
- **neofetch** - Información del sistema
- **bat** - Sustituto mejorado de `cat`
- **ripgrep** - Búsqueda de texto ultrarrápida
- **fd** - Sustituto moderno de `find`

### Utilidades del Sistema
- **curl** - Transferencia de datos
- **gdebi** - Instalador de paquetes .deb (solo Debian)
- **Firma GPG** - Configuración para commits firmados en Git

## 🎯 Opciones Disponibles

| Opción | Función |
|--------|---------|
| 1 | Instalar todo (configuración completa) |
| 2 | Instalar dependencias básicas |
| 3 | Instalar Google Chrome |
| 4 | Configurar Git |
| 5 | Instalar gdebi (solo Debian) |
| 6 | Instalar curl |
| 7 | Instalar JDK |
| 8 | Instalar graphviz |
| 9 | Instalar Visual Studio Code |
| 10 | Instalar Spotify |
| 11 | Instalar VLC |
| 12 | Instalar oh-my-posh |
| 13 | Instalar utilitarios (tree, eza) |
| 14 | Instalar GitHub CLI |
| 15 | Configurar firma GPG para Git |
| 16 | Instalar utilidades adicionales |
| 17 | Limpiar sistema |
| 18 | **Quitar bloatware** (LibreOffice, Firefox, Thunderbird) |
| 19 | Mostrar información del sistema |

## 🎨 Personalización del Terminal

El script incluye **oh-my-posh** para personalizar tu terminal:

- Descarga automática de temas
- Configuración para bash y zsh
- Recomendaciones de Nerd Fonts
- Temas sugeridos: `nordtron`, `atomic`, `powerlevel10k_rainbow`

### Instalación de Nerd Fonts

Después de instalar oh-my-posh, descarga una Nerd Font:

```bash
# FiraCode Nerd Font
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip
unzip FiraCode.zip -d ~/.fonts/
fc-cache -fv

# MesloLG Nerd Font  
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Meslo.zip
unzip Meslo.zip -d ~/.fonts/
fc-cache -fv
```

## 🔧 Configuración de Git

El script configura Git con:

- Nombre de usuario y email
- Rama por defecto: `main`
- Configuración de merge: `pull.rebase false`
- Autocrlf: `input`
- Firma GPG opcional para commits

## 🔑 Configuración GPG

Para commits firmados en GitHub:

1. Genera clave GPG de 4096 bits
2. Exporta la clave pública
3. Añade la clave a GitHub
4. Configura Git para firmar automáticamente

## 🗑 Limpieza de Bloatware

La opción de **quitar bloatware** elimina:

- **LibreOffice** - Suite ofimática
- **Firefox** - Navegador (se reemplaza por Chrome)
- **Thunderbird** - Cliente de email

Con opción de eliminar también las configuraciones de usuario.

## ⚠️ Requisitos

- Sistema Linux compatible
- Conexión a internet
- Permisos de sudo
- **NO ejecutar como root** (el script lo detecta y lo impide)

## 🚨 Uso Seguro

```bash
# ✅ CORRECTO - como usuario normal
./setup-linux.sh

# ❌ INCORRECTO - como root
sudo ./setup-linux.sh  # El script rechazará esto
```

## 🔍 Detección Inteligente

El script detecta automáticamente:

- Distribución Linux y familia
- Gestor de paquetes disponible
- Software ya instalado
- Arquitectura del sistema

Si no reconoce tu distribución, intentará detectar el gestor de paquetes como fallback.

## 📦 Métodos de Instalación

Para mayor compatibilidad, muchas aplicaciones tienen múltiples métodos de instalación:

### Visual Studio Code
1. Repositorio oficial de Microsoft
2. Snap (respaldo)
3. Descarga directa .deb/.rpm

### Spotify
1. Repositorio oficial de Spotify
2. Snap (respaldo)

### Chrome
1. Repositorio oficial de Google
2. Descarga directa

## 🐛 Solución de Problemas

### Error con snapd
Si `snapd` no está disponible, el script usará métodos alternativos automáticamente.

### Distribución no reconocida
El script intentará detectar el gestor de paquetes disponible como fallback.

### Permisos de sudo
Asegúrate de que tu usuario tenga permisos de sudo configurados.

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Para cambios importantes:

1. Abre un issue primero
2. Fork el repositorio
3. Crea una rama para tu feature
4. Envía un pull request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 🎯 Casos de Uso Ideales

- **Desarrolladores** que necesitan configurar rápidamente un entorno de trabajo
- **Usuarios nuevos** en Linux que quieren las aplicaciones esenciales
- **Administradores** que configuran múltiples máquinas
- **Estudiantes** que necesitan herramientas de desarrollo y productividad

## 📞 Soporte

Si encuentras problemas:

1. Revisa que tu distribución esté soportada
2. Verifica tu conexión a internet
3. Asegúrate de tener permisos de sudo
4. Ejecuta como usuario normal (no root)

---

**¿Te ha sido útil este script? ⭐ Dale una estrella al repositorio!**
