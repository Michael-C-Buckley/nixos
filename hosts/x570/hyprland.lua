require("binds")
require("input")
require("lookfeel")
require("noctalia")
require("windowrules")

hl.monitor({ output = "DP-1", mode = "3440x1440@165", position = "0x0", scale = 1 })

for workspace = 1, 10 do
  hl.workspace_rule({
    workspace = tostring(workspace),
    monitor = "DP-1",
    layout = "dwindle",
    persistent = true,
    default = workspace == 1,
  })
end
