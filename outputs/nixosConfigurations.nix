{
  self,
  inputs,
  config,
  ...
}: let
  inherit (config) flake;
  inherit (builtins) mapAttrs;
  inherit (inputs) nixpkgs;

  npins = import ../npins;

  # My individual hosts
  hosts = {
    b550 = {};
    o1 = {system = "aarch64-linux";};
    t14 = {};
    t14g5 = {};
    tempest = {};
    x570 = {};
  };

  # My UFF cluster, which gets the extra module for the cluster common base
  uffs = builtins.listToAttrs (
    map (hostname: {
      name = hostname;
      value.modules = [../hosts/uff/${hostname}];
    }) ["uff1" "uff2" "uff3"]
  );

  # Function to streamline building the configs from the input params I pass
  mkSystem = {
    hostname,
    system ? "x86_64-linux",
    cudaSupport ? false,
    modules ? [../hosts/${hostname}/configuration.nix],
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
        inherit self flake inputs npins;
        # This intentionally does not collide with `lib`
        flakeLib = flake.custom.lib;
        # These require pkgs to be passed so collect and do once to get the ready functions
        functions = mapAttrs (_: v: v {inherit pkgs;}) flake.custom.functions;
      };
      inherit modules;
    };
in {
  flake.nixosConfigurations =
    # Add the hostname to the params and assemble the closures
    mapAttrs (
      hostname: params:
        mkSystem (params // {inherit hostname;})
    ) (hosts // uffs);
}
