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

    "/home/michael" = {
      device = "zroot/p520/home/michael";
      fsType = "zfs";
      neededForBoot = true;
      options = ["defaults" "uid=1000" "gid=100"];
    };
    "/home/shawn" = {
      device = "zroot/p520/home/shawn";
      fsType = "zfs";
      neededForBoot = true;
      options = ["defaults" "uid=1001" "gid=100"];
    };

    # HDD Array
    "/data" = zfsFs "zhdd/data";
  };
}
