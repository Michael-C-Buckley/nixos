_: {
  system = {
    boot.uuid = "26BA-7AD8";

    impermanence = {
      usePreset = false;
      usePreset2 = true;
      enable = true;
      zrootPath = "zroot";
      tmpRootSize = "2G";
    };
  };

  fileSystems = {
    "/media/games" = {
      device = "zroot/local/games";
      fsType = "zfs";
      neededForBoot = true;
    };
  };
}
