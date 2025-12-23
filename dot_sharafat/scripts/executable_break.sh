#!/bin/bash

################################################################################
# Break Reminder Script
################################################################################
# This script sends periodic notifications to remind the user to take breaks
# from work. Following the 20-20-20 rule for eye health and productivity.
################################################################################

################################################################################
# Configuration
################################################################################

# Interval between reminders (in seconds)
# Default: 1200 seconds (20 minutes)
BREAK_INTERVAL=1200

# Notification title and message
NOTIFICATION_TITLE="Take a Break"
NOTIFICATION_MESSAGE="It's time for a 20-minute break! Rest your eyes and stretch."

# Optional: Sound notification (uncomment to enable)
# NOTIFICATION_SOUND="/usr/share/sounds/freedesktop/stereo/complete.oga"

LOG_FILE="$HOME/.sharafat/automation.log"

################################################################################
# Functions
################################################################################

# Display break reminder notification
show_notification() {
    local timestamp=$(date +"%T")
    local message="[$(date +"%Y-%m-%d %T")] [BREAK] Break reminder sent"
    
    # Basic notification
    notify-send "$NOTIFICATION_TITLE" "$NOTIFICATION_MESSAGE" \
        --urgency=normal \
        --icon=appointment-soon
    
    # Optional: Play sound (uncomment if NOTIFICATION_SOUND is set)
    # if [ -f "$NOTIFICATION_SOUND" ]; then
    #     paplay "$NOTIFICATION_SOUND" &
    # fi
    
    echo "$message"
    echo "$message" >> "$LOG_FILE"
}

# Handle script termination gracefully
cleanup() {
    local message="[$(date +"%Y-%m-%d %T")] [BREAK] Break reminder script stopped"
    echo "$message"
    echo "$message" >> "$LOG_FILE"
    exit 0
}

# Register cleanup on script termination
trap cleanup SIGINT SIGTERM

################################################################################
# Main Loop
################################################################################

message="[$(date +"%Y-%m-%d %T")] [BREAK] Break reminder script started (interval: ${BREAK_INTERVAL}s)"
echo "$message"
echo "$message" >> "$LOG_FILE"

while true; do
    # Wait for the specified interval
    sleep "$BREAK_INTERVAL"
    
    # Show the notification
    show_notification
done
