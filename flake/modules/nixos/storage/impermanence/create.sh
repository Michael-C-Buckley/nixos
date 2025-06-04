# Reference guide only
# Use as-is at your own risk
zpool create -o ashift=12 \
  -O compression=zstd \
  -O atime=off \
  -O xattr=sa \
  -O acltype=posixacl \
  -O dnodesize=auto \
  -O normalization=formD \
  -O mountpoint=none \
  -O encryption=on \
  -O keyformat=passphrase \
  -O keylocation=prompt \
  zroot /dev/nvme0n1p3

# Create all the ZFS volumes
zfs create -o mountpoint=legacy zroot/nixroot
zfs create -o mountpoint=legacy zroot/tmp
zfs create -o mountpoint=legacy zroot/nix
zfs create -o mountpoint=legacy zroot/cache
zfs create -o mountpoint=legacy zroot/persist

# Mount root
mount -t zfs zroot/nixroot /mnt
# Create the rest of the mount points
mkdir -p /mnt/{etc,nix,home,boot,persist,cache}
# Mount the rest
mount -t zfs zroot/nix /mnt/nix
mount -t zfs zroot/persist /mnt/persist
mount -t zfs zroot/cache /mnt/cache
