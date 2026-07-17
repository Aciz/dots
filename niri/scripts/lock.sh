#!/bin/bash

# If idle for 300s, power down the output
swayidle -w \
  timeout 300 'niri msg action power-off-monitors' \
  resume 'niri msg action power-on-monitors' &

# Lock screen immediately
swaylock --screenshots \
  --clock \
  --effect-blur 48x4 \
  --fade-in 0.2 \
  --font 'SF Pro Display SemiBold'

# Kill the last instance of swayidle so the timer doesn't keep running in background
pkill --newest swayidle
