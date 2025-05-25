{config, ...}: let
  inherit (config.networking) hostName;
  zfsFs = name: {
    device = "zroot/${hostName}/${name}";
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  system = {
    impermanence.enable = true;
    zfs.enable = true;
  };

  fileSystems = {
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
    "/tmp" = zfsFs "tmp";
    "/nix" = zfsFs "nix";
    "/cache" = zfsFs "cache";
    "/persist" = zfsFs "persist";
  };
}
