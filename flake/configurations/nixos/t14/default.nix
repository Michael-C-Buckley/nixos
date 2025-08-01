# T14 Laptop Configuration
{inputs, ...}: let
  inherit (inputs) nix-secrets;
in {
  imports = [
    nix-secrets.nixosModules.t14
    ./hardware
    ./networking
    ./systemd
    ./hyprland.nix
  ];

  features.boot = "limine";

  virtualisation = {
    podman.enable = true;
    libvirtd.enable = true;
  };

  security.tpm2.enable = true;

  system = {
    preset = "laptop";
    stateVersion = "24.11";
  };
}
