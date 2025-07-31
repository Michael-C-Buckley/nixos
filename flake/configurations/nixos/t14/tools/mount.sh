# Mount the existing drives
zmount() {
  mkdir -p "$2"
  mount -t zfs "$1" "$2"
}

mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot

zpool import -f zroot

# Get the user password
zfs load-key zroot/local/crypt

zmount "zroot/local/crypt" "/mnt/crypt"
zmount "zroot/local/nix" "/mnt/nix"

mkdir -p /crypt/zfs
cp /mnt/crypt/zfs/* /crypt/zfs

# Load the key files
zfs load-key zroot/local/cache
zfs load-key zroot/t14/nixos
zfs load-key zroot/t14/nixos/home/michael
zfs load-key zroot/t14/nixos/home/shawn

# Mount the rest since the keys are loaded
zmount "zroot/local/cache" "/mnt/cache"

for set in "home" "persist"; do
    zmount "zroot/t14/nixos/$set" "/mnt/$set"
done

for user in "michael" "shawn"; do
    zmount "zroot/t14/nixos/home/$user" "/mnt/home/$user"
done

rm -rf /crypt/zfs
