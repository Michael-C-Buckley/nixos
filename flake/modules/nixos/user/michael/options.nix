# Interim Options
{lib, ...}: let
  inherit (lib) types mkOption mkEnableOption;
  inherit (types) bool;
in {
  options.features.michael = {
    minimalGraphical = mkOption {
      type = bool;
      default = true;
      description = "Include a footprint of small and useful GUI packages";
    };
    extendedGraphical = mkEnableOption {};
  };
}
