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
    "/var/log" = {
      device = "zroot/nixos/var/log";
      fsType = "zfs";
    };
    "/var/lib" = {
      device = "zroot/nixos/var/lib";
      fsType = "zfs";
    };
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
