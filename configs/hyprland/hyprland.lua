-- Shared single-display configuration. The home module owns session startup/shutdown.
require("binds")
require("input")
require("lookfeel")
require("noctalia")
require("windowrules")

-- Host modules can replace this entrypoint when they need fixed geometry or
-- dynamic display/workspace routing.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
