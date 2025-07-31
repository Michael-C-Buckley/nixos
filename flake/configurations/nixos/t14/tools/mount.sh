# Mount the existing drives
zmount() {
  mkdir -p "$2"
  mount -t zfs "$1" "$2"
}

mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot

zpool import -f zroot

# Get the user password
zfs load-key zroot/t14/nixos

zmount "zroot/local/nix" "/mnt/nix"

for set in "home" "persist" "cache"; do
    zmount "zroot/t14/nixos/$set" "/mnt/$set"
done

for user in "michael" "shawn"; do
    zmount "zroot/t14/nixos/home/$user" "/mnt/home/$user"
done
