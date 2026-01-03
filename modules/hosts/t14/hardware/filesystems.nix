{
  flake.modules.nixos.t14 = let
    mkZfs = device: {
      inherit device;
      fsType = "zfs";
      neededForBoot = true;
    };
  in {
    swapDevices = [];

    custom.impermanence = {
      var.enable = true;
      home.enable = false;
    };

    services.sanoid.datasets = {
      "zroot/t14/nixos/persist".use_template = ["normal"];
      "zroot/t14/nixos/home/michael".use_template = ["normal"];
    };

    boot.zfs.requestEncryptionCredentials = true;

    fileSystems = {
      "/boot" = {
        device = "/dev/disk/by-uuid/A926-212B";
        fsType = "vfat";
      };

      "/" = {
        device = "tmpfs";
        fsType = "tmpfs";
        options = [
          "defaults"
          "size=1G"
          "mode=755"
        ];
      };

      "/nix" = mkZfs "zroot/local/nix";
      "/cache" = mkZfs "zroot/t14/nixos/cache";
      "/persist" = mkZfs "zroot/t14/nixos/persist";

      "/home/michael" = mkZfs "zroot/t14/nixos/home/michael";
      "/home/shawn" = mkZfs "zroot/t14/nixos/home/shawn";
    };
  };
}
