{inputs, ...}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
    ./hjem.nix
    ./wsl.nix
  ];

  networking = {
    hostName = "wsl";
    hostId = "e07f0101";
    nameservers = ["1.1.1.1" "8.8.8.8" "9.9.9.9"];
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";
}
