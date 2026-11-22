let
  btrfs = subvol: {
    device = "/dev/disk/by-label/X570-SYSTEM";
    fsType = "btrfs";
    options = [
      "subvol=@${subvol}"
      "compress=zstd:2"
      "noatime"
    ];
  };
in
{
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "4G";
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/8BCE-78C9";
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

    # Shared keys I use for the multiboot host
    "/var/lib/sbctl/keys" = btrfs "sbctl-keys";
    "/home/michael/.config/keys" = btrfs "user-keys";

    # Data mount is XFS for non-cow things like VMs and also steam
    "/data" = {
      device = "/dev/disk/by-uuid/e6bc9bb7-9a26-405f-9a51-d880cb4bb3d3";
      fsType = "xfs";
    };
    "/var/lib/libvirt/images" = {
      device = "/data/nixos/libvirt/images";
      fsType = "none";
      options = [ "bind" ];
      depends = [ "/data" ];
    };
  };
}
