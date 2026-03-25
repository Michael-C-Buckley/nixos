--@module "oxwm"

-------------------------------------------------------------------------------
-- Keybindings
-------------------------------------------------------------------------------

local modkey = "Mod4"
oxwm.set_modkey(modkey) -- This is for Mod + mouse binds, such as drag/resize

oxwm.key.bind({ modkey }, "Return", oxwm.spawn_terminal())

-- Copy screenshot to clipboard
oxwm.key.bind({ modkey }, "S", oxwm.spawn({ "sh", "-c", "maim -s | xclip -selection clipboard -t image/png" }))

oxwm.key.bind({ modkey }, "Q", oxwm.client.kill())

-- Keybind overlay - Shows important keybindings on screen
oxwm.key.bind({ modkey, "Shift" }, "Slash", oxwm.show_keybinds())

-- Window state toggles
oxwm.key.bind({ modkey, "Shift" }, "F", oxwm.client.toggle_fullscreen())
oxwm.key.bind({ modkey }, "V", oxwm.client.toggle_floating())

-- Layout management
oxwm.key.bind({ modkey }, "F", oxwm.layout.set("normie"))
oxwm.key.bind({ modkey }, "C", oxwm.layout.set("tiling"))
-- Cycle through layouts
oxwm.key.bind({ modkey }, "N", oxwm.layout.cycle())

-- Master area controls (tiling layout)

-- Decrease/Increase master area width
oxwm.key.bind({ modkey }, "H", oxwm.set_master_factor(-5))
oxwm.key.bind({ modkey }, "L", oxwm.set_master_factor(5))
-- Increment/Decrement number of master windows
oxwm.key.bind({ modkey }, "I", oxwm.inc_num_master(1))
oxwm.key.bind({ modkey }, "P", oxwm.inc_num_master(-1))

-- Gaps toggle
oxwm.key.bind({ modkey }, "A", oxwm.toggle_gaps())

-- Window manager controls
oxwm.key.bind({ modkey, "Shift" }, "Q", oxwm.quit())
oxwm.key.bind({ modkey, "Shift" }, "R", oxwm.restart())

-- Focus movement [1 for up in the stack, -1 for down]
oxwm.key.bind({ modkey }, "J", oxwm.client.focus_stack(1))
oxwm.key.bind({ modkey }, "K", oxwm.client.focus_stack(-1))

-- Window movement (swap position in stack)
oxwm.key.bind({ modkey, "Shift" }, "J", oxwm.client.move_stack(1))
oxwm.key.bind({ modkey, "Shift" }, "K", oxwm.client.move_stack(-1))

-- Multi-monitor support

-- Focus next/previous Monitors
oxwm.key.bind({ modkey }, "Comma", oxwm.monitor.focus(-1))
oxwm.key.bind({ modkey }, "Period", oxwm.monitor.focus(1))
-- Move window to next/previous Monitors
oxwm.key.bind({ modkey, "Shift" }, "Comma", oxwm.monitor.tag(-1))
oxwm.key.bind({ modkey, "Shift" }, "Period", oxwm.monitor.tag(1))

-- Workspace (tag) navigation
for i = 0, 8 do
    local j = tostring(i + 1)
    -- Switch to workspace
    oxwm.key.bind({ modkey }, j, oxwm.tag.view(i))
    -- Move focused window to the workspace
    oxwm.key.bind({ modkey, "Shift" }, j, oxwm.tag.move_to(i))
    -- Combo view (view multiple tags at once) {argos_nothing}
    -- Example: Mod+Ctrl+2 while on tag 1 will show BOTH tags 1 and 2:
    oxwm.key.bind({ modkey, "Control" }, j, oxwm.tag.toggleview(i))
    -- Multi tag (window on multiple tags)
    -- Example: Mod+Ctrl+Shift+2 puts focused window on BOTH current tag and tag 2
    oxwm.key.bind({ modkey, "Control", "Shift" }, j, oxwm.tag.toggletag(1))
end

-------------------------------------------------------------------------------
-- Keychords
-------------------------------------------------------------------------------
oxwm.key.chord({
    { { modkey }, "Space" },
    { {},         "F" },
}, oxwm.spawn({ "sh", "-c", "rofi -show drun" }))

oxwm.key.chord({
    { { modkey }, "Space" },
    { {},         "W" },
}, oxwm.spawn({ "sh", "-c", "rofi -show window" }))
