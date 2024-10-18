#!/bin/bash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.config/chadwm/scripts/bar_themes/dracula

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  printf "^c$black^ ^b$green^ CPU"
  printf "^c$white^ ^b$grey^ $cpu_val"
}

pkg_updates() {
  #updates=$({ timeout 20 doas xbps-install -un 2>/dev/null || true; } | wc -l) # void
  updates=$({ timeout 20 checkupdates 2>/dev/null || true; } | wc -l) # arch
  # updates=$({ timeout 20 aptitude search '~U' 2>/dev/null || true; } | wc -l)  # apt (ubuntu, debian etc)

  if [ -z "$updates" ]; then
    printf "  ^c$green^    Fully Updated"
  else
    printf "  ^c$green^    $updates"" updates"
  fi
}

battery() {
  get_capacity="$(cat /sys/class/power_supply/BAT0/capacity)"
  printf "^c$blue^   $get_capacity"
}

brightness() {
  # Get the current brightness percentage
  current_brightness=$(brightnessctl g)
  max_brightness=$(brightnessctl m)
  brightness_percent=$((current_brightness * 100 / max_brightness))
  printf "^c$red^   "
  printf "^c$red^%d%%\n" "$brightness_percent"
}

mem() {
  printf "^c$blue^^b$black^  "
  printf "^c$blue^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$black^ ^b$blue^ 󰤨 ^d^%s" " ^c$blue^Connected" ;;
	down) printf "^c$black^ ^b$blue^ 󰤭 ^d^%s" " ^c$blue^Disconnected" ;;
	esac
}

clock() {
	printf "^c$black^ ^b$darkblue^ 󱑆 "
	printf "^c$black^^b$blue^ $(date '+%H:%M')  "
}

update_interval=1
pkg_check_interval=3600 # Check for updates every hour

update_interval=1
pkg_check_interval=3600 # Check for updates every hour

updates=$(pkg_updates)  # Initial check for updates
last_update_time=$SECONDS

while true; do
  # Get the current time
  current_time=$SECONDS

  # Update all values except package updates every iteration
  bat=$(battery)
  bright=$(brightness)
  cpu_info=$(cpu)
  mem_info=$(mem)
  wifi=$(wlan)
  time=$(clock)

  # Update package information if enough time has passed
  if ((current_time - last_update_time >= pkg_check_interval)); then
    updates=$(pkg_updates)
    last_update_time=$current_time
  fi

  # Update the status bar
  xsetroot -name "$updates $bat $bright $cpu_info $mem_info $wifi $time"
  
  # Calculate how long to sleep
  end_time=$SECONDS
  sleep_time=$((update_interval - (end_time - current_time)))
  
  # Only sleep if there's time left
  if ((sleep_time > 0)); then
    sleep $sleep_time
  fi
done