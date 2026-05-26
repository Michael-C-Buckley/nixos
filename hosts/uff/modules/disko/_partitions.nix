{flake, ...}: let
  inherit (flake.lib.disko) mkBoot mkSwap mkZfs mkLvm;
in {
  boot = mkBoot "1G";
  nvmeSwap = mkSwap {
    size = "8G";
    priority = 100;
  };
  nvmeZfs = mkZfs {
    size = "400G";
    pool = "zroot";
  };
  nvmeLvm = mkLvm {
    size = "65G";
    vg = "nvme";
  };

  # Include SATA ones
}
