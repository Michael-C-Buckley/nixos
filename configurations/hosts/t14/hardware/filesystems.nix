_: let
  zfsFs = name: {
    device = "zroot/t14/nixos/${name}";
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  boot.zfs.forceImportAll = true;

  system.boot.uuid  = "1A0C-115C";

  fileSystems = {
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
    "/tmp" = zfsFs "tmp";
    "/nix" = zfsFs "nix";
    "/cache" = zfsFs "cache";
    "/persist" = zfsFs "persist";
  };
}
