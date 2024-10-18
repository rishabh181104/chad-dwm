#!/bin/bash

xrandr --output eDP-1 --mode "1920x1080" --rate 60.01

feh --randomize --bg-fill ~/Wallpapers/*

picom &

dunst &

flameshot &

bash ~/.config/chadwm/scripts/bar.sh &

while type chadwm >/dev/null; do chadwm && continue || break; done
