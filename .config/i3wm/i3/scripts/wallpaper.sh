#!/usr/bin/bash
shopt -s nullglob

if [[ -z $(which feh) ]]; then
    echo "wallpaper err: Can not found command feh." > ~/i3wm-wallpaper.err
    exit 127
fi

#
# DIRECTORI ON ESTAN ELS FONTS DE PANTALLA
#
path=~/.config/wallpapers

#
# TEMPS / INTERVAL ENTRE ELS CANVIS DE FONS DE PANTALLA
#
interval=59m

#
# INICI DE L'SCRIPT

cd $path

while true
do
	files=()

	for i in *.jpg *.png;
	do
	     [[ -f $i ]] && files+=("$i")
	done
	range=${#files[@]}

	CURRENT_WALLPAPER="${files[RANDOM % range]}"

	CURRENT_IMAGE=$path"/"$CURRENT_WALLPAPER

	#((range)) && feh --bg-scale "${files[RANDOM % range]}"
	((range)) && feh --bg-scale $CURRENT_WALLPAPER

	#
	# ENVIEM LA NOTIFICACIÓ AL SISTEMA, PERQUE ES VEGI PER PANTALLA
	#
	notify-send -i "$CURRENT_IMAGE" 'Desktop Changed' $(basename -- "$CURRENT_WALLPAPER")

	sleep $interval
done

# while true; do
# 	find ~/.config/wallpapers -type f \( -name '*.jpg' -o -name '*.png' \) -print0 |
# 		shuf -n1 -z | xargs -0 feh --bg-scale
# 	sleep 1m
# done
