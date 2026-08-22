#!/bin/bash

# Shared Utilities & Functions for Automation System

SHARAFAT_DIR="$HOME/.sharafat"
LOG_FILE="$SHARAFAT_DIR/automation.log"
SETTINGS_FILE="$SHARAFAT_DIR/config/settings.env"

# Load settings configuration
load_settings() {
    if [ -f "$SETTINGS_FILE" ]; then
        # Load key=value pairs, ignoring comments and blank lines
        export $(grep -v '^#' "$SETTINGS_FILE" | grep -v '^[[:space:]]*$' | xargs)
    fi
}

# Unified logging function
log() {
    local category="${1:-GENERAL}"
    local message="${2:-}"
    local formatted="[$(date +"%Y-%m-%d %T")] [$category] $message"
    echo "$formatted"
    echo "$formatted" >> "$LOG_FILE"
}

# Internet connectivity check
check_internet() {
    ping -c 1 -W 2 8.8.8.8 &> /dev/null || ping -c 1 -W 2 1.1.1.1 &> /dev/null
}

# Send desktop notifications
send_notification() {
    local title="$1"
    local msg="$2"
    local urgency="${3:-normal}"
    if command -v notify-send &> /dev/null; then
        notify-send "$title" "$msg" --urgency="$urgency"
    fi
}

# Package backup helper (pacman)
backup_pacman_pkgs() {
    if command -v pacman &> /dev/null; then
        log "BACKUP" "Backing up pacman package list"
        pacman -Q > "$SHARAFAT_DIR/pacman_pkgs.txt"
    else
        log "BACKUP" "Pacman package manager not found, skipping"
    fi
}
