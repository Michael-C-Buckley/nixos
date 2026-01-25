{
  flake.modules.nixos = {
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
