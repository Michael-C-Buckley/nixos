{
  flake.modules.nixos.uff3 = let
    zfsFs = path: {
      device = "zroot/uff3/${path}";
      fsType = "zfs";
      neededForBoot = true;
    };
  in {
    custom.impermanence = {
      var.enable = false;
      home.enable = false;
    };

    fileSystems = {
      "/boot" = {
        device = "/dev/disk/by-uuid/1555-62FA";
        fsType = "vfat";
      };
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
      "/var/lib/longhorn" = zfsFs "longhorn";
      "/var" = zfsFs "var";
      "/home" = zfsFs "home";
    };
  };
}
