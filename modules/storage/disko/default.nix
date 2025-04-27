{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkOption mkIf;
  inherit (lib.types) nullOr str;
  disko = config.features.disko;
  mainDisko = disko.main;
in {
  imports = [inputs.disko.nixosModules.disko];

  options = {
    features.disko = {
      enable = mkEnableOption "Enable Disko for this host";
      main = {
        device = mkOption {
          type = nullOr str;
          default = null;
          description = "Activate Disko by declaring the primary drive";
        };
        swapSize = mkOption {
          type = str;
          default = "1G";
          description = "Swap partition size";
        };
        rootSize = mkOption {
          type = str;
          default = "1G";
          description = "Size of the root tmpfs";
        };
        imageSize = mkOption {
          type = nullOr str;
          default = null;
          description = "Size of VM image to be created, if making a VM";
        };
      };
    };
  };

  config = mkIf disko.enable {
    # This uses ZFS so activate it if needed
    system.zfs.enable = mkDefault true;

    # Add the filesystems we'll need to boot
    fileSystems = {
      "/persist".neededForBoot = true;
      "/cache".neededForBoot = true;
    };

    disko.devices = {
      disk."main" = {
        device = mainDisko.device;
        type = "disk";
        imageSize = mainDisko.imageSize;

        content = {
          type = "gpt";
          partitions = import ./partitions.nix {inherit config;};
        };
      };
      zpool."zroot" = import ./zroot.nix {inherit config;};
      nodev = import ./nodevs.nix {inherit config;};
    };
  };
}
