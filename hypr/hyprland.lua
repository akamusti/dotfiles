local var_mainMod = "SUPER"

hl.config({
    cursor = {
        no_hardware_cursors = true,
    },
    input = {
        kb_layout = "tr,us",
        kb_options = "grp:alt_shift_toggle",
        follow_mouse = 1,
    },
    general = {
        gaps_in = 6,
        gaps_out = 14,
        border_size = 2,
        col = {
            active_border = {
                colors = {"rgba(cba6f7ff)", "rgba(89b4faff)"},
                angle = 45,
            },
            inactive_border = "rgb(313244)",
        },
        layout = "dwindle",
    },
    decoration = {
        rounding = 12,
        active_opacity = 1.0,
        inactive_opacity = 0.93,
    },
    misc = {
    mouse_move_enables_dpms = true,
    key_press_enables_dpms = true,
        background_color = "rgb(1e1e2e)",
  disable_hyprland_logo = true,
    },
    animations = {
        enabled = true,
    },
})

hl.monitor({
    output = "",
    disabled = false,
    mode = "preferred",
    position = "auto",
    scale = 1,
})
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 6,
    bezier = "myBezier",
})
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 6,
    bezier = "myBezier",
})
hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 5,
    bezier = "default",
})
hl.animation({
    leaf = "border",
    enabled = true,
    speed = 8,
    bezier = "default",
})
hl.bind(var_mainMod .. " + Return", hl.dsp.exec_cmd("kitty"))
hl.bind(var_mainMod .. " + T", hl.dsp.exec_cmd("kitty"))
hl.bind("ALT + Return", hl.dsp.exec_cmd("kitty"))
hl.bind(var_mainMod .. " + D", hl.dsp.exec_cmd("pkill wofi || wofi --show drun"))
hl.bind(var_mainMod .. " + Space", hl.dsp.exec_cmd("pkill wofi || wofi --show drun"))
hl.bind(var_mainMod .. " + Q", hl.dsp.window.close())
hl.bind(var_mainMod .. " + SHIFT + M", hl.dsp.exit())
hl.bind(var_mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(var_mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(var_mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(var_mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(var_mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(var_mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(var_mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(var_mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(var_mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(var_mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(var_mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(var_mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(var_mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(var_mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(var_mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(var_mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")
    hl.exec_cmd("/usr/libexec/polkit-kde-authentication-agent-1")
    hl.exec_cmd("nm-applet --indicator &")
    hl.exec_cmd("wl-paste --watch cliphist store &")
end)

-- bind = , Print, exec, grim -g "$(slurp)" ~/Pictures/screenshot-$(date +%F-%H%M%S).png
hl.bind(var_mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))

hl.on("hyprland.start", function()
    hl.exec_cmd("hypridle")
    hl.exec_cmd("blueman-applet &")
end)

hl.bind(var_mainMod .. " + Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" ~/Pictures/screenshot-$(date +%F-%H%M%S).png"))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region --raw | swappy -f -"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m region --clipboard"))
hl.bind(var_mainMod .. " + Print", hl.dsp.exec_cmd("hyprshot -m window --clipboard"))

-- HyprMod managed settings
require("hyprland-gui")

-- ses/parlaklik OSD + medya + eksik tuslar (tek kopya)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("/home/insanmusti/.config/hypr/vol-osd.sh mute"), {
    locked = true,
})
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("/home/insanmusti/.config/hypr/vol-osd.sh down"), {
    locked = true,
})
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("/home/insanmusti/.config/hypr/vol-osd.sh up"), {
    locked = true,
})
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("/home/insanmusti/.config/hypr/bri-osd.sh down"), {
    locked = true,
})
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("/home/insanmusti/.config/hypr/bri-osd.sh up"), {
    locked = true,
})
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), {
    locked = true,
})
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), {
    locked = true,
})
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), {
    locked = true,
})
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), {
    locked = true,
})
hl.bind("ALT + Q", hl.dsp.window.close())
hl.bind("ALT + Space", hl.dsp.exec_cmd("pkill wofi || wofi --show drun"))
hl.bind(var_mainMod .. " + " .. "X", hl.dsp.exec_cmd("pkill wofi || /home/insanmusti/.config/wofi/powermenu.sh"))
