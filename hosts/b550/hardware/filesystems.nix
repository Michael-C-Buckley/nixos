let
  mkZfs = device: {
    inherit device;
    fsType = "zfs";
  };

  mkZfsBoot = device: {
    inherit device;
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  swapDevices = [];

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/E09B-A739";
      fsType = "vfat";
    };

    "/" = mkZfsBoot "zroot/nixos/root";
    "/nix" = mkZfsBoot "zroot/nixos/nix";
    "/var" = mkZfsBoot "zroot/nixos/var";
    "/home" = mkZfsBoot "zroot/nixos/home";

    "/var/lib/attic" = mkZfs "zroot/local/attic";
    "/var/lib/docker" = mkZfs "zhdd/var/docker";
  };
}
