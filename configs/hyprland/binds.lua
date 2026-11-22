-- Based heavily on the default config

local mainMod = "SUPER"
local terminal = "kitty --override remember_window_size=no"
local browser = "helium --profile-directory=Default"
local browser2 = "gtk-launch helium-incognito"
local personalBrowser = 'helium --profile-directory="Profile 1"'
local menu = "noctalia msg panel-toggle launcher"
local fileManager = "pcmanfm"
local powerCommand = os.getenv("HYPRLAND_POWER_COMMAND") or "systemctl"

for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))

hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + ALT + B", hl.dsp.exec_cmd(browser2))
hl.bind(mainMod .. " + CTRL + B", hl.dsp.exec_cmd(personalBrowser))

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(
  mainMod .. " + Escape",
  hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))

-- System
hl.bind(mainMod .. " + CTRL + semicolon", hl.dsp.exec_cmd(powerCommand .. " poweroff"))
hl.bind(mainMod .. " + CTRL + ALT + semicolon", hl.dsp.exec_cmd(powerCommand .. " reboot"))

hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + A", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
  "XF86AudioRaiseVolume",
  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioLowerVolume",
  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMicMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up 10"), { locked = true, repeating = true })
hl.bind(
  "XF86MonBrightnessDown",
  hl.dsp.exec_cmd("noctalia msg brightness-down 10"),
  { locked = true, repeating = true }
)

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Screenshot
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("noctalia msg screenshot-region"))
