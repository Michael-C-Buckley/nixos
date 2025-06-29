{inputs, ...}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
    ./hjem.nix
    ./wsl.nix
  ];

  networking.hostId = "e07f0101";

  services = {
    unbound.enable = true;
  };

  system = {
    preset = "wsl";
    stateVersion = "24.11";
  };

  programs.winbox.enable = true;

  virtualisation.docker = {
    enable = true;
    kata.enable = false; # Needs debugging
  };
}
