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
  in
    nixpkgs.lib.nixosSystem {
      inherit system pkgs;

      # My own custom functions are passed via specialArgs
      specialArgs = {
        # This intentionally does not collide with `lib`
        flakeLib = flake.lib;
        # These require pkgs to be passed so collect and do once to get the ready functions
        functions = mapAttrs (_: v: v {inherit pkgs;}) flake.functions;
      };
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
