{inputs, ...}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
    inputs.quadlet-nix.nixosModules.quadlet
    ./hjem.nix
    ./networking.nix
    ./wsl.nix
    ./quadlet.nix
  ];

  networking.hostId = "e07f0101";

  services = {
    unbound.enable = true;
  };

  system = {
    preset = "wsl";
    stateVersion = "24.11";
    zfs.enable = false;
  };

  programs.winbox.enable = true;

  virtualisation.podman.enable = true;
}
