{
  flake.modules.nixos.tempest = let
    zfsFs = name: {
      device = "ztempest/${name}";
      fsType = "zfs";
      neededForBoot = true;
    };
  in {
    custom.impermanence = {
      var.enable = true;
      home.enable = true;
    };

    # Preserve everything for users
    environment.persistence."/persist".directories = [
      "/root"
      "/home/michael"
      "/home/shawn"
      "/etc/sops"
    ];

    boot.zfs.requestEncryptionCredentials = true;

    fileSystems = {
      "/etc/sops".neededForBoot = true;

      "/boot" = {
        device = "/dev/disk/by-uuid/159C-593C";
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

      # nixos is encrypted and local is not
      "/nix" = zfsFs "local/nix";
      "/cache" = zfsFs "nixos/cache";
      "/persist" = zfsFs "nixos/persist";
    };
  };
}
