# 🐧 GNU/Linux - Documentación y Scripts

Esto, que empezó como una chuleta de cosas por hacer cuando instalaba la distribución de elementaryOS en un ordenador nuevo, ha crecido hasta convertirse en un chuletón de cosas por hacer cuando instale casi que cualquier distribución de GNU/Linux en un ordenador nuevo.

Esta carpeta contiene documentación, scripts y guías para configurar y administrar sistemas GNU/Linux de manera eficiente.

## 📁 Contenido de la Carpeta

### 🚀 Scripts de Automatización

#### [`setup-linux.sh`](setup-linux.sh)
**Script principal de configuración automática para sistemas Linux**

- **Detección automática** de distribución (Debian/Ubuntu, Fedora/RHEL, Arch/Manjaro)
- **19 opciones de instalación** desde dependencias básicas hasta configuración completa
- **Métodos de respaldo** cuando fallan las instalaciones principales
- **Verificación inteligente** de software ya instalado
- **Menú interactivo** fácil de usar

**Herramientas que instala:**
- Desarrollo: Git, GitHub CLI, JDK, VS Code, Graphviz
- Navegación: Google Chrome
- Multimedia: Spotify, VLC
- Terminal: oh-my-posh, tree, eza, htop, neofetch, bat, ripgrep
- Utilidades: curl, gdebi, firma GPG

**Características especiales:**
- ✅ Opción para **quitar bloatware** (LibreOffice, Firefox, Thunderbird)
- ✅ **Configuración completa de Git** con firma GPG
- ✅ **Personalización del terminal** con oh-my-posh
- ✅ **Limpieza automática** del sistema

### 📚 Documentación

#### [`GNU.Linux.md`](GNU.Linux.md)
**Manual completo de configuración manual**

Documentación original que sirvió de base para crear el script automatizado. Incluye:

- Instalación manual de todas las herramientas
- Comandos específicos para cada distribución
- Configuración de impresora Canon
- Instalación de utilidades adicionales
- Configuración de GitHub Classroom
- Recomendaciones de temas para KDE

#### [`GNU.Linux.GPG.md`](GNU.Linux.GPG.md)
**Guía completa de configuración GPG para Git/GitHub**

Tutorial paso a paso para configurar firma de commits:

- Instalación de GPG en diferentes sistemas
- Generación de claves GPG de 4096 bits
- Configuración en GitHub
- Configuración del entorno (Bash/Zsh)
- Cache de contraseña
- Solución de problemas comunes
- Configuración para VS Code

#### [`reconnectBluetooth.md`](reconnectBluetooth.md)
**Script de reconexión automática de dispositivos Bluetooth**

Solución para el problema común de dispositivos Bluetooth que no se reconectan automáticamente en KDE:

- **Script de autoconexión** personalizable
- **Dos métodos de implementación:**
  - Nivel usuario (al iniciar sesión)
  - Nivel sistema (al arrancar)
- **Servicio systemd** para ejecución automática
- **Logging y notificaciones** integradas
- Compatible con KDE Plasma y systemd

#### [`setup-linux.md`](setup-linux.md)
**README del script de configuración**

Documentación completa del script automatizado con:
- Guía de instalación rápida
- Lista detallada de herramientas incluidas
- Tabla de opciones disponibles
- Instrucciones de personalización
- Solución de problemas
- Casos de uso recomendados

## 🎯 Casos de Uso

### Para Desarrolladores
- **Configuración rápida** de entorno de desarrollo
- **Git con firma GPG** para commits verificados
- **VS Code** con repositorios oficiales
- **JDK** con múltiples versiones disponibles

### Para Usuarios Nuevos en Linux
- **Script automatizado** que elimina la complejidad
- **Instalación de aplicaciones esenciales**
- **Personalización del terminal** con oh-my-posh
- **Limpieza de bloatware** preinstalado

### Para Administradores de Sistema
- **Configuración masiva** de múltiples máquinas
- **Detección automática** de distribuciones
- **Scripts modulares** para instalaciones específicas
- **Logging y verificación** de procesos

