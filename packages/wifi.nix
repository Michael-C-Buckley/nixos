{config, pkgs, lib, ...}: let
  wifi = config.features.wifi;
  graphicsWifi = (config.features.wifi && config.features.graphics);
in {
  options.features.wifi = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable wifi features on host.";
  };

  config.environment.systemPackages = with pkgs;
  lib.optionals wifi [
    wavemon
  ] ++ lib.optionals graphicsWifi [
    blueman
  ];
}
