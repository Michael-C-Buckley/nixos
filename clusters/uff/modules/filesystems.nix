{lib, ...}: {
  # Planned options for the ZFS module
  boot.zfs = {
    forceImportRoot = lib.mkForce true;
    extraPools = ["rpool"];
  };

  system.zfs.enable = true;

  fileSystems = {
    "/" = {
      device = "rpool/root/nixos";
      fsType = "zfs";
    };
    "/nix" = {
      device = "rpool/root/nix";
      fsType = "zfs";
    };
    "/home" = {
      device = "rpool/root/home";
      fsType = "zfs";
    };
    "/data/gluster" = {
      device = "rpool/root/gluster";
      fsType = "zfs";
    };
  };
}
