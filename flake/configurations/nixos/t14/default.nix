# T14 Laptop Configuration
{inputs, ...}: let
  inherit (inputs) nix-secrets home-config;
in {
  imports = [
    nix-secrets.nixosModules.t14
    home-config.hjemConfigurations.default
    ./hardware
    ./networking
    ./systemd
    ./hyprland.nix
  ];

  security.tpm2.enable = true;

  system = {
    preset = "laptop";
    stateVersion = "24.11";
  };
}
