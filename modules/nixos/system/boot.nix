{config, ...}: {
  flake.modules.nixos = {
    grub = {
      boot.loader.grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
        device = "nodev";
      };
    };

    lanzaboote = {pkgs, ...}: {
      imports = ["${config.flake.npins.lanzaboote-bin}/modules"];
      environment.systemPackages = [pkgs.sbctl];

      boot = {
        loader.systemd-boot.enable = false;
        lanzaboote = {
          enable = true;
          pkiBundle = "/var/lib/sbctl";
        };
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
