################################################################################
# Shell Aliases and Functions
################################################################################

################################################################################
# Basic Command Aliases
################################################################################

alias ls='ls --color'
# alias ls='eza'
# alias vim='nvim'
alias c='clear'

################################################################################
# Android Development
################################################################################

alias droid-lists='~/Android/Sdk/emulator/emulator -list-avds'
alias droid-1='~/Android/Sdk/emulator/emulator @Medium_Phone_API_35'

################################################################################
# Development Tools
################################################################################

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
alias py="bpython"

################################################################################
# Font Management
################################################################################

# Temporarily disable custom fonts
alias fontrem="mv ~/.local/share/fonts ~/.local/share/.fonts"

# Re-enable custom fonts
alias fontadd="mv ~/.local/share/.fonts ~/.local/share/fonts"

################################################################################
# Git Workflows
################################################################################

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

################################################################################
# Package Managers
################################################################################

# Use podman instead of docker
alias docker="podman"

# Prefer pnpm over npm
alias npm="pnpm"
alias npx="pnpm dlx"

################################################################################
# Media Tools
################################################################################

# YouTube downloader
alias y="yt-dlp"

# YouTube audio-only downloader
alias ya="yt-dlp --extract-audio"

################################################################################
# Configuration Management (Chezmoi)
################################################################################

# Re-add changes and navigate to chezmoi directory
alias chezmoi-cd="chezmoi re-add && chezmoi cd"

# Commit and push chezmoi changes
alias chezmoi-up="gflow \"Auto push at \$(date +\"%T\")\" && exit"

################################################################################
# Custom Scripts
################################################################################

# Amate script
alias amate="python $HOME/amate.py"

# Gemini CLI
# alias gemini="npx https://github.com/google-gemini/gemini-cli"
