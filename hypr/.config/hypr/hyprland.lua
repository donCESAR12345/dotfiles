-- Hyprland 0.57+ Lua Configuration (Shared via GNU Stow)
-- Aligned with daily KDE Plasma muscle memory + DankMaterialShell (DMS)
-- https://wiki.hypr.land/configuring/

local is_headless = os.getenv("HYPR_REMOTE_HEADLESS") == "1"
local headless_res = os.getenv("HYPR_REMOTE_RES") or "1920x1080@60"

-- ==================
-- MONITOR CONFIG
-- ==================
if is_headless then
    hl.monitor({
        output   = "",
        mode     = headless_res,
        position = "0x0",
        scale    = 1,
    })
else
    hl.monitor({
        output   = "",
        mode     = "preferred",
        position = "auto",
        scale    = "auto",
    })
end

-- ==================
-- ENVIRONMENT
-- ==================
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- ==================
-- STARTUP APPS
-- ==================
if not is_headless then
    hl.on("hyprland.start", function()
        hl.exec_cmd("dbus-update-activation-environment --systemd --all")
        hl.exec_cmd("systemctl --user start hyprland-session.target")
        hl.exec_cmd("systemctl --user start hyprpolkitagent.service")
    end)
end

-- ==================
-- INPUT (Mirrors KDE kxkbrc: latam + us-intl)
-- ==================
hl.config({
    input = {
        kb_layout          = "latam,us",
        kb_variant         = ",intl",
        numlock_by_default = true,
        follow_mouse       = 1,
        sensitivity        = 0,
        touchpad = {
            natural_scroll = false,
        },
    },

    general = {
        gaps_in     = 4,
        gaps_out    = 4,
        border_size = 2,
        layout      = "dwindle",
        col = {
            active_border   = "rgb(cba6f7)",
            inactive_border = "rgb(6c7086)",
        },
    },

    decoration = {
        rounding         = 12,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled      = true,
            range        = 24,
            render_power = 4,
            color        = "rgba(00000070)",
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        mfact = 0.5,
    },

    misc = {
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
    },
})

hl.animation({ leaf = "windowsIn",   enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "border",      enabled = true, speed = 3, bezier = "default" })

-- ==================
-- WINDOW & LAYER RULES
-- ==================
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "gnome-rounding",
    match = { class = "^(org\\.gnome\\.)" },
    rounding = 12,
})

hl.window_rule({
    name  = "tile-system-settings",
    match = { class = "^(gnome-control-center|pavucontrol|nm-connection-editor|org\\.wezfurlong\\.wezterm)$" },
    tile  = true,
})

hl.window_rule({
    name  = "float-dialogs-and-utilities",
    match = { class = "^(gnome-calculator|galculator|blueman-manager|org\\.gnome\\.Nautilus|xdg-desktop-portal|zoom)$" },
    float = true,
})

hl.window_rule({
    name  = "float-firefox-pip",
    match = { class = "^(firefox)$", title = "^(Picture-in-Picture)$" },
    float = true,
})

hl.window_rule({
    name  = "steam-toasts",
    match = { class = "^(steam)$", title = "^(notificationtoasts)" },
    no_initial_focus = true,
    pin = true,
})

hl.layer_rule({
    name    = "dms-no-anim",
    match   = { namespace = "^(quickshell|dms:.*)$" },
    no_anim = true,
})

-- ==================
-- MODULAR INCLUDES (DMS + KEYBINDS + HOST OVERRIDES)
-- ==================
pcall(require, "dms.colors")
if not is_headless then
    pcall(require, "dms.outputs")
end
pcall(require, "dms.layout")
pcall(require, "dms.cursor")
pcall(require, "dms.windowrules")
require("dms.binds")
pcall(require, "local")
