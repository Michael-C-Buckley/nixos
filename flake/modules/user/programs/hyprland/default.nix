{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkOption mkIf concatStringsSep;
  inherit (lib.types) lines str package listOf;
  cfg = config.programs.hyprland;

  mkEmptyListOfOption = description:
    mkOption {
      inherit description;
      type = listOf str;
      default = [];
    };

  # Custom wrapper for handling things like properly adding the first prepend and last newline
  fuse = prepend: list: (
    prepend + (concatStringsSep "\n${prepend}" list) + "\n\n"
  );
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
    sourceList = mkEmptyListOfOption "List of files to source.";

    initialConfig = mkOption {
      type = lines;
      default = '''';
      description = "Config lines at the top of the Hyprland config file.";
    };

    extraConfig = mkOption {
      type = lines;
      default = '''';
      description = "Additional lines to add the Hyprland config file.";
    };
  };

  config = {
    # WIP: Portals and other things later
    packageList = mkIf cfg.enable [cfg.package];

    fileList = {
      ".config/hypr/hyprland.conf".text = mkDefault (cfg.initialConfig
        + fuse "exec-once=" cfg.execList
        + fuse "bind=" cfg.bindList
        + fuse "binde=" cfg.bindeList
        + fuse "bindm=" cfg.bindmList
        + cfg.extraConfig
        + fuse "source=" cfg.sourceList);
    };
  };
}
