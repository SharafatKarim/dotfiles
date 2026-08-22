#!/bin/bash

# Seed Script: Clone GitHub Repositories
# Clones missing repositories defined in config/git_repos.txt

source "$HOME/.sharafat/lib/utils.sh"
load_settings

REPOS_CONFIG="$SHARAFAT_DIR/config/git_repos.txt"
GH_USER="${GITHUB_USERNAME:-SharafatKarim}"

if [ ! -f "$REPOS_CONFIG" ]; then
    log "SEED" "ERROR: Repository configuration $REPOS_CONFIG not found."
    exit 1
fi

log "SEED" "Checking and cloning missing repositories for user: $GH_USER"

while IFS= read -r line || [ -n "$line" ]; do
    # Strip comments and whitespace
    target_path=$(echo "$line" | sed 's/#.*//' | xargs)
    [ -z "$target_path" ] && continue

    # Extract repository name from end of path
    repo_name=$(basename "$target_path")
    parent_dir=$(dirname "$target_path")

    # Construct GitHub URL
    clone_url="https://github.com/${GH_USER}/${repo_name}.git"

    if [ -d "$target_path/.git" ]; then
        log "SEED" "EXISTS: $target_path is already cloned."
    else
        log "SEED" "CLONING: $clone_url -> $target_path"
        mkdir -p "$parent_dir"
        if git clone "$clone_url" "$target_path"; then
            log "SEED" "SUCCESS: Cloned $repo_name to $target_path"
        else
            log "SEED" "ERROR: Failed to clone $clone_url"
        fi
    fi

done < "$REPOS_CONFIG"

log "SEED" "Seeding process completed."
