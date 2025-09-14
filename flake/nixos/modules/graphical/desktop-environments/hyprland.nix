{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.programs) hyprland;
in {
  config = mkIf hyprland.enable {
    programs = {
      hyprland.xwayland.enable = true;
      hyprlock.enable = true;
    };

    environment = {
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        GDK_BACKEND = "wayland,x11";
        QT_QPA_PLATFORM = "wayland;xcb";

        # fix java bug on tiling wm's / compositors
        _JAVA_AWT_WM_NONREPARENTING = "1";
      };

      # TO DO: audit these packages to see what I use
      systemPackages = with pkgs; [
        hyprshot
        hyprpaper
        hyprcursor
        hyprsunset
        hyprpolkitagent # Auth agent
        dunst
        waybar
        libnotify
        swww
        rofi
        xdg-desktop-portal

        # Clipboard
        clipse
        wl-clip-persist
        wl-clipboard
        xclip
      ];
    };
  };
}
