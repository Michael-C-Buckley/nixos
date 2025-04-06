# WIP: changing module structure

{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption mkEnableOption types;
  inherit (types) str float nullOr;
  cfg = config.users.michael.ghostty;
  boolToString = b:
    if b
    then "true"
    else "false";
in {
  # TO-DO: make these available for mutliple users
  options.users.michael.ghostty = {
    config = mkOption {
      type = nullOr str;
      default = null;
    };
    theme = mkOption {
      type = nullOr str;
      default = "Seti";
    };
    window = {
      theme = mkOption {
        type = nullOr str;
        default = "system";
      };
      decoration = mkEnableOption "Enable Ghostty window decoration";
    };
    cursor = {
      color = mkOption {
        type = nullOr str;
        default = "#44A3A3";
      };
      opacity = mkOption {
        type = nullOr float;
        default = 0.7;
      };
    };
  };
  # create the config from these parts, link it
  config = {
    users.michael.ghostty.config = lib.concatStringSep "\n" [
      (
        if cfg.theme != null
        then "theme = ${cfg.theme}"
        else ""
      )
      (
        if cfg.window.theme != null
        then "window-theme = ${cfg.window.theme}"
        else ""
      )
      "window-decoration = ${boolToString cfg.window.decoration}"
    ];

    # link it
  };
}
