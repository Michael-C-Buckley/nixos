{inputs, ...}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
    ./hjem.nix
    ./networking.nix
    ./wsl.nix
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
