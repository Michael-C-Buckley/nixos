{
  description = "Michael's System Flake";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    nix-secrets = {
      url = "git+ssh://git@github.com/michael-c-buckley/nix-secrets";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-compat.url = "github:edolstra/flake-compat";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";

    hjem.follows = "home-config/hjem";
    home-manager.follows = "home-config/home-manager";
    schizofox.follows = "home-config/schizofox";

    home-config = {
      url = "github:Michael-C-Buckley/home-config";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
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
      };
    };

    # No Nixpkgs Inputs
    impermanence.url = "github:nix-community/impermanence";
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import inputs.systems;
      imports = [./outputs];
    };
}
