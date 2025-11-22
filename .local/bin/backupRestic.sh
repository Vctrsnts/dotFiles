#!/usr/bin/env bash
# -*- coding: utf-8 -*-

set -e

# Función para notificar sobre el proceso de respaldo
enviarNotificacions(){
    local repository="$1"
    local action="$2"
    local data="$3"
    local result=""
    local ok="$4"

    local formatted_message="📢 Resumen de respaldo:\n"
    formatted_message+="🗂  Repositorio: ${repository}\n"
    formatted_message+="⚡ Acción: ${action}\n"
    formatted_message+="📦 Archivos procesados:\n=== === === ===\n"

    # Genera un txnId unic en resposta a acció i un timestamp per assegurar que sigui unic
    local current_timestamp_ms=$(date '+%s%3N')
    # RANDOM afegedir un extra per si hi ha dos cridas que es fan en el mateix ms
    local txn_id="${action}_${current_timestamp_ms}_${RANDOM}"

    while read -r line; do
        if [[ -z $result ]]; then
          result=$(echo "${line}" | tr '"' "'")
        else
          result="${result}\n${line}"
        fi
    done < <(echo "$data")

    formatted_message+="${result}\n"

    # Determinar mensaje final según la acción
    case "$action" in
        create) formatted_message+="=== === === ===\n💾 End backup at ${repository}" ;;
        check) formatted_message+="=== === === ===\n🔍 End check at ${repository}" ;;
        prune) formatted_message+="=== === === ===\n🗑️  End prune at ${repository}" ;;
        snapshots) formatted_message+="=== === === ===\n📸 End snapshots at ${repository}" ;;
    esac

    #curl -XPUT \
    #    -H "Authorization: Bearer ${MATRIX_TOKEN}"\
    #    -H "Content-Type: application/json"\
    #    -d "{ \"msgtype\":\"m.text\", \"body\":\"${formatted_message}\"}" \
    #        "${MATRIX_SERVER}/_matrix/client/v3/rooms/${MATRIX_ROOM}/send/m.room.message/$(date '+%s%3N')"

    local response=$(curl -s -XPUT \
        -H "Authorization: Bearer ${MATRIX_TOKEN}" \
        -H "Content-Type: application/json" \
        -d "{ \"msgtype\":\"m.text\", \"body\":\"${formatted_message}\"}" \
        "${MATRIX_SERVER}/_matrix/client/v3/rooms/${MATRIX_ROOM}/send/m.room.message/${txn_id}")

}
# Cargar las variables de entorno desde el archivo backup.env
ENV_FILE="$HOME/.local/bin/backup.env"

if [ -f "$ENV_FILE" ]; then
    set -a
    source "$ENV_FILE"
    set +a
else
    echo "Error: No se encuentra el archivo $ENV_FILE"
    exit 1
fi


# Configuració de Restic Local
export RESTIC_PASSWORD=${RESTIC_PASSWORD}
# DECLARACIÓ DEL ARRAY REPOS
#declare -A REPOS

# Configuración de repositorios
REPOS=(
  "s3:${SERVER_MINIO_URL}/totenkopf|${SERVER_AWS_ACCESS_KEY_ID}|${SERVER_AWS_SECRET_ACCESS_KEY}"
  "s3:${VPS_MINIO_URL}/totenkopf|${VPS_AWS_ACCESS_KEY_ID}|${VPS_AWS_SECRET_ACCESS_KEY}"
)

# Directorios que se respaldarán
DIRECTORIOS=(
    "/home/$user/.config"
    "/home/$user/.local/share/fonts"
    "/home/$user/.local/share/icons"
    "/home/$user/.local/share/themes"
    "/home/$user/.local/bin"
    "/home/$user/.ssh"
    "/home/$user/.signature"
    "/home/$user/.bashrc"
    "/home/$user/Mail"
    "/home/$user/Projects"
    "/home/$user/Varios/Novela"
)

# Exclusiones
EXCLUSIONES=(
    "--exclude=*.tmp"
    "--exclude=*.mkv"
    "--exclude=*.mp4"
    "--exclude=*.mp3"
    "--exclude=*.avi"
    "--exclude=*.log"
    "--exclude=*.AppImage"
)

# Realizar respaldos en cada repositorio
for entry in "${REPOS[@]}"; do
    IFS='|' read -r REPO AWS_KEY AWS_SECRET <<< "$entry"
    export AWS_ACCESS_KEY_ID="$AWS_KEY"
    export AWS_SECRET_ACCESS_KEY="$AWS_SECRET"

    echo "restic -r $REPO backup --verbose --skip-if-unchanged ${DIRECTORIOS[@]} ${EXCLUSIONES[@]}"

    create_output=$(restic -r "$REPO" backup \
                    --tag ${TAG_1} \
                    --tag ${TAG_2} \
                    --host ${HOST} \
                    --verbose \
                    --skip-if-unchanged \
                    "${DIRECTORIOS[@]}" \
                    "${EXCLUSIONES[@]}")
    ok=$?
    enviarNotificacions "$REPO" "create" "$create_output" "$ok"
done

# Verificar cada repositorio
for entry in "${REPOS[@]}"; do
    IFS='|' read -r REPO AWS_KEY AWS_SECRET <<< "$entry"
    export AWS_ACCESS_KEY_ID="$AWS_KEY"
    export AWS_SECRET_ACCESS_KEY="$AWS_SECRET"

    check_output=$(restic -r "$REPO" check)
    ok=$?
    enviarNotificacions "$REPO" "check" "$check_output" "$ok"
done

# Limpiar datos antiguos en cada repositorio
for entry in "${REPOS[@]}"; do
    IFS='|' read -r REPO AWS_KEY AWS_SECRET <<< "$entry"
    export AWS_ACCESS_KEY_ID="$AWS_KEY"
    export AWS_SECRET_ACCESS_KEY="$AWS_SECRET"

    prune_output=$(restic -r "$REPO" forget \
                    --prune \
                    --keep-daily 7 \
                    --keep-weekly 4 \
                    --keep-monthly 6)
    ok=$?
    enviarNotificacions "$REPO" "prune" "$prune_output" "$ok"
done

# Listar snapshots en cada repositorio
for entry in "${REPOS[@]}"; do
    IFS='|' read -r REPO AWS_KEY AWS_SECRET <<< "$entry"
    export AWS_ACCESS_KEY_ID="$AWS_KEY"
    export AWS_SECRET_ACCESS_KEY="$AWS_SECRET"

    snapshots_output=$(restic -r "$REPO" snapshots -c)
    ok=$?
    enviarNotificacions "$REPO" "snapshots" "$snapshots_output" "$ok"
done
