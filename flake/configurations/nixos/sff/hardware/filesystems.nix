_: let
  zfsFs = device: {
    inherit device;
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
        "size=1G"
        "mode=755"
      ];
    };

    # ZFS Volumes
    "/nix" = zfsFs "zroot/sff/nix";
    "/cache" = zfsFs "zroot/sff/cache";
    "/persist" = zfsFs "zroot/sff/persist";

    # Data
    "/storage" = zfsFs "zdata/storage";
    "/storage/services" = zfsFs "zdata/storage/services";
  };
}
