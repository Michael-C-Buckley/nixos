{config}: let
  mainDisko = config.features.disko.main;
in {
  boot = {
    alignment = 3;
    content = {
      format = "vfat";
      mountpoint = "/boot";
      type = "filesystem";
    };
    name = "boot";
    size = "500M";
    start = "1M";
    type = "EF00";
  };
  swap = {
    alignment = 2;
    content = {
      type = "swap";
    };
    name = "swap";
    size = mainDisko.swapSize;
  };
  zfs = {
    alignment = 1;
    content = {
      pool = "zroot";
      type = "zfs";
    };
    name = "zfs";
    size = "100%";
  };
}
