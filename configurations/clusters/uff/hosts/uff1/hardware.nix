{...}: {
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/AB50-96FA";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
  };

  swapDevices = [];
}
