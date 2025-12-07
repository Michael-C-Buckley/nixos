{
  flake.modules.nixos.b550 = let
    mkZfs = path: {
      device = "zroot/${path}";
      fsType = "zfs";
      neededForBoot = true;
    };
  in {
    swapDevices = [];

    services.sanoid.datasets = {
      "zroot/b550/nixos/persist".use_template = ["normal"];
    };

    fileSystems = {
      "/boot" = {
        device = "/dev/disk/by-uuid/AAAA-AAAA";
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

      # ZFS Volumes
      "/persist" = mkZfs "b550/nixos/persist";
    };
  };
}
