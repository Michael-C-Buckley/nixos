{inputs, ...}: {
  imports = [
    inputs.vscode-server.nixosModules.default
    ./modules
    ./packages
    ./programs
    ./system
    ./home/hjem.nix
  ];
}
