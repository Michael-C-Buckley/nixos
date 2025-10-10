{
  flake.nixosModules.zfs = {
    config,
    pkgs,
    lib,
    ...
  }: let
    inherit (config.system) zfs;
  in {
    options.system.zfs = {
      encryption = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Request decryption credentials on boot.";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.zfs;
        description = "The ZFS package to use.";
      };
    };

    config = {
      boot = {
        kernelModules = ["zfs"];
        supportedFilesystems = ["zfs"];
        zfs.requestEncryptionCredentials = zfs.encryption;
      };

      environment.systemPackages = [zfs.package];
      services.zfs.autoScrub.enable = true;

      # https://github.com/openzfs/zfs/issues/10891
      systemd.services.systemd-udev-settle.enable = false;
    };
  };
}
