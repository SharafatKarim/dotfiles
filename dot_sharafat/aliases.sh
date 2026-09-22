alias c='clear'
if command -v eza &>/dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -lh --icons --git --header --color-scale'
    alias la='eza -lah --icons --git --header --color-scale'
    alias lt='eza --tree --icons --level=2'
    alias lf='eza -l'
fi
command -v bat    &>/dev/null && alias cat='bat'
command -v rg     &>/dev/null && alias grep='rg'
command -v fd     &>/dev/null && alias find='fd'
command -v ncdu   &>/dev/null && alias du='ncdu'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias dol='dolphin --new-window . 1>/dev/null 2>/dev/null & disown'
alias x='xdg-open'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias zshrc='${EDITOR:-nano} ~/.zshrc'
alias zprofile='${EDITOR:-nano} ~/.zprofile'

alias myip='curl -s https://ifconfig.me'
alias ports='netstat -tulanp'

alias droid-lists='~/Android/Sdk/emulator/emulator -list-avds'
alias droid-1='~/Android/Sdk/emulator/emulator @Medium_Phone_API_35'

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

alias python="uv run"
alias python3="uv run"
alias pip="uv pip"
alias pip3="uv pip"

function mdpdf() {
    if ! command -v md2typst &> /dev/null; then
        echo "md2typst not found. Installing via uv..."
        uv tool install md2typst || {
            echo "Error: Failed to install md2typst. Make sure 'uv' is installed."
            return 1
        }
    fi

    if [ -z "$1" ]; then
        echo "Usage: build_typst <filename.md>"
        return 1
    fi

    local md_file="$1"
    local base_name="${md_file%.md}"
    local typ_file="${base_name}.typ"

    md2typst "$md_file" && \
    typst compile "$typ_file" && \
    rm "$typ_file" && \
    echo "Compiled ${base_name}.pdf successfully!"
}

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

command -v bpython &>/dev/null && alias py='bpython'

alias gp="git pull --rebase && git push"
function gflow {
    git add .
    git commit -am "$1"
    git pull --rebase
    git push
}

alias docker="podman"
alias npm="pnpm"
alias npx="pnpm dlx"

alias y="yt-dlp"
alias ya="yt-dlp --extract-audio"

alias chezmoi-cd="chezmoi re-add && chezmoi cd"
alias chezmoi-up="gflow \"Auto push at \$(date +\"%T\")\" && exit"

alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"

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

alias amate="python $HOME/amate.py"
alias pkg-backup="[ -f ~/.sharafat/lib/utils.sh ] && source ~/.sharafat/lib/utils.sh && backup_pacman_pkgs"

alias seed-repos="bash ~/.sharafat/seed/clone_repos.sh"
alias seed-drive="bash ~/.sharafat/seed/restore_drive.sh"

alias mount-gdrive-ug="mkdir -p ~/mnt/drive-ug && rclone mount drive-ug: ~/mnt/drive-ug --daemon --vfs-cache-mode writes"
alias umount-gdrive-ug="fusermount -u ~/mnt/drive-ug"
alias mount-gdrive-sharafat="mkdir -p ~/mnt/drive-sharafat && rclone mount drive-sharafat: ~/mnt/drive-sharafat --daemon --vfs-cache-mode writes"
alias umount-gdrive-sharafat="fusermount -u ~/mnt/drive-sharafat"
alias mount-mega-sharafat="mkdir -p ~/mnt/mega-sharafat && rclone mount mega-sharafat: ~/mnt/mega-sharafat --daemon --vfs-cache-mode writes"
alias umount-mega-sharafat="fusermount -u ~/mnt/mega-sharafat"
