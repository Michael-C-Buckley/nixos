# I have split the disko config into several files as it's extremely
# verbose and nested if kept together, which is just hard to read
let
  parts = import ./_partitions.nix;
in
  {inputs, ...}: {
    flake.modules.nixos.x570 = {
      imports = [
        inputs.disko.nixosModules.disko
        inputs.disko-zfs.nixosModules.default
      ];
      # WARNING: Must absolutely make sure of the device names at install time
      disko.devices = {
        disk.main1 = {
          device = "/dev/nvme0n1";
          content = {
            type = "gpt";
            partitions = {
              inherit (parts) boot swap zfs;
            };
          };
        };
        disk.main2 = {
          device = "/dev/nvme1n1";
          content = {
            type = "gpt";
            partitions = {
              inherit (parts) extraSwap swap zfs;
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
          datasets = import ./_datasets.nix;
        };
      };
    };
  }
