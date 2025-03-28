{config, pkgs, lib, inputs, ...}:   let
  useGraphics = config.features.graphics;

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
    enable = useGraphics;
    package = inputs.hyprland.packages.x86_64-linux.hyprland;
    xwayland.enable = useGraphics;
  };

  environment.systemPackages = lib.optionals useGraphics hyprPkgs;
}
