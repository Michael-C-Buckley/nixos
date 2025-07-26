# Default ZFS configs
{
  config,
  lib,
  ...
}: let
  # WIP: Remove impermanence when denesting
  inherit (config.system.impermanence) zrootPath;
  zfsFs = name: {
    device = "${zrootPath}/${name}";
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  # define user partitions
  config = lib.mkIf config.system.zfs.enable {
    fileSystems = {
      "/home/michael" = zfsFs "home/michael";
      "/home/shawn" = zfsFs "home/shawn";
    };
  };
}
