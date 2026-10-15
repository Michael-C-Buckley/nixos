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
    "/" = {
      device = "zroot/nixos/root";
      fsType = "zfs";
    };
    "/nix" = {
      device = "zroot/nixos/nix";
      fsType = "zfs";
    };
    "/home" = {
      device = "zroot/nixos/home";
      fsType = "zfs";
    };
    "/var" = {
      device = "zroot/nixos/var";
      fsType = "zfs";
    };
    # Bulk data on XFS that will be bound to other usage locations
    "/data" = {
      device = "/dev/disk/by-uuid/ee79ce37-3960-43a2-b6fb-10253e096e69";
      fsType = "xfs";
    };
  };
}
