{
  mkBoot = size: {
    content = {
      format = "vfat";
      mountpoint = "/boot";
      type = "filesystem";
      mountOptions = [
        "fmask=0077"
        "dmask=0077"
        "noexec"
        "nodev"
        "nosuid"
      ];
    };
    name = "boot";
    inherit size;
    start = "1M";
    type = "EF00";
  };

  mkDisk = {
    device,
    partitions,
  }: {
    inherit device;
    content = {
      type = "gpt";
      inherit partitions;
    };
  };

  mkSwap = {
    size,
    priority,
  }: {
    inherit size;
    content = {
      type = "swap";
      inherit priority;
    };
  };

  mkZfs = {
    size,
    pool,
  }: {
    content = {
      inherit pool;
      type = "zfs";
    };
    name = "zfs";
    inherit size;
  };

  mkLvm = {
    size,
    vg,
  }: {
    content = {
      inherit vg;
      type = "lvm_pv";
    };
    inherit size;
  };
}
