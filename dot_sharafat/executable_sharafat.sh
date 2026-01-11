#!/bin/bash

################################################################################
# Sharafat's Master Automation Script
################################################################################
# This script manages background automation tasks including git auto-push
# and cloud sync operations.
################################################################################

################################################################################
# Configuration
################################################################################

AUTOPUSH_SCRIPT="$HOME/.sharafat/scripts/autoPush.sh"
AUTOSYNC_SCRIPT="$HOME/.sharafat/scripts/autoDriveSync.sh"
BREAK_SCRIPT="$HOME/.sharafat/scripts/break.sh"
LOG_FILE="$HOME/.sharafat/automation.log"

GIT_PUSH_INTERVAL=60       # Git push every 60 minutes
DRIVE_SYNC_INTERVAL=60     # Drive sync every 60 minutes
CHECK_INTERVAL=1           # Check interval (in minutes)

git_push_counter=0
drive_sync_counter=0

################################################################################
# Functions
################################################################################

log() {
    local message="[$(date +"%Y-%m-%d %T")] [MASTER] $1"
    echo "$message"
    echo "$message" >> "$LOG_FILE"
}

check_internet() {
    ping -c 1 -W 2 8.8.8.8 &> /dev/null || ping -c 1 -W 2 1.1.1.1 &> /dev/null
}

run_git_autopush() {
    if check_internet; then
        log "Running git auto-push"
        bash "$AUTOPUSH_SCRIPT"
    else
        log "Skipping git auto-push: No internet"
    fi
}

run_drive_sync() {
    if check_internet; then
        log "Running drive sync"
        bash "$AUTOSYNC_SCRIPT"
    else
        log "Skipping drive sync: No internet"
    fi
}

cleanup() {
    log "Stopped"
    exit 0
}

backup_pkgs() {
    if command -v pacman &> /dev/null; then
        log "Backing up pacman packages"
        pacman -Q > "$HOME/.sharafat/pacman_pkgs.txt"
    else
        log "Pacman not found, skipping package backup"
    fi
}

trap cleanup SIGINT SIGTERM

################################################################################
# Validation
################################################################################

validate_scripts() {
    [ -f "$AUTOPUSH_SCRIPT" ] || { log "ERROR: $AUTOPUSH_SCRIPT not found"; exit 1; }
    [ -f "$AUTOSYNC_SCRIPT" ] || { log "ERROR: $AUTOSYNC_SCRIPT not found"; exit 1; }
    log "Scripts validated"
}

################################################################################
# Main Loop
################################################################################

# Break script in the background
bash "$BREAK_SCRIPT" &

log "Started"
validate_scripts
backup_pkgs

while true; do
    sleep "${CHECK_INTERVAL}m"
    
    git_push_counter=$((git_push_counter + CHECK_INTERVAL))
    drive_sync_counter=$((drive_sync_counter + CHECK_INTERVAL))
    
    [ "$git_push_counter" -ge "$GIT_PUSH_INTERVAL" ] && { run_git_autopush; git_push_counter=0; }
    [ "$drive_sync_counter" -ge "$DRIVE_SYNC_INTERVAL" ] && { run_drive_sync; drive_sync_counter=0; }
done
