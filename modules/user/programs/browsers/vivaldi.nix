{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.programs.vivaldi;
  imperm = config.system.impermanence.enable;
in {
  options = {
    programs.vivaldi = {
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
