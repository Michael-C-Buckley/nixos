{
  inputs,
  config,
  ...
}: let
  inherit (config) flake;
  inherit (builtins) mapAttrs;
  inherit (inputs) nixpkgs;

  mkSystem = {
    hostname,
    system ? "x86_64-linux",
    cudaSupport ? false,
  }: let
    pkgs = import nixpkgs {
      inherit system;
      config = {
        inherit cudaSupport;
        allowUnfree = true;
      };
    };
    # Prime the lib functions that need pkgs which are prefixed with `functions`
    functions = pkgs.lib.filterAttrs (n: _: pkgs.lib.hasPrefix "functions" n) flake.lib;
    primedFunctions = mapAttrs (_: v: v {inherit pkgs;}) functions;
    flakeLib = flake.lib // primedFunctions;
  in
    nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      specialArgs = {inherit flakeLib;};
      modules = [flake.modules.nixos.${hostname}];
    };
in {
  flake.nixosConfigurations =
    # Add the hostname to the params
    mapAttrs (
      hostname: params:
        mkSystem (params // {inherit hostname;})
    ) {
      b550 = {};
      o1 = {system = "aarch64-linux";};
      p520 = {cudaSupport = true;};
      t14 = {};
      tempest = {};
      x570 = {};
    };
}
