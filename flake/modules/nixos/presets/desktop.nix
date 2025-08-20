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
      cosmic.enable = mkDefault false;
      hyprland.enable = mkDefault true;
      niri.enable = mkDefault false;
    };

    services.xserver.windowManager.stumpwm.enable = true;

    virtualisation = {
      containerlab.enable = true;
    };

    environment.systemPackages = with pkgs; [pulseaudioFull];

    features = {
      boot = mkDefault "systemd";
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
