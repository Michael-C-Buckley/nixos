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
    basePkgs = import nixpkgs {
      inherit system;
      config = {
        inherit cudaSupport;
        allowUnfree = true;
      };
    };
    lib = basePkgs.lib // {flake = config.flake.lib.functions basePkgs;};
  in
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [flake.modules.nixos.${hostname}];

      pkgs = basePkgs // {inherit lib;};
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
