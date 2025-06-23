{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.system) preset;
in {
  # These are shared on my systems, laptops get everything plus more
  config = mkIf (preset
    == "desktop"
    || preset == "laptop") {
    environment.systemPackages = with pkgs; [
      devenv
    ];

    programs = {
      cosmic.enable = true;
      hyprland.enable = true;
      niri.enable = true;
    };

    features = {
      michael = {
        extendedGraphical = true;
        hyprland.enable = true;
      };
      autoLogin = true;
      displayManager = "greetd";
      gaming.enable = true;
      pkgs.fonts = true;
    };
  };
}
