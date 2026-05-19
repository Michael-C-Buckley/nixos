let
  zfsFs = name: {
    device = "ztempest/${name}";
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  boot.zfs.requestEncryptionCredentials = true;

  fileSystems = {
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
        "size=1G"
        "mode=755"
      ];
    };

    # nixos is encrypted and local is not
    "/nix" = zfsFs "local/nix";
    "/cache" = zfsFs "nixos/cache";
    "/persist" = zfsFs "nixos/persist";
  };
}
