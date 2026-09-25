#!/bin/bash

SHARAFAT_DIR="$HOME/.sharafat"
source "$SHARAFAT_DIR/lib/utils.sh"

load_settings
git_push_counter=${GIT_PUSH_INTERVAL:-60}
drive_sync_counter=${DRIVE_SYNC_INTERVAL:-60}
break_pid=""

cleanup() {
    log "MASTER" "Shutting down automation orchestrator"
    [ -n "$break_pid" ] && kill "$break_pid" &>/dev/null
    exit 0
}

trap cleanup SIGINT SIGTERM

log "MASTER" "Master Automation Orchestrator started"
backup_packages

while true; do
    load_settings

    if [ "$ENABLE_BREAK_REMINDER" = "true" ]; then
        if [ -z "$break_pid" ] || ! kill -0 "$break_pid" &>/dev/null; then
            bash "$SHARAFAT_DIR/modules/break_reminder.sh" &
            break_pid=$!
            log "MASTER" "Spawned break reminder module (PID: $break_pid)"
        fi
    else
        if [ -n "$break_pid" ] && kill -0 "$break_pid" &>/dev/null; then
            kill "$break_pid" &>/dev/null
            log "MASTER" "Terminated break reminder process per settings"
            break_pid=""
        fi
    fi

    if [ "$ENABLE_GIT_PUSH" = "true" ] && [ "$git_push_counter" -ge "${GIT_PUSH_INTERVAL:-60}" ]; then
        bash "$SHARAFAT_DIR/modules/git_push.sh" &
        git_push_counter=0
    fi

    if [ "$ENABLE_DRIVE_SYNC" = "true" ] && [ "$drive_sync_counter" -ge "${DRIVE_SYNC_INTERVAL:-60}" ]; then
        bash "$SHARAFAT_DIR/modules/drive_sync.sh" &
        drive_sync_counter=0
    fi

    step="${CHECK_INTERVAL:-1}"
    sleep "${step}m"

    git_push_counter=$((git_push_counter + step))
    drive_sync_counter=$((drive_sync_counter + step))
done
