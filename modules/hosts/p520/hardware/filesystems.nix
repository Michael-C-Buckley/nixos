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

    custom = {
      impermanence = {
        var.enable = true;
        home.enable = true;
      };
      k3s.impermanence = {
        use_cache = false;
      };
    };

    services = {
      sanoid.datasets = {
        "zroot/p520/persist".use_template = ["short"];
        "zroot/p520/postgres".use_template = ["short"];
        "zhdd/backup/p520/persist".use_template = ["normal"];
        "zhdd/backup/p520/postgres".use_template = ["normal"];
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
      "/var/lib/rancher/k3s/agent" = zfsFs "zhdd/k3s/agent";
    };
  };
}
