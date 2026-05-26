{flake, ...}: let
  parts = import ./_partitions.nix {inherit flake;};
  inherit (flake.lib.disko) mkDisk;
in {
  main1 = mkDisk {
    device = "/dev/disk/by-id/nvme-CT2000P3PSSD8_2321E6DC0D72";
    partitions = {
      inherit (parts) boot swap zfs nvmeLvm;
    };
  };
  main2 = mkDisk {
    device = "/dev/disk/by-id/nvme-CT2000P3PSSD8_2321E6DC11CE";
    partitions = {
      inherit (parts) extraSwap swap zfs nvmeLvm;
    };
  };

  optane = mkDisk {
    device = "/dev/disk/by-id/nvme-eui.e4d25ce60f200100";
    partitions = {
      inherit (parts) optaneSwap optaneLvm;
    };
  };
}
