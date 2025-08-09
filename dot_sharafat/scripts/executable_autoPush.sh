#!/bin/bash

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
}

file_locations=("/home/sharafat/Documents/academic" "/home/sharafat/Desktop/code/problem-sloving" "/home/sharafat/Desktop/code/practice-contest" "/home/sharafat/Desktop/gits/logs" "/home/sharafat/Desktop/gits/notes" "/home/sharafat/Desktop/gits/stash-contents")

while true
do
    sleep 5m
    autoPush

    rclone sync /home/sharafat/Documents/Books drive-ug:DATA/Books
    rclone sync /home/sharafat/Desktop/personal drive-ug:DATA/personal
    rclone sync /home/sharafat/Desktop/canvas drive-ug:DATA/canvas
    rclone sync /home/sharafat/Desktop/people drive-ug:DATA/people
    rclone sync /home/sharafat/Desktop/org drive-ug:DATA/org

    # echo "Auto push script triggered!"
    notify-send "Automation" "Auto push script triggered!"

    sleep
    sleep 55m
done
