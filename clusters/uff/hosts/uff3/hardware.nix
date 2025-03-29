{...}: {
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/28FA-4449";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };

  swapDevices = [];
}
