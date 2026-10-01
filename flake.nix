{
  description = "Michael's system flake";

  outputs =
    { self, ... }@args:
    let
      inputs = (import ./.tack) { overrides = args.tackOverrides or { }; };
    in
    {
      devShells = import ./outputs/devShells.nix { inherit self inputs; };
      packages = import ./outputs/packages.nix { inherit self inputs; };
      nixosConfigurations = import ./outputs/nixosConfigurations.nix { inherit self inputs; };
    };
}
