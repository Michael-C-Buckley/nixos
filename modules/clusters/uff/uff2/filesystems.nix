{
  flake.modules.nixos.uff2 = let
    zfsFs = path: {
      device = "zroot/uff2/${path}";
      fsType = "zfs";
      neededForBoot = true;
    };
  in {
    custom.impermanence = {
      var.enable = true;
      home.enable = true;
    };

    fileSystems = {
      "/boot" = {
        device = "/dev/disk/by-uuid/E8D1-BB86";
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
    };
  };
}
