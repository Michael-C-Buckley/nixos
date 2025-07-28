_: let
  zfsFs = device: {
    inherit device;
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  boot.zfs = {
    extraPools = ["zhdd"];
  };
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
    "/nix" = zfsFs "zroot/p520/nix";
    "/cache" = zfsFs "zroot/p520/cache";
    "/persist" = zfsFs "zroot/p520/persist";

    # HDD Array
    "/data" = zfsFs "zhdd/data";
  };
}
