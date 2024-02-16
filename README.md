# jweckman dotfiles & scripts

# Usage
Rename any existing folders e.g. ~/.config/nushell --> ~/.config/nushellbak
1. Install GNU Stow
2. clone this repo to your home directory
3. run `stow .` inside the dotfiles directory

This will symlink all the folders that are relevant on a linux system to the parent folder by structure.

When pulling new commit of the repo you only need to run `stow .` inside dotfiles folder to update everything at once.
