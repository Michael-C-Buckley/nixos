#!/usr/bin/env bash
set -euo pipefail

# ZFS Install Script for P520 Workstation Server

INTEL=/dev/disk/by-id/nvme-INTEL_SSDPE2KX010T8_BTLJ9103057V1P0FGN_1
SAMSUNG1=/dev/disk/by-id/nvme-Samsung_SSD_980_1TB_S64ANS0T100673K
SAMSUNG2=/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_1TB_S5P2NC0RA09780V

ZFS_OPTS="-o ashift=12 \
  -O compression=zstd \
  -O atime=off \
  -O xattr=sa \
  -O acltype=posixacl \
  -O dnodesize=auto \
  -O normalization=formD \
  -O mountpoint=none"

hostname="p520"

echo "---- P520 Install ----"
read -rp "This will erase the drives, as you sure? [y/N]" confirm
if [[ $confirm =~ ^[Yy]$ ]]; then
  echo "Proceeding..."
else
  echo "Aborted."
  exit 1
fi

echo "Wiping drives..."
# Wipe the NVMe drives
for i in $INTEL $SAMSUNG1 $SAMSUNG2; do
    wipefs -a $i
    sgdisk --zap-all $i
done

echo "Formatting drives..."
# Put boot on the NVMe DC drive
sgdisk -n1:1M:+512M -t1:EF00 -c1:"EFI System" $INTEL
mkfs.vfat -F32 "$INTEL"-part1

# Create the pool on the drive, use reasonable settings
echo "Creating zroot..."
zpool create $ZFS_OPTS zroot $SAMSUNG1 $SAMSUNG2

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
file=../default.nix
sed -i -E \
  "s|^([[:space:]]*system\.boot\.uuid[[:space:]]*=[[:space:]]*\")[0-9A-Fa-f-]+(\"[[:space:]]*;)|\1${new_uuid}\2|" \
  "$file"

echo "Updated UUID for $hostname"

# Lastly, deploy the secrets
key_dir=/etc/nix/secrets/crypt/ssh/$hostname
persist_dir=/mnt/persist/etc/ssh
mkdir -p $persist_dir
cp "$key_dir"/ssh_host_{ed25519,rsa}_key.pub ${persist_dir}

for key in ed25519 rsa; do
  sops -d "$key_dir/ssh_host_${key}_key.sops" >${persist_dir}/ssh_host_${key}_key
  chmod 0600 ${persist_dir}/ssh_host_${key}_key
done
