#!/bin/sh

swayidle -w \
  timeout 300 'swaylock -f' \
  timeout 600 'mmsg dispatch disable_monitor,DP-1' \
  resume 'mmsg dispatch enable_monitor,DP-1' \
  before-sleep 'swaylock -f'
