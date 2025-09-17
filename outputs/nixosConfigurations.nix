{
  inputs,
  lib,
  ...
}: let
  inherit (builtins) mapAttrs;
  inherit (inputs) self nixpkgs;

  customLib = import ../flake/lib {inherit (nixpkgs) lib;};

  defaultMods = [
    inputs.sops-nix.nixosModules.sops
    ../flake/nixos/modules
  ];

  mkSystem = {
    hostname,
    system ? "x86_64-linux",
    modules ? [],
    hjem ? "default",
    secrets ? hostname,
  }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit system inputs self;};
      modules =
        modules
        ++ defaultMods
        ++ [
          self.hjemConfigurations.${hjem}
          self.hjemConfigurations.root
          inputs.nix-secrets.nixosModules.${secrets}
          inputs.impermanence.nixosModules.impermanence
          ../flake/nixos/configurations/${hostname}
        ];

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (
            _: prev: {lib = prev.lib // customLib;}
          )
        ];
      };
    };
in {
  flake.nixosConfigurations =
    mapAttrs (
      hostname: params:
        mkSystem (params // {inherit hostname;})
    ) {
      o1 = {
        system = "aarch64-linux";
        hjem = "minimal-arm";
      };
      p520 = {
        hjem = "server";
        modules = [inputs.quadlet-nix.nixosModules.quadlet];
      };
      t14 = {};
      tempest = {
        secrets = "common";
      };
      x570 = {};
    };
}
