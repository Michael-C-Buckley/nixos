{
  config,
  inputs,
  ...
}: let
  # To prevent shadowing from the inner module config
  inherit (config.host) bootloader;
in {
  flake.modules.nixosModules = {
    boot = {
      imports = [
        inputs.self.nixosModules.${bootloader}
      ];

      boot.initrd.systemd.enable = true;
    };

    # This page intentionally left blank
    none = {};

    grub = {
      boot.loader.grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
        device = "nodev";
      };
    };

    systemd-boot = {
      boot.loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 10;
          netbootxyz.enable = true;
        };
        efi.canTouchEfiVariables = true;
      };
    };

    limine = {
      boot.loader.limine.enable = true;
    };
  };
}
