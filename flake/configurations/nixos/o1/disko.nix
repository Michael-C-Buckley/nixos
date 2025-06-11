_: let
  zfsFs = mount: {
    mountpoint = mount;
    options.mountpoint = "legacy";
    type = "zfs_fs";
  };
in {
  disko.devices = {
    disk."main" = {
      content = {
        type = "gpt";
        partitions = {
          boot = {
            alignment = 3;
            content = {
              format = "vfat";
              mountpoint = "/boot";
              type = "filesystem";
            };
            name = "boot";
            size = "512M";
            start = "1M";
            type = "EF00";
          };
          swap = {
            alignment = 2;
            content = {
              type = "swap";
            };
            name = "swap";
            size = "4G";
          };
          zfs = {
            alignment = 1;
            content = {
              pool = "zroot";
              type = "zfs";
            };
            name = "zfs";
            size = "100%";
          };
        };
      };
      device = "/dev/sda";
      imageSize = "200G";
      type = "disk";
    };
    zpool."zroot" = {
      type = "zpool";
      datasets = {
        "nix" = zfsFs "/nix";
        "persist" = zfsFs "/persist";
        "cache" = zfsFs "/cache";
        "tmp" = zfsFs "/tmp";
      };
      options = {
        ashift = "12";
        autotrim = "on";
      };
      rootFsOptions = {
        acltype = "posixacl";
        atime = "off";
        compression = "zstd";
        normalization = "none";
        xattr = "sa";
      };
    };
  };
}
