let
  mkZfsLegacyFs = mount: {
    mountpoint = mount;
    options.mountpoint = "legacy";
    type = "zfs_fs";
  };
in {
  type = "zpool";
  datasets = {
    "nix" = mkZfsLegacyFs "/nix";
    "persist" = mkZfsLegacyFs "/persist";
    "cache" = mkZfsLegacyFs "/cache";
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
}
