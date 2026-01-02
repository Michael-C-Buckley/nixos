{
  flake.modules.nixos.b550 = let
    mkZfs = device: {
      inherit device;
      fsType = "zfs";
      neededForBoot = true;
    };
  in {
    swapDevices = [];

    custom.impermanence = {
      var.enable = true;
      home.enable = true;
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
          "size=6G"
          "mode=755"
        ];
      };

      # local datasets
      "/cache" = mkZfs "zroot/local/cache";
      "/nix" = mkZfs "zroot/local/nix";

      # ZFS Volumes
      "/persist" = mkZfs "zroot/b550/nixos/persist";
      "/var/lib/attic" = mkZfs "zroot/local/attic";
    };
  };
}
