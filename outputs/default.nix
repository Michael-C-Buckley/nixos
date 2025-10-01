{inputs, ...}: {
  imports = [
    (inputs.import-tree ../dendrites)
    ./hjemConfigurations.nix
    ./hydraJobs.nix
    ./nixosConfigurations.nix
    ./packages.nix
  ];
}
