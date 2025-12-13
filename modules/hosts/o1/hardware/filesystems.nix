{
  flake.modules.nixos.o1 = let
    zfsFs = path: {
      device = "zroot/o1/${path}";
      fsType = "zfs";
      neededForBoot = true;
    };
  in {
    services.sanoid.datasets = {
      "zroot/o1/persist".use_template = ["normal"];
    };

    fileSystems = {
      "/boot" = {
        device = "/dev/disk/by-uuid/12CE-A600";
        fsType = "vfat";
      };

      "/" = {
        device = "tmpfs";
        fsType = "tmpfs";
        options = [
          "defaults"
          "size=4G"
          "mode=755"
        ];
      };

      # ZFS Volumes
      "/nix" = zfsFs "nix";
      "/cache" = zfsFs "cache";
      "/persist" = zfsFs "persist";

      "/var/lib/attic" = {
        device = "zroot/local/attic";
        fsType = "zfs";
      };
    };
  };
}
