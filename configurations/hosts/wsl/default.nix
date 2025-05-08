{inputs, ...}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
    inputs.nix-index-database.nixosModules.nix-index
    ./wsl.nix
  ];

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

  nixpkgs.hostPlatform = "x86_64-linux";
  system = {
    preset = "wsl";
    stateVersion = "24.11";
  };

  virtualisation.docker = {
    enable = true;
    kata.enable = true;
  };
}
