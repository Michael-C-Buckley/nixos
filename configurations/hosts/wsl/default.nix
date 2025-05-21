{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
    inputs.nix-index-database.nixosModules.nix-index
    ./wsl.nix
  ];

  environment.systemPackages = [pkgs.devenv];

  features.michael = {
    nvf.package = "default";
    extendedGraphical = false;
    vscode.enable = false;
    waybar.enable = false;
  };

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
