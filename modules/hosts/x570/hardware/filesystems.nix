{
  flake.modules.nixos.x570 = let
    mkZfs = path: {
      device = "zroot/${path}";
      fsType = "zfs";
      neededForBoot = true;
    };
  in {
    swapDevices = [];

    services.sanoid.datasets = {
      "zroot/x570/nixos/persist".use_template = ["normal"];
    };

    fileSystems = {
      "/boot" = {
        device = "/dev/disk/by-uuid/26BA-7AD8";
        fsType = "vfat";
      };

      "/" = {
        device = "tmpfs";
        fsType = "tmpfs";
        options = [
          "defaults"
          "size=6G"
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
  };
}
