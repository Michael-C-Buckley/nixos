let
  zfsFs = device: {
    inherit device;
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  boot.zfs.extraPools = ["zhdd"];

  # Just persist all of home for simplicity
  environment.persistence."/persist".directories = ["/home"];

  system = {
    boot.uuid = "BA57-3530";
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
    "/nix" = zfsFs "zroot/p520/nix";
    "/cache" = zfsFs "zroot/p520/cache";
    "/persist" = zfsFs "zroot/p520/persist";
    "/var/lib/postgresql" = zfsFs "zroot/p520/postgres";

    # HDD Array
    "/data" = zfsFs "zhdd/data";
  };
}
