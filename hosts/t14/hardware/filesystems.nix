{inputs, ...}: let
  zfsFs = name: {
    device = "zroot/${name}";
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  imports = [
    inputs.impermanence.nixosModules.impermanence
    ../../../modules/storage/impermanence.nix
  ];
  boot.zfs.forceImportAll = true;

  fileSystems = {
    # Physical
    "/boot" = {
      device = "/dev/disk/by-label/BOOTDEV";
      fsType = "vfat";
    };

    # ZFS Volumes
    #  Root and tmp are a fallbacks for tmpfs
    "/" = zfsFs "nixroot";
    "/tmp" = zfsFs "tmp";
    "/nix" = zfsFs "nix";
    "/cache" = zfsFs "cache";
    "/persist" = zfsFs "persist";
  };
}
