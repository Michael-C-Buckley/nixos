#!/usr/bin/env bash

# ZFS Install Script for X570
# 2x2 TB NVMe that will be striped

ZFS_OPTS="-o ashift=12 \
  -O compression=lz4 \
  -O atime=off \
  -O xattr=sa \
  -O acltype=posixacl \
  -O dnodesize=auto \
  -O normalization=formD \
  -O mountpoint=none"

hostname="x570"

read -rp "This will erase the NVMe drives, as you sure? [y/N]" confirm
if [[ $confirm =~ ^[Yy]$ ]]; then
  for dev in /dev/nvme{0,1}n1; do
    echo "Erasing NVMe ${dev}..."
    wipefs -a $dev
    sgdisk --zap-all $dev
    zpool labelclear -f $dev

    # Format the partitions
    sgdisk -n1:1M:+2G -t1:EF00 -c1:"EFI System" $dev
    sgdisk -n2:0:+1500G -t2:BF01 -c2:"ZROOT" $dev

    # Windows
    sgdisk -n3:0:+200G -t3:0700 -c3:"Windows" $dev
    mkfs.ntfs -f {$dev}p3

    # Format the first partition
    mkfs.vfat -F32 {$dev}p1
  done

  # Format for the striped ZFS pool
  zpool create -f "$ZFS_OPTS" zroot /dev/nvme0n1p2 /dev/nvme1n1p2
else
  echo "Skipping NVMe wipe."
fi

# Create local datasets
zfs create -o mountpoint=none zroot/local
for set in "crypt" "cache" "games"; do
  zfs create -o mountpoint=legacy zroot/local/$set
done
# Nix store gets higher compression
zfs create -o mountpoint=legacy -o compression=zstd zroot/local/nix

# Create hostnamed sets
zfs create -o mountpoint=none zroot/$hostname
for set in "home" "home/michael" "home/shawn" "nixos" "nixos/root" "nixos/persist"; do
  zfs create -o mountpoint=legacy zroot/$hostname/$set
  mount -t zfs zroot/$hostname/$set /mnt/$set
done

# Mount system directories
for dir in "cache" "crypt" "nix"; do
  mkdir -p /mnt/$dir
  mount -t zfs zroot/local/$dir /mnt/$dir
done
mkdir -p /mnt/persist
mount -t zfs zroot/$hostname/nixos/persist

# Mount user homes
for user in "michael" "shawn"; do
  mkdir -p /mnt/home/$user
  mount -t zfs zroot/$hostname/home/$user /mnt/home/$user
done

# Mount boot
mkdir -p /mnt/boot
mount /dev/nvme0n0p1 /mnt/boot

# Update the boot drive reference
new_uuid=$(blkid -s UUID -o value /dev/nvme0n1p1)
file=../hosts/$hostname/default.nix
sed -i -E \
  "s|^([[:space:]]*system\.boot\.uuid[[:space:]]*=[[:space:]]*\")[0-9A-Fa-f-]+(\"[[:space:]]*;)|\1${new_uuid}\2|" \
  "$file"

echo "Updated UUID for $hostname"

key=/etc/nix/secrets/crypt/age/x570.sops
persist_dir=/mnt/persist/etc/sops
mkdir -p $persist_dir
sops -d "$key" >${persist_dir}/age.txt
chmod 0600 ${persist_dir}/age.txt
