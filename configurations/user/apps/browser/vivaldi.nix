{
  config,
  lib,
  user,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption;
  cfg = config.apps.${user}.browsers.vivaldi;
in {
  options = {
    apps.${user}.browsers.vivaldi = {
      enable = mkEnableOption "Install vivaldi";
      package = mkOption {
        type = lib.types.package;
        default = pkgs.vivaldi;
        description = "Package to use for Vivaldi";
      };
    };
  };

  config = {
    environment.persistence."/persist".users.${user}.directories =
      if cfg.enable
      then [
        ".config/vivaldi"
        ".cache/vivaldi"
      ]
      else [];

    users.${user}.packages =
      if cfg.enable
      then [cfg.package]
      else [];
  };
}
