_: {
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/38fe9cd4-6d72-4b64-b9f9-85e3b3960b8a";
      fsType = "ext4";
    };

    "/local/llm" = {
      device = "/dev/disk/by-uuid/4c755769-a8bb-40be-9318-19f0534ef59e";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/2312-A651";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
  };
}
