{ modules, pkgs, ... }:
{
  imports = [ modules.hyprland ];

  programs.hyprland.enable = true;
  environment.systemPackages = with pkgs; [
    hyprland-guiutils
    hyprcursor
    hyprpolkitagent
    xdg-desktop-portal
    clipse
    wl-clip-persist
    wl-clipboard
    xclip
  ];
}
