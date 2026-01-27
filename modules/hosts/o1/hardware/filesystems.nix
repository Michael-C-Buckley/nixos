{
  flake.modules.nixos.o1 = let
    zfsFs = mount: {
      device = "zroot/o1/${mount}";
      fsType = "zfs";
      neededForBoot = true;
    };

    services = [
      "authentik"
      "forgejo"
      "postgres"
      "vaultwarden"
    ];
  in {
    custom.impermanence = {
      var.enable = false;
      home.enable = true;
    };

    services.sanoid.datasets = {
      "zroot/o1/persist".use_template = ["normal"];
      "zroot/o1/services/postgres".use_template = ["database"];
    };

    fileSystems =
      {
        "/boot" = {
          device = "/dev/disk/by-uuid/12CE-A600";
          fsType = "vfat";
        };

        "/" = {
          device = "tmpfs";
          fsType = "tmpfs";
          options = [
            "defaults"
            "size=256G"
            "mode=755"
          ];
        };

        # ZFS Volumes
        "/nix" = zfsFs "nix";
        "/cache" = zfsFs "cache";
        "/persist" = zfsFs "persist";
        "/var" = zfsFs "var";
        "/home" = zfsFs "home";

        # Attic separate from services to not replicate
        "/var/lib/atticd" = {
          device = "zroot/local/attic";
          fsType = "zfs";
        };
      }
      // builtins.listToAttrs (map (a: {
          name = "/var/lib/${a}";
          value = {
            device = "zroot/o1/services/${a}";
            fsType = "zfs";
          };
        })
        services);
  };
}
