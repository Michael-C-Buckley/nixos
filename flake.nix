{
  description = "Michael's System Flake";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    nix-secrets = {
      url = "git+ssh://git@github.com/michael-c-buckley/nix-secrets?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-compat.url = "github:edolstra/flake-compat";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";

    hjem.follows = "home-config/hjem";
    hjem-rum.follows = "home-config/hjem-rum";

    home-config = {
      url = "github:Michael-C-Buckley/home-config";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
        home-manager.follows = "";
      };
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mangowc = {
      url = "github:DreamMaoMao/mangowc";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        mmsg.inputs.flake-parts.follows = "flake-parts";
      };
    };

    schizofox = {
      url = "github:schizofox/schizofox";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
        searx-randomizer.inputs.flake-parts.follows = "flake-parts";
      };
    };

    # No Nixpkgs Inputs
    lupinix = {
      url = "github:Michael-C-Buckley/lupinix/noDash";
      inputs.flake-parts.follows = "flake-parts";
    };
    impermanence.url = "github:nix-community/impermanence";
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import inputs.systems;
      imports = with inputs;
        [lupinix.flakeModules.default]
        ++ import ./flake/modules-list.nix;

      debug = true;

      perSystem = {system, ...}: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config = {allowUnfree = true;};
        };
      };
    };
}
