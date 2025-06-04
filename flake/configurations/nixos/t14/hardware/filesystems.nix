_: {
  boot.zfs.forceImportAll = true;

  swapDevices = [];

  system = {
    boot.uuid = "1A0C-115C";
    impermanence = {
      enable = true;
      zrootPath = "zroot/t14/nixos";
      tmpRootSize = "2G";
    };
    zfs.enable = true;
  };
}
