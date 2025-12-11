''
  // Use spawn-sh to run a shell command. Do this if you need pipes, multiple commands, etc.
  // Note: the entire command goes as a single argument. It's passed verbatim to `sh -c`.
  // For example, this is a standard bind to toggle the screen reader (orca).
  Super+Alt+S allow-when-locked=true hotkey-overlay-title=null { spawn-sh "pkill orca || exec orca"; }

  // Applications such as remote-desktop clients and software KVM switches may
  // request that niri stops processing the keyboard shortcuts defined here
  // so they may, for example, forward the key presses as-is to a remote machine.
  // It's a good idea to bind an escape hatch to toggle the inhibitor,
  // so a buggy application can't hold your session hostage.
  //
  // The allow-inhibiting=false property can be applied to other binds as well,
  // which ensures niri always processes them, even when an inhibitor is active.
  Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

  Ctrl+Alt+Delete { quit; }
  Mod+Shift+P { power-off-monitors; }
''
