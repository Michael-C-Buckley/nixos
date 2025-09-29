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

  environment.persistence."/cache".directories = [
    "/var/lib/ipex"
  ];

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

    # ZFS Volumes
    "/persist" = mkZfs "x570/nixos/persist";
    "/home" = mkZfs "x570/home";
    "/home/michael" = mkZfs "x570/home/michael";
    "/home/shawn" = mkZfs "x570/home/shawn";
  };
}
