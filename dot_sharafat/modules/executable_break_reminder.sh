#!/bin/bash

# Module: Break Reminder
source "$HOME/.sharafat/lib/utils.sh"
load_settings

if [ "$ENABLE_BREAK_REMINDER" != "true" ]; then
    log "BREAK" "Break reminder is disabled in settings.env"
    exit 0
fi

# Convert minutes to seconds (default 20 minutes)
INTERVAL_SEC=$((${BREAK_INTERVAL_MINUTES:-20} * 60))

log "BREAK" "Break reminder script started (interval: ${BREAK_INTERVAL_MINUTES}m)"

# Clean up trap
trap "log 'BREAK' 'Break reminder script stopped'; exit 0" SIGINT SIGTERM

while true; do
    sleep "$INTERVAL_SEC"
    
    # Re-check settings in case it was toggled dynamically during sleep
    load_settings
    if [ "$ENABLE_BREAK_REMINDER" != "true" ]; then
        log "BREAK" "Break reminder turned off in settings. Stopping reminder process."
        exit 0
    fi

    send_notification "Take a Break" "It's time for a ${BREAK_INTERVAL_MINUTES}-minute break! Rest your eyes and stretch."
    log "BREAK" "Break reminder notification sent"
done
