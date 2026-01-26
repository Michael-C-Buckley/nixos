{
  flake.modules.nixos.x570 = let
    mkZfs = device: neededForBoot: {
      inherit device neededForBoot;
      fsType = "zfs";
    };
  in {
    swapDevices = [];

    users.users = {
      michael.uid = 1000;
      shawn.uid = 1001;
    };

    custom.impermanence = {
      var.enable = false;
      home.enable = false;
    };

    services.sanoid.datasets = {
      "zroot/x570/nixos/persist".use_template = ["normal"];
      "zroot/x570/nixos/home/michael".use_template = ["normal"];
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
          "size=1G"
          "mode=755"
        ];
      };

      # local datasets
      "/cache" = mkZfs "zroot/local/cache" true;
      "/nix" = mkZfs "zroot/local/nix" true;
      "/media/games" = mkZfs "zroot/local/games" false;

      # ZFS Volumes
      "/persist" = mkZfs "zroot/x570/nixos/persist" true;
      "/var" = mkZfs "zroot/x570/nixos/var" true;
      "/home/michael" = mkZfs "zroot/x570/nixos/home/michael" true;
      "/home/shawn" = mkZfs "zroot/x570/nixos/home/shawn" true;
    };
  };
}
