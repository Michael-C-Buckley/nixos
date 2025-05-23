{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
    inputs.nix-index-database.nixosModules.nix-index
    ./hjem.nix
    ./wsl.nix
  ];

  environment.systemPackages = [pkgs.devenv];

  features.michael.nvf.package = "default";

  networking = {
    hostName = "wsl";
    hostId = "e07f0101";
    nameservers = ["1.1.1.1" "8.8.8.8" "9.9.9.9"];
  };

  programs.nix-index-database.comma.enable = true;

  services.k3s.enable = true;

  system = {
    preset = "wsl";
    stateVersion = "24.11";
  };

  virtualisation.docker = {
    enable = true;
    kata.enable = false; # Needs debugging
  };
}
