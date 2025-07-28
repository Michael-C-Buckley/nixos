_: let
  zfsFs = name: {
    device = "zroot/t14/nixos/${name}";
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  swapDevices = [];

  system = {
    boot.uuid = "1A0C-115C";
    impermanence.enable = true;
    zfs.enable = true;
  };
  fileSystems = {
    # Tmpfs
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
