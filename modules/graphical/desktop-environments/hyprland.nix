{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault optionals;
  hyprEnable = config.programs.hyprland.enable;

  # TO DO: audit these packages to see what I use
  hyprPkgs = with pkgs; [
    hyprshot
    hyprpaper
    hyprcursor
    hyprsunset
    hyprpolkitagent # Auth agent
    dunst
    waybar
    libnotify
    swww
    rofi-wayland
    xdg-desktop-portal
    kdePackages.dolphin

    # GTK Tools
    nwg-look
    nwg-panel
    nwg-launchers

    # Clipboard
    clipse
    wl-clip-persist
    wl-clipboard
    xclip
  ];
in {
  programs.hyprland = {
    xwayland.enable = mkDefault hyprEnable;
  };
  programs.hyprlock.enable = hyprEnable;
  environment.systemPackages = optionals hyprEnable hyprPkgs;
}
