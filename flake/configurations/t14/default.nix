# T14 Laptop Configuration
_: {
  imports = [
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
