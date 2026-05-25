{
  inputs,
  nixosModules,
  packages,
  ...
}: let
  inherit (builtins) mapAttrs;
  inherit (inputs) nixpkgs self;

  npins = import ../npins;
  mkImport = import ../lib/flake/mkImport.nix {inherit inputs;};

  lib = import ../lib {inherit inputs;};

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
      value = {
        hostDir = ../hosts/uff/${hostname};
        modules = mkImport ../hosts/uff/modules;
      };
    }) ["uff1" "uff2" "uff3"]
  );

  # Function to streamline building the configs from the input params I pass
  mkSystem = {
    hostname,
    system ? "x86_64-linux",
    cudaSupport ? false,
    hostDir ? ../hosts/${hostname},
    modules ? [],
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
      specialArgs = {
        inherit self inputs;
        # Vehicle for some things originating from my flake
        flake = {
          hosts = import ../modules/flake/hosts.nix;
          inherit nixosModules packages npins lib system;
          # These require pkgs to be passed so collect and do once to get the ready functions
          functions = lib.functions {inherit pkgs;}; # Vehicle for some things originating from my flake
        };
      };
      modules =
        (mkImport hostDir)
        ++ modules
        ++ [
          ../modules/flake/hostOptions.nix
        ];
    };
in
  # Add the hostname to the params and assemble the closures
  mapAttrs (
    hostname: params:
      mkSystem (params // {inherit hostname;})
  ) (hosts // uffs)
