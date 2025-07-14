{config, ...}: let
  inherit (config.networking) hostName;
in {
  system.gluster.enable = true;

  fileSystems = {
    "/data/gluster" = {
      device = "zroot/${hostName}/gluster";
      fsType = "zfs";
    };
  };
}
