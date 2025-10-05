let
  mkZfs = path: {
    device = "zroot/${path}";
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  system = {
    boot.uuid = "26BA-7AD8";
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

    # local datasets
    "/cache" = mkZfs "local/cache";
    "/nix" = mkZfs "local/nix";
    "/crypt" = mkZfs "local/crypt";
    "/media/games" = mkZfs "local/games";
    "/var/lib/ipex" = mkZfs "local/ollama"; # No compression, 1M record size

    # ZFS Volumes
    "/persist" = mkZfs "x570/nixos/persist";
  };
}
