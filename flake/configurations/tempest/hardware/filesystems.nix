_: let
  zfsFs = name: {
    device = "ztempest/${name}";
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  system = {
    boot.uuid = "159C-593C";
    impermanence.enable = true;
  };

  # Preserve everything for users
  environment.persistence."/persist".directories = [
    "/root"
    "/home/michael"
    "/home/shawn"
  ];

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

    # nixos is encrypted and local is not
    "/nix" = zfsFs "local/nix";
    "/cache" = zfsFs "nixos/cache";
    "/persist" = zfsFs "nixos/persist";
  };
}
