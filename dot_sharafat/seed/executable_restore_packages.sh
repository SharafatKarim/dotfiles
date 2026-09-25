#!/bin/bash

source "$HOME/.sharafat/lib/utils.sh"
load_settings

PKG_DIR="$SHARAFAT_DIR/packages"

if [ ! -d "$PKG_DIR" ]; then
    log "RESTORE" "ERROR: Package directory $PKG_DIR not found"
    exit 1
fi

if [ -s "$PKG_DIR/pacman_native.txt" ]; then
    log "RESTORE" "Installing native pacman packages..."
    sudo pacman -S --needed --noconfirm - < "$PKG_DIR/pacman_native.txt"
fi

if [ -s "$PKG_DIR/pacman_aur.txt" ]; then
    AUR_HELPER=""
    command -v yay &>/dev/null && AUR_HELPER="yay"
    command -v paru &>/dev/null && AUR_HELPER="paru"

    if [ -n "$AUR_HELPER" ]; then
        log "RESTORE" "Installing AUR & Chaotic packages with $AUR_HELPER..."
        $AUR_HELPER -S --needed --noconfirm - < "$PKG_DIR/pacman_aur.txt"
    else
        log "RESTORE" "WARNING: Neither yay nor paru found, skipping AUR/Chaotic packages"
    fi
fi

if [ -s "$PKG_DIR/uv_tools.txt" ] && command -v uv &>/dev/null; then
    log "RESTORE" "Installing uv global tools..."
    while IFS= read -r tool || [ -n "$tool" ]; do
        [ -n "$tool" ] && uv tool install "$tool"
    done < "$PKG_DIR/uv_tools.txt"
fi

if [ -s "$PKG_DIR/pnpm_global.txt" ] && command -v pnpm &>/dev/null; then
    log "RESTORE" "Installing pnpm global packages..."
    xargs -a "$PKG_DIR/pnpm_global.txt" -r pnpm add -g
fi

if [ -s "$PKG_DIR/vscode_extensions.txt" ] && command -v code &>/dev/null; then
    log "RESTORE" "Installing VS Code extensions..."
    xargs -a "$PKG_DIR/vscode_extensions.txt" -r -L 1 code --install-extension
fi

log "RESTORE" "Package restoration complete"
