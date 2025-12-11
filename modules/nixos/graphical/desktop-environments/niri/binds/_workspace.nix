''
  // Open/close the Overview: a zoomed-out view of workspaces and windows.

  // You can also move the mouse into the top-left hot corner,
  // or do a four-finger swipe up on a touchpad.
  Mod+O repeat=false { toggle-overview; }

  Mod+Q repeat=false { close-window; }

  Mod+Left  { focus-column-left; }
  Mod+Down  { focus-window-down; }
  Mod+Up    { focus-window-up; }
  Mod+Right { focus-column-right; }
  Mod+H     { focus-column-left; }
  Mod+J     { focus-window-down; }
  Mod+K     { focus-window-up; }
  Mod+L     { focus-column-right; }

  Mod+Ctrl+Left  { move-column-left; }
  Mod+Ctrl+Down  { move-window-down; }
  Mod+Ctrl+Up    { move-window-up; }
  Mod+Ctrl+Right { move-column-right; }
  Mod+Ctrl+H     { move-column-left; }
  Mod+Ctrl+J     { move-window-down; }
  Mod+Ctrl+K     { move-window-up; }
  Mod+Ctrl+L     { move-column-right; }

  // Alternative commands that move across workspaces when reaching
  // the first or last window in a column.
  // Mod+J     { focus-window-or-workspace-down; }
  // Mod+K     { focus-window-or-workspace-up; }
  // Mod+Ctrl+J     { move-window-down-or-to-workspace-down; }
  // Mod+Ctrl+K     { move-window-up-or-to-workspace-up; }

  Mod+Home { focus-column-first; }
  Mod+End  { focus-column-last; }
  Mod+Ctrl+Home { move-column-to-first; }
  Mod+Ctrl+End  { move-column-to-last; }

  Mod+Shift+Left  { focus-monitor-left; }
  Mod+Shift+Down  { focus-monitor-down; }
  Mod+Shift+Up    { focus-monitor-up; }
  Mod+Shift+Right { focus-monitor-right; }
  Mod+Shift+H     { focus-monitor-left; }
  Mod+Shift+J     { focus-monitor-down; }
  Mod+Shift+K     { focus-monitor-up; }
  Mod+Shift+L     { focus-monitor-right; }

  Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
  Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
  Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
  Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
  Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
  Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
  Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
  Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

  // Alternatively, there are commands to move just a single window:
  // Mod+Shift+Ctrl+Left  { move-window-to-monitor-left; }
  // ...

  // And you can also move a whole workspace to another monitor:
  // Mod+Shift+Ctrl+Left  { move-workspace-to-monitor-left; }
  // ...

  Mod+Page_Down      { focus-workspace-down; }
  Mod+Page_Up        { focus-workspace-up; }
  Mod+U              { focus-workspace-down; }
  Mod+I              { focus-workspace-up; }
  Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
  Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
  Mod+Ctrl+U         { move-column-to-workspace-down; }
  Mod+Ctrl+I         { move-column-to-workspace-up; }

  // Alternatively, there are commands to move just a single window:
  // Mod+Ctrl+Page_Down { move-window-to-workspace-down; }
  // ...

  Mod+Shift+Page_Down { move-workspace-down; }
  Mod+Shift+Page_Up   { move-workspace-up; }
  Mod+Shift+U         { move-workspace-down; }
  Mod+Shift+I         { move-workspace-up; }

  // You can bind mouse wheel scroll ticks using the following syntax.
  // These binds will change direction based on the natural-scroll setting.
  //
  // To avoid scrolling through workspaces really fast, you can use
  // the cooldown-ms property. The bind will be rate-limited to this value.
  // You can set a cooldown on any bind, but it's most useful for the wheel.
  Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
  Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
  Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
  Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

  Mod+WheelScrollRight      { focus-column-right; }
  Mod+WheelScrollLeft       { focus-column-left; }
  Mod+Ctrl+WheelScrollRight { move-column-right; }
  Mod+Ctrl+WheelScrollLeft  { move-column-left; }

  // Usually scrolling up and down with Shift in applications results in
  // horizontal scrolling; these binds replicate that.
  Mod+Shift+WheelScrollDown      { focus-column-right; }
  Mod+Shift+WheelScrollUp        { focus-column-left; }
  Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
  Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

  // Similarly, you can bind touchpad scroll "ticks".
  // Touchpad scrolling is continuous, so for these binds it is split into
  // discrete intervals.
  // These binds are also affected by touchpad's natural-scroll, so these
  // example binds are "inverted", since we have natural-scroll enabled for
  // touchpads by default.
  // Mod+TouchpadScrollDown { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.02+"; }
  // Mod+TouchpadScrollUp   { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.02-"; }

  // You can refer to workspaces by index. However, keep in mind that
  // niri is a dynamic workspace system, so these commands are kind of
  // "best effort". Trying to refer to a workspace index bigger than
  // the current workspace count will instead refer to the bottommost
  // (empty) workspace.
  //
  // For example, with 2 workspaces + 1 empty, indices 3, 4, 5 and so on
  // will all refer to the 3rd workspace.
  Mod+1 { focus-workspace 1; }
  Mod+2 { focus-workspace 2; }
  Mod+3 { focus-workspace 3; }
  Mod+4 { focus-workspace 4; }
  Mod+5 { focus-workspace 5; }
  Mod+6 { focus-workspace 6; }
  Mod+7 { focus-workspace 7; }
  Mod+8 { focus-workspace 8; }
  Mod+9 { focus-workspace 9; }
  Mod+Ctrl+1 { move-column-to-workspace 1; }
  Mod+Ctrl+2 { move-column-to-workspace 2; }
  Mod+Ctrl+3 { move-column-to-workspace 3; }
  Mod+Ctrl+4 { move-column-to-workspace 4; }
  Mod+Ctrl+5 { move-column-to-workspace 5; }
  Mod+Ctrl+6 { move-column-to-workspace 6; }
  Mod+Ctrl+7 { move-column-to-workspace 7; }
  Mod+Ctrl+8 { move-column-to-workspace 8; }
  Mod+Ctrl+9 { move-column-to-workspace 9; }

  // Alternatively, there are commands to move just a single window:
  // Mod+Ctrl+1 { move-window-to-workspace 1; }

  // Switches focus between the current and the previous workspace.
  // Mod+Tab { focus-workspace-previous; }

  // The following binds move the focused window in and out of a column.
  // If the window is alone, they will consume it into the nearby column to the side.
  // If the window is already in a column, they will expel it out.
  Mod+BracketLeft  { consume-or-expel-window-left; }
  Mod+BracketRight { consume-or-expel-window-right; }

  // Consume one window from the right to the bottom of the focused column.
  Mod+Comma  { consume-window-into-column; }
  // Expel the bottom window from the focused column to the right.
  Mod+Period { expel-window-from-column; }

  Mod+R { switch-preset-column-width; }
  // Cycling through the presets in reverse order is also possible.
  // Mod+R { switch-preset-column-width-back; }
  Mod+Shift+R { switch-preset-window-height; }
  Mod+Ctrl+R { reset-window-height; }
  Mod+F { maximize-column; }
  Mod+Shift+F { fullscreen-window; }

  // Expand the focused column to space not taken up by other fully visible columns.
  // Makes the column "fill the rest of the space".
  Mod+Ctrl+F { expand-column-to-available-width; }

  Mod+C { center-column; }

  // Center all fully visible columns on screen.
  Mod+Ctrl+C { center-visible-columns; }

  // Finer width adjustments.
  // This command can also:
  // * set width in pixels: "1000"
  // * adjust width in pixels: "-5" or "+5"
  // * set width as a percentage of screen width: "25%"
  // * adjust width as a percentage of screen width: "-10%" or "+10%"
  // Pixel sizes use logical, or scaled, pixels. I.e. on an output with scale 2.0,
  // set-column-width "100" will make the column occupy 200 physical screen pixels.
  Mod+Minus { set-column-width "-10%"; }
  Mod+Equal { set-column-width "+10%"; }
''
