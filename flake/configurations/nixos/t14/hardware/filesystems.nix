_: let
  mkZfs = device: {
    inherit device;
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  swapDevices = [];

  boot.zfs = {
    requestEncryptionCredentials = ["zroot/local/crypt"];
    forceImportAll = true;
  };

  system = {
    boot.uuid = "DE87-32BC";
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

    "/crypt" = mkZfs "zroot/local/crypt";
    "/nix" = mkZfs "zroot/local/nix";
    "/cache" = mkZfs "zroot/local/cache";

    "/persist" = mkZfs "zroot/t14/nixos/persist";
    "/home" = mkZfs "zroot/t14/nixos/home";
    "/home/michael" = mkZfs "zroot/t14/nixos/home/michael";
    "/home/shawn" = mkZfs "zroot/t14/nixos/home/shawn";
  };
}
