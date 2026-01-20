# Instalación de impresora Canon iR-ADV en Linux (Kubuntu/Ubuntu)

## ¿Por qué?

Las impresoras corporativas Canon imageRUNNER ADVANCE son notoriamente difíciles de configurar en Linux. A diferencia de Windows, donde el driver se instala con un asistente gráfico, en Linux debemos:

- Instalar manualmente el driver propietario de Canon (UFRII)
- Resolver dependencias de librerías que pueden estar desactualizadas
- Configurar la autenticación por Department ID si la impresora lo requiere
- Entender cómo funciona CUPS, el sistema de impresión de Linux

Este documento nace de una instalación real en Kubuntu 25.10, donde enfrentamos y resolvimos cada uno de estos obstáculos.

## ¿Qué?

### El sistema de impresión en Linux: CUPS

**CUPS** (Common UNIX Printing System) es el estándar de impresión en Linux. Funciona como intermediario entre las aplicaciones y la impresora:

```
Aplicación → CUPS → Filtros/Driver → Impresora
```

Componentes clave:
- **Servicio cupsd**: El demonio que gestiona las colas de impresión
- **PPD (PostScript Printer Description)**: Archivo que describe las capacidades de la impresora
- **Filtros**: Programas que convierten documentos al formato que entiende la impresora
- **Backend**: El componente que envía los datos a la impresora (socket, ipp, usb, etc.)

### El driver Canon UFRII

Canon proporciona el driver **UFR II** (Ultra Fast Rendering II) para Linux. Este driver:
- Viene empaquetado en formato `.deb` (Debian/Ubuntu) y `.rpm` (Fedora/RHEL)
- Incluye filtros propios (`rastertoufr2`) que convierten el formato CUPS al formato nativo Canon
- Requiere librerías específicas que pueden no estar en versiones modernas de Linux
- Incluye herramientas de configuración (`cnjatool2`, `cngplp2`)

### Autenticación por Department ID

Muchas impresoras Canon corporativas tienen habilitado el **Department ID Management**, un sistema de control de acceso que:
- Requiere un ID numérico (y opcionalmente un PIN) para imprimir
- Permite a las organizaciones rastrear el uso por departamento
- Rechaza silenciosamente los trabajos sin credenciales válidas

## ¿Para qué?

Al completar esta instalación conseguimos:

1. **Imprimir documentos PDF** directamente desde la línea de comandos
2. **Imprimir desde aplicaciones** que generan documentos correctamente formateados (LibreOffice, etc.)
3. **Autenticarnos automáticamente** con el Department ID configurado
4. **Acceder a todas las funciones** de la impresora: color, dúplex, bandejas, etc.

### Limitaciones conocidas

- El texto plano (`echo "texto" | lp`) puede salir en blanco por falta de fuentes configuradas
- La impresión desde navegadores web puede no funcionar correctamente
- El driver es antiguo y requiere symlinks de compatibilidad para librerías modernas

## ¿Cómo?

### Información del entorno

| Elemento | Valor |
|----------|-------|
| Sistema operativo | Ubuntu/Kubuntu 25.10 |
| Arquitectura | x86_64 (64 bits) |
| Impresora | Canon iR-ADV C5235/C5240 |
| Conexión | Red (socket TCP puerto 9100) |
| IP de la impresora | 172.27.0.213 |
| Department ID | XXXX (sin PIN) |

### Paso 1: Obtener el driver

Descargar el driver Canon UFRII desde la web oficial de Canon. El paquete incluye:

```
Canon-Drivers/
├── Linux/
│   └── linux-UFRII-drv-v550-m17n/
│       ├── x64/Debian/cnrdrvcups-ufr2-uk_5.50-1.00_amd64.deb  ← Para Ubuntu 64-bit
│       ├── x86/Debian/...                                      ← Para 32-bit
│       ├── ARM64/Debian/...                                    ← Para ARM
│       └── install.sh                                          ← Script alternativo
├── Windows/
└── cups/                                                       ← Backups de configuración
```

