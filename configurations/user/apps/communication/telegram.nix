{ user, config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.apps.${user}.communication.telegram;
in
{
  options.apps.${user}.communication.telegram = {
    enable  = mkEnableOption "Install Telegram for ${user}";
    package = mkOption {
      type        = lib.types.package;
      default     = pkgs.materialgram;   # your preferred build
      description = "Telegram package used for your user.";
    };
  };

  config = {
    environment.persistence = mkIf config.system.impermanence.enable {
      "/persist".users.${user}.directories = mkIf cfg.enable [
        ".local/share/materialgram"
        ".local/share/TelegramDesktop"
      ];
    };

    users.users.${user}.packages = mkIf cfg.enable [cfg.package];
  };
}
