{lib, ...}: {
  imports = [
    ./containers
    ./hardware
    ./networking
    ./hyprland.nix
  ];

  features = {
    boot = "systemd";
    gaming.enable = true;
  };

  nix.settings = {
    substituters = lib.mkBefore ["http://p520:5000"];
  };

  system = {
    preset = "desktop";
    stateVersion = "25.05";
  };
}
