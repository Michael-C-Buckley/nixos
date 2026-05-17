let
  parts = import ./_partitions.nix;
in {
  main1 = {
    device = "/dev/disk/by-id/nvme-CT2000P3PSSD8_2321E6DC0D72";
    content = {
      type = "gpt";
      partitions = {
        inherit (parts) boot swap zfs nvmeLvm;
      };
    };
  };
  main2 = {
    device = "/dev/disk/by-id/nvme-CT2000P3PSSD8_2321E6DC11CE";
    content = {
      type = "gpt";
      partitions = {
        inherit (parts) extraSwap swap zfs nvmeLvm;
      };
    };
  };

  optane = {
    device = "/dev/disk/by-id/nvme-eui.e4d25ce60f200100";
    content = {
      type = "gpt";
      partitions = {
        inherit (parts) optaneSwap optaneLvm;
      };
    };
  };
}
