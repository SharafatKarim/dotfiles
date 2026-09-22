#!/bin/bash

source "$HOME/.sharafat/lib/utils.sh"
load_settings

SYNC_CONFIG="$SHARAFAT_DIR/config/drive_sync.txt"

if ! command -v rclone &> /dev/null; then
    log "SEED" "ERROR: rclone is not installed."
    exit 1
fi

if [ ! -f "$SYNC_CONFIG" ]; then
    log "SEED" "ERROR: Drive configuration $SYNC_CONFIG not found."
    exit 1
fi

log "SEED" "Checking and restoring missing local directories from Google Drive"

while IFS= read -r line || [ -n "$line" ]; do
    clean_line=$(echo "$line" | sed 's/#.*//' | xargs)
    [ -z "$clean_line" ] && continue

    local_dir=$(echo "$clean_line" | awk -F '=' '{print $1}' | xargs)
    remote_dir=$(echo "$clean_line" | awk -F '=' '{print $2}' | xargs)

    if [ -z "$local_dir" ] || [ -z "$remote_dir" ]; then
        continue
    fi

    if [ ! -d "$local_dir" ] || [ $(find "$local_dir" -mindepth 1 2>/dev/null | wc -l) -eq 0 ]; then
        log "SEED" "RESTORING: $remote_dir -> $local_dir"
        mkdir -p "$local_dir"
        if rclone copy "$remote_dir" "$local_dir"; then
            log "SEED" "SUCCESS: Restored $local_dir from $remote_dir"
        else
            log "SEED" "ERROR: Failed to restore $local_dir"
        fi
    else
        log "SEED" "EXISTS: $local_dir has content, skipping restore."
    fi
done < "$SYNC_CONFIG"

log "SEED" "Drive restore process completed."
