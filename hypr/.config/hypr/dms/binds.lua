-- Hyprland 0.57+ Lua Keybindings (Shared via GNU Stow)
-- Aligned with daily KDE Plasma muscle memory (kglobalshortcutsrc)

local mainMod = "SUPER"
local smart_terminal = "sh -c 'if zellij terminal --help >/dev/null 2>&1; then exec zellij terminal; else exec ghostty -e zellij; fi'"

-- === Launcher & Terminal ===
-- Tap Super alone -> DMS Spotlight (mirrors KDE Kickoff on Meta tap)
hl.bind(mainMod .. " + SUPER_L", hl.dsp.exec_cmd("dms ipc call spotlight toggle"), { release = true })
hl.bind(mainMod .. " + D",       hl.dsp.exec_cmd("dms ipc call spotlight toggle"))
hl.bind(mainMod .. " + Return",  hl.dsp.exec_cmd(smart_terminal))
hl.bind(mainMod .. " + T",       hl.dsp.exec_cmd("ghostty"))
hl.bind(mainMod .. " + ALT + K", hl.dsp.exec_cmd("keepassxc"))

-- === Keyboard Layout (Mirrors KDE Meta+Space: latam <-> us-intl) ===
hl.bind(mainMod .. " + space", hl.dsp.exec_cmd("hyprctl switchxkblayout all next"))

-- === DMS Overlays & Utilities ===
hl.bind(mainMod .. " + V",            hl.dsp.exec_cmd("dms ipc call clipboard toggle"))
hl.bind("CTRL + SHIFT + Escape",      hl.dsp.exec_cmd("dms ipc call processlist focusOrToggle"))
hl.bind(mainMod .. " + comma",        hl.dsp.exec_cmd("dms ipc call settings focusOrToggle"))
hl.bind(mainMod .. " + N",            hl.dsp.exec_cmd("dms ipc call notifications toggle"))
hl.bind(mainMod .. " + SHIFT + D",    hl.dsp.exec_cmd("dms ipc call notifications toggleDoNotDisturb"))
hl.bind(mainMod .. " + SHIFT + N",    hl.dsp.exec_cmd("dms ipc call notepad toggle"))
hl.bind(mainMod .. " + Y",            hl.dsp.exec_cmd("dms ipc call dankdash wallpaper"))
hl.bind(mainMod .. " + TAB",          hl.dsp.exec_cmd("dms ipc call hypr toggleOverview"))
hl.bind(mainMod .. " + X",            hl.dsp.exec_cmd("dms ipc call powermenu toggle"))
hl.bind(mainMod .. " + SHIFT + Slash", hl.dsp.exec_cmd("dms ipc call keybinds toggle hyprland"))

