# El iMac que pensé que se moría, y no

## De KDE Neon a Xubuntu pasando por un diagnóstico equivocado

**Por Manuel & Claude Code**

---

Esta es la historia de un iMac de 2011 al que le puse Linux, que empezó a sonar como un avión, y cuya causa real no era lo que yo creía. Spoiler: pasé por tres distribuciones antes de darme cuenta de que el problema no era el escritorio gráfico.

---

## El punto de partida

El iMac es un **iMac 2011 (iMac12,2)**. Tiene un Intel Core i5-2500S (Sandy Bridge), 16 GB de RAM, un SSD Kingston de 960 GB que puse yo, y dos GPUs: una Intel HD 2000 integrada y una **AMD Radeon HD 6770M** discreta que es la que tiene conexión física a la pantalla interna. Es una máquina perfectamente capaz para uso de escritorio en 2025.

Instalé **KDE Neon**, que es mi distribución habitual. Entorno familiar, flujo de trabajo conocido, todo en orden.

Excepto que a los pocos minutos, el iMac empezaba a sonar. Los ventiladores se disparaban. La parte trasera del chasis, ese aluminio elegante, calentaba notablemente. No estaba haciendo nada especialmente intenso.

---

## El diagnóstico equivocado (razonable, pero equivocado)

Mi razonamiento fue directo: KDE es un escritorio visualmente rico, con efectos, compositing, animaciones. Este iMac tiene más de diez años. La GPU es vieja. La combinación tiene sentido como culpable.

Así que probé **Linux Mint**. Mismo resultado. Los ventiladores seguían disparándose.

Instalé **Xubuntu 24.04**. XFCE es ligero, sin efectos pesados, pensado para hardware más modesto. Los ventiladores... seguían igual.

En este punto el problema claramente no era KDE. Pero tampoco había mejorado nada.

---

## El primer descubrimiento: llvmpipe

Investigando, ejecuté:

```bash
glxinfo | grep renderer
```

Salida:

```
OpenGL renderer string: llvmpipe (LLVM 20.1.2, 256 bits)
```

`llvmpipe` significa que no hay aceleración gráfica real. OpenGL se está ejecutando completamente en la CPU, por software. Cualquier cosa que involucre gráficos — incluido el propio escritorio — está sobrecargando innecesariamente el procesador.

¿Por qué? El iMac tiene dos GPUs, pero ninguna estaba activa para Xorg.

---

## El segundo descubrimiento: la GPU estaba desactivada a propósito

Investigando más, encontré esto en `/etc/default/grub`:

```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash radeon.modeset=0"
```

`radeon.modeset=0` desactiva el driver de la AMD Radeon. Alguien (yo, en algún momento anterior) lo había puesto ahí deliberadamente. Y había sobrevivido a dos reinstalaciones porque mantuve las particiones.

¿Por qué lo puse? Por exactamente el mismo síntoma: los ventiladores se disparaban y la AMD calentaba. La solución de entonces fue desactivar la AMD. Pero eso hacía que todo el rendering cayera sobre la CPU vía llvmpipe, que a su vez también calentaba y hacía trabajar más al sistema. Un círculo.

La solución fue:

```bash
# Quitar radeon.modeset=0 de /etc/default/grub
sudo update-grub
# Instalar mbpfan para control de fans
sudo apt install mbpfan
sudo systemctl enable --now mbpfan
# Reboot
```

Tras el reinicio:

```
OpenGL renderer string: AMD TURKS (DRM 2.51.0 / 6.17.0-20-generic, LLVM 20.1.2)
```

Aceleración real. La GPU haciendo su trabajo. La CPU libre para lo suyo.

---

## El tercer descubrimiento: el ventilador del disco que no existe

Con la GPU activa y mbpfan controlando los fans por temperatura, la situación mejoró. Pero había un ventilador que seguía alto. No el de la CPU. El del disco duro.

```bash
sensors
# HDD : 3828 RPM  (min = 2000 RPM, max = 5500 RPM)
```

3828 RPM con la CPU a 44°C. No tenía sentido térmico.

La causa: el SSD Kingston no tiene el sensor de temperatura propietario que Apple incluye en sus discos duros originales. El SMC del iMac, al no recibir lectura de temperatura del disco, activa el modo de seguridad y dispara el fan al máximo. *Si no sé la temperatura, mejor enfriar.*

`mbpfan` controla los fans basándose en la temperatura de la CPU, pero no pelea contra el SMC cuando este toma el control del fan del HDD. La solución fue un servicio systemd con un loop que sobreescribe al SMC cada segundo:

```bash
# /usr/local/bin/fan-hdd-quiet.sh
while true; do
  echo 1 > /sys/devices/platform/applesmc.768/fan2_manual
  echo 2000 > /sys/devices/platform/applesmc.768/fan2_output
  sleep 1
done
```

Resultado final:

```
ODD :  1998 RPM  ← mínimo
HDD :  1998 RPM  ← mínimo
CPU :   938 RPM  ← mínimo
CPU Package: 47°C
```

Silencio.

---

## La conclusión incómoda

El ventilador del HDD llevaba disparado desde el día uno, independientemente del escritorio instalado. No era KDE. No era el rendering. Era un fan respondiendo al pánico térmico del SMC por un sensor ausente.

Es probable que KDE Neon hubiera funcionado perfectamente con la GPU activa y el fan controlado. El diagnóstico inicial — *KDE es pesado para este hardware* — era razonable dado los síntomas, pero los síntomas tenían otra causa.

No es que el diagnóstico estuviera mal hecho. Es que había dos problemas distintos (GPU desactivada + fan descontrolado) produciendo el mismo síntoma visible (calor, ruido, lentitud), y ambos apuntaban en la dirección equivocada.

---

## Estado final del sistema

- **Distribución:** Xubuntu 24.04.4 LTS
- **Escritorio:** XFCE (por ahora — KDE queda pendiente de probar)
- **GPU:** AMD Radeon HD 6770M activa, driver `radeon`, aceleración real
- **Fans:** mbpfan + fan-hdd-quiet.service, todos al mínimo en reposo
- **Temperatura CPU en reposo:** ~44-48°C
- **Ruido:** ninguno apreciable

El iMac de 2011 está, finalmente, como debería haber estado desde el principio.
