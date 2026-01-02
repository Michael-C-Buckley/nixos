{
  flake.modules.nixos.x570 = let
    mkZfs = device: neededForBoot: {
      inherit device neededForBoot;
      fsType = "zfs";
    };
  in {
    swapDevices = [];

    custom.impermanence = {
      var.enable = true;
      home.enable = true;
    };

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
      "/cache" = mkZfs "zroot/local/cache" true;
      "/nix" = mkZfs "zroot/local/nix" true;
      "/media/games" = mkZfs "zroot/local/games" false;

      # ZFS Volumes
      "/persist" = mkZfs "zroot/x570/nixos/persist" true;
    };
  };
}
