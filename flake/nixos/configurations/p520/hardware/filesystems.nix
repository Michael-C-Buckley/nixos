let
  zfsFs = device: {
    inherit device;
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  boot.zfs.extraPools = ["zhdd"];

  environment.persistence."/persist".directories = [
    "/var/lib/quadlet"
  ];

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

    # Essential System Volumes
    "/nix" = zfsFs "zroot/p520/nix";
    "/cache" = zfsFs "zroot/p520/cache";
    "/persist" = zfsFs "zroot/p520/persist";

    # Datasets
    "/var/lib/postgresql" = zfsFs "zroot/p520/postgres";
    "/var/lib/ollama" = zfsFs "zroot/local/ollama";

    # HDD Array
    "/data" = zfsFs "zhdd/data";
  };
}
