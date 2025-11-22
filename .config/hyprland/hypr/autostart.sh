###############################################################################
# Autostart applications
###############################################################################
# Agente de polkit (gestión de permisos administrativos)
exec-once = systemctl --user start hyprpolkitagent
