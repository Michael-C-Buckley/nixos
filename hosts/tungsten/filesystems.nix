{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/fc16390f-90f1-4c5b-80d2-800cadb9e2ae";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/FA0E-8AA8";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
        "noexec"
        "nodev"
        "nosuid"
      ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/aede04a9-9d72-41e1-8c41-02254789be8f";
      fsType = "ext4";
    };
  };
}
