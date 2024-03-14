#!/bin/bash

# Function to display the break reminder notification
function autoPush() {
    currentTime=$(date +"%T")
    echo "Auto push at $currentTime"

    for file_location in "${file_locations[@]}"
    do
        cd $file_location
        git add .
        git commit -am "Auto push at $currentTime"
        git push
    done

    echo "Auto push done at $currentTime"
    notify-send "Automation" "Auto push done at $currentTime"
}

file_locations=("/home/sharafat/Desktop/academic" "/home/sharafat/Desktop/code/problem-sloving" "/home/sharafat/Desktop/code/contest")

# Wait for 300 seconds (5 minutes)
sleep 300
# auto push
autoPush
