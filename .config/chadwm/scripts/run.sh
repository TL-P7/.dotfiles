#!/bin/sh

xrdb merge ~/.Xresources 
xbacklight -set 10 &
# feh --bg-fill ~/Pictures/wall/gruv.png &
# feh --bg-fill ~/.config/variety/Favorites/1694272661061.jpg
# feh --bg-fill .config/variety/Favorites/5.jpg
blueman-applet &
bash ~/.config/chadwm/scripts/wallpaper.sh &
picom &
fcitx5 &
setxkbmap -option caps:swapescape &
# xset r rate 220 50 &
xset r rate 250 30 &
xset b off &
cp -r ~/.config/chadwm/eww ~/.config/ &
#eww open eww &

dash ~/.config/chadwm/scripts/bar.sh &
while type chadwm >/dev/null; do chadwm && continue || break; done

