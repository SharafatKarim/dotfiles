# Aliases
alias ls='ls --color'
# alias ls='eza'
# alias vim='nvim'
alias c='clear'

# Android
alias droid-lists='~/Android/Sdk/emulator/emulator -list-avds'
alias droid-1='~/Android/Sdk/emulator/emulator @Medium_Phone_API_35'

# c code runner
function cl() {
  echo -e "compiling ${1%.*}"
  #   time gcc -lstdc++ -lm -o ${1%.*} $1
  time g++ -o ${1%.*} $1

  if [ -f ${1%.*} ]; then
    echo -e "----------------- \n"
    chmod +x ${1%.*}
    ./${1%.*}
    rm ${1%.*}
  else
    echo -e "----------------- \n"
    echo -e "compiler didn't create an executable file!\n"
  fi
}

# Font management
alias fontrem="mv ~/.local/share/fonts ~/.local/share/.fonts"
alias fontadd="mv ~/.local/share/.fonts ~/.local/share/fonts"

# Personalized ones
alias gp="git pull --rebase && git push"
function gflow {
    git add .
    git commit -am "$1"
    git pull --rebase
    git push
}

alias docker="podman"
alias y="yt-dlp"
alias ya="yt-dlp --extract-audio"
alias py="bpython"

# scripts
alias amate="python $HOME/amate.py"
alias chezmoi-up="chezmoi re-add && chezmoi cd && gflow "Auto push at $(date +"%T")" && exit"

# Gemini CLI
alias gemini="npx https://github.com/google-gemini/gemini-cli"
