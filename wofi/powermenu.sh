#!/bin/bash
secim=$(printf "Kilitle\nCikis\nUyku\nYeniden Baslat\nKapat" | wofi --dmenu --prompt "Guc")
case "$secim" in
  Kilitle) hyprlock ;;
  Cikis) hyprctl dispatch exit ;;
  Uyku) hyprlock & sleep 1; systemctl suspend ;;
  "Yeniden Baslat") systemctl reboot ;;
  Kapat) systemctl poweroff ;;
esac
