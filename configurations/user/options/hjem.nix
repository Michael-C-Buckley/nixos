# Interim Options
{
  self,
  config,
  pkgs,
  lib,
  system,
  ...
}: let
  inherit (lib) types mkOption mkEnableOption mkDefault hiPrio;
  inherit (types) bool package enum;
  cfg = config.features.michael;
  extGfx = cfg.extendedGraphical;
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

  config = {
    hjem.users.michael.packageList = [(hiPrio self.packages.${system}."nvf-${cfg.nvf.package}")];
    features.michael = {
      nvf.package = mkDefault
        (if extGfx
        then "default"
        else "minimal");
    };
  };
}
