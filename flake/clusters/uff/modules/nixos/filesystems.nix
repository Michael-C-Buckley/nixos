{config, ...}: let
  inherit (config.networking) hostName;

  zfsFs = name: prefix: {
    device = "${prefix}/${hostName}/${name}";
    fsType = "zfs";
    neededForBoot = true;
  };

  zrootFs = name: zfsFs name "zroot";
  # zdataFs = name: zfsFs name "zdata";
in {
  system = {
    impermanence.enable = true;
    zfs.enable = true;
    gluster.enable = true;
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
    "/tmp" = zrootFs "tmp";
    "/nix" = zrootFs "nix";
    "/cache" = zrootFs "cache";
    "/persist" = zrootFs "persist";
  };
}
