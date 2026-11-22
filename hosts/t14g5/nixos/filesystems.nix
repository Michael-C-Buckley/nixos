{ lib, ... }:
let
  btrfs = subvol: {
    device = "/dev/disk/by-label/T14G5-SYSTEM";
    fsType = "btrfs";
    options = [
      "subvol=@${subvol}"
      "compress=zstd:2"
      "noatime"
    ];
  };
  debianRoot = "/var/lib/machines/debian";
  debianStorage = import ../storage.nix;
  debianSubvolumes =
    readOnly: subvolumes:
    lib.mapAttrs' (path: subvol: {
      name = debianRoot + lib.optionalString (path != "/") path;
      value = {
        device = "/dev/disk/by-uuid/${debianStorage.systemUUID}";
        fsType = "btrfs";
        options = [
          "subvol=${subvol}"
          "compress=zstd:2"
          "noatime"
        ]
        ++ lib.optionals readOnly [
          "ro"
          "nodev"
          "nosuid"
          "noexec"
        ];
      };
    }) subvolumes;
in
{
  boot = {
    initrd.services.lvm.enable = true;
    initrd.luks = {
      cryptoModules = [
        "aes"
        "cbc"
        "xts"
        "sha1"
        "sha256"
        "sha512"
        "af_alg"
        "algif_skcipher"
        "cryptd"
        "input_leds"
      ];
      devices.cryptroot = {
        device = "/dev/disk/by-label/T14G5-CRYPT";
        crypttabExtraOpts = [ "fido2-device=auto" ];
      };
    };
    tmp = {
      useTmpfs = true;
      tmpfsSize = "2G";
    };
  };

  fileSystems = {
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
    "/" = btrfs "nixos-root";
    "/nix" = btrfs "nixos-nix";
    "/home" = btrfs "nixos-home";
    "/var" = btrfs "nixos-var";

    # The inactive installation supplies substitutes, including its store DB.
    "/var/lib/machines/finix/nix" = {
      inherit (btrfs "finix-nix") device fsType;
      options = (btrfs "finix-nix").options ++ [
        "ro"
        "nodev"
        "nosuid"
      ];
    };

    # Shared keys I use for the multiboot host
    "/var/lib/sbctl/keys" = btrfs "sbctl-keys";
    "/home/michael/.config/keys" = btrfs "user-keys";

    # Shared Bluetooth pairings (one adapter, all installs)
    "/var/lib/bluetooth" = btrfs "bluetooth";

    # Shared NetworkManager connection profiles (all installs)
    "/etc/NetworkManager/system-connections" = btrfs "networkmanager";

    # Linear volume for bulk data that doesn't do well on COW
    "/data" = {
      device = "/dev/disk/by-label/T14G5-DATA";
      fsType = "ext4";
    };
  }
  # Mount the installed Debian tree for an interactive nspawn maintenance shell.
  # Keep its /nix separate and share the bootstrap's storage definitions.
  // debianSubvolumes false debianStorage.subvolumes
  # These are live host resources; maintenance only needs to read them.
  // debianSubvolumes true debianStorage.sharedSubvolumes
  // {
    "${debianRoot}/boot/efi" = {
      device = "/boot";
      fsType = "none";
      options = [ "bind" ];
      depends = [ "/boot" ];
    };
    "${debianRoot}/data" = {
      device = "/data";
      fsType = "none";
      options = [ "bind" ];
      depends = [ "/data" ];
    };
  };
}