### Paso 2: Identificar la IP de la impresora

Si no conoces la IP, CUPS puede detectar impresoras en la red:

```bash
lpinfo -v | grep socket
```

Salida típica:
```
network socket://172.27.0.213
network socket://172.27.0.206
...
```

Para identificar cuál es la Canon, puedes consultar su panel web:

```bash
curl -s "http://IP_IMPRESORA:8000/" | grep -i canon
```

### Paso 3: Instalar dependencias

El driver requiere `libjpeg62`, que puede no estar instalada:

```bash
sudo apt update
sudo apt install libjpeg62 -y
```

### Paso 4: Instalar el driver

```bash
sudo dpkg -i /ruta/a/cnrdrvcups-ufr2-uk_5.50-1.00_amd64.deb
```

Si hay errores de dependencias:

```bash
sudo apt install -f -y
```

Verificar la instalación:

```bash
dpkg -l | grep cnrdrv
```

### Paso 5: Resolver compatibilidad de libxml2

El driver Canon busca `libxml2.so.2`, pero Ubuntu moderno tiene `libxml2.so.16`. Crear un symlink de compatibilidad:

```bash
# Ver qué versión tenemos
ldconfig -p | grep libxml2

# Crear el symlink
sudo ln -sf /lib/x86_64-linux-gnu/libxml2.so.16 /lib/x86_64-linux-gnu/libxml2.so.2
```

> **Nota**: Este paso es crucial. Sin él, el filtro del driver falla silenciosamente y los trabajos no se imprimen.

### Paso 6: Verificar que CUPS está activo

```bash
systemctl status cups
```

Si no está activo:

```bash
sudo systemctl enable --now cups
```

### Paso 7: Identificar el PPD correcto

Ver los drivers disponibles para nuestra impresora:

```bash
lpinfo -m | grep -i "C5235\|C5240"
```

Salida:
```
CNRCUPSIRADVC5240ZK.ppd Canon iR-ADV C5235/5240 UFR II
foomatic-db-compressed-ppds:0/ppd/foomatic-ppd/Canon-iR-ADV_C5235_5240-Postscript.ppd Canon iR-ADV C5235/5240 Foomatic/Postscript
```

Usaremos el driver **UFR II** (`CNRCUPSIRADVC5240ZK.ppd`).

### Paso 8: Configurar la impresora en CUPS

```bash
sudo lpadmin -p Canon-iR-ADV-C5240 \
    -E \
    -v "socket://172.27.0.213:9100" \
    -m "CNRCUPSIRADVC5240ZK.ppd" \
    -D "Canon iR-ADV C5240" \
    -L "Oficina"
```

