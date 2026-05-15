{
  # First drive will get the boot drive
  boot = {
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
    size = "5G";
    start = "1M";
    type = "EF00";
  };

  # Here's a bit of extra swap that takes up the same space as boot
  # It is lower priority than shared swap
  extraSwap = {
    size = "5G";
    content = {
      type = "swap";
      priority = 60;
    };
  };

  # This shared swap will effectively be "raided"
  swap = {
    size = "8G";
    content = {
      type = "swap";
      priority = 80;
    };
  };

  nvmeLvm = {
    size = "200G";
    content = {
      type = "lvm_pv";
      vg = "nvme";
    };
  };

  zfs = {
    content = {
      pool = "zroot";
      type = "zfs";
    };
    name = "zfs";
    size = "1000G";
  };

  optaneSwap = {
    size = "50%";
    content = {
      type = "swap";
      priority = 90;
    };
  };

  optaneLvm = {
    size = "50%";
    content = {
      type = "lvm_pv";
      vg = "optane";
    };
  };
}
