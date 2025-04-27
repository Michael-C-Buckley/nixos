{config}: let
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
  preCreateHook = ''
    mkdir -p /etc
    hostid=${config.networking.hostId}
    printf "\\x${hostid:0:2}\\x${hostid:2:2}\\x${hostid:4:2}\\x${hostid:6:2}" > /etc/hostid
  '';
  postCreateHook = ''
    zpool set multihost=on zroot
  '';
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
