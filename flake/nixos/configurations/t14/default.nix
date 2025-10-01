# T14 Laptop Configuration
_: {
  imports = [
    ./hardware
    ./networking
    ./services
    ./systemd
    ./hyprland.nix
  ];

  security.tpm2.enable = true;

  system = {
    preset = "laptop";
    stateVersion = "24.11";
  };

  nix.settings.trusted-substituters = ["http://192.168.48.5:5000"];

  virtualisation.podman.enable = true;
}
