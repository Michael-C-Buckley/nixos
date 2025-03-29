{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.types) bool package;
  cfg = config.custom.zfs;
in {
  options.custom.zfs = {
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

  config = {
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
