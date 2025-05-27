_: let
  zfsFs = name: {
    device = "ZROOT/nixos/${name}";
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  boot.zfs.forceRoot = true;

  system.boot.uuid = "3A0E-2554";

  fileSystems = {
    # Tmpfs
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=2G"
        "mode=755"
      ];
    };
    "/tmp" = zfsFs "tmp";
    "/nix" = zfsFs "nix";
    "/cache" = zfsFs "cache";
    "/persist" = zfsFs "persist";
  };
}
