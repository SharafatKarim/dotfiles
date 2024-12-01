#!/bin/bash

# Function to display the break reminder notification
function show_notification() {
    notify-send "Take a Break" "It's time for a 20-minute break!"
}

# Main loop to remind every 20 minutes
while true; do
    # Wait for 20 minutes (1200 seconds)
    sleep 1200
    # Show the notification
    show_notification
done
