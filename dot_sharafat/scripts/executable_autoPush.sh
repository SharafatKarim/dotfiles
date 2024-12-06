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
        git pull --rebase
        git push
    done

    # echo "Auto push done at $currentTime"
    notify-send "Automation" "Auto push done at $currentTime"
}

file_locations=("/home/sharafat/Documents/academic" "/home/sharafat/Desktop/code/problem-sloving" "/home/sharafat/Desktop/code/practice-contest" "/home/sharafat/Desktop/gits/logs" "/home/sharafat/Desktop/gits/notes" "/home/sharafat/Desktop/gits/stash-contents")

while true
do
    sleep 5m
    autoPush
    sleep
    sleep 55m
done
