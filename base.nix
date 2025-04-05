{inputs, ...}: {
  imports = [
    inputs.lix.nixosModules.default
    inputs.vscode-server.nixosModules.default
    inputs.nvf.nixosModules.default
    ./modules
    ./packages
    ./programs
    ./system
    ./home/hjem.nix
  ];
}
