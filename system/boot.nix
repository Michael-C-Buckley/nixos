{
  pkgs,
  lib,
  ...
}: {
  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxKernel.packages.linux_hardened;
    loader = {
      grub.enable = false;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        netbootxyz.enable = true;
      };
    };
  };
}
