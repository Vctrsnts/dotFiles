# i3-wm

Fitxer de configuració del meu actual gestor de finestres ( i3WM ).

Tot el que hi ha aqui penjat esta pensat per fer-s'he servir amb GNU/Debian.

Conter el següents fitxers:

* fonts : directori on estan les fonts per a i3WM ( aquest directori te que esta ocult )
* gtk-3.0 : directori que conte el fitxer de configuració per a les aplicacions GKT3
* i3 : directori que conte els arxius per a la configuració de i3WM
  * config : fitxer que conte la configuració de i3WM
  * i3blocks.conf : fitxer que conte la configuració de la barra d'estat
  * example_config.txt : fitxer d'exemple de i3WM que pot fer-s'he servir com a model.
* i3blocks : fitxers que es necessiten per a visualitzar informació sobre el sistema ( han d'estat situats a `/usr/share/i3blocks` ), aquests fitxers son:
  * "trash": per veure els fitxers que hi ha a la paperera
  * "battery": per veure l'estat de la bateria ( durada, endollat o no, etc... )
    * Per fer servir aquest fitxer es necessita que estigui instalat el paquet "ACPI"
  * "cpu": per veure el nivell d'ocupació de la CPU
  * "memory": per veure el nivell d'ocupació de la RAM del sistema. Inclou el percentatge.
* rofi : fitxers / templates per el llançador d'aplicacions.
* scripts : directori on estan els fitxers necessaris per bloqueja la pantalla en cas de necessitat.
* packages_install_i3wm : Tots els paquets que jo tinc instalats per fer servir i3WM.
  * En aquest cas, es per una distribució de GNU/Debian.
