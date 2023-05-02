#!/bin/zsh
export ZDOTDIR=$HOME/.config/zsh
# XDG Paths
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
if [ $XDG_SESSION_TYPE = "x11" ]; then
  for f in /etc/X11/xinit/xinitrc.d/*.sh; do
    source "$f"
  done
fi
