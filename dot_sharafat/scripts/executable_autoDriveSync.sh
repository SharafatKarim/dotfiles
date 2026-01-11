#!/bin/bash

################################################################################
# Auto Drive Sync Script
################################################################################
# This script syncs local directories to Google Drive using rclone.
# Called by the master automation script (sharafat.sh).
################################################################################

################################################################################
# Configuration
################################################################################

# Directories to sync to Google Drive
declare -a RCLONE_SYNC_DIRS=(
    "/home/sharafat/Desktop/personal:drive-ug:DATA/Desktop/personal"
    "/home/sharafat/Desktop/canvas:drive-ug:DATA/Desktop/canvas"
    "/home/sharafat/Desktop/people:drive-ug:DATA/Desktop/people"
    "/home/sharafat/Desktop/org:drive-ug:DATA/Desktop/Desktop/org"
    "/home/sharafat/Documents/Books:drive-ug:DATA/Documents/Books"
    "/home/sharafat/Documents/sync/backup:drive-ug:DATA/Documents/sync/backup"
)

LOG_FILE="$HOME/.sharafat/automation.log"

################################################################################
# Functions
################################################################################

# Log function with timestamp
log() {
    local message="[$(date +"%Y-%m-%d %T")] [SYNC] $1"
    echo "$message"
    echo "$message" >> "$LOG_FILE"
}

# Check if rclone is installed
check_rclone() {
    if ! command -v rclone &> /dev/null; then
        log "ERROR: rclone is not installed. Please install rclone to use this script."
        notify-send "Error" "rclone is not installed. Drive sync script cannot run." --urgency=critical
        exit 1
    fi
    log "rclone found: $(rclone --version | head -n 1)"
}

# Sync directories to cloud using rclone
sync_to_cloud() {
    log "Starting rclone sync operations"

    for sync_pair in "${RCLONE_SYNC_DIRS[@]}"; do
        local source="${sync_pair%%:*}"
        local destination="${sync_pair#*:}"

        if [ ! -d "$source" ]; then
            log "WARNING: Source directory not found: $source"
            continue
        fi

        log "Syncing: $source -> $destination"
        if rclone sync "$source" "$destination"; then
            log "Successfully synced: $source"
        else
            log "ERROR: Failed to sync: $source"
        fi
    done
}

# Send notification
send_notification() {
    notify-send "Automation" "Drive sync completed at $(date +"%T")"
}

################################################################################
# Main Execution
################################################################################

log "Auto Drive sync script started"

# Check if rclone is installed before proceeding
check_rclone

# Execute cloud sync once
sync_to_cloud

# Send notification
send_notification

log "Auto Drive sync script completed"

