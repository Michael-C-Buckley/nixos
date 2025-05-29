{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf;
  inherit (lib.types) lines str package listOf;
  cfg = config.programs.hyprland;

  mkEmptyListOfOption = description: mkOption {
    inherit description;
    type = listOf str;
    default = [];
  };
in {
  options.programs.hyprland = {
    enable = mkEnableOption "Install and enable Hyprland.";
    package = mkOption {
      type = package;
      default = pkgs.hyprland;
      description = "Package to use for Hyprland.";
    };

    execList = mkEmptyListOfOption "List of commands (string format) that will be `exec-once` by Hyprland.";
    bindList = mkEmptyListOfOption "List of binds (string following the `bind=`).";
    bindmList = mkEmptyListOfOption "List of bindm (string following the `bind=`).";
    bindeList = mkEmptyListOfOption "List of binde (string following the `bind=`).";

    extraConfig = mkOption {
      type = lines;
      default = '''';
      description = "Additional lines to add to the end of the Hyprland config file.";
    };
  };

  config = {
    # WIP: Portals and other things later
    packageList = mkIf cfg.enable [cfg.package];
  };
}
