{
  inputs,
  lib,
  ...
}: let
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
  flake.nixosConfigurations = {
    o1 = mkSystem {
      hostname = "o1";
      system = "aarch64-linux";
      hjem = "minimal-arm";
    };
    p520 = mkSystem {
      hostname = "p520";
      hjem = "server";
    };
    t14 = mkSystem {
      hostname = "t14";
    };
    tempest = mkSystem {
      hostname = "tempest";
      secrets = "common";
    };
    x570 = mkSystem {
      hostname = "x570";
    };
    wsl = mkSystem {
      hostname = "wsl";
      secrets = "common";
      hjem = "wsl";
      modules = [inputs.nixos-wsl.nixosModules.default];
    };
  };
}
