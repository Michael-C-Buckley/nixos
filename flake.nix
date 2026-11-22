{
  description = "Michael's Personal Flake";

  outputs =
    { self, ... }@args:
    let
      inputs = (import ./.tack) { overrides = args.tackOverrides or { }; };
      systems = args.systemOverrides or (import ./systems.nix);
    in
    inputs.adios-flake.lib.mkFlake {
      inherit self inputs systems;

      flake = {
        # Exposed so it is available for any downstreams that use this flake as an input
        lib.tackInputs = inputs;
        nixosConfigurations = {};
        hjemConfigurations = {};
      };

      perSystem =
        { system, lib, ... }:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          # This instance is reused everywhere so that no other nixpkgs has to be imported or reimported
          legacyPackages = pkgs;
          devShells.default = pkgs.mkShellNoCC {};
        };
    };
}
