#!/usr/bin/env bash
set -euo pipefail

# ZFS Install Script for P520 Workstation Server

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
for i in 0 1 2; do
    wipefs -a /dev/nvme$i
    sgdisk --zap-all /dev/nvme$i
end

echo "Formatting drives..."
# Put boot on the NVMe DC drive
sgdisk -n1:1M:+512M -t1:EF00 -c1:"EFI System" /dev/nvme0n1
mkfs.vfat -F32 /dev/nvme0n1p1

# Create the pool on the drive, use reasonable settings
echo "Creating zroot..."
zpool create -f $ZFS_OPTS zroot /dev/nvme1 /dev/nvme2

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
key_dir=/etc/nix/secrets/ssh/keys/$hostname
persist_dir=/mnt/persist/etc/ssh
mkdir -p $persist_dir
cp "$key_dir"/ssh_host_{ed25519,rsa}_key.pub ${persist_dir}

for key in ed25519 rsa; do
  sops -d "$key_dir/ssh_host_${key}_key.sops" >${persist_dir}/ssh_host_${key}_key
  chmod 0600 ${persist_dir}/ssh_host_${key}_key
done
