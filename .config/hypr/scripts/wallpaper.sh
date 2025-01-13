#!/bin/bash

sleep 1
while true; do
    n=$(($RANDOM % 10 + 1))
    if [ "$n" -eq 8 ]; then
        hyprctl hyprpaper preload "~/Pictures/$n.png"
        hyprctl hyprpaper wallpaper ", ~/Pictures/$n.png"
    else
        hyprctl hyprpaper preload "~/Pictures/$n.jpg"
        hyprctl hyprpaper wallpaper ", ~/Pictures/$n.jpg"
    fi
    sleep 1800
done
