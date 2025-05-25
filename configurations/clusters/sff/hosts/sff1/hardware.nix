{...}: {
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/DF19-0E9F";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
  };

  swapDevices = [];
}
