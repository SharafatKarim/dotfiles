# Shell Aliases and Functions

# Basic Command Aliases
alias c='clear'
if command -v eza &>/dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -lh --icons --git --header --color-scale'
    alias la='eza -lah --icons --git --header --color-scale'
    alias lt='eza --tree --icons --level=2'
    alias lf='eza -l'
fi
command -v bat    &>/dev/null && alias cat='bat'
command -v delta  &>/dev/null && alias diff='delta'
command -v rg     &>/dev/null && alias grep='rg'
command -v fd     &>/dev/null && alias find='fd'
command -v ncdu   &>/dev/null && alias du='ncdu'
# command -v nvim  &>/dev/null && alias vim='nvim'

# Navigation shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Safety first
alias rm='rm -i'        # Always ask before deleting
alias cp='cp -i'        # Always ask before overwriting
alias mv='mv -i'        # Always ask before overwriting

# Quick edits
alias zshrc='${EDITOR:-nano} ~/.zshrc'
alias zprofile='${EDITOR:-nano} ~/.zprofile'

# Network & System
alias myip='curl -s https://ifconfig.me'
alias ports='netstat -tulanp'

# Android Development
alias droid-lists='~/Android/Sdk/emulator/emulator -list-avds'
alias droid-1='~/Android/Sdk/emulator/emulator @Medium_Phone_API_35'

# Development Tools
# C/C++ Code Runner
# Usage: cl <filename.c>
# Compiles and runs C/C++ code, then cleans up the executable
function cl() {
  echo -e "Compiling ${1%.*}..."
  time g++ -o "${1%.*}" "$1"

  if [ -f "${1%.*}" ]; then
    echo -e "----------------- \n"
    chmod +x "${1%.*}"
    ./"${1%.*}"
    rm "${1%.*}"
  else
    echo -e "----------------- \n"
    echo -e "Compiler didn't create an executable file!\n"
  fi
}

# Assembly Code Runner
# Usage: asm <filename.asm>
# Assembles and runs x86 assembly code, then cleans up
function asm() {
  echo -e "Assembling ${1%.*}..."
  time nasm -f elf "$1"

  if [ -f "${1%.*}.o" ]; then
    echo -e "----------------- \n"
    ld -m elf_i386 -s -o "${1%.*}" "${1%.*}.o"
    chmod +x "${1%.*}"
    ./"${1%.*}"
    rm "${1%.*}.o" "${1%.*}"
  else
    echo -e "----------------- \n"
    echo -e "Assembly failed!\n"
  fi
}

# Python REPL
command -v bpython &>/dev/null && alias py='bpython'

# Font Management
# Temporarily disable custom fonts
alias fontrem="mv ~/.local/share/fonts ~/.local/share/.fonts"
# Re-enable custom fonts
alias fontadd="mv ~/.local/share/.fonts ~/.local/share/fonts"

# ---
# Git Workflows
# Quick git pull and push
alias gp="git pull --rebase && git push"
# Git flow with commit message
# Usage: gflow "commit message"
function gflow {
    git add .
    git commit -am "$1"
    git pull --rebase
    git push
}
# ---

# Package Managers
# Use podman instead of docker
alias docker="podman"
# Prefer pnpm over npm
alias npm="pnpm"
alias npx="pnpm dlx"

# Media Tools
# YouTube downloader
alias y="yt-dlp"
# YouTube audio-only downloader
alias ya="yt-dlp --extract-audio"

# Configuration Management (Chezmoi)
# Re-add changes and navigate to chezmoi directory
alias chezmoi-cd="chezmoi re-add && chezmoi cd"
# Commit and push chezmoi changes
alias chezmoi-up="gflow \"Auto push at \$(date +\"%T\")\" && exit"

# Containers
alias win-up="podman-compose --file /home/sharafat/.sharafat/containers/windows.yaml up -d"

podlatex() {
    podman run --rm -it \
      --userns=keep-id \
      -v "$(pwd):/project:Z" \
      -w /project \
      leplusorg/latex \
      latexmk -pdf "$1"
}

alias podlatex-clean='podman run --rm --userns=keep-id -v "$(pwd):/project:Z" -w /project leplusorg/latex latexmk -c'

# Custom Scripts
# Amate script
alias amate="python $HOME/amate.py"

