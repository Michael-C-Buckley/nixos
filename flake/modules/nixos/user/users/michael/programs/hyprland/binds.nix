# Hyprland config according to my custom module
_: let
  # 1 to 9 is unchanged
  workspaceBinds =
    builtins.concatMap (
      i: let
        n = toString i;
      in [
        "$mod, ${n}, workspace, ${n}"
        "$mod SHIFT, ${n}, movetoworkspace, ${n}"
      ]
    )
    (builtins.genList (i: i + 1) 9);

  # Map the non-matching keys
  moreWorkspaceBinds =
    builtins.concatMap (
      i: let
        k = builtins.elemAt ["0" "A" "S" "D"] i;
        s = builtins.elemAt ["10" "11" "12" "13"] i;
      in [
        "$mod, ${k}, workspace, ${s}"
        "$mod SHIFT, ${k}, movetoworkspace, ${s}"
      ]
    )
    (builtins.genList (_: _) 4);
in {
  hjem.users.michael.programs.hyprland = {
    bindList =
      workspaceBinds
      ++ moreWorkspaceBinds
      ++ [
        # See https://wiki.hyprland.org/Configuring/Keywords/
        "$mod, W, exec, rofi -show drun -show-icons"
        "$mod, Tab, exec, rofi -show window"

        # Launch Programs
        "$mod, Return, exec, $terminal"
        "$mod ALT, Return, exec, $terminal2"
        "$mod, E, exec, $fileManager"
        "$mod, I, exec, $ide"
        "$mod, O, exec, $browser"
        "$mod, R, exec, $menu"

        # Window Manipulation
        "$mod, space, togglefloating,"
        "$mod, Q, killactive,"
        "$mod, P, pseudo,"
        "$mod, G, togglesplit,"
        "$mod, F, fullscreen,0"
        "$mod CTRL, f, fullscreen,1"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod ALT, left, resizeactive, -200 0"
        "$mod ALT, right, resizeactive, 200 0"
        "$mod ALT, up, resizeactive, 0 -200"
        "$mod ALT, down, resizeactive, 0 200"

        # Info
        "$mod, H, exec, hyprctl dispatch exec '[float;center;size 1400 1000]ghostty --command=btop'"

        # System Control
        "$mod CTRL, M, exit,"
        "$mod, L, exec, hyprlock"
        "$mod CTRL, semicolon, exec, sudo shutdown now"
        "$mod CTRL ALT, semicolon, exec, sudo reboot now"

        # Workspace Manipulation
        "$mod, J, togglespecialworkspace, magic1"
        "$mod SHIFT, J, movetoworkspace, special:magic1"
        "$mod, K, togglespecialworkspace, magic2"
        "$mod SHIFT, K, movetoworkspace, special:magic2"

        # Media Controls
        ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        ", XF86MonBrightnessUp, exec, brightnessctl s +10%"
        "$mod, Home, exec, hyprshot -m region"
      ];

    bindeList = [
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 10%+"
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ];

    bindmList = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
  };
}
