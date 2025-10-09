let
  mkZfs = device: {
    inherit device;
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  swapDevices = [];

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
        "size=1000M"
        "mode=755"
      ];
    };

    "/nix" = mkZfs "zroot/local/nix";
    "/cache" = mkZfs "zroot/t14/nixos/cache";
    "/persist" = mkZfs "zroot/t14/nixos/persist";

    "/var/lib/ollama" = mkZfs "zroot/local/ollama";
  };
}
