# I have split the disko config into several files as it's extremely
# verbose and nested if kept together, which is just hard to read
{
  disko = {
    zfs.enable = true;
    devices = {
      disk = import ./_disks.nix;
      lvm_vg = import ./_lvm.nix;
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
