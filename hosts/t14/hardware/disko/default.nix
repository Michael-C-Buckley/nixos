{
  disko.devices = {
    disk."main" = {
      device = "/dev/nvme0n1";
      type = "disk";

      content = {
        type = "gpt";
        partitions = import ./partitions.nix;
      };
    };
    zpool."zroot" = import ./zroot.nix;
    nodev = import ./nodevs.nix;
  };
}
