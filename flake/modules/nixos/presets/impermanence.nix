# I use this as my starting point for the root filesystem for Impermanence with ZFS
{
  config,
  lib,
  ...
}: let
  inherit (config.networking) hostName;
  inherit (lib) mkOption mkIf;
  inherit (lib.types) str bool;
  inherit (config.system) impermanence;

  zfsFs = name: {
    device = "${impermanence.zrootPath}/${name}";
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  options.system.impermanence = {
    usePreset = mkOption {
      type = bool;
      default = true;
      description = "Configures the impermanence preset rules.";
    };
    zrootPath = mkOption {
      type = str;
      default = "zroot/${hostName}";
      description = "The ZFS dataset path for the root filesystem.";
    };
    tmpRootSize = mkOption {
      type = str;
      default = "1G";
      description = "The size of the tmpfs root partition.";
    };
  };

  config = mkIf (impermanence.enable && impermanence.usePreset) {
    system.zfs.enable = true;

    fileSystems = {
      "/boot" = {
        device = "/dev/disk/by-uuid/${config.system.boot.uuid}";
        fsType = "vfat";
      };

      # Tmpfs
      "/" = {
        device = "tmpfs";
        fsType = "tmpfs";
        options = [
          "defaults"
          "size=${impermanence.tmpRootSize}"
          "mode=755"
        ];
      };

      # ZFS Volumes
      "/tmp" = zfsFs "tmp";
      "/nix" = zfsFs "nix";
      "/cache" = zfsFs "cache";
      "/persist" = zfsFs "persist";
    };
  };
}
