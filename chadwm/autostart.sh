#!/bin/bash

xrandr --output eDP-1 --mode "1920x1080" --rate 60.01

~/.config/chadwm/chadwm/slstatus/./slstatus &

feh --randomize --bg-fill ~/Wallpapers/*

picom &

dunst &

flameshot &
