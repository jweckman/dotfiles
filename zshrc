export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="takashiyoshida"
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
# USERCONFIG

. $HOME/.asdf/asdf.sh

# General
set -o vi
bindkey '   ' autosuggest-accept
bindkey '^ ' autosuggest-execute
export PATH="$HOME/.poetry/bin:$PATH"
# Speeds up key repeats using xset tool, needs to be installed separately
xset r rate 200 30
#bindkey -m vi-insert "\C-l":clear-screen

# PATH variables
path+=$HOME/.local/bin/
path+=/$HOME/scriptconf/
export EDITOR='nvim'
export VISUAL='nvim'

# Aliases
alias weather='python /rpi2tb/joakim/coding_projects/python/fishing_data/weather/ilmatieteen_laitos.py'
alias mpgn='mv ~/Downloads/*.pgn /rpi2tb/joakim/chess/db/joakim/'
alias lynx='lynx --vikeys'
alias clean_filenames='python $HOME/scripts/clean_filenames.py'
alias c='xclip -selection clipboard'
alias v='xclip -o'
alias vim="nvim"
alias vi="nvim"
alias oldvim="vim"
alias scripts="whence -pm '*' | grep scripts"
alias ls="ls --color=auto"
alias tree="tree -I '*.pyc'"
function open () {
    xdg-open "$*" &
}

# ASDF MANAGER
# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit
