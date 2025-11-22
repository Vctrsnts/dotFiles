#!/bin/bash
# ---------------------------------------------------------
# Script: umount-usb.sh
# Objetivo: Desmontar automáticamente la última partición
#           de un disco USB externo montado
# ---------------------------------------------------------

# 1. Detectar el último disco USB
DISK=$(lsblk -p -nr -o NAME,TYPE,TRAN | awk '$2=="disk" && $3=="usb" {print $1}' | tail -n 1)

if [ -z "$DISK" ]; then
    echo "No se encontró ningún disco USB externo."
    exit 1
fi

# 2. Buscar la primera partición montada de ese disco
PART=$(lsblk -p -nr -o NAME,TYPE,MOUNTPOINT "$DISK" | awk '$2=="part" && $3!="" {print $1}' | head -n 1)

if [ -z "$PART" ]; then
    echo "El disco $DISK no tiene particiones montadas."
    exit 1
fi

# 3. Desmontar la partición
udisksctl unmount -b "$PART"

echo "Dispositivo $PART desmontado correctamente."
