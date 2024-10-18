#!/bin/sh

xrandr --output eDP-1 --mode "1920x1080" --rate 60.01

~/.config/chadwm/chadwm/slstatus/./slstatus &

feh --randomize --bg-fill ~/Wallpapers/*

picom &

dunst &

flameshot &

dash ~/.config/chadwm/scripts/bar.sh &

while type chadwm >/dev/null; do chadwm && continue || break; done
