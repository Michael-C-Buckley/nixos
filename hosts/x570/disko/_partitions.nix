{flake, ...}: let
  inherit (flake.lib.disko) mkBoot mkSwap mkZfs mkLvm;
in {
  # First drive will get the boot drive
  boot = mkBoot "5G";

  # Here's a bit of extra swap that takes up the same space as boot
  # It is lower priority than shared swap
  extraSwap = mkSwap {
    size = "5G";
    priority = 60;
  };

  # This shared swap will effectively be "raided"
  swap = mkSwap {
    size = "8G";
    priority = 80;
  };

  nvmeLvm = mkLvm {
    size = "200G";
    vg = "nvme";
  };

  zfs = mkZfs {
    size = "1000G";
    pool = "zroot";
  };

  optaneSwap = mkSwap {
    size = "6500M";
    priority = 90;
  };

  optaneLvm = mkLvm {
    size = "6500M";
    vg = "optane";
  };
}
