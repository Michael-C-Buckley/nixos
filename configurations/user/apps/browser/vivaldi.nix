{
  config,
  lib,
  user,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf;
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
    environment = mkIf config.system.impermanence.enable {
      persistence."/persist".users.${user}.directories = mkIf cfg.enable [
        ".config/vivaldi"
        ".cache/vivaldi"
      ];
    };

    users.users.${user}.packages = mkIf cfg.enable [cfg.package];
  };
}
