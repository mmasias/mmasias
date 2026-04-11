# Si no sé la temperatura, mejor enfriar

## El ventilador que nadie pidió: iMac + SSD + Linux

**Por Manuel & Claude Code**

---

Instalas Linux en un iMac. Todo parece funcionar. Pero hay un ventilador que no para, que va a tope sin importar lo que hagas, sin importar si la máquina está en reposo o cargando algo pesado. No es la CPU. No es la GPU. Es el ventilador del disco duro. Y el disco duro es un SSD.

Este artículo explica por qué ocurre y cómo solucionarlo de forma permanente, independientemente de la distribución que uses.

---

## Por qué ocurre

Los iMac de Apple incluyen, además del ventilador estándar del procesador, un ventilador dedicado al disco duro. Este ventilador es controlado directamente por el **SMC** (System Management Controller), el chip de Apple encargado de la gestión térmica.

El SMC no usa los sensores genéricos del sistema operativo. Usa un sensor de temperatura propietario que Apple incluye en sus discos duros originales. Cuando el SMC detecta que ese sensor no responde — porque has instalado un SSD de terceros que no tiene ese sensor — activa el modo de seguridad: **si no sé la temperatura, mejor enfriar**. El ventilador se dispara a velocidades de entre 3500 y 5500 RPM y no baja.

Linux no tiene forma nativa de decirle al SMC "tranquilo, el disco está bien". El SMC toma el control del fan y lo mantiene alto.

---

## Diagnóstico

Verifica que este es tu problema:

```bash
# Ver velocidades actuales de los fans
sensors

# Ejemplo de salida problemática:
# ODD :  1999 RPM  (min = 2000 RPM, max = 2500 RPM)
# HDD :  3828 RPM  (min = 2000 RPM, max = 5500 RPM)  ← este es el problema
# CPU :   939 RPM  (min =  940 RPM, max = 2100 RPM)
```

Si el fan HDD está por encima del mínimo mientras la CPU está fría (por debajo de 60°C), es casi seguro que el SMC está en modo pánico térmico.

Identifica el número de fan y el path correcto:

```bash
cat /sys/devices/platform/applesmc.768/fan*_label
# ODD
# HDD   ← este es fan2
# CPU
```

Prueba manual para confirmar que escribir al fan funciona:

```bash
sudo bash -c 'echo 1 > /sys/devices/platform/applesmc.768/fan2_manual && echo 2000 > /sys/devices/platform/applesmc.768/fan2_output'
sensors  # ¿bajó el HDD fan?
```

Si baja momentáneamente y luego vuelve a subir, confirmas el problema: el SMC lo sobreescribe.

---

## La solución

El SMC recupera el control cada pocos segundos. La solución es un servicio que pelee contra él continuamente, escribiendo la velocidad deseada en un loop.

### Paso 1: Crear el script

```bash
sudo nano /usr/local/bin/fan-hdd-quiet.sh
```

```bash
#!/bin/bash
while true; do
  echo 1 > /sys/devices/platform/applesmc.768/fan2_manual
  echo 2000 > /sys/devices/platform/applesmc.768/fan2_output
  sleep 1
done
```

```bash
sudo chmod +x /usr/local/bin/fan-hdd-quiet.sh
```

### Paso 2: Crear el servicio systemd

```bash
sudo nano /etc/systemd/system/fan-hdd-quiet.service
```

```ini
[Unit]
Description=Keep HDD fan at minimum (SSD has no temp sensor)
After=multi-user.target

[Service]
Type=simple
Restart=always
ExecStart=/usr/local/bin/fan-hdd-quiet.sh

[Install]
WantedBy=multi-user.target
```

### Paso 3: Activar

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now fan-hdd-quiet.service
```

### Verificar

```bash
sensors
# HDD : 1998 RPM  (min = 2000 RPM, max = 5500 RPM)  ← silencioso
```

---

## Notas importantes

**¿Es seguro fijar el fan al mínimo?**
Sí, siempre que el SSD esté montado correctamente y tenga ventilación razonable. Los SSD no generan calor significativo. El fan original servía para enfriar un HDD mecánico con partes móviles. Un SSD moderno en reposo genera menos de 1W de calor.

**¿Qué pasa si la temperatura sube?**
Este script fija el fan del HDD al mínimo siempre. Si tienes una carga intensa y quieres que el fan suba automáticamente con la temperatura, necesitarías lógica adicional. Para uso general de escritorio, el mínimo es más que suficiente.

**¿Funciona en todos los iMac?**
Funciona en cualquier iMac que use `applesmc` como driver (la mayoría de modelos 2009-2017 con Linux). El número de fan puede variar — usa `cat /sys/devices/platform/applesmc.768/fan*_label` para identificar cuál es el HDD en tu modelo.

**¿Y si reinstalo la distro?**
Necesitas repetir los pasos. Son solo dos archivos:
- `/usr/local/bin/fan-hdd-quiet.sh`
- `/etc/systemd/system/fan-hdd-quiet.service`

Y el comando `sudo systemctl enable --now fan-hdd-quiet.service`.

---

## Contexto del sistema donde se verificó

- iMac 2011 (iMac12,2), Ubuntu/Xubuntu 24.04, kernel 6.17.0-20
- SSD Kingston 960 GB (sin sensor térmico Apple)
- Driver applesmc cargado automáticamente
