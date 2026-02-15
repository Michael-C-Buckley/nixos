{
  flake.modules.nixos.b550 = let
    mkZfs = device: {
      inherit device;
      fsType = "zfs";
    };

    mkZfsBoot = device: {
      inherit device;
      fsType = "zfs";
      neededForBoot = true;
    };
  in {
    swapDevices = [];

    custom.impermanence = {
      var.enable = false;
      home.enable = false;
    };

    services.sanoid.datasets = {
      "zroot/b550/nixos/persist".use_template = ["normal"];
    };

    fileSystems = {
      "/boot" = {
        device = "/dev/disk/by-uuid/E09B-A739";
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
      "/cache" = mkZfsBoot "zroot/local/cache";
      "/nix" = mkZfsBoot "zroot/local/nix";

      # ZFS Volumes
      "/persist" = mkZfsBoot "zroot/b550/nixos/persist";
      "/var" = mkZfsBoot "zroot/b550/nixos/var";
      "/home" = mkZfsBoot "zroot/b550/nixos/home";

      "/var/lib/attic" = mkZfs "zroot/local/attic";
      "/var/lib/docker" = mkZfs "zhdd/var/docker";
    };
  };
}
