{
  description = "Michael's System Flake";

  outputs = {self, ...} @ args: let
    inputs = ((import ./.tack) {overrides = args.tackOverrides or {};}) // {inherit self;};
    inherit (import ./lib/flake {inherit inputs;}) mkModule;
    nixosModules = mkModule ./modules/nixos;
    packages = import ./outputs/packages.nix {inherit inputs;};
  in {
    inherit nixosModules packages;
    # Pass along the references so that self is not needed to be called and doesn't break if it's changed
    nixosConfigurations = import ./outputs/nixosConfigurations.nix {inherit self inputs nixosModules packages;};
    devShells = import ./outputs/devShells.nix {inherit inputs;};
  };
}
