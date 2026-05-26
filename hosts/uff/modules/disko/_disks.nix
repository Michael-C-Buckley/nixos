{flake, ...}: let
  parts = import ./_partitions.nix {inherit flake;};
  inherit (flake.lib.disko) mkDisk;
in {
  nvme = mkDisk {
    device = "/dev/nvme0n1";
    partitions = {
      inherit (parts) boot nvmeSwap nvmeZfs nvmeLvm;
    };
  };
  # sata = mkDisk {
  #   device = "/dev/sda";
  #   partitions = {
  #   };
  # };
}
