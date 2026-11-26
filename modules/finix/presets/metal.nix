{ pkgs, ... }:
{
  imports = [
    ./base.nix
    ../system/netbird.nix
  ];

  environment.systemPackages = with pkgs; [
    killall
    expect
    efibootmgr
    gptfdisk
    parted
    btop
    usbutils
    pciutils
  ];

  services.netbird.enable = true;
}
