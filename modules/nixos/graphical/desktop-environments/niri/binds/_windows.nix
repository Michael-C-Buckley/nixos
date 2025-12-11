''
  // Finer height adjustments when in column with other windows.
  Mod+Shift+Minus { set-window-height "-10%"; }
  Mod+Shift+Equal { set-window-height "+10%"; }

  // Move the focused window between the floating and the tiling layout.
  Mod+V       { toggle-window-floating; }
  Mod+Shift+V { switch-focus-between-floating-and-tiling; }

  // Toggle tabbed column display mode.
  // Windows in this column will appear as vertical tabs,
  // rather than stacked on top of each other.
  Mod+W { toggle-column-tabbed-display; }

  // Actions to switch layouts.
  // Note: if you uncomment these, make sure you do NOT have
  // a matching layout switch hotkey configured in xkb options above.
  // Having both at once on the same hotkey will break the switching,
  // since it will switch twice upon pressing the hotkey (once by xkb, once by niri).
  // Mod+Space       { switch-layout "next"; }
  // Mod+Shift+Space { switch-layout "prev"; }
''
