{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.system) preset;
in {
  config = lib.mkIf (preset == "server") {
    environment.systemPackages = with pkgs; [
      netsurf.browser
    ];
  };
}
