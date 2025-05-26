{config, ...}: let
  inherit (config.networking) hostName;
  zfsFs = name: {
    device = "zroot/${hostName}/${name}";
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  system = {
    impermanence.enable = true;
    zfs.enable = true;
  };

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
        "size=2G"
        "mode=755"
      ];
    };
    "/tmp" = zfsFs "tmp";
    "/nix" = zfsFs "nix";
    "/cache" = zfsFs "cache";
    "/persist" = zfsFs "persist";
  };

  swapDevices = [];
}
