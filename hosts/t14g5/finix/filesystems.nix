{ lib, ... }:
let
  # LVM volumes inside cryptroot. Use /dev/mapper paths: dm devices get no
  # /dev/disk/by-label links without lvm2's udev rules, which finix omits.
  storage = import ../storage.nix;
  btrfs = subvol: {
    device = storage.rootDevice;
    fsType = "btrfs";
    options = [
      "subvol=@${subvol}"
      "compress=zstd:2"
      "noatime"
    ];
  };
in
{
  boot.initrd = {
    supportedFilesystems.lvm.enable = true;
    # TODO: Remove once Finix boots reliably on this host.
    emergencyAccess = true;
    finit.tasks = {
      # Activate the existing volume group only after cryptroot is unlocked.
      lvm.conditions = [ "task/luks/success" ];
    }
    # Start the 90s device waits only after the logical volumes exist, so a
    # slow passphrase entry can't time them out.
    // lib.genAttrs [ "wait-dev-root" "wait-dev-nix" "wait-dev-var" ] (_: {
      conditions = [ "task/lvm/success" ];
    });
  };
  boot.supportedFilesystems.lvm.enable = true;

  # Finix's default tmpfiles rule resets /tmp to 0755 after it is mounted.
  # Restore the sticky, writable mode so the user D-Bus session can bind its socket.
  finit.tmpfiles.rules = lib.mkAfter [ "d /tmp 1777 root root" ];

  fileSystems = {
    # Finix represents LUKS mappings as pseudo-filesystems, not mount points.
    cryptroot = {
      device = "/dev/disk/by-label/T14G5-CRYPT";
      fsType = "luks";
      neededForBoot = true;
      options = [ "--type luks" ];
      # TODO: Port T14g5's systemd FIDO2 unlock; use a passphrase for now.
    };

    "/boot" = {
      device = "/dev/disk/by-label/T14G5-EFI";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
        "noexec"
        "nodev"
        "nosuid"
      ];
    };
    "/" = btrfs "finix-root";
    "/nix" = btrfs "finix-nix";
    "/home" = btrfs "finix-home";
    "/var" = btrfs "finix-var";

    # The inactive installation supplies substitutes, including its store DB.
    "/var/lib/machines/nixos/nix" = {
      inherit (btrfs "nixos-nix") device fsType;
      options = (btrfs "nixos-nix").options ++ [
        "ro"
        "nodev"
        "nosuid"
        "X-mount.mkdir"
      ];
    };

    # Shared keys used by the multiboot host.
    "/var/lib/sbctl/keys" = btrfs "sbctl-keys";
    "/home/michael/.config/keys" = btrfs "user-keys";

    # Shared Bluetooth pairings (one adapter, all installs)
    "/var/lib/bluetooth" = btrfs "bluetooth";

    # Shared NetworkManager connection profiles (all installs).
    "/etc/NetworkManager/system-connections" = btrfs "networkmanager";

    # Shared logical volume for bulk data that doesn't do well on COW.
    "/data" = {
      device = "/dev/mapper/crypt--lv-data";
      fsType = "ext4";
    };

    "/tmp" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [
        "mode=1777"
        "size=2G"
      ];
    };
  };
}