-- === Session & Security ===
hl.bind(mainMod .. " + ALT + L",  hl.dsp.exec_cmd("dms ipc call lock lock"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())
hl.bind("CTRL + ALT + Delete",    hl.dsp.exec_cmd("dms ipc call processlist focusOrToggle"))

-- === Audio & Media Controls ===
hl.bind("XF86AudioRaiseVolume",        hl.dsp.exec_cmd("dms ipc call audio increment 3"),  { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",        hl.dsp.exec_cmd("dms ipc call audio decrement 3"),  { locked = true, repeating = true })
hl.bind("XF86AudioMute",               hl.dsp.exec_cmd("dms ipc call audio mute"),         { locked = true })
hl.bind("XF86AudioMicMute",            hl.dsp.exec_cmd("dms ipc call audio micmute"),      { locked = true })
hl.bind("XF86AudioPause",              hl.dsp.exec_cmd("dms ipc call mpris playPause"),    { locked = true })
hl.bind("XF86AudioPlay",               hl.dsp.exec_cmd("dms ipc call mpris playPause"),    { locked = true })
hl.bind("XF86AudioPrev",               hl.dsp.exec_cmd("dms ipc call mpris previous"),     { locked = true })
hl.bind("XF86AudioNext",               hl.dsp.exec_cmd("dms ipc call mpris next"),         { locked = true })
hl.bind("CTRL + XF86AudioRaiseVolume", hl.dsp.exec_cmd("dms ipc call mpris increment 3"),  { locked = true, repeating = true })
hl.bind("CTRL + XF86AudioLowerVolume", hl.dsp.exec_cmd("dms ipc call mpris decrement 3"),  { locked = true, repeating = true })

-- === Brightness Controls ===
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd('dms ipc call brightness increment 5 ""'), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd('dms ipc call brightness decrement 5 ""'), { locked = true, repeating = true })

-- === Window Management (Mirrors KDE KWin) ===
hl.bind(mainMod .. " + Q",         hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.kill())
hl.bind(mainMod .. " + M",         hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + C",         hl.dsp.window.center())
hl.bind(mainMod .. " + B",         hl.dsp.window.pin())
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("dms ipc call window-rules toggle"))

-- === Window Switcher (Mirrors KDE Alt+Tab) ===
hl.bind("ALT + TAB",         hl.dsp.window.cycle_next())
hl.bind("ALT + SHIFT + TAB", hl.dsp.window.cycle_next({ prev = true }))

-- === Focus Navigation (Mirrors KDE Meta+H/J/K/L) ===
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + H",     hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J",     hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K",     hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L",     hl.dsp.focus({ direction = "right" }))

-- === Window Movement (Mirrors KDE Meta+Shift+H/J/K/L) ===
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + H",     hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + J",     hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K",     hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + L",     hl.dsp.window.move({ direction = "right" }))

-- === Move Window Across Monitors (Mirrors KDE Meta+Ctrl+H/L) ===
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.window.move({ monitor = "l" }))
hl.bind(mainMod .. " + CTRL + down",  hl.dsp.window.move({ monitor = "d" }))
hl.bind(mainMod .. " + CTRL + up",    hl.dsp.window.move({ monitor = "u" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ monitor = "r" }))
hl.bind(mainMod .. " + CTRL + H",     hl.dsp.window.move({ monitor = "l" }))
hl.bind(mainMod .. " + CTRL + J",     hl.dsp.window.move({ monitor = "d" }))
hl.bind(mainMod .. " + CTRL + K",     hl.dsp.window.move({ monitor = "u" }))
hl.bind(mainMod .. " + CTRL + L",     hl.dsp.window.move({ monitor = "r" }))

-- === Workspace Navigation (Mirrors KDE Meta+S / Meta+W + Meta+1..9) ===
hl.bind(mainMod .. " + S",          hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + W",          hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + Page_Down",  hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + Page_Up",    hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Numbered workspaces (Meta+1..9) + Move to workspace (Meta+Ctrl+1..9 and Meta+Shift+1..9)
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i,            hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + CTRL + " .. i,     hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i,    hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + SHIFT + Page_Down", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + Page_Up",   hl.dsp.window.move({ workspace = "e-1" }))
hl.bind("CTRL + SHIFT + R",                hl.dsp.exec_cmd("dms ipc call workspace-rename open"))

-- === Layout & Sizing ===
hl.bind(mainMod .. " + R",            hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + bracketleft",  hl.dsp.layout("preselect l"))
hl.bind(mainMod .. " + bracketright", hl.dsp.layout("preselect r"))
hl.bind(mainMod .. " + minus",         hl.dsp.window.resize({ x = -50, y = 0,   relative = true }), { repeating = true })
hl.bind(mainMod .. " + equal",         hl.dsp.window.resize({ x = 50,  y = 0,   relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + minus", hl.dsp.window.resize({ x = 0,   y = -50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + equal", hl.dsp.window.resize({ x = 0,   y = 50,  relative = true }), { repeating = true })

-- === Mouse Drag Move / Resize ===
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- === Screenshots (Mirrors KDE Spectacle: Print / Alt+Print / Ctrl+Print) ===
hl.bind("Print",        hl.dsp.exec_cmd("dms screenshot"))
hl.bind("ALT + Print",  hl.dsp.exec_cmd("dms screenshot full"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("dms screenshot window"))

-- === Display Power ===
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.dpms({ action = "toggle" }))
