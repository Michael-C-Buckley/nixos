{
  config,
  inputs,
  ...
}: let
  inherit (inputs) nixpkgs;
  inherit (config.flake.modules) nixos;

  # These hosts are all X86
  system = "x86_64-linux";

  # WIP: convert to dendrite
  customLib = import ../lib/_default.nix {inherit (nixpkgs) lib;};

  mkSystem = {
    hostname,
    modules ? [],
  }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs customLib;};

      modules =
        modules
        ++ [
          inputs.nix-secrets.nixosModules.uff
          config.flake.modules.nixos.${hostname}
        ]
        ++ (with nixos; [
          uff-networking
          uff-shared
          serverPreset
        ]);

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };
in {
  flake.nixosConfigurations = {
    uff1 = mkSystem {hostname = "uff1";};
    uff2 = mkSystem {hostname = "uff2";};
    uff3 = mkSystem {hostname = "uff3";};
  };
}
