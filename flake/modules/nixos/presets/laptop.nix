{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.system) preset;
in {
  config = mkIf (preset == "laptop") {
    environment.systemPackages = [
      pkgs.brightnessctl
    ];
    # Disable discovery for laptops
    services.lldpd.enable = false;
  };
}
