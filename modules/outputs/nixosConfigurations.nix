{
  inputs,
  config,
  ...
}: let
  inherit (builtins) mapAttrs;
  inherit (inputs) nixpkgs;

  mkSystem = {
    hostname,
    system ? "x86_64-linux",
    secrets ? hostname,
  }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        inputs.nix-secrets.nixosModules.${secrets}
        config.flake.modules.nixos.${hostname}
      ];

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };
in {
  flake.nixosConfigurations =
    # Add the hostname to the params
    mapAttrs (
      hostname: params:
        mkSystem (params // {inherit hostname;})
    ) {
      o1 = {system = "aarch64-linux";};
      p520 = {};
      t14 = {};
      tempest = {};
      x570 = {};
      #wsl = {}; # Temporarily suspended - not currently being used
    };
}
