#!/bin/bash

################################################################################
# Auto Push Script
################################################################################
# This script commits and pushes changes to multiple git repositories.
# Called by the master automation script (sharafat.sh).
################################################################################

################################################################################
# Configuration
################################################################################

# Git repositories to auto-push
declare -a GIT_REPOS=(
    "/home/sharafat/Documents/academic"
    "/home/sharafat/Desktop/code/problem-sloving"
    "/home/sharafat/Desktop/code/practice-contest"
    "/home/sharafat/Desktop/gits/logs"
    "/home/sharafat/Desktop/gits/notes"
    "/home/sharafat/Desktop/gits/stash-contents"
)

LOG_FILE="$HOME/.sharafat/automation.log"

################################################################################
# Functions
################################################################################

# Log function with timestamp
log() {
    local message="[$(date +"%Y-%m-%d %T")] [GIT] $1"
    echo "$message"
    echo "$message" >> "$LOG_FILE"
}

# Auto-push git repositories
auto_push_repos() {
    local current_time=$(date +"%T")
    log "Starting auto-push for ${#GIT_REPOS[@]} repositories"

    for repo_path in "${GIT_REPOS[@]}"; do
        if [ ! -d "$repo_path" ]; then
            log "WARNING: Repository not found: $repo_path"
            continue
        fi

        log "Processing: $repo_path"
        cd "$repo_path" || continue

        # Check if it's a git repository
        if [ ! -d ".git" ]; then
            log "WARNING: Not a git repository: $repo_path"
            continue
        fi

        # Stage all changes
        git add .

        # Commit with timestamp (only if there are changes)
        if git diff --cached --quiet; then
            log "No changes to commit in: $repo_path"
        else
            git commit -am "Auto push at $current_time"
            
            # Pull with rebase
            if git pull --rebase; then
                # Push changes
                if git push; then
                    log "Successfully pushed: $repo_path"
                else
                    log "ERROR: Failed to push: $repo_path"
                fi
            else
                log "ERROR: Failed to pull: $repo_path"
            fi
        fi
    done
}

# Send notification
send_notification() {
    notify-send "Automation" "Git auto-push completed at $(date +"%T")"
}

################################################################################
# Main Execution
################################################################################

log "Auto push script started"

# Execute auto-push once
auto_push_repos

# Send notification
send_notification

log "Auto push script completed"

