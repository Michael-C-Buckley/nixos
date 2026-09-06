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
in
{
  boot = {
    kernelModules = [ "zfs" ];
    supportedFilesystems = [ "zfs" ];
    zfs.forceImportRoot = true;
    kernelParams = [
      "zfs.zfs_arc_max=17179869184" # 16GB max
      "zfs.zfs_arc_min=4294967296" # 4GB min
    ];
  };
  swapDevices = [ ];

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
