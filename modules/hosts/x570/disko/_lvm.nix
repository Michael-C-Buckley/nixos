{
  nvme = {
    type = "lvm_vg";
    lvs = {
      # Cache volume for small metadata items unsuited for ZFS
      cache = {
        size = "100G";
        lvm_type = "raid0";
        content = {
          type = "filesystem";
          format = "ext4";
          mountpoint = "/media/cache";
        };
      };
    };
  };

  # Nothing yet
  optane = {
    type = "lvm_vg";
    lvs = {};
  };
}
