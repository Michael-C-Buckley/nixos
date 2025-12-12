''
  Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
  Ctrl+Alt+Delete { quit skip-confirmation=true; }
  Mod+Shift+P { power-off-monitors; }

  Ctrl+Mod+semicolon { spawn-sh "systemctl poweroff"; }
  Ctrl+Alt+Mod+semicolon { spawn-sh "systemctl reboot"; }
''
