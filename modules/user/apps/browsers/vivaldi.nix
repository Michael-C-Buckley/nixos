{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.apps.browsers.vivaldi;
  imperm = config.system.impermanence.enable;
in {
  options = {
    apps.browsers.vivaldi = {
      enable = mkEnableOption "Install vivaldi";
      package = mkOption {
        type = lib.types.package;
        default = pkgs.vivaldi;
        description = "Package to use for Vivaldi";
      };
    };
  };

  config = {
    packageList = mkIf cfg.enable [cfg.package];
    system.impermanence = mkIf (cfg.enable && imperm) {
      userPersistDirs = [
        ".config/vivaldi"
        ".cache/vivaldi"
      ];
    };
  };
}
