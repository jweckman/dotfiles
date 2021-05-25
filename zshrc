export ZSH="/home/jweckman/.oh-my-zsh"
ZSH_THEME="random"
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-nvm
)

source $ZSH/oh-my-zsh.sh
# USERCONFIG

# General
set -o vi
bindkey '   ' autosuggest-accept
bindkey '^ ' autosuggest-execute
#bindkey -m vi-insert "\C-l":clear-screen

# PATH variables
path+=/home/jweckman/.local/bin/
path+=/home/jweckman/scripts/
export EDITOR='nvim'
export VISUAL='nvim'

# Aliases
alias weather='python /rpi2tb/joakim/coding_projects/python/fishing_data/weather/ilmatieteen_laitos.py'
alias mpgn='mv ~/Downloads/*.pgn /rpi2tb/joakim/chess/db/joakim/'
alias lynx='lynx --vikeys'
alias clean_filenames='python /home/jweckman/scripts/clean_filenames.py'
alias c='xclip -selection clipboard'
alias v='xclip -o'
alias vim="$HOME/appimage/nvim"
alias vi="nvim"
alias oldvim="vim"
alias scripts="whence -pm '*' | grep scripts"
alias ls="ls --color=auto"
alias tree="tree -I '*.pyc'"
function open () {
    xdg-open "$*" &
}


# nvim
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

