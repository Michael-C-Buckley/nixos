{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.system) preset;
  inherit (pkgs) brightnessctl;
in {
  config = mkIf (preset == "laptop") {
    environment.systemPackages = [brightnessctl];
    services.lldpd.enable = false; # Disable discovery for laptops
  };
}
