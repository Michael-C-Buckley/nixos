#!/usr/bin/env bash
set -euo pipefail

# ZFS Install Script for O1 (Oracle ARM instance)

ZFS_OPTS="-o ashift=12 \
  -O compression=zstd \
  -O atime=off \
  -O xattr=sa \
  -O acltype=posixacl \
  -O dnodesize=auto \
  -O normalization=formD \
  -O mountpoint=none"

hostname="o1"

read -rp "This will erase the drives, as you sure? [y/N]" confirm
if [[ $confirm =~ ^[Yy]$ ]]; then
  echo "Proceeding..."
else
  echo "Aborted."
  exit 1
fi

echo "Wiping drives..."
# Wipe the NVMe
wipefs -a /dev/sda
sgdisk --zap-all /dev/sda

echo "Formatting drives..."
# Put boot on the NVMe then fill the rest with ZFS
sgdisk -n1:1M:+512M -t1:EF00 -c1:"EFI System" /dev/sda
sgdisk -n2:0:+4G -t2:8200 -c2:"Linux Swap" /dev/sda
sgdisk -n3:0:0 -t3:BF01 -c3:"ZROOT" /dev/sda

# Format the boot partition
mkfs.vfat -F32 /dev/sda1

# Create the pool on the drive, use reasonable settings
echo "Creating zroot..."
zpool create -f $ZFS_OPTS zroot /dev/sda3

# Mount the drives and prepare for the install
mkdir -p /mnt
mkdir -p /mnt/{cache,nix,persist,tmp,boot}
mount /dev/sda3 /mnt/boot

# This create the zvols used in this cluster
zfs create -o mountpoint=none zroot/$hostname
for zvol in "tmp" "nix" "cache" "persist"; do
  zfs create -o mountpoint=legacy zroot/$hostname/$zvol
  mount -t zfs zroot/$hostname/$zvol /mnt/$zvol
done

# Update the boot drive reference
new_uuid=$(blkid -s UUID -o value /dev/sda3)
file=../default.nix
sed -i -E \
  "s|^([[:space:]]*system\.boot\.uuid[[:space:]]*=[[:space:]]*\")[0-9A-Fa-f-]+(\"[[:space:]]*;)|\1${new_uuid}\2|" \
  "$file"

echo "Updated UUID for $hostname"
