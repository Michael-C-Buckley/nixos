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
    hyprlock
    hyprcursor
    dunst
    waybar
    swayws
    wlogout
    libnotify
    swww
    rofi-wayland
    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    nwg-look
    nwg-panel
    nwg-launchers
  ];
in {
  programs.hyprland = {
    xwayland.enable = mkDefault hyprEnable;
  };
  programs.hyprlock.enable = hyprEnable;
  environment.systemPackages = optionals hyprEnable hyprPkgs;
}
