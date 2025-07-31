_: let
  mkZfs = device: {
    inherit device;
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  swapDevices = [];

  boot.zfs = {
    forceImportAll = true;
  };

  system = {
    boot.uuid = "A926-212B";
    impermanence.enable = true;
    zfs = {
      encryption = true;
      enable = true;
    };
  };
  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=500M"
        "mode=755"
      ];
    };

    "/nix" = mkZfs "zroot/local/nix";

    "/cache" = mkZfs "zroot/t14/nixos/cache";
    "/persist" = mkZfs "zroot/t14/nixos/persist";
    "/home" = mkZfs "zroot/t14/nixos/home";
    "/home/michael" = mkZfs "zroot/t14/nixos/home/michael";
    "/home/shawn" = mkZfs "zroot/t14/nixos/home/shawn";
  };
}
