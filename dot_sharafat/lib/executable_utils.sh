#!/bin/bash

SHARAFAT_DIR="$HOME/.sharafat"
LOG_FILE="$SHARAFAT_DIR/automation.log"
SETTINGS_FILE="$SHARAFAT_DIR/config/settings.env"

load_settings() {
    if [ -f "$SETTINGS_FILE" ]; then
        export $(grep -v '^#' "$SETTINGS_FILE" | grep -v '^[[:space:]]*$' | xargs)
    fi
}

log() {
    local category="${1:-GENERAL}"
    local message="${2:-}"
    local formatted="[$(date +"%Y-%m-%d %T")] [$category] $message"
    echo "$formatted"
    echo "$formatted" >> "$LOG_FILE"
}

check_internet() {
    ping -c 1 -W 2 8.8.8.8 &> /dev/null || ping -c 1 -W 2 1.1.1.1 &> /dev/null
}

send_notification() {
    local title="$1"
    local msg="$2"
    local urgency="${3:-normal}"
    if command -v notify-send &> /dev/null; then
        notify-send "$title" "$msg" --urgency="$urgency"
    fi
}

backup_packages() {
    local target="$SHARAFAT_DIR/packages"
    mkdir -p "$target"
    command -v pacman &>/dev/null && pacman -Qqe > "$target/pacman_explicit.txt"
    command -v uv &>/dev/null && uv tool list > "$target/uv_tools.txt"
    command -v pnpm &>/dev/null && pnpm list -g --depth=0 > "$target/pnpm_global.txt"

    command -v chezmoi &>/dev/null && chezmoi add "$target"
    log "BACKUP" "Package lists updated and staged in chezmoi"
}

backup_pacman_pkgs() {
    backup_packages true
}
