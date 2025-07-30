# ZFS Install Script for T14

ZFS_LINUX_OPTS="-o ashift=12 \
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
  dev="/dev/nvme0n1"
  echo "Erasing NVMe ${dev}..."
  wipefs -a $dev
  sgdisk --zap-all $dev
  zpool labelclear -f $dev

  # Create the partitions
  sgdisk -n1:1M:+2G -t1:EF00 -c1:"EFI System" $dev
  sgdisk -n2:0:+128M -t2:0C01 -c2:"Microsoft Reserved" $dev
  sgdisk -n3:0:+8G -t3:8200 -c3:"WAP" $dev
  sgdisk -n4:0:+300G -t4:BF01 -c4:"Zroot" $dev
  sgdisk -n6:0:+150G -t6:0700 -c6:"Windows" $dev

  # Format boot partition
  mkfs.vfat -F32 "$dev"p1

  # Create the pools
  zpool create -f $ZFS_LINUX_OPTS zroot /dev/nvme0n1p2 || { echo "Failed to create zroot"; exit 1; }
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
  zfs create -o mountpoint=none zroot/$hostname/nixos
  for set in  "home" "home/michael" "home/shawn" "persist" "root"; do
    zfs create -o mountpoint=legacy zroot/$hostname/nixos/$set
  done
else
  echo "Skipping dataset creation."
fi

# NOT CURRENTLY WORKING
# read -rp "Create BSD Datasets? [y/N]" confirm
# if [[ $confirm =~ ^[Yy]$ ]]; then
#   # Create top level datasets
#   zfs create -o mountpoint=none -o compression=zstd zbsd/ROOT
#   zfs create -o mountpoint=/ zbsd/ROOT/default

#   # Does not get mounted
#   zfs create -o mountpoint=none zbsd/usr

#   for set in "home" "var" "tmp"; do
#     zfs create -o mountpoint=/$set zbsd/$set
#   done

#   for varset in "audit" "log" "crash" "mail" "tmp" "db"; do
#     zfs create -o mountpoint=/var/$varset zbsd/var/$varset
#   done

#   for usrset in "ports" "src"; do
#     zfs create -o mountpoint=/usr/$usrset -o compression=zstd zbsd/usr/$usrset
#   done

# else
#   echo "Skipping BSD dataset creation."
# fi


read -rp "Mount Datasets? [y/N]" confirm
if [[ $confirm =~ ^[Yy]$ ]]; then

  # Mount system directories
  for dir in "${LOCAL_DATASETS[@]}"; do
    mkdir -p /mnt/$dir
    mount -t zfs zroot/local/$dir /mnt/$dir
  done
  mkdir -p /mnt/persist
  mount -t zfs zroot/$hostname/nixos/persist /mnt/persist

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
# Export BSD as we are done with it
zpool export zbsd


read -rp "Ready for deploy? [y/N]" confirm
if [[ $confirm =~ ^[Yy]$ ]]; then
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
