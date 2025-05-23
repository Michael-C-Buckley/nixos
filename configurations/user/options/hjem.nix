# Interim Options
{pkgs, lib, ...}: let
  inherit (lib) types mkOption mkEnableOption;
  inherit (types) bool package enum;
in {
  options.features.michael = {
    useHome = mkEnableOption "Use home-manager for any features covered by hjem";
    minimalGraphical = mkOption {
      type = bool;
      default = true;
      description = "Include a footprint of small and useful GUI packages";
    };
    nvf = {
      package = mkOption {
        type = enum ["default" "minimal"];
        default = "minimal";
      };
    };
    zed = {
      include = mkEnableOption {};
      package = mkOption {
        type = package;
        default = pkgs.zed-editor;
      };
    };
    extendedGraphical = mkEnableOption {};
    hyprland.enable = mkEnableOption {};
    waybar.enable = mkEnableOption {};
    includeZed = mkEnableOption {};
  };
}