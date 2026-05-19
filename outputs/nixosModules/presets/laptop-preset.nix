{
  flake,
  pkgs,
  lib,
  ...
}: {
  imports = with flake.nixosModules; [
    desktop-preset
    wifi
  ];

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  services = {
    upower.enable = true;
    tlp.enable = true;
    power-profiles-daemon.enable = lib.mkForce false;
  };
}
