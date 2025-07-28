_: let
  zfsFs = path: {
    device = "zroot/x370/${path}";
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  system = {
    boot.uuid = "B187-B440";
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
