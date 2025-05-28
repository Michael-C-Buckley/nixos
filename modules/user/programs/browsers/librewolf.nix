{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.programs.librewolf;
  imperm = config.system.impermanence.enable;
in {
  options = {
    programs.librewolf = {
      enable = mkEnableOption "Install Librewolf";
      package = mkOption {
        type = lib.types.package;
        default = pkgs.librewolf;
        description = "Package to use for Librewold";
      };
    };
  };

  config = {
    packageList = mkIf cfg.enable [cfg.package];
    system.impermanence = mkIf (cfg.enable && imperm) {
      userPersistDirs = [
        # Default profile location
        ".librewolf"
        ".mozilla/librewolf"
        ".cache/mozilla/librewolf"
      ];
    };
  };
}