### Para Usuarios de KDE
- **Reconexión automática** de dispositivos Bluetooth
- **Configuración de temas** y personalización
- **Soluciones específicas** para problemas comunes

## 🚀 Inicio Rápido

### Configuración Automática Completa
```bash
# Descargar y ejecutar el script principal
wget https://raw.githubusercontent.com/tu-repo/GNU.Linux/main/setup-linux.sh
chmod +x setup-linux.sh
./setup-linux.sh
```

### Configuración GPG Manual
```bash
# Seguir la guía paso a paso
cat GNU.Linux.GPG.md
```

### Configurar Bluetooth en KDE
```bash
# Implementar script de reconexión automática
cat reconnectBluetooth.md
```

## 📋 Distribuciones Soportadas

| Familia | Distribuciones |
|---------|----------------|
| **Debian** | Ubuntu, Debian, Linux Mint, Elementary OS, Pop!_OS, Zorin OS |
| **RPM** | Fedora, RHEL, CentOS, Rocky Linux, AlmaLinux |
| **Arch** | Arch Linux, Manjaro, EndeavourOS |

## 🛠 Herramientas y Tecnologías

### Desarrollo
- **Git** con configuración completa
- **GitHub CLI** con extensiones
- **OpenJDK** (versiones 11, 17, 21)
- **Visual Studio Code** desde repositorios oficiales
- **Graphviz** para diagramas

### Productividad
- **Google Chrome** como navegador principal
- **Spotify** para música
- **VLC** para multimedia
- **Terminal personalizado** con oh-my-posh

### Sistema
- **Utilidades modernas**: `eza`, `bat`, `ripgrep`, `fd`
- **Monitoreo**: `htop`, `neofetch`
- **Seguridad**: Firma GPG para commits
- **Limpieza**: Herramientas de mantenimiento del sistema

## 📖 Orden de Lectura Recomendado

1. **[`setup-linux.md`](setup-linux.md)** - Empezar aquí para una visión general
2. **[`setup-linux.sh`](setup-linux.sh)** - Ejecutar para configuración automática
3. **[`GNU.Linux.GPG.md`](GNU.Linux.GPG.md)** - Para configurar firma de commits
4. **[`reconnectBluetooth.md`](reconnectBluetooth.md)** - Solo si usas KDE y Bluetooth
5. **[`GNU.Linux.md`](GNU.Linux.md)** - Referencia para configuración manual

## ⚡ Funcionalidades Destacadas

### 🤖 Automatización Inteligente
- Detección automática de distribución y gestor de paquetes
- Métodos de respaldo cuando fallan las instalaciones principales
- Verificación de software existente para evitar reinstalaciones

### 🎨 Personalización
- Terminal personalizado con oh-my-posh y Nerd Fonts
- Múltiples temas disponibles
- Configuración específica para cada shell (bash/zsh)

### 🔒 Seguridad
- Configuración completa de GPG para firma de commits
- Validación de emails y configuraciones
- Buenas prácticas de seguridad integradas

### 🧹 Mantenimiento
- Opción de limpieza de bloatware
- Herramientas de limpieza del sistema
- Gestión automática de dependencias

## 🤝 Contribuciones

Estas documentaciones y scripts son de código abierto. Las contribuciones son bienvenidas:

- **Nuevas distribuciones**: Añadir soporte para más distribuciones Linux
- **Nuevas herramientas**: Incluir software adicional útil
- **Mejoras de documentación**: Clarificar instrucciones y añadir ejemplos
- **Corrección de errores**: Reportar y corregir problemas encontrados

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 🆘 Soporte

Si encuentras problemas:

1. **Revisa la documentación** específica del tema
2. **Verifica los requisitos** del sistema
3. **Consulta la sección de solución de problemas** en cada documento
4. **Abre un issue** si el problema persiste

---

**💡 Tip:** Empezar con `setup-linux.sh` para una configuración rápida, luego consultar la documentación específica según tus necesidades.
