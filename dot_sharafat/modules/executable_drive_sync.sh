#!/bin/bash

source "$HOME/.sharafat/lib/utils.sh"
load_settings

SYNC_CONFIG="$SHARAFAT_DIR/config/drive_sync.txt"

if [ "$ENABLE_DRIVE_SYNC" != "true" ]; then
    log "SYNC" "Drive sync is disabled in settings.env"
    exit 0
fi

if ! check_internet; then
    log "SYNC" "Skipping drive sync: No internet connection"
    exit 0
fi

if ! command -v rclone &> /dev/null; then
    log "SYNC" "ERROR: rclone is not installed"
    send_notification "Error" "rclone is not installed. Drive sync cannot run." "critical"
    exit 1
fi

if [ ! -f "$SYNC_CONFIG" ]; then
    log "SYNC" "ERROR: Configuration file $SYNC_CONFIG not found"
    exit 1
fi

log "SYNC" "Starting rclone sync sequence"

while IFS= read -r line || [ -n "$line" ]; do
    clean_line=$(echo "$line" | sed 's/#.*//' | xargs)
    [ -z "$clean_line" ] && continue

    source_dir=$(echo "$clean_line" | awk -F '=' '{print $1}' | xargs)
    dest_dir=$(echo "$clean_line" | awk -F '=' '{print $2}' | xargs)

    if [ -z "$source_dir" ] || [ -z "$dest_dir" ]; then
        log "SYNC" "WARNING: Invalid line format: $line"
        continue
    fi

    if [ ! -d "$source_dir" ]; then
        log "SYNC" "WARNING: Source directory does not exist: $source_dir"
        continue
    fi

    # Empty directory protection: prevents wiping cloud data if drive unmounted/empty
    item_count=$(find "$source_dir" -mindepth 1 | wc -l)
    if [ "$item_count" -eq 0 ]; then
        log "SYNC" "SAFETY TRIGGERED: Source directory '$source_dir' is EMPTY! Skipping sync to prevent cloud wiping."
        send_notification "Drive Sync Aborted" "Empty source directory: $source_dir" "critical"
        continue
    fi

    log "SYNC" "Syncing ($item_count items): $source_dir -> $dest_dir"
    if rclone sync "$source_dir" "$dest_dir"; then
        log "SYNC" "Successfully synced: $source_dir"
    else
        log "SYNC" "ERROR: Failed to sync: $source_dir"
    fi

done < "$SYNC_CONFIG"

send_notification "Automation" "Drive sync completed at $(date +"%T")"
log "SYNC" "Drive sync sequence completed"
