{config, ...}: let
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
            size = "1G";
            start = "1M";
            type = "EF00";
          };
          swap = {
            alignment = 2;
            content = {
              type = "swap";
            };
            name = "swap";
            size = "2G";
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
      imageSize = "49G";
      type = "disk";
    };
    zpool."zroot" = {
      type = "zpool";
      preCreateHook = ''
        hostid=${config.networking.hostId}
        printf "\\x${hostid:0:2}\\x${hostid:2:2}\\x${hostid:4:2}\\x${hostid:6:2}" > /etc/hostid
      '';
      postCreateHook = ''
        zpool set multihost=on zroot
      '';
      datasets = {
        "nix" = zfsFs "/nix";
        "root" = zfsFs "/";
        "home" = zfsFs "/home";
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
