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

read -rp "This will erase the NVMe drives, as you sure? [y/N]" confirm
if [[ $confirm =~ ^[Yy]$ ]]; then
  for dev in /dev/nvme{1,2}n1; do
    echo "Erasing NVMe ${dev}..."
    wipefs -a $dev
    sgdisk --zap-all $dev
    zpool labelclear -f $dev

    # Format the partitions
    sgdisk -n1:1M:+500M -t1:EF00 -c1:"EFI System" $dev
    sgdisk -n2:0:+800G -t2:BF01 -c2:"ZROOT" $dev

    # Format the boot partition
    mkfs.vfat -F32 /dev/nvme1n1p1
  done

  # Format for the striped ZFS pool
  zpool create -f $ZFS_OPTS zroot /dev/nvme1n1p2 /dev/nvme2n1p2
else
  echo "Skipping NVMe wipe."
fi

read -rp "This will erase the HDD drives, as you sure? [y/N]" confirm
if [[ $confirm =~ ^[Yy]$ ]]; then
  for dev in /dev/sd{b,c,d,e}; do
    echo "Erasing HDD ${dev}..."
    wipefs -a $dev
    sgdisk --zap-all $dev
    zpool labelclear -f $dev
  done
else
  echo "Skipping HDD wipe."
fi

# Mount the drives and prepare for the install
mkdir -p /mnt
mkdir -p /mnt/{cache,nix,persist,tmp,boot}
mount /dev/nvme1n1p1 /mnt/boot

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
key=/etc/nix/secrets/crypt/age/ln.sops
persist_dir=/mnt/persist/etc/sops
mkdir -p $persist_dir

for key in ed25519 rsa; do
  sops -d "$key" >${persist_dir}/age.txt
  chmod 0600 ${persist_dir}/ssh_host_${key}_key
done
