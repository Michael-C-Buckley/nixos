{inputs, ...}: let
  inherit (inputs) nix-secrets;
in {
  imports = [
    nix-secrets.nixosModules.x570
    ./hardware
    ./networking
    ./hyprland.nix
  ];

  features.gaming.enable = true;

  system = {
    builder.enable = true;
    preset = "desktop";
    stateVersion = "25.05";
  };

  virtualisation = {
    gns3.enable = true;
    podman.enable = true;
  };
}
