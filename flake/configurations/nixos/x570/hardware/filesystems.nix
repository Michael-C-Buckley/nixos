_: {
  system = {
    boot.uuid = "AFF4-A1EE";

    impermanence = {
      enable = true;
      zrootPath = "zroot";
      tmpRootSize = "2G";
    };
  };

  fileSystems = {
    "/media/steam" = {
      device = "/dev/disk/by-uuid/7d9b6689-5ca7-4fb0-85e8-4b4298bdaa9a";
    };
  };
}
