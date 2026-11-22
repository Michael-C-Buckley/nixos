let
  limine =
    extraCfg:
    {
      enable = true;
      efiSupport = true;
      biosSupport = false;
      maxGenerations = 15;
    }
    // extraCfg;
in
{ config, pkgs, ... }:
let
  sb = config.boot.loader.limine.secureBoot.enable;
in
{
  environment.systemPackages = [
    pkgs.sbctl
    pkgs.efibootmgr
  ];
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    systemd-boot.enable = false;
    grub.enable = false;

    limine = limine {
      enrollConfig = sb;
      validateChecksums = sb;
      panicOnChecksumMismatch = sb;
      enableEditor = !sb;
    };
  };
}
