_: let
  zfsFs = name: {
    device = "ZROOT/nixos/${name}";
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  boot.zfs.forceImportAll = true;

  fileSystems = {
    # Physical
    "/boot" = {
      device = "/dev/disk/by-uuid/3A0E-2554";
      fsType = "vfat";
    };

    # ZFS Volumes
    "/" = zfsFs "root";
    "/tmp" = zfsFs "tmp";
    "/nix" = zfsFs "nix";
    "/cache" = zfsFs "cache";
    "/persist" = zfsFs "persist";
  };
}
