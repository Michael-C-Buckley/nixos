{inputs}: {
  mkImport = import ./mkImport.nix {inherit inputs;};
  mkModule = import ./mkModule.nix {inherit inputs;};
  eachSystem = import ./eachSystem.nix {inherit inputs;};
}
