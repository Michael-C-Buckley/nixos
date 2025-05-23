{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.apps.communication.telegram;
  imperm = config.system.impermanence.enable;
in {
  options.apps.communication.telegram = {
    enable = mkEnableOption "Install Telegram.";
    package = mkOption {
      type = lib.types.package;
      default = pkgs.materialgram; # your preferred build
      description = "Telegram package used for your user.";
    };
  };

  config = {
    packageList = mkIf cfg.enable [cfg.package];
    system.impermanence = mkIf (cfg.enable && imperm) {
      userPersistDirs = [
        ".local/share/materialgram"
        ".local/share/TelegramDesktop"
      ];
    };
  };
}
