{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkOption mkIf;
  inherit (lib.types) bool package;
  cfg = config.system.zfs;
in {
  options.system.zfs = {
    enable = mkOption {
      type = bool;
      default = true;
      description = "Enable ZFS features on host.";
    };
    encryption = mkOption {
      type = bool;
      default = false;
      description = "Request decryption credentials on boot.";
    };
    package = mkOption {
      type = package;
      default = pkgs.zfs;
      description = "The ZFS package to use.";
    };
  };

  config = mkIf cfg.enable {
    boot = {
      kernelModules = ["zfs"];
      supportedFilesystems = ["zfs"];
      zfs = {
        forceImportRoot = false;
        requestEncryptionCredentials = cfg.encryption;
      };
    };

    environment.systemPackages = [cfg.package];
    services.zfs.autoScrub.enable = true;
  };
}
