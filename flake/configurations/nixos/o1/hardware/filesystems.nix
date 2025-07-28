_: let
  zfsFs = path: {
    device = "zroot/o1/${path}";
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  system = {
    impermanence.enable = true;
    zfs.enable = true;
  };

  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=500M"
        "mode=755"
      ];
    };

    # ZFS Volumes
    "/nix" = zfsFs "nix";
    "/cache" = zfsFs "cache";
    "/persist" = zfsFs "persist";
  };
}
