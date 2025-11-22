#!/bin/bash
# ---------------------------------------------------------
# Script: mount-usb.sh
# Objetivo: Montar automáticamente el último disco USB externo
#           y devolver el punto de montaje
# ---------------------------------------------------------

# 1. Detectar el último disco USB
DISK=$(lsblk -p -nr -o NAME,TYPE,TRAN | awk '$2=="disk" && $3=="usb" {print $1}' | tail -n 1)

if [ -z "$DISK" ]; then
    echo "ERROR: No se encontró ningún disco USB externo." >&2
    exit 1
fi

# 2. Buscar la primera partición
PART=$(lsblk -p -nr -o NAME,TYPE "$DISK" | awk '$2=="part" {print $1}' | head -n 1)

if [ -z "$PART" ]; then
    echo "ERROR: El disco $DISK no tiene particiones." >&2
    exit 1
fi

# 3. Montar la partición
udisksctl mount -b "$PART" >/dev/null

# 4. Obtener el punto de montaje
MOUNTPOINT=$(lsblk -nr -o NAME,MOUNTPOINT "$PART" | awk '{print $2}')

# 5. Imprimir SOLO el punto de montaje (para que MC lo capture)
echo "$MOUNTPOINT"
