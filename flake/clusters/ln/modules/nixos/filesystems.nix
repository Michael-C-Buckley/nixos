{
  config,
  lib,
  ...
}: let
  inherit (config.networking) hostName;
in {
  system = {
    zfs.enable = true;
    impermanence.enable = lib.mkDefault true;
  };

  # WIP: temporary directories for users
  fileSystems = {
    "/home/michael" = {
      device = "zroot/${hostName}/home/michael";
      fsType = "zfs";
      neededForBoot = true;
    };
    "/home/shawn" = {
      device = "zroot/${hostName}/home/shawn";
      fsType = "zfs";
      neededForBoot = true;
    };
  };

  swapDevices = [];
}
