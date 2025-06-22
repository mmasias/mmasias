#!/bin/bash

# Script para aplicar la configuración capturada
# EJECUTAR EN EL ORDENADOR DESTINO

echo "=== APLICACIÓN DE CONFIGURACIÓN MIDI Y DOSBOX-X ==="
echo "ADVERTENCIA: Este script modificará configuraciones del sistema"
echo "Asegúrate de hacer backup antes de continuar"
echo ""
read -p "¿Continuar? (s/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Cancelado por el usuario"
    exit 1
fi

echo "Instalando paquetes necesarios..."
# Aquí se añadirán los comandos específicos basados en la configuración capturada

echo "Aplicación completada. Reinicia el sistema para asegurar que todos los cambios tomen efecto."
