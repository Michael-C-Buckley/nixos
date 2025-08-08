{inputs, ...}: let
  inherit (inputs) nix-secrets mangowc;
in {
  imports = [
    nix-secrets.nixosModules.x570
    mangowc.nixosModules.mango
    ./hardware
    ./networking
    ./hyprland.nix
  ];

  features = {
    boot = "systemd";
    gaming.enable = true;
  };

  # Testing the Mango Wayland Compositor
  programs.mango.enable = true;

  # Only used during active testing, as it isn't completed
  presets.kubernetes.singleNode = false;

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
