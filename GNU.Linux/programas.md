# Script de Migración de Programas Linux

## Descripción

Script de consola para listar todos los programas instalados en tu distribución Linux y generar archivos para facilitar la migración a una nueva distro.

## Características Principales

- **Detección automática** del gestor de paquetes
- **Compatibilidad universal** con las principales distribuciones Linux
- **Generación de scripts** de reinstalación automática e interactiva
- **Soporte para gestores alternativos** (Flatpak, Snap, AppImage)
- **Separación entre paquetes manuales** y dependencias automáticas

## Distribuciones Soportadas

| Distribución | Gestor de Paquetes | Estado |
|--------------|-------------------|---------|
| Ubuntu/Debian/Mint | apt | ✅ Completo |
| Fedora/RHEL/CentOS | dnf/yum | ✅ Completo |
| Arch/Manjaro | pacman | ✅ Completo |
| openSUSE | zypper | ✅ Completo |
| Gentoo | portage | ✅ Básico |
| Void Linux | xbps | ✅ Básico |
| Alpine Linux | apk | ✅ Básico |

## Instalación y Uso

### 1. Preparación

```bash
# Descargar el script
curl -O [URL_DEL_SCRIPT]

# Dar permisos de ejecución
chmod +x listar_programas.sh
```

### 2. Ejecución

```bash
# Ejecutar el script
./listar_programas.sh
```

### 3. Archivos Generados

El script genera automáticamente tres archivos:

#### `programas_instalados_YYYYMMDD_HHMMSS.txt`
- Lista completa de todos los programas instalados
- Incluye comandos de reinstalación comentados
- Separación por categorías (paquetes principales, Flatpak, Snap, etc.)

#### `reinstalar_programas.sh`
- Script de reinstalación automática
- Instala todos los programas de una vez
- Más rápido pero se detiene si hay errores

#### `reinstalar_interactivo.sh`
- Script de reinstalación interactiva
- Pregunta programa por programa
- Permite saltar paquetes problemáticos
- Continúa aunque fallen algunos paquetes

## Modos de Reinstalación

### Modo Automático
```bash
./reinstalar_programas.sh
```

**Ventajas:**
- Instalación rápida
- Sin intervención manual

**Desventajas:**
- Se detiene si falla un paquete
- No permite selección

### Modo Interactivo
```bash
./reinstalar_interactivo.sh
```

**Opciones disponibles:**
- `Y` o `Enter`: Instalar programa
- `n`: Saltar programa
- `s`: Saltar programa
- `q`: Salir del script

**Ventajas:**
- Control total sobre la instalación
- Continúa aunque fallen paquetes
- Permite saltar programas no deseados

## Migración Entre Distribuciones

### Limitaciones Conocidas

**Nombres de paquetes diferentes:**
```bash
# Ubuntu → Fedora
build-essential → @development-tools
python3-pip → python3-pip
libreoffice → libreoffice-*
```

**Paquetes no disponibles:**
- Algunos paquetes específicos de distro
- Versiones diferentes en repositorios
- Dependencias con nombres distintos

### Estrategia Recomendada

1. **Generar lista** en la distro actual
2. **Usar modo interactivo** en la nueva distro
3. **Instalar universales primero:**
   ```bash
   # Flatpak (recomendado para migración)
   flatpak install firefox thunderbird gimp libreoffice

   # Snap (si está disponible)
   snap install code discord
   ```
4. **Adaptar nombres** manualmente para paquetes problemáticos

## Estructura del Archivo de Salida

```
=== PAQUETES APT (Debian/Ubuntu) ===

# Para reinstalar estos paquetes:
# sudo apt update && sudo apt install \
#   firefox \
#   gimp \
#   vlc \

=== TODOS LOS PAQUETES INSTALADOS ===
firefox
gimp
vlc
...

=== PROGRAMAS ADICIONALES ===

--- FLATPAK ---
org.mozilla.firefox
org.gimp.GIMP

--- SNAP ---
code
discord

--- POSIBLES APPIMAGES ---
/home/user/Applications/app.AppImage
```

## Casos de Uso

### Migración Completa de Distro
```bash
# En la distro actual
./listar_programas.sh

# Copiar archivos a la nueva distro
scp programas_instalados_*.txt user@nueva-pc:~/
scp reinstalar_interactivo.sh user@nueva-pc:~/

# En la nueva distro
./reinstalar_interactivo.sh
```

### Backup de Configuración
```bash
# Generar backup mensual
./listar_programas.sh
mv programas_instalados_*.txt ~/Documentos/backups/
```

### Sincronización de Múltiples Equipos
```bash
# Equipo principal
./listar_programas.sh

# Otros equipos
./reinstalar_interactivo.sh
```

## Solución de Problemas

### Script No Detecta Gestor de Paquetes
```bash
# Verificar gestores disponibles
which apt dnf yum pacman zypper

# Ejecutar manualmente
dpkg --get-selections > mis_programas.txt  # Debian/Ubuntu
rpm -qa > mis_programas.txt                # RedHat/Fedora
```

### Paquetes No Encontrados
```bash
# Buscar nombres alternativos
apt search programa_name    # Ubuntu
dnf search programa_name    # Fedora
pacman -Ss programa_name    # Arch
```

### Errores de Permisos
```bash
# Verificar permisos sudo
sudo -l

# Ejecutar partes manualmente
sudo apt update
sudo apt install programa1 programa2
```

## Mejores Prácticas

### Antes de Migrar
- [ ] Ejecutar script en distro actual
- [ ] Verificar archivos generados
- [ ] Hacer backup de configuraciones importantes
- [ ] Listar programas compilados manualmente

### Durante la Migración
- [ ] Actualizar repositorios primero
- [ ] Usar modo interactivo para mayor control
- [ ] Instalar gestores universales (Flatpak/Snap)
- [ ] Documentar paquetes problemáticos

### Después de Migrar
- [ ] Verificar programas críticos
- [ ] Reinstalar configuraciones personalizadas
- [ ] Actualizar el script para futuras migraciones
- [ ] Crear nuevo backup en la nueva distro

## Contribuciones

Para añadir soporte para nuevas distribuciones:

1. Identificar el gestor de paquetes
2. Añadir detección en `detect_package_manager()`
3. Implementar listado en `list_packages()`
4. Probar en la distribución objetivo

## Notas de Versión

### v1.0
- Soporte básico para gestores principales
- Generación de archivos de salida
- Script de reinstalación automática

### v2.0
- Añadido modo interactivo
- Soporte para Flatpak/Snap/AppImage
- Mejor detección de distribuciones
- Documentación completa

## Licencia

Script de uso libre para la comunidad Linux.