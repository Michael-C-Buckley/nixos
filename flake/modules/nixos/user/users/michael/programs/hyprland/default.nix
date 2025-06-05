# Hyprland config according to my custom module
{config, ...}: {
  imports = [
    ./binds.nix
  ];

  hjem.users.michael.programs.hyprland = {
    inherit (config.programs.hyprland) enable;

    initialConfig = ''
      $browser=librewolf
      $fileManager=thunar
      $ide=code
      $menu=wofi -s drun -show-icons
      $mod=SUPER
      $terminal=ghostty
    '';

    extraConfig = ''
      master {
        new_status=master
      }

      misc {
        disable_hyprland_logo=true
        force_default_wallpaper=0
      }

      ecosystem {
        no_update_news=true
      }

      env=XCURSOR_SIZE,28
      env=HYPRCURSOR_SIZE,28
    '';

    sourceList = [
      "~/.config/hypr/input.conf"
      "~/.config/hypr/lookfeel.conf"
    ];

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
