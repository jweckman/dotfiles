# Shell script for swapping Esc and Caps Lock on X
# Needs to run every boot to take effect

# This part should work
xmodmap -e "remove Lock = Caps_Lock"
xmodmap -e "keycode 9 = Caps_Lock NoSymbol Caps_Lock"
xmodmap -e "keycode 66 = Escape NoSymbol Escape"
xmodmap -pke > ~/.xmodmap

# In case it does not, replace accordingly:
# xmodmap -e "remove Lock = Caps_Lock"
# --> xmodmap -e "clear Lock" 
