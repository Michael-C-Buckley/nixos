# ZFS Install Script for T14

ZFS_OPTS="-o ashift=12 \
  -O compression=lz4 \
  -O atime=off \
  -O xattr=sa \
  -O acltype=posixacl \
  -O dnodesize=auto \
  -O normalization=formD \
  -O mountpoint=none"

# Host Info
modprobe zfs zfs_hostid=0x8425e349
hostname="t14"

read -rp "This will erase the NVMe drive, as you sure? [y/N]" confirm
if [[ $confirm =~ ^[Yy]$ ]]; then
  dev="nvme1n1"
  echo "Erasing NVMe ${dev}..."
  wipefs -a $dev
  sgdisk --zap-all $dev
  zpool labelclear -f $dev

  # Create the partitions
  sgdisk -n1:1M:+2G -t1:EF00 -c1:"EFI System" $dev
  sgdisk -n2:0:+250G -t2:BF01 -c2:"ZLINUX" $dev
  sgdisk -n3:0:+150G -t3:BF01 -c3:"ZBSD" $dev
  sgdisk -n4:0:+150G -t4:0700 -c4:"Windows" $dev

  # Format boot partition
  mkfs.vfat -F32 {$dev}p1

  # Format for the ZFS pool for Linux
  zpool create -f $ZFS_OPTS zroot /dev/nvme0n1p2
else
  echo "Skipping NVMe wipe."
fi

LOCAL_DATASETS=("crypt" "cache" "games")


read -rp "Create Datasets? [y/N]" confirm
if [[ $confirm =~ ^[Yy]$ ]]; then

  # Create local datasets
  zfs create -o mountpoint=none zroot/local
  for set in "${LOCAL_DATASETS[@]}"; do
    zfs create -o mountpoint=legacy zroot/local/$set
  done
  # Nix store gets higher compression
  zfs create -o mountpoint=legacy -o compression=zstd zroot/local/nix

  # Create hostnamed sets
  zfs create -o mountpoint=none zroot/$hostname
  for set in "" "home" "home/michael" "home/shawn" "persist" "root"; do
    zfs create -o mountpoint=legacy zroot/$hostname/nixos/$set
  done
else
  echo "Skipping dataset creation."
fi

read -rp "Mount Datasets? [y/N]" confirm
if [[ $confirm =~ ^[Yy]$ ]]; then

  # Mount system directories
  for dir in "${LOCAL_DATASETS[@]}"; do
    mkdir -p /mnt/$dir
    mount -t zfs zroot/local/$dir /mnt/$dir
  done
  mkdir -p /mnt/persist
  mount -t zfs zroot/$hostname/nixos/persist

  # Mount user homes
  for user in "michael" "shawn"; do
    mkdir -p /mnt/home/$user
    mount -t zfs zroot/$hostname/nixos/home/$user /mnt/home/$user
  done

  # Mount boot
  mkdir -p /mnt/boot
  mount /dev/nvme0n1p1 /mnt/boot
else
  echo "Skipping mounting."
fi

read -rp "Ready for deploy? [y/N]" confirm
  # Update the boot drive reference
  new_uuid=$(blkid -s UUID -o value /dev/nvme0n1p1)
  file=../hosts/$hostname/default.nix
  sed -i -E \
    "s|^([[:space:]]*system\.boot\.uuid[[:space:]]*=[[:space:]]*\")[0-9A-Fa-f-]+(\"[[:space:]]*;)|\1${new_uuid}\2|" \
    "$file"

  echo "Updated UUID for $hostname"

  key=/etc/nix/secrets/crypt/age/t14.sops
  persist_dir=/mnt/persist/etc/sops
  mkdir -p $persist_dir
  sops -d "$key" >${persist_dir}/age.txt
  chmod 0600 ${persist_dir}/age.txt
else
  echo "Skipping deployment prep."
fi
