{
  config,
  lib,
  user,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.apps.${user}.communication.discord;
in {
  options = {
    apps.${user}.communication.discord = {
      enable = mkEnableOption "Install Discord";
      package = mkOption {
        type = lib.types.package;
        default = pkgs.legcord; # I use Legcord
        description = "Package to use for Discord";
      };
    };
  };

  config = {
    environment = mkIf config.system.impermanence.enable {
      persistence."/persist".users.${user}.directories = mkIf cfg.enable [
        ".config/legcord"
      ];
    };

    users.users.${user}.packages = mkIf cfg.enable [cfg.package];
  };
}
