-- For v5
local ipc = "noctalia msg "
local mainMod = "SUPER"

-- The home module starts Noctalia through a service or Hyprland's execOnce.

hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
hl.bind(mainMod .. " + ALT + Space", hl.dsp.exec_cmd(ipc .. "bar-toggle"))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd(ipc .. "session lock"))
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd(ipc .. "settings-toggle"))

-- Noctalia Settings
hl.window_rule({
  match = { class = "dev.noctalia.Noctalia" },
  float = true,
  size = { 1080, 920 },
})

-- Noctalia renders notification toasts from every source through this layer.
-- Redact their contents from portal screenshots and screen sharing.
hl.layer_rule({
  match = { namespace = "^noctalia-notification$" },
  no_screen_share = true,
})
