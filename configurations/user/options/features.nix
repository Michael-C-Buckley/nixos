{lib, ...}: let
  inherit (lib) types mkOption mkEnableOption;
  inherit (types) bool;
in {
  options.features.michael = {
    useHome = mkEnableOption "Use home-manager for any features covered by hjem";
    minimalGraphical = mkOption {
      type = bool;
      default = true;
      description = "Include a footprint of small and useful GUI packages";
    };
    extendedGraphical = mkEnableOption {};
    hyprland.enable = mkEnableOption {};
    waybar.enable = mkEnableOption {};
    includeZed = mkEnableOption {};
  };
}
