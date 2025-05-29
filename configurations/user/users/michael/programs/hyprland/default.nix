# Hyprland config according to my custom module
_: {
  imports = [
    ./binds.nix
  ];

  hjem.users.michael.programs.hyprland = {
    enable = true;

    execList = [
      "systemctl --user start hyprpolkitagent"
      "hyprpaper &"
      "nm-applet --indicator &"
      "blueman-applet &"
      "waybar &"
      "dunst &"
      "gammastep -l 36:-78 -t 6500k:1800k"
      "[workspace 11 silent] $terminal"
      "[workspace 12 silent] signal-desktop"
      "[workspace 12 silent] materialgram"
    ];
  };
}
