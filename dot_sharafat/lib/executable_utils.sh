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

    if command -v pacman &>/dev/null; then
        comm -23 <(pacman -Qenq | sort) <(pacman -Sql chaotic-aur 2>/dev/null | sort) > "$target/pacman_native.txt"
        cat <(pacman -Qemq) <(comm -12 <(pacman -Qeq | sort) <(pacman -Sql chaotic-aur 2>/dev/null | sort)) | sort -u > "$target/pacman_aur.txt"
        rm -f "$target/pacman_explicit.txt"
    fi

    if command -v uv &>/dev/null; then
        uv tool list 2>/dev/null | awk '/^[a-zA-Z0-9_-]/ && !/^-/ {print $1}' | sort -u > "$target/uv_tools.txt"
    fi

    if command -v pnpm &>/dev/null; then
        find "$HOME/.local/share/pnpm/global" -name "package.json" 2>/dev/null | xargs -r jq -r '.dependencies // {} | keys[]' 2>/dev/null | sort -u > "$target/pnpm_global.txt"
    fi

    if command -v code &>/dev/null; then
        code --list-extensions 2>/dev/null | sort -u > "$target/vscode_extensions.txt"
    fi

    command -v chezmoi &>/dev/null && chezmoi add "$target"
    log "BACKUP" "Sanitized package lists updated and staged in chezmoi"
}

backup_pacman_pkgs() {
    backup_packages true
}
