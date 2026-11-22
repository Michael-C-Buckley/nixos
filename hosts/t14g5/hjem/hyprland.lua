require("binds")
require("input")
require("lookfeel")
require("noctalia")
require("windowrules")

-- Fallback for unknown displays. Kanshi owns display geometry on the T14g5.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

for n = 1, 10 do
  hl.workspace_rule({
    workspace = tostring(n),
    monitor = "eDP-1",
    layout = "dwindle",
    persistent = true,
    default = n == 1,
  })
end
