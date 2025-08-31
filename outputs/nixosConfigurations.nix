{inputs}: let
  inherit (inputs) nixpkgs nix-secrets home-config self;

  customLib = import ../flake/lib {inherit (nixpkgs) lib;};

  defaultMods = [
    inputs.sops-nix.nixosModules.sops
    nix-secrets.nixosModules.ssh
    nix-secrets.nixosModules.common
    ../flake/modules
  ];

  mkSystem = {
    system ? "x86_64-linux",
    modules ? [],
  }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit system inputs self;};
      modules = modules ++ defaultMods;

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
  o1 = mkSystem {
    system = "aarch64-linux";
    modules = [
      home-config.hjemConfigurations.minimal-arm
      nix-secrets.nixosModules.oracle
      ../flake/configurations/o1
    ];
  };
  p520 = mkSystem {
    modules = [
      home-config.hjemConfigurations.minimal
      ../flake/configurations/p520
    ];
  };
  t14 = mkSystem {
    modules = [
      home-config.hjemConfigurations.default
      nix-secrets.nixosModules.t14
      ../flake/configurations/t14
    ];
  };
  tempest = mkSystem {
    modules = [
      home-config.hjemConfigurations.default
      ../flake/configurations/tempest
    ];
  };
  x570 = mkSystem {
    modules = [
      home-config.hjemConfigurations.server
      nix-secrets.nixosModules.x570
      ../flake/configurations/x570
    ];
  };
}
