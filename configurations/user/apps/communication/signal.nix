{
  config,
  lib,
  user,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.apps.${user}.communication.signal;
in {
  options = {
    apps.${user}.communication.signal = {
      enable = mkEnableOption "Install Signal.";
      package = mkOption {
        type = lib.types.package;
        default = pkgs.signal-desktop-bin;
        description = "Package to use for Signal.";
      };
    };
  };

  config = {
    environment.persistence = mkIf config.system.impermanence.enable {
      "/persist".users.${user}.directories = mkIf cfg.enable [
        ".config/Signal"
      ];
    };

    users.users.${user}.packages = mkIf cfg.enable [cfg.package];
  };
}
