{
  config,
  pkgs,
  lib,
  inputs,
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
    package = mkDefault inputs.hyprland.packages.x86_64-linux.hyprland;
    xwayland.enable = mkDefault hyprEnable;
  };
  programs.hyprlock.enable = hyprEnable;
  environment.systemPackages = optionals hyprEnable hyprPkgs;
}
