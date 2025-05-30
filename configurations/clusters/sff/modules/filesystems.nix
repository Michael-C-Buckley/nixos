{config, ...}: let
  inherit (config.networking) hostName;

  zfsFs = name: prefix : {
    device = "${prefix}/${hostName}/${name}";
    fsType = "zfs";
    neededForBoot = true;
  };

  zrootFs = name: zfsFs name "zroot";
  # zdataFs = name: zfsFs name "zdata";
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
    "/tmp" = zrootFs "tmp";
    "/nix" = zrootFs "nix";
    "/cache" = zrootFs "cache";
    "/persist" = zrootFs "persist";
  };

  swapDevices = [];
}
