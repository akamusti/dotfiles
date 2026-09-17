#!/bin/bash
case "$1" in
  up) brightnessctl set 5%+ ;;
  down) brightnessctl set 5%- ;;
esac
notify-send -a OSD -r 9992 -t 1500 -h int:value:$(brightnessctl -m | cut -d, -f4 | tr -d %) "Parlaklik"
