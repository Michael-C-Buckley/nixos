{
  flake.modules.uff.uff3 = let
    zfsFs = path: {
      device = "zroot/uff3/${path}";
      fsType = "zfs";
      neededForBoot = true;
    };
  in {
    system = {
      impermanence.enable = true;
      gluster.enable = true;
      zfs.enable = true;
    };

    fileSystems = {
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
      "/data/gluster" = zfsFs "gluster";
    };
  };
}
