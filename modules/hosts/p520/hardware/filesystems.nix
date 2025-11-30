let
  pushToHDD = name: {
    source = "zroot/p520/${name}";
    target = "zhdd/backup/p520/${name}";
    recvOptions = "o compression=zstd";
  };
  zfsFs = device: {
    inherit device;
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  flake.modules.nixos.p520 = {
    boot.zfs.extraPools = ["zhdd"];

    services = {
      sanoid.datasets = {
        "zroot/p520/persist".useTemplate = ["short"];
        "zroot/p520/postgres".useTemplate = ["short"];
        "zhdd/backup/p520/persist".useTemplate = ["normal"];
        "zhdd/backup/p520/postgres".useTemplate = ["normal"];
      };
      syncoid = {
        enable = true;
        commands = {
          "persist-backup" = pushToHDD "persist";
          "postgres-backup" = pushToHDD "postgres";
        };
      };
    };

    fileSystems = {
      "/boot" = {
        device = "/dev/disk/by-uuid/BA57-3530";
        fsType = "vfat";
      };

      "/" = {
        device = "tmpfs";
        fsType = "tmpfs";
        options = [
          "defaults"
          "size=40G" # Big because it's a builder
          "mode=755"
        ];
      };

      # Essential System Volumes
      "/nix" = zfsFs "zroot/p520/nix";
      "/cache" = zfsFs "zroot/p520/cache";
      "/persist" = zfsFs "zroot/p520/persist";

      # Datasets
      "/var/lib/postgresql" = zfsFs "zroot/p520/postgres";
      "/var/lib/attic" = zfsFs "zroot/local/attic";

      # HDD Array
      "/data" = zfsFs "zhdd/data";
    };
  };
}
