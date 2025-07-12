{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault mkIf;
  inherit (config.system) preset;
in {
  # These are shared on my systems, laptops get everything plus more
  config = mkIf (preset
    == "desktop"
    || preset == "laptop") {
    programs = {
      cosmic.enable = mkDefault false; # I don't use it currently
      hyprland.enable = mkDefault true;
      niri.enable = mkDefault true;
    };

    environment.systemPackages = with pkgs; [pulseaudioFull];

    hjem.users.michael.programs = {vivaldi.enable = true;};

    services.flatpak.enable = true;

    features = {
      michael = {
        extendedGraphical = mkDefault true;
        hyprland.enable = mkDefault true;
      };
      autoLogin = mkDefault true;
      displayManager = mkDefault "greetd";
      pkgs.fonts = mkDefault true;
    };
  };
}
