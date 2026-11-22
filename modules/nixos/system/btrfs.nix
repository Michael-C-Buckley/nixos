# TODO: Add bees
{ lib, pkgs, ... }: {
  boot = {
    # This sits between normal and default
    kernelPackages = lib.mkOverride 900 pkgs.linuxPackages_latest;
  };

  environment.systemPackages = with pkgs; [
    compsize
    duperemove
  ];

  services.btrfs.autoScrub.enable = true;
}
