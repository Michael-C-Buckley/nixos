let
  mkBtrfs =
    {
      device ? "/dev/disk/by-uuid/0ecc4808-a4e5-4600-8682-1cace4078a98", # will be replaced on provisioning
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
  boot = {
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
        device = "/dev/disk/by-uuid/9a321103-d7c0-493f-b177-3b98adc7f4bd";
        crypttabExtraOpts = [ "fido2-device=auto" ];
      };
    };
    tmp = {
      useTmpfs = true;
      tmpfsSize = "2G";
    };
  };

  services.btrfs.autoScrub.enable = true;

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/12CE-A600";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
        "noexec"
        "nodev"
        "nosuid"
      ];
    };
    # Btrfs for the main components
    "/" = mkBtrfs { subvol = "@nixos"; };
    "/home" = mkBtrfs { subvol = "@nixos-home"; };
    "/nix" = mkBtrfs { subvol = "@nixos-nix"; };
    # Bulk data on XFS that will be bound to other usage locations
    "/data" = {
      device = "/dev/disk/by-uuid/ee79ce37-3960-43a2-b6fb-10253e096e69";
      fsType = "xfs";
    };
    # Currently I'm only anticipating VM drive images to be off the COW
    "/var/lib/libvirt/images" = {
      device = "/data/nixos/libvirt/images";
      fsType = "none";
      options = [ "bind" ];
      depends = [ "/data" ];
    };
  };
}
