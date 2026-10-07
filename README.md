# Musti'nin Hyprland dotfiles

Fedora + Hyprland + Catppuccin Mocha. KDE yaninda ikinci oturum olarak kurulu.

Kurulum: asagidaki adimlari izle. Tum path'ler `~` ile yazildi,
kullanici adindan bagimsiz.

## Kurulum (Fedora, KDE yani)

Hyprland Fedora deposunda yok; resmi wiki Fedora icin
`lionheartp/Hyprland` COPR'unu onerir:

```bash
sudo dnf copr enable lionheartp/Hyprland
sudo dnf install hyprland hyprpaper hyprlock hypridle hyprshot xdg-desktop-portal-hyprland \
  waybar wofi swaync kitty \
  grim slurp swappy cliphist wl-clipboard \
  playerctl brightnessctl libnotify \
  network-manager-applet nm-connection-editor blueman bluez \
  pavucontrol htop upower \
  qt6-qtwayland \
  jetbrains-mono-fonts fontawesome-fonts \
  thunar
```

Opsiyonel (eksikse ilgili Fn tusu sadece bildirim gosterir):

```bash
sudo dnf install gnome-calculator guvcview thunderbird wdisplays
sudo systemctl enable --now bluetooth
```

Configleri yerlestir:

```bash
git clone https://github.com/akamusti/dotfiles ~/dotfiles
cp -r ~/dotfiles/hypr ~/dotfiles/waybar ~/dotfiles/kitty ~/dotfiles/swaync ~/dotfiles/wofi ~/.config/
mkdir -p ~/Pictures
chmod +x ~/.config/hypr/*.sh ~/.config/wofi/powermenu.sh
```

Oturumu kapat, giris ekraninda **Hyprland**'i sec, gir. Her sey
`exec-once` ile kendiliginden baslar.

Notlar:
- KDE spin `tuned` kullanir; `power-profiles-daemon` kurma (cakisir).
  Pil dugmesi tuned ile calisir.
- Polkit ajani KDE'den gelir. KDE'siz minimal kurulumda
  `hyprland.conf`'taki polkit satirini `hyprpolkitagent`'e cevir.
- NVIDIA kart icin RPM Fusion'dan `akmod-nvidia` gerekir.

## Kaldirma (vazgecersem)

1. Oturumu kapat, **Plasma (KDE)** ile gir.
2. Sadece Hyprland katmanini kaldir (font, bluetooth altyapisi,
   qt6-qtwayland gibi KDE'nin de kullandiklari durur):

```bash
sudo dnf remove hyprland hyprpaper hyprlock hypridle hyprshot xdg-desktop-portal-hyprland \
  waybar wofi swaync kitty \
  grim slurp swappy cliphist wl-clipboard \
  playerctl brightnessctl \
  network-manager-applet nm-connection-editor blueman \
  pavucontrol thunar wdisplays guvcview
sudo dnf copr disable lionheartp/Hyprland
```

3. Configleri yedekle (veya sil):

```bash
mkdir -p ~/.config-bak
mv ~/.config/hypr ~/.config/waybar ~/.config/kitty ~/.config/swaync ~/.config/wofi ~/.config-bak/
```

4. Guc profilini degistirdiysen geri al:

```bash
tuned-adm profile balanced
```

`~/Pictures` altindaki ekran goruntuleri silinmez, durur.

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

Sol tik guc profilini dondurur (power-profiles-daemon veya tuned uyumlu;
ikisi de yoksa pil bilgisi gosterir), sag tik pil bilgisini gosterir.
KDE spin tuned kullandigi icin power-profiles-daemon kurma (cakisir).

## Notlar

- `hyprland.conf` (native) ve `hyprland.lua` (HyprMod) senkron tutulur.
- `fn-osd.sh` cagrilari `sh` ile yapilir, +x biti gerekmez.
- Duvar kagidi repo icindedir: `hypr/wallpaper.png` (2560x1440, Mocha).
