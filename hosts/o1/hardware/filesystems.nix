{
  flake.modules.nixos.o1 = let
    base = [
      "cache"
      "home"
      "persist"
      "nix"
      "var"
    ];

    services = [
      "authentik"
      "forgejo"
      "postgresql"
      "vaultwarden"
    ];
  in {
    custom.impermanence = {
      var.enable = false;
      home.enable = true;
    };

    services.sanoid.datasets = {
      "zroot/o1/persist".use_template = ["normal"];
      "zroot/o1/services/postgresql".use_template = ["database"];
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
            "size=256M"
            "mode=755"
          ];
        };
        # Attic separate from services to not replicate
        "/var/lib/atticd/storage" = {
          device = "zroot/local/attic";
          fsType = "zfs";
        };
      }
      # Base volumes at the top level under root
      // builtins.listToAttrs (map (a: {
          name = "/${a}";
          value = {
            device = "zroot/o1/${a}";
            fsType = "zfs";
            neededForBoot = true;
          };
        })
        base)
      # My various services datasets for convenient segmentation
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
