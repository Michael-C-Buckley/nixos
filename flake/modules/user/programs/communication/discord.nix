{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.programs.discord;
  imperm = config.system.impermanence.enable;
in {
  options = {
    programs.discord = {
      enable = mkEnableOption "Install Discord";
      package = mkOption {
        type = lib.types.package;
        default = pkgs.legcord; # I use Legcord
        description = "Package to use for Discord";
      };
    };
  };

  config = {
    packageList = mkIf cfg.enable [cfg.package];
    system.impermanence = mkIf (cfg.enable && imperm) {
      userPersistDirs = [
        ".config/legcord"
      ];
    };
  };
}
