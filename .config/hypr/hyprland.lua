-------------------
---- AUTOSTART ----
-------------------
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
-- `hl.exec_cmd()` runs asynchronously, so no `&` / `disown` is needed.
hl.on("hyprland.start", function()
	-- Clipboard history daemon
	hl.exec_cmd("wl-clipboard-history -t")

	-- Make systemd user services and the D-Bus session see the Wayland vars.
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

	-- KDE polkit authentication agent
	hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")

	-- Tag the initial keyboard layout for any tooling that reads it
	hl.exec_cmd("echo fi > /tmp/kb_layout")

	-- Night-light / blue-light filter
	hl.exec_cmd("wlsunset -t 4500 -S 6:00 -s 19:30")

	-- Audio stack
	hl.exec_cmd("systemctl --user restart pipewire")

	-- Notification daemon
	hl.exec_cmd("mako")

	-- cliphist — text only
	hl.exec_cmd("wl-paste --type text --watch cliphist store") -- Stores only text data
	-- cliphist — images only
	hl.exec_cmd("wl-paste --type image --watch cliphist store") -- Stores only image data

	-- Wallpaper daemon (swww) — init must come before `img`
	hl.exec_cmd("swww init")
	hl.exec_cmd("swww img /home/joakim/.config/wallpapers/main.jpg")

	-- GNOME / GTK interop (fcitx, disable overlay scrollbars)
	hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-im-module 'fcitx'")
	hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-overlay-scrollbar false")

	-- fcitx5 input method
	hl.exec_cmd("fcitx5 -d")

	-- Re-assert Wayland display vars (kept to match the original config order)
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
-- Japanese input (fcitx5)
hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("SDL_IM_MODULE", "fcitx")
hl.env("INPUT_METHOD", "fcitx")

-- Announce Hyprland to toolkits / portals
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")

-- Locale
hl.env("LANG", "en_GB.UTF-8")

---------------
---- CONFIG ---
---------------
hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
	input = {
		kb_layout = "fi",
		kb_options = "caps:escape",
		repeat_rate = 35,
		repeat_delay = 250,
		follow_mouse = 0,
		sensitivity = 0,
		force_no_accel = true,
	},
	general = {
		gaps_in = 2,
		gaps_out = 2,
		border_size = 1,
		layout = "dwindle",
		["col.active_border"] = "0xff2962FF",
		["col.inactive_border"] = "0xff382D2E",
	},
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		mouse_move_enables_dpms = true,
		enable_swallow = true,
		swallow_regex = "^(wezterm)$",
		vrr = 0,
	},
	binds = {
		allow_workspace_cycles = true,
	},
	decoration = {
		rounding = 0,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		shadow = {
			offset = "1 2",
			range = 10,
			render_power = 2,
			color = "0x66404040",
		},
	},
	dwindle = {
		preserve_split = true,
	},
})

----------------
---- MONITOR ---
----------------
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
	output = "DP-3",
	mode = "2560x1440@144",
	position = "0x0",
	scale = 1,
})

-------------------
---- ANIMATIONS ---
-------------------
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
-- Custom bezier curves
hl.curve("overshot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("smoothOut", { type = "bezier", points = { { 0.36, 0 }, { 0.66, -0.56 } } })
hl.curve("smoothIn", { type = "bezier", points = { { 0.25, 1 }, { 0.5, 1 } } })

-- Animations: leaf, enabled, speed, curve, style
hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "overshot", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "smoothOut", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 10, bezier = "smoothIn" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 10, bezier = "smoothIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "default" })

-------------------------
---- WORKSPACE RULES ----
-------------------------
-- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
hl.workspace_rule({
	workspace = "w[tv1]",
	gaps_out = 0,
	gaps_in = 0,
})
hl.workspace_rule({
	workspace = "f[1]",
	gaps_out = 0,
	gaps_in = 0,
})

----------------------
---- WINDOW RULES ----
----------------------
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

hl.window_rule({
	name = "no-deco-wtv1",
	match = { float = false, workspace = "w[tv1]" },
	border_size = 0,
	rounding = 0,
})
hl.window_rule({
	name = "no-deco-f1",
	match = { float = false, workspace = "f[1]" },
	border_size = 0,
	rounding = 0,
})

-- App-specific
hl.window_rule({
	name = "jw-notifications",
	match = { title = "jw_personal_notifications" },
	float = true,
	rounding = 5,
})
hl.window_rule({
	name = "empyrion-fullscreen",
	match = { title = ".*Empyrion - Galactic Survival.*" },
	fullscreen = true,
})
hl.window_rule({
	name = "satisfactory-fullscreen",
	match = { title = ".*Satisfactory.*" },
	fullscreen = true,
})
hl.window_rule({
	name = "game-fullscreen",
	match = { content = "game" },
	fullscreen = true,
	fullscreen_state = 2,
})

------------------------
---- KEYBINDINGS ----
------------------------
local mainMod = "SUPER"

-- Apps
hl.bind(mainMod .. " + v", hl.dsp.exec_cmd("wf-recorder -f $(xdg-user-dir VIDEOS)/$(date +'%H:%M:%S_%d-%m-%Y.mp4')"))
hl.bind(mainMod .. " + SHIFT + v", hl.dsp.exec_cmd("killall -s SIGINT wf-recorder"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("~/scripts/notification_dash.sh | python ~/scripts/jwqtnotify.py"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("flameshot gui"))

-- System / launcher
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("swaylock"))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("tofi-drun --drun-launch=true"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("wofi-emoji"))

-- Volume
hl.bind(
	"CTRL + ALT + comma",
	hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 3%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"CTRL + ALT + period",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 3%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))

-- Audio output cycle
hl.bind("CTRL + ALT + O", hl.dsp.exec_cmd("~/.config/hypr/cycle-audio-output.sh"))

-- Brightness (repeating)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"), { locked = true, repeating = true })

-- Window management
hl.bind(mainMod .. " + Escape", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Escape", hl.dsp.exit())
-- Ö key (Finnish layout)
hl.bind(mainMod .. " + code:47", hl.dsp.window.fullscreen(1))
-- Ä key (Finnish layout)
hl.bind(mainMod .. " + code:48", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + minus", hl.dsp.window.pseudo())

-- Focus
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "right" }))

-- Move window
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

-- Resize
hl.bind(mainMod .. " + h", hl.dsp.window.resize({ x = -50, y = 0, relative = true }))
hl.bind(mainMod .. " + l", hl.dsp.window.resize({ x = 50, y = 0, relative = true }))
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }))

-- Groups
hl.bind(mainMod .. " + g", hl.dsp.group.toggle())
hl.bind(mainMod .. " + tab", hl.dsp.group.next())

-- Special workspace / center
hl.bind(mainMod .. " + SHIFT + a", hl.dsp.window.move({ workspace = "special" }))
hl.bind(mainMod .. " + n", hl.dsp.window.center())

-- Workspace switch
local wsKeys = { "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P" }
local focusWs = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 0 }
local moveWs = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }
for i = 1, 10 do
	hl.bind(mainMod .. " + " .. wsKeys[i], hl.dsp.focus({ workspace = focusWs[i] }))
	hl.bind(mainMod .. " + SHIFT + " .. wsKeys[i], hl.dsp.window.move({ workspace = moveWs[i] }))
end

-- Mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
