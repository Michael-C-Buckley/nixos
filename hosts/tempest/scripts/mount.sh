#! /usr/bin/env bash
# A simple script to mount the drive and partitions
# Be sure to unlock the pool first: zfs load-key -r ZROOT/nixos

set -euo pipefail

mountpoint -q /mnt && {
  echo "/mnt is already mounted. Exiting."
  exit 1
}

echo "Mounting root dataset..."
mkdir -p /mnt
mount -t zfs ZROOT/nixos/root /mnt

echo "Mounting USB's boot partition"
mkdir -p /mnt/boot
mount UUID=3A0E-2554 /mnt/boot

for i in "persist" "cache" "tmp" "nix"; do
  echo "Mounting $i dataset"
  mkdir -p /mnt/$i
  mount -t zfs ZROOT/nixos/$i /mnt/$i
done

echo "✅ NixOS system is mounted and ready. You can now run:"
echo "    nixos-enter --root /mnt"
