{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.apps.communication.signal;
  imperm = config.system.impermanence.enable;
in {
  options = {
    apps.communication.signal = {
      enable = mkEnableOption "Install Signal.";
      package = mkOption {
        type = lib.types.package;
        default = pkgs.signal-desktop-bin;
        description = "Package to use for Signal.";
      };
    };
  };

  config = {
    packageList = mkIf cfg.enable [cfg.package];
    system.impermanence = mkIf (cfg.enable && imperm) {
      userPersistDirs = [
        ".config/Signal"
      ];
    };
  };
}
