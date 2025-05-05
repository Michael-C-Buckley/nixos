{
  config,
  pkgs,
  lib,
  ...
}: let
  wifi = config.features.wifi;
in {
  options.features.wifi = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable wifi features on host.";
  };

  config.environment.systemPackages = with pkgs;
    lib.optionals wifi [
      blueman
      wavemon
    ];
}
