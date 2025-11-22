#!/bin/bash
# -----------------------------------------------------------------------------
# Script: sysUpdate.sh
# Autor: Vctrsnts
# Descripción:
#   Módulo para Waybar que muestra el número de paquetes pendientes de actualizar
#   en Arch Linux. Clasifica el estado en tres niveles de alerta y añade iconos
#   estilo semáforo para mayor claridad visual:
#     -    none     -> 0 paquetes para actualizar
#     - 🟢 normal   -> ≤10 paquetes y ninguno crítico
#     - 🟡 warning  -> entre 11 y 30 paquetes
#     - 🔴 critical -> >30 paquetes o si hay algún paquete crítico (kernel, systemd, nvidia)
#
# Funcionalidad:
#   - Usa `checkupdates` para obtener la lista de paquetes pendientes.
#   - Muestra el número de paquetes junto a un icono (🟢🟡🔴).
#   - Genera un tooltip con hasta 10 paquetes listados (añade "..." si hay más).
#   - Escapa caracteres especiales para que el JSON sea válido.
#   - Detecta paquetes críticos definidos en la lista `critical_pkgs`.
#
# Notas:
#   - Puedes ampliar la lista de paquetes críticos según tus necesidades.
#   - Los umbrales de normal/warning/critical se pueden ajustar fácilmente.
#   - Requiere fuente con soporte Unicode/emoji (JetBrainsMono Nerd Font funciona).
# -----------------------------------------------------------------------------

# Obtener lista de actualizaciones (maneja errores silenciosamente)
updates="$(checkupdates 2>/dev/null || true)"

# Contar correctamente: si está vacío, es 0; si no, cuenta líneas reales
if [ -z "$updates" ]; then
  count=0
else
  # Usa printf en lugar de echo para no añadir salto de línea extra
  count="$(printf "%s" "$updates" | wc -l)"
fi

# Definir paquetes críticos (puedes ampliar la lista)
critical_pkgs="linux-lts linux-dkms linux-headers systemd nvidia-dkms nvidia"

# Comprobar si hay algún paquete crítico en la lista (solo si hay actualizaciones)
critical_found=false
if [ "$count" -gt 0 ]; then
  for pkg in $critical_pkgs; do
    # ^pkg[[:space:]] asegura coincidencia al inicio y separada por espacio
    if printf "%s" "$updates" | grep -q "^$pkg[[:space:]]"; then
      critical_found=true
      break
    fi
  done
fi

# Preparar tooltip (máx. 10 paquetes), vacío si no hay actualizaciones
if [ "$count" -gt 0 ]; then
  tooltip="$(printf "%s" "$updates" | head -n 10)"
  # Si hay más de 10, añade una línea en blanco para estética (opcional)
  if [ "$count" -gt 10 ]; then
    tooltip="${tooltip}\n"
  fi
else
  tooltip=""
fi

# Escapar saltos de línea y comillas
tooltip_escaped=$(printf "%s" "$tooltip" | sed ':a;N;$!ba;s/\n/\\n/g; s/"/\\"/g')

# Determinar clase según reglas
if [ "$count" -eq 0 ]; then
  class="none"
elif [ "$critical_found" = true ]; then
  class="critical"
elif [ "$count" -le 10 ]; then
  class="normal"
elif [ "$count" -le 30 ]; then
  class="warning"
else
  class="critical"
fi

# Escapar saltos de línea y comillas para JSON
tooltip_escaped="$(printf "%s" "$tooltip" | sed ':a;N;$!ba;s/\n/\\n/g; s/"/\\"/g')"

# Asignar icono estilo semáforo (incluye estado sin actualizaciones)
if [ "$count" -eq 0 ]; then
  icon=""
elif [ "$class" = "normal" ]; then
  icon="🟢"
elif [ "$class" = "warning" ]; then
  icon="🟡"
else
  icon="🔴"
fi
# Salida JSON para waybar
echo "{\"text\":\"$icon $count\",\"class\":\"$class\",\"tooltip\":\"$tooltip_escaped\"}"
