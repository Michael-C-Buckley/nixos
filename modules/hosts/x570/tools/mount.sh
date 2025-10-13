#!/usr/bin/env bash

# For mounting all the drives
hostname="x570"

# Create hostnamed sets
for set in "home" "home/michael" "home/shawn" "nixos" "nixos/root" "nixos/persist"; do
  mkdir -p /mnt/$set
  mount -t zfs zroot/$hostname/$set /mnt/$set
done

# Mount system directories
for dir in "cache" "crypt" "nix"; do
  mkdir -p /mnt/$dir
  mount -t zfs zroot/local/$dir /mnt/$dir
done

mkdir -p /mnt/persist
mount -t zfs zroot/$hostname/nixos/persist /mnt/persist

# Mount user homes
for user in "michael" "shawn"; do
  mkdir -p /mnt/home/$user
  mount -t zfs zroot/$hostname/home/$user /mnt/home/$user
done

# Mount boot
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot

