#!/usr/bin/env bash
set -euo pipefail

# ZFS Install Script for the cluster

ZFS_OPTS="-o ashift=12 \
  -O compression=zstd \
  -O atime=off \
  -O xattr=sa \
  -O acltype=posixacl \
  -O dnodesize=auto \
  -O normalization=formD \
  -O mountpoint=none"

read -rp "Enter hostname for this server: " hostname
echo "You entered: $hostname"

read -rp "This will erase the drives, as you sure? [y/N]" confirm
if [[ $confirm =~ ^[Yy]$ ]]; then
  echo "Proceeding..."
else
  echo "Aborted."
  exit 1
fi

echo "Wiping drives..."
# Wipe the NVMe
wipefs -a /dev/nvme0n1
sgdisk --zap-all /dev/nvme0n1
# Wipe the SATA HDD
wipefs -a /dev/sda
sgdisk --zap-all /dev/sda

echo "Formatting drives..."
# Put boot on the NVMe then fill the rest with ZFS
sgdisk -n1:1M:+1G -t1:EF00 -c1:"EFI System" /dev/nvme0n1
sgdisk -n2:0:0 -t2:BF01 -c2:"ZROOT" /dev/nvme0n1

# Format the boot partition
mkfs.vfat -F32 /dev/nvme0n1p1

# Format the HDD
sgdisk -n1:0:0 -t1:BF01 -c1:"ZDATA" /dev/sda

# Create the pool on the drive, use reasonable settings
echo "Creating zroot..."
zpool create -f $ZFS_OPTS zroot /dev/nvme0n1p2

echo "Creating zdata..."
zpool create -f $ZFS_OPTS zdata /dev/sda1

# Mount the drives and prepare for the install
mkdir -p /mnt
mkdir -p /mnt/{cache,nix,persist,tmp,boot}
mount /dev/nvme0n1p1 /mnt/boot

# This create the zvols used in this cluster
zfs create -o mountpoint=none zroot/$hostname
for zvol in "tmp" "nix" "cache" "persist"; do
  zfs create -o mountpoint=legacy zroot/$hostname/$zvol
  mount -t zfs zroot/$hostname/$zvol /mnt/$zvol
done

# Update the boot drive reference
new_uuid=$(blkid -s UUID -o value /dev/nvme0n1p1)
file=../hosts/$hostname/default.nix
sed -i -E \
  "s|^([[:space:]]*system\.boot\.uuid[[:space:]]*=[[:space:]]*\")[0-9A-Fa-f-]+(\"[[:space:]]*;)|\1${new_uuid}\2|" \
  "$file"

echo "Updated UUID for $hostname"

# Lastly, deploy the secrets
key=/etc/nix/secrets/crypt/age/uff.sops
persist_dir=/mnt/persist/etc/sops
mkdir -p $persist_dir

for key in ed25519 rsa; do
  sops -d "$key" >${persist_dir}/age.txt
  chmod 0600 ${persist_dir}/ssh_host_${key}_key
done
