{
  pkgs,
  lib,
  ...
}: let
  kernelPkg = pkgs.linuxKernel.packages;
in {
  boot = {
    kernelPackages = lib.mkDefault kernelPkg.linux_hardened;
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
