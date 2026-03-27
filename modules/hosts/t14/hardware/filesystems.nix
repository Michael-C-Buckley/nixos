{
  flake.modules.nixos.t14 = let
    mkZfsNeeded = device: {
      inherit device;
      fsType = "zfs";
      neededForBoot = true;
    };
    mkZfs = device: {
      inherit device;
      fsType = "zfs";
    };
    mkNspawnMounts = name: {
      "var/lib/machines/${name}" = mkZfs "zroot/crypt/t14/${name}/root";
      "var/lib/machines/${name}/home" = mkZfs "zroot/crypt/t14/${name}/home";
      "var/lib/machines/${name}/var" = mkZfs "zroot/crypt/t14/${name}/var";
    };
  in {
    # For ownership, declaring what was created on install
    users.users = {
      michael.uid = 1001;
      shawn.uid = 1000;
    };

    swapDevices = [];

    custom.impermanence = {
      var.enable = false;
      home.enable = false;
    };

    boot.zfs.requestEncryptionCredentials = true;

    fileSystems =
      {
        "/boot" = {
          device = "/dev/disk/by-uuid/A926-212B";
          fsType = "vfat";
        };

        "/" = {
          device = "tmpfs";
          fsType = "tmpfs";
          options = [
            "defaults"
            "size=256M"
            "mode=755"
          ];
        };

        "/nix" = mkZfsNeeded "zroot/local/nix/nixos";
        "/nix/store" = mkZfsNeeded "zroot/local/nix/store";
        "/cache" = mkZfsNeeded "zroot/crypt/t14/nixos/cache";
        "/persist" = mkZfsNeeded "zroot/crypt/t14/nixos/persist";
        "/home" = mkZfsNeeded "zroot/crypt/t14/nixos/home";
        "/var" = mkZfsNeeded "zroot/crypt/t14/nixos/var";
        "/var/lib/docker" = mkZfs "zroot/local/docker";
      }
      # Some experimentation I'm doing
      // (mkNspawnMounts "alpine") // (mkNspawnMounts "gentoo");
  };
}
