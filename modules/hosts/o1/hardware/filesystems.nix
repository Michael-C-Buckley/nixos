{
  flake.modules.nixos.o1 = let
    zfsFs = path: {
      device = "zroot/o1/${path}";
      fsType = "zfs";
      neededForBoot = true;
    };
  in {
    custom.impermanence = {
      var.enable = false;
      home.enable = true;
    };

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
          "size=1G"
          "mode=755"
        ];
      };

      # ZFS Volumes
      "/nix" = zfsFs "nix";
      "/cache" = zfsFs "cache";
      "/persist" = zfsFs "persist";
      "/var" = zfsFs "var";

      "/var/lib/atticd" = {
        device = "zroot/local/attic";
        fsType = "zfs";
      };

      "/var/lib/postgres" = {
        device = "zroot/o1/postgres";
        fsType = "zfs";
      };

      "var/lib/authentik" = {
        device = "zroot/o1/authentik";
        fsType = "zfs";
      };

      "/var/lib/vaultwarden" = {
        device = "zroot/o1/vaultwarden";
        fsType = "zfs";
      };
    };
  };
}
