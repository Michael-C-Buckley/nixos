let
  mkBtrfs =
    {
      device ? "/dev/disk/by-uuid/d65908f7-0071-427b-8f0f-1bf9906ef5e9",
      subvol,
    }:
    {
      inherit device;
      fsType = "btrfs";
      options = [
        "subvol=${subvol}"
        "compress=zstd:2"
        "ssd"
        "discard=async"
        "noatime"
      ];
    };
in
{
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "4G";
  };

  services.btrfs.autoScrub.enable = true;

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
    "/" = mkBtrfs { subvol = "@nixos"; };
    "/home" = mkBtrfs { subvol = "@nixos-home"; };
    "/nix" = mkBtrfs { subvol = "@nixos-nix"; };
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
