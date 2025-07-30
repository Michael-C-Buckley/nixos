# ZFS Install Script for T14

set -euo pipefail

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

read -rp "This will erase the NVMe drive, are you sure? [y/N] " confirm
if [[ $confirm =~ ^[Yy]$ ]]; then
  dev="/dev/nvme0n1"
  echo "Erasing NVMe ${dev}..."
  wipefs -a "$dev"
  sgdisk --zap-all "$dev"
  zpool labelclear -f "$dev" || :

  # Create the partitions
  sgdisk -n1:1M:+2G -t1:EF00 -c1:"EFI System" "$dev"
  sgdisk -n2:0:+128M -t2:0C01 -c2:"Microsoft Reserved" "$dev" 
  sgdisk -n3:0:+8G -t3:8200 -c3:"SWAP" "$dev"
  sgdisk -n4:0:+300G -t4:BF01 -c4:"Zroot" "$dev"
  sgdisk -n5:0:+150G -t5:0700 -c5:"Windows" "$dev"  # Fixed partition number

  # Format boot partition
  mkfs.vfat -F32 "${dev}p1"

  # Mount boot
  mkdir -p /mnt/boot
  mount "${dev}p1" /mnt/boot

  # Create the pools
  zpool create -f $ZFS_LINUX_OPTS zroot "${dev}p4" || { echo "Failed to create zroot"; exit 1; }
else
  echo "Skipping NVMe wipe."
fi

zmount() {
  mkdir -p "$2"
  mount -t zfs "$1" "$2"
}

read -rp "Create Datasets? [y/N] " confirm
if [[ $confirm =~ ^[Yy]$ ]]; then
# Create local datasets
  zfs create -o mountpoint=none zroot/local

  # Create the crypt
  zfs create -o encryption=aes-256-gcm -o compression=zstd -o keyformat=passphrase -o mountpoint=legacy zroot/local/crypt
  zmount "zroot/local/crypt" "/mnt/crypt"

  # Generate keys - They need to be in the actual location and are copied over to the mount
  mkdir -p /crypt/zfs
  mkdir -p /mnt/crypt/zfs
  dd if=/dev/urandom of=/crypt/zfs/nixos.key bs=32 count=1
  dd if=/dev/urandom of=/crypt/zfs/cache.key bs=32 count=1
  cp /crypt/zfs/cache.key /mnt/crypt/zfs/cache.key
  cp /crypt/zfs/nixos.key /mnt/crypt/zfs/nixos.key

  zfs create -o mountpoint=legacy -o encryption=aes-128-gcm -o keyformat=raw -o keylocation=file:///crypt/zfs/cache.key zroot/local/cache
  zmount "zroot/local/cache" "/mnt/cache"
  cp /crypt/zfs/cache.key /mnt/crypt/zfs/cache.key 

  # isn't needed for install
  zfs create -o mountpoint=legacy zroot/local/games

  for set in "${LOCAL_DATASETS[@]}"; do
    zfs create -o mountpoint=legacy zroot/local/"$set"
    zmount "zroot/local/$set" "/mnt/$set" 
  done

  # Nix store gets higher compression
  zfs create -o mountpoint=legacy -o compression=zstd zroot/local/nix
  zmount "zroot/local/nix" "/mnt/nix"

  # Create hostnamed sets
  zfs create -o mountpoint=none zroot/"$hostname"
  zfs create -o mountpoint=none -o encryption=aes-128-gcm -o keyformat=raw -o keylocation=file:///crypt/zfs/nixos.key zroot/"$hostname"/nixos

  for set in "home" "persist"; do
    zfs create -o mountpoint=legacy zroot/"$hostname"/nixos/"$set"
    zmount "zroot/$hostname/nixos/$set" "/mnt/$set"
  done

  # Create user homes
  for user in "michael" "shawn"; do
    dd if=/dev/urandom of=/crypt/zfs/"$user".key bs=32 count=1
    zfs create -o mountpoint=legacy -o encryption=aes-128-gcm -o keyformat=raw -o keylocation=file:///crypt/zfs/"$user".key zroot/"$hostname"/nixos/home/"$user"
    zmount "zroot/$hostname/nixos/home/$user" "/mnt/home/$user"
    cp /crypt/zfs/"$user".key /mnt/crypt/zfs/"$user".key 
  done

else
  echo "Skipping dataset creation."
fi

read -rp "Ready for deploy? [y/N] " confirm
if [[ $confirm =~ ^[Yy]$ ]]; then
  # Update the boot drive reference
  new_uuid=$(blkid -s UUID -o value "${dev}p1")  # Use variable instead of hardcoded
  file="../hosts/$hostname/default.nix"
  
  # Check if file exists
  if [[ -f "$file" ]]; then
    sed -i -E \
      "s|^([[:space:]]*system\.boot\.uuid[[:space:]]*=[[:space:]]*\")[0-9A-Fa-f-]+(\"[[:space:]]*;)|\1${new_uuid}\2|" \
      "$file"
    echo "Updated UUID for $hostname"
  else
    echo "Warning: File $file not found"
  fi

  key="/etc/nix/secrets/crypt/age/t14.sops"
  persist_dir="/mnt/persist/etc/sops"
  
  # Check if key file exists
  if [[ -f "$key" ]]; then
    mkdir -p "$persist_dir"
    sops -d "$key" > "${persist_dir}/age.txt"
    chmod 0600 "${persist_dir}/age.txt"
  else
    echo "Warning: SOPS key file $key not found"
  fi
else
  echo "Skipping deployment prep."
fi
