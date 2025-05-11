{
  config,
  lib,
  user,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.apps.${user}.browsers.librewolf;
in {
  options = {
    apps.${user}.browsers.librewolf = {
      enable = mkEnableOption "Install Librewolf";
      package = mkOption {
        type = lib.types.package;
        default = pkgs.librewolf;
        description = "Package to use for Librewold";
      };
    };
  };

  config = {
    environment.persistence = mkIf config.system.impermanence.enable {
      "/persist".users.${user}.directories = mkIf cfg.enable [
        # Default profile location
        ".mozilla/librewolf"
        ".cache/mozilla/librewolf"
      ];
    };

    users.users.${user}.packages = mkIf cfg.enable [cfg.package];
  };
}
