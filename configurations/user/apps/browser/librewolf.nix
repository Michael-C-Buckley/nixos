{
  config,
  lib,
  user,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption;
  cfg = config.apps.${user}.browsers.librewolf;
in {
  options = {
    apps.${user}.browsers.librewolf = {
      enable = mkEnableOption "Install Librewolf";
      package = mkOption {
        type = lib.types.package;
        default = pkgs.librewolf;
        description = "Package to use for Librewold";
      };
    };
  };

  config = {
    environment = if config.system.impermanence.enable then {
      
      persistence."/persist".users.${user}.directories =
      if cfg.enable
      then [
        ".config/librewolf"
        ".cache/librewolf"
      ]
      else [];
    } else {};

    users.users.${user}.packages =
      if cfg.enable
      then [cfg.package]
      else [];
  };
}
