{inputs, ...}: let
  inherit (inputs) home-config nix-secrets;
in {
  imports = [
    home-config.hjemConfigurations.default
    nix-secrets.nixosModules.x570
    ./hardware
    ./networking
    ./hyprland.nix
  ];

  features = {
    boot = "systemd";
    gaming.enable = true;
  };

  system = {
    preset = "desktop";
    stateVersion = "25.05";
  };

  virtualisation = {
    incus.enable = true;
    gns3.enable = false;
  };
}
