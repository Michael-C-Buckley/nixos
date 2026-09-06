{
  pkgs,
  workspaces ? 10,
  browser ? "helium",
  terminal ? "kitty",
  extraConfig ? { },
  ...
}:
let
  inherit (pkgs.lib) listToAttrs;

  mkFocus =
    direction: key:
    let
      verb = if direction == "left" || direction == "right" then "output" else "workspace";
      focus = "window-focus-or-${verb}-${direction}";
      move = "window-move-or-${verb}-${direction}";
    in
    {
      "Mod+Wheel${direction}" = focus;
      "Mod+${direction}" = focus;
      "Mod+${key}" = focus;
      "Mod+Shift+${key}" = move;
      "Mod+Shift+${direction}" = move;
    };

  # workspace 10 sits on the physical "0" key, like most keyboard layouts
  workspaceKey = n: if n == 10 then "0" else toString n;

  lockbind = action: {
    inherit action;
    allow_when_locked = true;
  };

  workspaceBinds =
    listToAttrs (
      map (n: {
        name = "Mod+${workspaceKey n}";
        value = "workspace-switch:${toString n}";
      }) (pkgs.lib.range 1 workspaces)
    )
    // listToAttrs (
      map (n: {
        name = "Mod+Shift+${workspaceKey n}";
        value = "window-move-to-workspace:${toString n}";
      }) (pkgs.lib.range 1 workspaces)
    );
in
{
  keybinds = {
    "Mod+Shift+WheelUp" = "window-move-to-workspace-previous";
    "Mod+Shift+WheelDown" = "window-move-to-workspace-next";

    "Mod+Ctrl+Escape" = "session-quit:skip-confirmation";
    "Mod+Ctrl+Semicolon" = "spawn:systemctl shutdown";
    "Mod+Ctrl+Alt+Semicolon" = "spawn:systemctl reboot";

    "Mod+T" = "window-toggle-floating";
    "Mod+P" = "window-toggle-pinned";
    "Mod+F" = "window-toggle-maximize-to-edges";
    "Mod+Shift+Q" = "window-close";
    "Mod+O" = "overview-toggle";

    "Mod+Space" = "spawn:noctalia msg panel-toggle launcher";
    "Mod+Ctrl+Space" = "spawn:noctalia msg bar-toggle";
    "Mod+Ctrl+L" = "spawn:noctalia msg session lock";
    "Mod+S" = "spawn:noctalia msg screenshot-region";

    "Mod+B" = "spawn:${browser}";
    "Mod+Return" = "spawn:${terminal}";

    "XF86AudioRaiseVolume" = lockbind "spawn:wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
    "XF86AudioLowerVolume" = lockbind "spawn:wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
    "Mod+XF86AudioMute" = lockbind "spawn:wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
    "XF86AudioPlay" = lockbind "spawn:playerctl play-pause";
    "XF86AudioNext" = lockbind "spawn:playerctl next";
    "XF86AudioPrev" = lockbind "spawn:playerctl prev";
    "XF86MonBrightnessDown" = lockbind "spawn:noctalia msg brightness-down 10";
    "XF86MonBrightnessUp" = lockbind "spawn:noctalia msg brightness-up 10";
  }
  // workspaceBinds
  // (mkFocus "left" "H")
  // (mkFocus "right" "L")
  // (mkFocus "up" "K")
  // (mkFocus "down" "J")
  // extraConfig;
}
