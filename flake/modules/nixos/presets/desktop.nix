{
  config,
  lib,
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
      cosmic.enable = mkDefault true;
      hyprland.enable = mkDefault true;
      niri.enable = mkDefault true;
    };

    services.flatpak = {
      enable = true;
      apps = [
        {
          remote = "flathub";
          name = "com.vscodium.codium";
        }
      ];
    };

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
