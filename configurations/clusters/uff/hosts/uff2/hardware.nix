{...}: {
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/F50D-E713";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
  };

  swapDevices = [];
}
