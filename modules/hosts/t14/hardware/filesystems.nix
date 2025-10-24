{
  flake.modules.nixos.t14 = {pkgs, ...}: let
    mkZfs = device: {
      inherit device;
      fsType = "zfs";
      neededForBoot = true;
    };
  in {
    swapDevices = [];

    custom.zfs.snapshotDatasets = [
      "zroot/t14/nixos/persist"
    ];

    boot.zfs = {
      requestEncryptionCredentials = true;
      package = pkgs.zfs_unstable;
    };

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
          "size=1000M"
          "mode=755"
        ];
      };

      "/nix" = mkZfs "zroot/local/nix";
      "/cache" = mkZfs "zroot/t14/nixos/cache";
      "/persist" = mkZfs "zroot/t14/nixos/persist";

      "/var/lib/ollama" = mkZfs "zroot/local/ollama";
    };
  };
}
