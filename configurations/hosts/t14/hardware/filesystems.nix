_: let
  zfsFs = name: {
    device = "zroot/t14/nixos/${name}";
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  boot.zfs.forceImportAll = true;

  fileSystems = {
    # Physical
    "/boot" = {
      device = "/dev/disk/by-uuid/1A0C-115C";
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

    # ZFS Volumes
    #  Root and tmp are a fallbacks for tmpfs
    # "/" = zfsFs "nixroot";
    "/tmp" = zfsFs "tmp";
    "/nix" = zfsFs "nix";
    "/cache" = zfsFs "cache";
    "/persist" = zfsFs "persist";
  };
}
