#!/bin/bash

# Module: Git Auto-Push
source "$HOME/.sharafat/lib/utils.sh"
load_settings

REPOS_CONFIG="$SHARAFAT_DIR/config/git_repos.txt"

if [ "$ENABLE_GIT_PUSH" != "true" ]; then
    log "GIT" "Git auto-push is disabled in settings.env"
    exit 0
fi

if ! check_internet; then
    log "GIT" "Skipping git auto-push: No internet connection"
    exit 0
fi

if [ ! -f "$REPOS_CONFIG" ]; then
    log "GIT" "ERROR: Configuration file $REPOS_CONFIG not found"
    exit 1
fi

log "GIT" "Starting git auto-push sequence"
current_time=$(date +"%T")

while IFS= read -r line || [ -n "$line" ]; do
    # Strip comments and whitespace
    repo_path=$(echo "$line" | sed 's/#.*//' | xargs)
    [ -z "$repo_path" ] && continue

    if [ ! -d "$repo_path" ]; then
        log "GIT" "WARNING: Directory not found: $repo_path"
        continue
    fi

    if [ ! -d "$repo_path/.git" ]; then
        log "GIT" "WARNING: Not a git repository: $repo_path"
        continue
    fi

    (
        cd "$repo_path" || exit
        git add .

        if git diff --cached --quiet; then
            log "GIT" "No changes to commit in: $repo_path"
        else
            git commit -am "Auto push at $current_time"
            if git pull --rebase; then
                if git push; then
                    log "GIT" "Successfully pushed: $repo_path"
                else
                    log "GIT" "ERROR: Failed to push: $repo_path"
                fi
            else
                log "GIT" "ERROR: Failed to pull --rebase: $repo_path"
            fi
        fi
    )
done < "$REPOS_CONFIG"

send_notification "Automation" "Git auto-push completed at $(date +"%T")"
log "GIT" "Git auto-push sequence completed"
