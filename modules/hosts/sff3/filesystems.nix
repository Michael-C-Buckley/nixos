{
  flake.modules.nixos.sff3 = {
    fileSystems = {
      "/boot" = {
        device = "/dev/disk/by-uuid/58C1-9A50";
        fsType = "vfat";
      };
      "/" = {
        device = "zroot/sff3/root";
        fsType = "zfs";
      };
      "/nix" = {
        device = "zroot/local/nix";
        fsType = "zfs";
      };
    };
  };
}
