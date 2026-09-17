#!/bin/bash
vol() { wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk "{print int($2*100)}"; }
case "$1" in
  mute) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED \
      && notify-send -a OSD -r 9991 -t 1500 "Ses kapali" \
      || notify-send -a OSD -r 9991 -t 1500 -h int:value:$(vol) "Ses" ;;
  up) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
    notify-send -a OSD -r 9991 -t 1500 -h int:value:$(vol) "Ses" ;;
  down) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    notify-send -a OSD -r 9991 -t 1500 -h int:value:$(vol) "Ses" ;;
esac
