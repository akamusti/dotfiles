#!/bin/bash
# fn-osd.sh — Laptop Fn+F1..F12 (XF86) ortak aksiyonlar + OSD bildirimleri
# hyprland.conf ve hyprland.lua ikisi de bunu çağırır, tek yerden bakım.
# Bağımlılıklar: wpctl, brightnessctl, playerctl, notify-send, nmcli, rfkill (opsiyonel)

note() { notify-send -a OSD -r "$1" -t 1500 "${@:2}"; }

vol() { wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{print int($2*100)}'; }
mic_vol() { wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | awk '{print int($2*100)}'; }

kbd_dev() {
  # Klavye arka ışığı cihazını otomatik bul (thinkpad, asus, generic...)
  brightnessctl -l 2>/dev/null | grep -oiE "device: '[^']*kbd[^']*'" | head -1 | sed -E "s/.*'([^']+)'/\1/"
}

case "$1" in
  # ---- Ses (genelde Fn+F1/F2/F3) ----
  mute) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED \
      && note 9991 "Ses kapalı" \
      || note 9991 -h int:value:"$(vol)" "Ses" ;;
  up) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
    note 9991 -h int:value:"$(vol)" "Ses" ;;
  down) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    note 9991 -h int:value:"$(vol)" "Ses" ;;

  # ---- Mikrofon (genelde Fn+F4, XF86AudioMicMute) ----
  mic)
    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
    wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED \
      && note 9993 "Mikrofon kapalı" \
      || note 9993 -h int:value:"$(mic_vol)" "Mikrofon açık" ;;

  # ---- Ekran parlaklığı (genelde Fn+F5/F6) ----
  bri-up) brightnessctl set 5%+ >/dev/null
    note 9992 -h int:value:"$(brightnessctl -m 2>/dev/null | cut -d, -f4 | tr -d %)" "Parlaklık" ;;
  bri-down) brightnessctl set 5%- >/dev/null
    note 9992 -h int:value:"$(brightnessctl -m 2>/dev/null | cut -d, -f4 | tr -d %)" "Parlaklık" ;;

  # ---- Klavye ışığı (genelde Fn+F7/F8, XF86KbdBrightness*) ----
  kbd-up)
    D=$(kbd_dev)
    if [ -n "$D" ]; then brightnessctl -d "$D" set +1 >/dev/null 2>&1 || brightnessctl -d "$D" set 10%+ >/dev/null
      note 9994 "Klavye ışığı artırıldı"; else note 9994 "Klavye ışığı yok"; fi ;;
  kbd-down)
    D=$(kbd_dev)
    if [ -n "$D" ]; then brightnessctl -d "$D" set 1- >/dev/null 2>&1 || brightnessctl -d "$D" set 10%- >/dev/null
      note 9994 "Klavye ışığı azaltıldı"; else note 9994 "Klavye ışığı yok"; fi ;;
  kbd-toggle)
    D=$(kbd_dev)
    if [ -n "$D" ]; then
      CUR=$(brightnessctl -d "$D" get 2>/dev/null); MAX=$(brightnessctl -d "$D" max 2>/dev/null)
      if [ "${CUR:-0}" -gt 0 ]; then brightnessctl -d "$D" set 0 >/dev/null; note 9994 "Klavye ışığı kapalı"
      else brightnessctl -d "$D" set "$MAX" >/dev/null 2>&1 || brightnessctl -d "$D" set 100% >/dev/null; note 9994 "Klavye ışığı açık"; fi
    else note 9994 "Klavye ışığı yok"; fi ;;

  # ---- Medya (genelde Fn+F9/F10/F11/F12) ----
  play) playerctl play-pause 2>/dev/null; note 9995 "Oynat / Duraklat" ;;
  next) playerctl next 2>/dev/null; note 9995 "Sonraki parça" ;;
  prev) playerctl previous 2>/dev/null; note 9995 "Önceki parça" ;;
  stop) playerctl stop 2>/dev/null; note 9995 "Durduruldu" ;;

  # ---- Kablosuz / Uçak modu (genelde Fn+F8, XF86WLAN / XF86RFKill) ----
  wifi)
    if command -v nmcli >/dev/null; then
      nmcli radio wifi toggle
      S=$(nmcli radio wifi 2>/dev/null); note 9996 "Wi-Fi: $S"
    else note 9996 "nmcli yok"; fi ;;
  airplane)
    if command -v rfkill >/dev/null; then
      BLOCKED=$(rfkill list wifi 2>/dev/null | grep -qi "soft blocked: yes" && echo yes || echo no)
      if [ "$BLOCKED" = "yes" ]; then rfkill unblock all; note 9996 "Uçak modu kapalı"
      else rfkill block all; note 9996 "Uçak modu açık"; fi
    elif command -v nmcli >/dev/null; then nmcli radio all toggle; note 9996 "Tüm radyolar değişti"
    else note 9996 "rfkill/nmcli yok"; fi ;;
  bluetooth)
    if bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then bluetoothctl power off >/dev/null 2>&1; note 9996 "Bluetooth kapalı"
    else bluetoothctl power on >/dev/null 2>&1; note 9996 "Bluetooth açık"; fi ;;

  # ---- Touchpad (genelde Fn+F9, XF86TouchpadToggle) ----
  touchpad)
    # Hyprland: input:touchpad:enabled durumunu çevir
    CUR=$(hyprctl getoption input:touchpad:enabled 2>/dev/null | awk '/^int:/ {print $2}')
    if [ "$CUR" = "1" ]; then hyprctl keyword input:touchpad:enabled false >/dev/null; note 9997 "Touchpad kapalı"
    else hyprctl keyword input:touchpad:enabled true >/dev/null; note 9997 "Touchpad açık"; fi ;;

  # ---- Ekran çıkışı / projeksiyon (genelde Fn+F7, XF86Display) ----
  display)
    if command -v wdisplays >/dev/null; then wdisplays &
    elif command -v nwg-displays >/dev/null; then nwg-displays &
    elif command -v arandr >/dev/null; then arandr &
    else note 9997 "Ekran aracı yok (wdisplays kur)"; fi ;;

  # ---- Webcam (XF86WebCam) ----
  webcam) if command -v guvcview >/dev/null; then guvcview & else note 9997 "Webcam tuşu (guvcview yok)"; fi ;;

  # ---- Hesap makinesi (XF86Calculator) ----
  calc)
    if command -v gnome-calculator >/dev/null; then gnome-calculator &
    elif command -v qalculate-gtk >/dev/null; then qalculate-gtk &
    elif command -v kcalc >/dev/null; then kcalc &
    else note 9997 "Hesap makinesi yok"; fi ;;

  # ---- Dosya yöneticisi / tarayıcı / mail / arama ----
  explorer)
    if command -v dolphin >/dev/null; then dolphin &
    elif command -v nautilus >/dev/null; then nautilus --new-window &
    elif command -v thunar >/dev/null; then thunar &
    else note 9997 "Dosya yöneticisi yok"; fi ;;
  browser) xdg-open https://www.google.com >/dev/null 2>&1 & ;;
  mail) if command -v thunderbird >/dev/null; then thunderbird & else xdg-open "mailto:" >/dev/null 2>&1 & fi ;;
  search) pkill wofi 2>/dev/null || wofi --show drun & ;;

  # ---- Bas-konus PTT (sessiz, bildirimsiz: basili tutarken cagrilir) ----
  ptt-on) wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0 ;;
  ptt-off) wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1 ;;

  # ---- Kilit / uyku / guc ----
  lock) hyprlock & ;;
  sleep) hyprlock & sleep 1; systemctl suspend ;;
  hibernate) hyprlock & sleep 1; systemctl hibernate ;;
  power) pkill wofi 2>/dev/null || ~/.config/wofi/powermenu.sh & ;;

  # ---- Pil durumu (XF86Battery) ----
  battery)
    if [ -r /sys/class/power_supply/BAT0/capacity ]; then
      C=$(cat /sys/class/power_supply/BAT0/capacity); S=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)
      note 9998 -h int:value:"$C" "Pil: %$C ($S)"
    elif command -v upower >/dev/null; then
      upower -i "$(upower -e | grep -i bat | head -1)" 2>/dev/null | grep -E "percentage|state" | head -2 | xargs; note 9998 "Pil bilgisi"
    else note 9998 "Pil bilgisi yok"; fi ;;

  *) echo "kullanim: $0 {mute|up|down|mic|ptt-on|ptt-off|bri-up|bri-down|kbd-up|kbd-down|kbd-toggle|play|next|prev|stop|wifi|airplane|bluetooth|touchpad|display|webcam|calc|explorer|browser|mail|search|lock|sleep|hibernate|power|battery}" ;;
esac
