#!/bin/bash
#
# cpu_temp.sh - Script para mostrar la temperatura de la CPU en Waybar
#
# Descripción:
#   - Detecta automáticamente el directorio "hwmon" correspondiente al sensor
#     de la CPU (Intel: coretemp, AMD: k10temp).
#   - Lee la temperatura desde "temp1_input" y la convierte a grados Celsius.
#   - Selecciona un icono (glifo) según el rango de temperatura:
#       < 50 °C  →   (frío)
#       50–69 °C →   (medio)
#       ≥ 70 °C  →   (caliente)
#   - Si la temperatura es ≥ 90 °C, añade la clase "critical" en la salida JSON.
#
# Uso:
#   - Guardar en ~/.config/waybar/scripts/cpu_temp.sh
#   - Dar permisos: chmod +x ~/.config/waybar/scripts/cpu_temp.sh
#   - Configurar en Waybar como módulo "custom":
#       "custom/cpu_temp": {
#         "interval": 10,
#         "exec": "~/.config/waybar/scripts/cpu_temp.sh",
#         "return-type": "json",
#         "tooltip": true
#       }
#
# Notas:
#   - Waybar aplicará el estilo CSS con la clase "critical" cuando corresponda.
#

# Buscar el hwmon de la CPU
HWMON=$(for d in /sys/class/hwmon/hwmon*; do
    if grep -qE 'coretemp|k10temp' "$d/name"; then
        echo "$d"
        break
    fi
done)

# Leer temperatura en miligrados Celsius
TEMP=$(cat "$HWMON/temp1_input")
TEMP_C=$((TEMP / 1000))

# Seleccionar icono según rango
if [ "$TEMP_C" -lt 50 ]; then
    ICON=""
elif [ "$TEMP_C" -lt 70 ]; then
    ICON=""
else
    ICON=""
fi

# Determinar clase CSS
if [ "$TEMP_C" -ge 90 ]; then
    CLASS="critical"
else
    CLASS=""
fi

# Salida en formato JSON para Waybar
echo "{\"text\": \"${TEMP_C}°C $ICON\", \"class\": \"$CLASS\"}"
