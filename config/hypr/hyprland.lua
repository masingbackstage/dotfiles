-- https://wiki.hypr.land/Configuring/Start/
-- Example config for reference: /usr/share/hypr/hyprland.lua
-- API stubs for your editor's Lua LSP: /usr/share/hypr/stubs/hl.meta.lua


------------------
---- MONITORS ----
------------------

hl.monitor({ output = "",         mode = "preferred",       position = "auto",    scale = 1 })
hl.monitor({ output = "DP-1",     mode = "1920x1080@165",   position = "0x0",     scale = 1 })
hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@60",    position = "-2048x0", scale = 1.25 })

-- Workspace ownership for nest-shell (ADR-0003)
for i = 1, 10 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor   = i <= 5 and "DP-1" or "HDMI-A-1",
        default   = (i == 1 or i == 6) or nil,
    })
end


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "ghostty"
local fileManager = "thunar"
local menu        = "hyprlauncher"


-------------------
---- AUTOSTART ----
-------------------

-- nest-shell: shell autostart + its keybinds (Meta+Space, Meta+D, volume/brightness keys...)
dofile(os.getenv("HOME") .. "/Projects/nest-shell/hyprland/shell-switch.lua")

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
    hl.exec_cmd("xrandr --output DP-1 --primary")
    hl.exec_cmd("udiskie")  -- automount USB drives / disks
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- NVIDIA: hardware video decoding via VA-API (libva-nvidia-driver)
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")
-- Electron apps (Discord, VS Code, Claude, Signal, Obsidian...) run natively on Wayland
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 20,

        border_size = 2,

        col = {
            active_border   = { colors = { "rgba(cba6f7ee)", "rgba(f5c2e7ee)", "rgba(89b4faee)" }, angle = 45 }, -- Catppuccin Mocha mauve -> pink -> blue
            inactive_border = "rgba(45475aaa)", -- Catppuccin Mocha surface1
        },

        resize_on_border = false,
        allow_tearing    = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        -- Soft purple glow around the focused window (Catppuccin mauve)
        glow = {
            enabled        = true,
            range          = 10,
            render_power   = 3,
            color          = "rgba(cba6f755)",
            color_inactive = "rgba(00000000)",
        },

        -- macOS-like "frosted glass": wide, smooth, slightly saturated blur
        blur = {
            enabled           = true,
            size              = 12,    -- radius per pass
            passes            = 4,     -- more passes = wider + smoother
            noise             = 0.02,  -- subtle grain, hides banding
            contrast          = 1.0,
            brightness        = 1.0,
            vibrancy          = 0.45,  -- boost colour saturation behind glass
            vibrancy_darkness = 0.2,
            xray              = false,
            popups            = true,  -- blur menus/popups too
            special           = true,
        },
    },

    animations = {
        enabled = true,
    },
})

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.79, 0.33}, {0.14, 0.53} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1.0}  } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
hl.curve("orzel",          { type = "bezier", points = { {0.79, 0.33}, {0.14, 0.53} } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
-- Border gradient rotating around windows (one full turn ~8 s)
hl.animation({ leaf = "borderangle",   enabled = true, speed = 80,   bezier = "linear",       style = "loop" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "slide 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "slide 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 3,    bezier = "easeOutQuint", style = "slidevert" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 3,    bezier = "easeOutQuint", style = "slidevert" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 3,    bezier = "easeOutQuint", style = "slidevert" })

-- "Smart gaps" / "No gaps when only" -- uncomment if you want it
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({ name = "no-gaps-wtv1", match = { float = false, workspace = "w[tv1]" }, border_size = 0, rounding = 0 })
-- hl.window_rule({ name = "no-gaps-f1",   match = { float = false, workspace = "f[1]" },   border_size = 0, rounding = 0 })

hl.config({
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = false,
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "pl",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        numlock_by_default = true,

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
-- Graceful exit: hyprshutdown lets apps close (and ask about unsaved work); falls back to a hard exit
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
-- hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("zen-browser"))
hl.bind("PRINT",                   hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen())
-- Clipboard history (cliphist runs as a systemd user service)
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -p Schowek -display-columns 2 | cliphist decode | wl-copy"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Switch workspace: mainMod + [0-9] / numpad
-- Move active window to workspace: mainMod + SHIFT + [0-9] / numpad
local numpad = {
    "KP_End", "KP_Down", "KP_Page_Down",
    "KP_Left", "KP_Begin", "KP_Right",
    "KP_Home", "KP_Up", "KP_Page_Up",
    "KP_INSERT",
}
for i = 1, 10 do
    -- digit row, numpad with NumLock off (KP_End...), numpad with NumLock on (KP_1...)
    for _, key in ipairs({ tostring(i % 10), numpad[i], "KP_" .. (i % 10) }) do
        hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
    end
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume/brightness keys are bound by nest-shell (shell-switch.lua)
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
    -- Ignore maximize requests from all apps.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

-- Thunar: translucent so Hyprland's blur shows through (frosted glass)
hl.window_rule({
    name    = "thunar-glass",
    match   = { class = "^([Tt]hunar)$" },
    opacity = "0.85 0.8",  -- focused / unfocused
})

-- Small tools and dialogs: centered floating windows instead of new tiles
hl.window_rule({
    name   = "float-tools",
    match  = { class = "^(org.pulseaudio.pavucontrol|nm-connection-editor|blueberry.py|xdg-desktop-portal-gtk|org.xfce.ristretto)$" },
    float  = true,
    size   = "900 600",
    center = true,
})
hl.window_rule({
    name   = "float-file-dialogs",
    match  = { title = "^(Open File|Open Files|Open Folder|Save As|Save File|Select a File|Choose Files|File Upload|Otwórz plik|Otwórz pliki|Otwórz katalog|Zapisz jako|Zapisz plik|Wybierz plik|Przesyłanie pliku|Wysyłanie pliku)(.*)$" },
    float  = true,
    size   = "1000 650",
    center = true,
})
hl.window_rule({
    -- Steam: everything except the main library window floats
    name   = "float-steam-dialogs",
    match  = { class = "^steam$", title = "^(Friends List|Lista znajomych|Steam Settings|Ustawienia Steam|Ustawienia|Settings|Special Offers|Oferty specjalne|Screenshot Uploader|Steam - News.*|Steam — wiadomości.*)$" },
    float  = true,
    center = true,
})