Parámetros:
| Opción | Significado |
|--------|-------------|
| `-p` | Nombre de la impresora en el sistema |
| `-E` | Habilitar la impresora |
| `-v` | URI del dispositivo (socket://IP:9100) |
| `-m` | Modelo/driver PPD a usar |
| `-D` | Descripción legible |
| `-L` | Ubicación física |

Establecer como impresora predeterminada:

```bash
sudo lpadmin -d Canon-iR-ADV-C5240
```

### Paso 9: Configurar autenticación (Department ID)

#### 9.1 Habilitar Job Accounting

```bash
sudo cnjatool2 -e Canon-iR-ADV-C5240
```

#### 9.2 Configurar credenciales

```bash
cnjatool2 -p Canon-iR-ADV-C5240
```

El programa preguntará:
```
id : XXXX
pin : (dejar vacío si no hay PIN)
```

#### 9.3 Verificar la configuración

```bash
cat /etc/cngplp2/account/*
```

Salida esperada:
```
<Canon-iR-ADV-C5240>
id=XXXX
password=
</Canon-iR-ADV-C5240>
<Canon-iR-ADV-C5240>ON</Canon-iR-ADV-C5240>
```

### Paso 10: Probar la impresión

```bash
# Imprimir un PDF de prueba del sistema
lp /usr/share/cups/data/default-testpage.pdf
```

Ver el estado del trabajo:

```bash
lpstat -t
```

## Comandos útiles para el día a día

### Imprimir archivos

```bash
# Imprimir un PDF
lp documento.pdf

# Imprimir con opciones
lp -n 2 documento.pdf                    # 2 copias
lp -o Duplex=DuplexNoTumble documento.pdf  # Doble cara
lp -o CNColorMode=mono documento.pdf       # Blanco y negro

# Especificar impresora (si hay varias)
lp -d Canon-iR-ADV-C5240 documento.pdf
```

### Gestionar trabajos

```bash
# Ver cola de impresión
lpq

# Ver todos los trabajos
lpstat -W all

# Cancelar un trabajo
cancel Canon-iR-ADV-C5240-123

# Cancelar todos los trabajos
cancel -a
```

### Diagnóstico

```bash
# Estado de la impresora
lpstat -p Canon-iR-ADV-C5240 -l

# Ver URI del dispositivo
lpstat -v

# Habilitar logs de debug
sudo cupsctl --debug-logging

# Ver logs de CUPS
tail -f /var/log/cups/error_log

# Desactivar debug (después de diagnosticar)
sudo cupsctl --no-debug-logging
```

## Resolución de problemas

### El trabajo se envía pero no imprime

1. **Verificar conectividad**:
   ```bash
   nc -zv 172.27.0.213 9100
   ```

2. **Verificar symlink de libxml2**:
   ```bash
   ls -la /lib/x86_64-linux-gnu/libxml2.so.2
   ```

3. **Revisar logs**:
   ```bash
   tail -50 /var/log/cups/error_log | grep -i error
   ```

### PDFs firmados digitalmente no imprimen

Los PDFs con firma digital pueden contener estructuras internas complejas (capas de firma, anotaciones, certificados embebidos) que el filtro `rastertoufr2` de Canon no procesa correctamente. El trabajo aparece como "completado" en CUPS pero no sale nada en la impresora.

**Solución**: Aplanar el PDF antes de imprimir usando `pdftocairo`:

```bash
pdftocairo -pdf documento_firmado.pdf documento_aplanado.pdf
lp documento_aplanado.pdf
```

Esto elimina las capas de firma y convierte el documento a un PDF simple que el driver puede procesar sin problemas.

> **Nota**: El documento aplanado pierde la firma digital (ya no es verificable), pero el contenido visual se mantiene intacto.

### Error de autenticación

Verificar que Job Accounting está habilitado:

```bash
cat /etc/cngplp2/account/status
```

Debe mostrar: `<Canon-iR-ADV-C5240>ON</Canon-iR-ADV-C5240>`

### CUPS no responde

```bash
sudo systemctl restart cups
```

### Después de actualizar el sistema

Si tras una actualización deja de funcionar, recrear el symlink:

```bash
sudo ln -sf /lib/x86_64-linux-gnu/libxml2.so.* /lib/x86_64-linux-gnu/libxml2.so.2
```

## Archivos de configuración importantes

| Archivo | Propósito |
|---------|-----------|
| `/etc/cups/printers.conf` | Configuración de impresoras |
| `/etc/cups/ppd/Canon-iR-ADV-C5240.ppd` | Descriptor de la impresora |
| `/etc/cngplp2/account/` | Credenciales de Department ID |
| `/var/log/cups/error_log` | Logs de CUPS |

## Referencias

- Driver Canon: Descargable desde [canon.es](https://www.canon.es) → Soporte → Drivers
- Documentación CUPS: https://www.cups.org/documentation.html
- Herramienta cnjatool2: Incluida en el paquete del driver

*Documento generado a partir de una instalación real en Kubuntu 25.10, enero 2026.*
