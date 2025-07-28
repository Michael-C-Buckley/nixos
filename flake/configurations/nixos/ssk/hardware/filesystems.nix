_: let
  zfsFs = name: {
    device = "ZROOT/nixos/${name}";
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  system = {
    boot.uuid = "3A0E-2554";
    impermanence.enable = true;
  };

  # Preserve everything for root
  environment.persistence."/persist".directories = ["/root"];

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
