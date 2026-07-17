#!/usr/bin/env bash

# Terminate already running bar instances
killall waybar

# Wait until the processes have been shut down
while pgrep -u $UID -x waybar >/dev/null; do sleep 1; done

# Launch waybar
waybar -c ~/.config/waybar/config.jsonc &
# waybar -c "~/.config/waybar/config_m.jsonc" &
# waybar -c "~/.config/waybar/config_r.jsonc" &
