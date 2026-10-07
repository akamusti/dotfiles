# Musti'nin Hyprland dotfiles

Fedora + Hyprland + Catppuccin Mocha. KDE yaninda ikinci oturum olarak kurulu.

Kurulum: klasorleri `~/.config` altina kopyala (`hypr/`, `waybar/`, `kitty/`,
`swaync/`, `wofi/`). Tum path'ler `~` ile yazildi, kullanici adindan bagimsiz.

## Tuslar (SUPER = Win)

| Tus | Is |
|---|---|
| SUPER + Return / T, ALT + Return | Terminal (kitty) |
| SUPER + D / Space, ALT + Space | Uygulama baslatici (wofi) |
| SUPER + Q, ALT + Q | Pencereyi kapat |
| SUPER + F | Tam ekran |
| SUPER + V | Yuzer/gezer pencere |
| SUPER + yon tuslari | Odak degistir |
| SUPER + 1..5 | Workspace 1..5 |
| SUPER + SHIFT + 1..5 | Pencereyi workspace'e tasi |
| SUPER + L | Ekran kilidi |
| SUPER + X | Guc menusu |
| SUPER + SHIFT + V | Pano gecmisi (cliphist + wofi) |
| SUPER + SHIFT + M | Oturumu kapat |

### Ekran goruntusu

| Tus | Is |
|---|---|
| Print | Bolge sec, swappy ile duzenle |
| SHIFT + Print | Bolgeyi panoya kopyala |
| SUPER + Print | Pencereyi panoya kopyala |
| SUPER + SHIFT + Print | Tam ekrani `~/Pictures` altina kaydet |

### Laptop Fn tuslari (F1..F12)

Fn, isletim sistemine modifier olarak gorunmez; cekirdek onu `XF86*`
tusuna cevirir. Bu yuzden bind'ler `XF86*` uzerinden `hypr/fn-osd.sh`
yardimiyla OSD bildirimli calisir: ses, mikrofon, ekran/klavye parlakligi,
medya, Wi-Fi/ucak modu/bluetooth, touchpad, ekran cikisi, hesap makinesi,
kilit/uyku/hibernate, pil.

### Bas-konus (Discord PTT cozumu)

Wayland'da Discord, odak disindayken global tusu goremez. Cozum sistem
seviyesinde: **sol ALT basiliyken mikrofon acik, birakinca kapali**
(`bind` + `bindr`, `fn-osd.sh ptt-on/ptt-off`). Acilista mic kapali baslar.

- Discord'da **Girdi Modu = "Ses Etkinligi"** yap, Discord ici PTT atamasini kaldir.
- Tusu degistirmek icin `hyprland.conf`'taki PTT blogunda `ALT_L` yazan iki satiri degistir.
- Sag ALT (AltGr) TR klavyede karakter yazdigi icin atanmadi.

### Waybar pil

Sol tik guc profilini dondurur (balanced → performance → power-saver),
sag tik pil bilgisini gosterir.

## Notlar

- `hyprland.conf` (native) ve `hyprland.lua` (HyprMod) senkron tutulur.
- `fn-osd.sh` cagrilari `sh` ile yapilir, +x biti gerekmez.
- Duvar kagidi repo icindedir: `hypr/wallpaper.png` (2560x1440, Mocha).
