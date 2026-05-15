let
  parts = import ./_partitions.nix;
in {
  main1 = {
    device = "/dev/nvme0n1";
    content = {
      type = "gpt";
      partitions = {
        inherit (parts) boot swap zfs;
      };
    };
  };
  main2 = {
    device = "/dev/nvme1n1";
    content = {
      type = "gpt";
      partitions = {
        inherit (parts) extraSwap swap zfs nvmeLvm;
      };
    };
  };

  optane = {
    device = "/dev/nvme2n1";
    content = {
      type = "gpt";
      partitions = {
        inherit (parts) optaneSwap optaneLvm;
      };
    };
  };
}
