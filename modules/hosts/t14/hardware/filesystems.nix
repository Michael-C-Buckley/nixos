{
  flake.modules.nixos.t14 = let
    mkZfs = device: {
      inherit device;
      fsType = "zfs";
      neededForBoot = true;
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

    #services.sanoid.datasets = {
    #  "zroot/t14/nixos/persist".use_template = ["normal"];
    #  "zroot/t14/nixos/home/michael".use_template = ["normal"];
    #};

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
          "size=256M"
          "mode=755"
        ];
      };

      "/nix" = mkZfs "zroot/local/nix/nixos";
      "/nix/store" = mkZfs "zroot/local/nix/store";
      "/cache" = mkZfs "zroot/crypt/t14/nixos/cache";
      "/persist" = mkZfs "zroot/crypt/t14/nixos/persist";
      "/home" = mkZfs "zroot/crypt/t14/nixos/home";
      "/var" = mkZfs "zroot/crypt/t14/nixos/var";
      "/var/lib/docker" = mkZfs "zroot/local/docker";

      # Mount my alpine instance so it could be inspected and modified, if needed
      "/var/lib/machines/alpine" = mkZfs "zroot/crypt/t14/alpine/root";
      "/var/lib/machines/alpine/home" = mkZfs "zroot/crypt/t14/alpine/home";
      "/var/lib/machines/alpine/var" = mkZfs "zroot/crypt/t14/alpine/var";
    };
  };
}
