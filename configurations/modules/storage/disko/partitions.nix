{config}: let
  inherit (config.features.disko.main) bootSize swapSize zfsSize;
in {
  boot = {
    alignment = 3;
    content = {
      format = "vfat";
      mountpoint = "/boot";
      type = "filesystem";
    };
    name = "boot";
    size = bootSize;
    start = "1M";
    type = "EF00";
  };
  swap = {
    alignment = 2;
    content = {
      type = "swap";
    };
    name = "swap";
    size = swapSize;
  };
  zfs = {
    alignment = 1;
    content = {
      pool = "zroot";
      type = "zfs";
    };
    name = "zfs";
    size = zfsSize;
  };
}
