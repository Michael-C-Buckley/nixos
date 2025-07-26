_: {
  system = {
    boot.uuid = "AFF4-A1EE";

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
