{inputs, ...}: let
  inherit (inputs) nixpkgs home-config self;

  customLib = import ../flake/lib {inherit (nixpkgs) lib;};

  defaultMods = [
    inputs.sops-nix.nixosModules.sops
    ../flake/modules
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
          home-config.hjemConfigurations.${hjem}
          ../flake/configurations/${hostname}
          ../flake/secrets/hosts/${secrets}.nix
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
      secrets = "common";
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
  };
}
