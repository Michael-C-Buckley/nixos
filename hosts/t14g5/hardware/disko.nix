{inputs, ...}: {
  imports = [
    inputs.disko.nixosModules.disko
    inputs.disko-zfs.nixosModules.default
  ];
  disko.devices = {
    disk.main = {
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            alignment = 1;
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
          encryptedSwap = {
            size = "16G";
            content = {
              type = "swap";
              randomEncryption = true;
              priority = 100;
            };
          };
          zfs = {
            alignment = 3;
            content = {
              pool = "zroot";
              type = "zfs";
            };
            name = "zfs";
            size = "500G";
          };
        };
      };
    };
    zpool.zroot = {
      type = "zpool";
      options = {
        ashift = "12";
        autotrim = "on";
      };
      rootFsOptions = {
        acltype = "posixacl";
        atime = "off";
        compression = "lz4";
        normalization = "none";
        xattr = "sa";
      };
      datasets = {
        crypt = {
          options = {
            mountpoint = "legacy";
            encryption = "aes-128-gcm";
            keyformat = "passphrase";
            keylocation = "prompt";
          };
          type = "zfs_fs";
        };
        "crypt/nixos/home" = {
          mountpoint = "/home";
          options.mountpoint = "legacy";
          type = "zfs_fs";
        };
        "crypt/nixos/var" = {
          mountpoint = "/var";
          options.mountpoint = "legacy";
          type = "zfs_fs";
        };
        "crypt/nixos/var/lib" = {
          mountpoint = "/var/lib";
          options.mountpoint = "legacy";
          type = "zfs_fs";
        };
        "crypt/nixos/var/log" = {
          mountpoint = "/var/log";
          options = {
            mountpoint = "legacy";
            recordsize = "1M";
            compression = "zstd";
          };
          type = "zfs_fs";
        };
        nixos = {
          type = "zfs_fs";
          options.mountpoint = "none";
        };
        "nixos/nix" = {
          mountpoint = "/nix";
          options = {
            mountpoint = "legacy";
            recordsize = "32K";
          };
          type = "zfs_fs";
        };
        "nixos/root" = {
          mountpoint = "/";
          options.mountpoint = "legacy";
          type = "zfs_fs";
        };
      };
    };
  };
}
