# For mounting all the drives
hostname="x570"

# Create hostnamed sets
for set in "home" "home/michael" "home/shawn" "nixos" "nixos/root" "nixos/persist"; do
  mount -t zfs zroot/$hostname/$set /mnt/$set
done

# Mount system directories
for dir in "cache" "crypt" "nix"; do
  mkdir -p /mnt/$dir
  mount -t zfs zroot/local/$dir /mnt/$dir
end
mkdir -p /mnt/persist
mount -t zfs zroot/$hostname/nixos/persist

# Mount user homes
for user in "michael" "shawn"; do
  mkdir -p /mnt/home/$user
  mount -t zfs zroot/$hostname/home/$user /home/$user
end

# Mount boot
mkdir -p /mnt/boot
mount /dev/nvme0n0p1 /mnt/boot