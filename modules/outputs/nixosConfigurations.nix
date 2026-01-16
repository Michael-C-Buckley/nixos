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
    extraCfg ? {},
  }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [flake.modules.nixos.${hostname}];

      pkgs = import nixpkgs {
        inherit system;
        config =
          {
            allowUnfree = true;
          }
          // extraCfg;
      };
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
      p520 = {extraCfg = {cudaSupport = true;};};
      t14 = {};
      tempest = {};
      x570 = {};
      sff3 = {};
    };
}
