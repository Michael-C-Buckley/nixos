{ lib }:
with lib.kernel;
lib.mapAttrs (_: lib.mkForce) {
  # Keep core boot functionality independently of the module observations.
  MODULES = yes;
  BLK_DEV_INITRD = yes;
  DEVTMPFS = yes;
  EFI = yes;
  EFI_STUB = yes;

  # All hosts share these capabilities, including during the ZFS migration.
  BTRFS_FS = module;
  XFS_FS = module;
  VFAT_FS = module;
  FUSE_FS = module;
  OVERLAY_FS = module;
  BLK_DEV_DM = module;
  DM_CRYPT = module;
  DM_SNAPSHOT = module;
  DM_RAID = module;
  KVM = module;
  KVM_AMD = module;
  VIRTIO_FS = module;
  NET_9P = module;
  NET_9P_VIRTIO = module;
  "9P_FS" = module;
  BRIDGE = module;
  BRIDGE_NETFILTER = module;
  VETH = module;
  TUN = module;
  WIREGUARD = module;
  NF_TABLES = module;
  NF_CONNTRACK = module;
  NF_NAT = module;

  # ZFS/SPL are external modules supplied by kernelPackages.zfs_cachyos.
}
