{
  boot = {
    alignment = 3;
    content = {
      format = "vfat";
      mountpoint = "/boot";
      type = "filesystem";
    };
    name = "boot";
    size = "500M";
    start = "1M";
    type = "EF00";
    label = "BOOTDEV";
  };

  swap = {
    alignment = 2;
    content = {
      type = "swap";
    };
    name = "swap";
    size = "8G";
  };

  zfs = {
    alignment = 1;
    content = {
      pool = "zroot";
      type = "zfs";
    };
    name = "zfs";
    size = "250G";
    label = "ZFSDEV";
  };
  
  # Pre-provisioning, future plans
  btrfs = {
    size = "150G";
    type = "8300";
    label = "BTRFSDEV";
    content = {
      type = "filesystem";
      format = "btrfs";
      mountpoint = null;
    };
  };

  # Pre-provisioning, future plans
  lvm = {
    size = "150G";
    type = "8e00";
    label = "LVMDEV";
    content = {
      type = "lvm_pv";
      vg = "t14";
    };
  };

  windows = {
    size = "200G";
    type = "0700";
    label = "WIN11";
    # content = {
    #   type = "blank";
    # };
  };
}
